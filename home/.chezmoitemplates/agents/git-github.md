## Git and GitHub
- Never add AI attribution such as "Generated with ..." footers or Co-Authored-By trailers to commits, PR bodies, or other authored artifacts.
- Inline PR review-comment replies: `gh api repos/<o>/<r>/pulls/<n>/comments --input payload.json` with `{"body": ..., "in_reply_to": <comment_id>}`, built with a real JSON encoder. `gh api -f body=@file` posts the literal "@path" string. For top-level comments, use `gh pr comment --body-file`.
