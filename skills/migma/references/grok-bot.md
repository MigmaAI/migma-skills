# Grok Bot mode and recovery

Use this reference only in Grok, Grok Bot, or Grok Build.

## Primary path: Migma Remote MCP

Grok Bot desktop uses connected `migma_*` tools for routine work.

When Migma needs connection:

1. Read `https://docs.migma.ai/grok.md`.
2. Inspect existing plugins and MCP connections, then reuse the existing Migma connection when available.
3. Present `https://migma.ai/mcp` and ask before adding it.
4. Stop for human browser sign-in and access approval.
5. Verify access with a read-only `migma_list_projects` call.

Agent-guided hosted MCP setup is beta. Marketplace availability and authentication depend on Grok build and workspace policy.

Use one write path per task. Before switching paths, finish or pause current work, list existing Migma drafts read-only, reconcile them, then continue.

## Authentication order

1. Reuse existing `migma_*` tools.
2. When a Migma plugin listing with browser OAuth is installed, complete that approval.
3. Otherwise go straight to claim-code: fetch `https://api.migma.ai/auth.md`, register intent, and store the returned credential in Grok's secure credential storage. Grok Bot's cloud computer cannot receive an OAuth callback, so do not attempt connector OAuth first and do not retry it.
4. Human opens the approval link, signs in if needed, reviews the permissions, and approves.
5. Repeat `migma_list_projects` and confirm Grok reports a durable connected state.

The user sees one thing: the approval link with one line of instruction. Connection mechanics (which flow, what was rejected, what is being retried) are not the user's problem; report them only if the user asks or the connection fails for good.

Claim-code provides a direct authenticated credential. `MIGMA_API_KEY` serves CI and server automation.

## Browser fallback

For browser fallback, use Grok Bot's cloud computer after the user explicitly chooses that path. Human takes over for password, passkey, two-factor code, and CAPTCHA. Every Bot shares one cloud computer and its browser sessions. Sign out after use.

## Permission truth

- `email:read email:write`: list/read/create/edit email drafts.
- `email:send`: test/direct sends.
- `campaign:read`: list campaigns, stats, logs.
- `campaign:write`: create, send, schedule, cancel, archive campaigns.

Omit `scope` when registering — the user approves the full permission set on the page. `campaign:write` covers create, send, and schedule, so confirm each send with the user in the chat before it goes out.

## Research-to-email sequence

1. Resolve exact Migma brand.
2. Research current primary sources outside Migma.
3. Build dated source brief: exact facts/features per email plus up to five public HTTPS image URLs — product shots as content, email/page screenshots as design reference. When the user names a style or a site like reallygoodemails.com, fetch the actual screenshot URL.
4. Call `migma_generate_email` once with `count`, distinct roles, full fact checklist in `prompt`, source URLs in structured `images` (say which are content and which are reference), and stable `idempotency_key`.
5. Poll status, show every preview and `appUrl` first.
6. Verify every named fact in content and every expected source asset in previews.
7. Make targeted text edits only after first show. Missing structured images require replacement generation.

Report brand, execution path, source checklist, generation ID, email IDs, previews, canvas links, and verification status. Mark completion after verification passes.
