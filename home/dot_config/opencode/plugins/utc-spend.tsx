/** @jsxImportSource @opentui/solid */
import { createSignal } from "solid-js"
import type { TuiPlugin, TuiPluginApi, TuiPluginModule } from "@opencode-ai/plugin/tui"

// Daily cost ($) spent across ALL sessions, scoped to the current UTC calendar day.
//
// Cost is stored per assistant turn (AssistantMessage.cost, already in USD,
// computed by opencode). We sum the cost of every assistant message whose own
// time.created falls within [startOfUTCDay, now] across every session touched
// today. The session-level lifetime cost is intentionally NOT used.

// Module-level signal so the View reacts; the slot may mount/unmount per session
// but the daily total is global, so a single shared signal is correct.
const [total, setTotal] = createSignal<number | null>(null)

// Per-assistant-message cost, keyed by message id. message.updated fires
// repeatedly as a turn streams and its cost grows; keying by id and summing the
// map avoids double-counting partial updates. Reset on UTC-day rollover.
const costByMessage = new Map<string, number>()

// The UTC-day window the map currently represents, so we can detect rollover.
let currentDayStart = -1

function startOfUTCDay(now: number): number {
  const d = new Date(now)
  return Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate())
}

function recomputeTotal() {
  let sum = 0
  for (const c of costByMessage.values()) sum += c
  setTotal(sum)
}

function formatCost(value: number | null): string {
  if (value === null) return "$—"
  if (value <= 0) return "$0.00"
  // Show sub-cent precision so a tiny day isn't a flat $0.00.
  if (value < 0.01) return "$" + value.toFixed(4)
  return "$" + value.toFixed(2)
}

/** Record one assistant message into the map if it belongs to today (UTC). */
function consider(info: any, dayStart: number) {
  if (!info || info.role !== "assistant") return
  const created = info.time?.created
  if (typeof created !== "number" || created < dayStart) return
  const cost = typeof info.cost === "number" ? info.cost : 0
  costByMessage.set(info.id, cost)
}

// Max sessions to pull from the global list per rescan. The endpoint defaults
// to 100 and is ordered by most-recently-updated; we filter to today anyway via
// `start`, so this is just a safety ceiling for an extremely busy UTC day.
const GLOBAL_SESSION_LIMIT = 1000

/** List sessions touched since `start` across ALL projects.
 *
 *  Two scoping traps to defeat:
 *
 *  1. `api.client.session.list` pins projectID = the current workspace's
 *     project (listByProject), so it can never see other workspaces. The
 *     experimental `GET /experimental/session` endpoint (Session.listGlobal)
 *     has no project constraint and supports `start` (time_updated >= start).
 *
 *  2. The v2 SDK client installs a request interceptor that injects
 *     `directory=<current workspace>` into every GET *unless the param is
 *     already present*. The server then filters listGlobal to that directory,
 *     re-scoping us to one workspace. Passing an explicit `directory: ""`
 *     makes the param already-present (empty), so the interceptor skips
 *     injection and the server's `if (input.directory)` guard is falsy — i.e.
 *     a truly global, unfiltered query.
 *
 *  Returns Session.GlobalInfo rows across every project. Exposed in the v2 SDK
 *  as experimental.session.list; cast to any since TuiPluginApi doesn't surface
 *  it. Experimental upstream, so the shape could move; callers fail soft. */
async function listGlobalSessions(api: TuiPluginApi, start: number): Promise<any[]> {
  const res = await (api.client as any).experimental.session.list({
    start,
    limit: GLOBAL_SESSION_LIMIT,
    directory: "", // suppress the client's current-workspace directory injection
  })
  return res.data ?? []
}

/** Full scan: list every session across all projects touched today, then sum
 *  today's assistant-message costs. Per-message (not per-session) so a session
 *  spanning midnight only contributes its post-midnight cost. Each session's
 *  messages are fetched with that session's own directory (see below), which is
 *  what lets us reach other workspaces' projects. Run on mount and on UTC-day
 *  rollover. */
async function rescan(api: TuiPluginApi, dayStart: number) {
  costByMessage.clear()
  currentDayStart = dayStart
  try {
    const sessions = await listGlobalSessions(api, dayStart)
    for (const s of sessions) {
      try {
        // Pass the session's own directory so the request is routed to that
        // session's project; without it the messages call resolves against the
        // current workspace and returns nothing for other projects' sessions.
        const msgsRes = await api.client.session.messages({
          sessionID: s.id,
          directory: s.directory,
        } as any)
        for (const m of msgsRes.data ?? []) consider((m as any).info, dayStart)
      } catch {
        // Skip a session we couldn't read; keep the rest of the total.
      }
    }
    recomputeTotal()
  } catch {
    // Listing failed entirely — surface as "$—" rather than crash the sidebar.
    if (total() === null) setTotal(null)
  }
}

function View(props: { api: TuiPluginApi }) {
  const theme = () => props.api.theme.current
  return (
    <box>
      <text fg={theme().textMuted}>Today (UTC)</text>
      <text fg={theme().text}>{formatCost(total())}</text>
    </box>
  )
}

const tui: TuiPlugin = async (api) => {
  const { event, slots, lifecycle } = api

  // Initial scan for today.
  const boot = startOfUTCDay(Date.now())
  void rescan(api, boot)

  // Live: fold each updated assistant message into the running total. Detect a
  // UTC-day rollover and re-scan from scratch when it happens.
  const offUpdated = event.on("message.updated", (e: any) => {
    const dayStart = startOfUTCDay(Date.now())
    if (dayStart !== currentDayStart) {
      void rescan(api, dayStart)
      return
    }
    consider(e.properties?.info, dayStart)
    recomputeTotal()
  })

  // Cheap reconcile when a turn finishes (also catches missed deltas / rollover).
  const offIdle = event.on("session.idle", () => {
    const dayStart = startOfUTCDay(Date.now())
    if (dayStart !== currentDayStart) void rescan(api, dayStart)
    else recomputeTotal()
  })

  lifecycle.onDispose(() => {
    offUpdated()
    offIdle()
  })

  slots.register({
    order: 200,
    slots: {
      sidebar_content(_ctx, _props) {
        return <View api={api} />
      },
    },
  })
}

const plugin: TuiPluginModule & { id: string } = {
  id: "utc-spend",
  tui,
}

export default plugin
