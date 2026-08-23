# Grok Bot mode and recovery

Use this reference only in Grok, Grok Bot, or Grok Build.

## Primary path: Migma Remote MCP

Grok Bot desktop should use connected `migma_*` tools. It does not need to open or operate `migma.ai` for routine work.

When Migma is not connected:

1. Read `https://docs.migma.ai/agents/mcp-grok.md`.
2. Inspect existing plugins and MCP connections. Do not add a duplicate.
3. Present `https://migma.ai/mcp` and ask before adding it.
4. Stop for human browser sign-in and access approval.
5. Verify with `migma_list_projects` only. Do not mutate data during setup.

Migma is not yet verified as a public Grok Bot Marketplace listing. Agent-guided hosted MCP setup is a beta path whose availability and authentication depend on Grok build and workspace policy.

Use one write path per task. Never generate through browser automation and MCP in parallel. Before switching paths, stop or await current work, list existing Migma drafts read-only, reconcile them, then continue.

## Authentication order

1. Reuse existing `migma_*` tools.
2. Connect `https://migma.ai/mcp` and complete human browser OAuth.
3. If Grok rejects the callback, never ask for a Settings API key. Fetch `https://api.migma.ai/auth.md`.
4. Use claim-code only if Grok can keep `claim_token` and returned `access_token` out of chat, logs, shell history, and shared files.
5. Human opens approval link, reviews account and scopes, then approves. Agent never approves its own request.
6. Repeat `migma_list_projects`. Do not call setup durable only because one bearer request worked while connector state still says `needsAuth`.

Claim-code does not repair hosted connector OAuth. Manual `MIGMA_API_KEY` belongs to CI/server automation only.

## Browser fallback

Use Grok Bot's cloud computer only when plugin/MCP is unavailable and the user explicitly chooses browser fallback. Human takes over for password, passkey, two-factor code, and CAPTCHA. Every Bot shares one cloud computer and its browser sessions. Sign out after use.

## Permission truth

- `email:read email:write`: list/read/create/edit email drafts.
- `email:send`: test/direct sends.
- `campaign:read`: list campaigns, stats, logs.
- `campaign:write`: create, send, schedule, cancel, archive campaigns.

Never call `campaign:write` no-send. For email-draft-only work, omit both `email:send` and `campaign:write`. Written approval is behavioral protection, not least privilege.

## Research-to-email sequence

1. Resolve exact Migma brand.
2. Research current primary sources outside Migma.
3. Build dated source brief: exact facts/features per email plus up to five public HTTPS image URLs.
4. Call `migma_generate_email` once with `count`, distinct roles, full fact checklist in `prompt`, source URLs in structured `images`, and stable `idempotency_key`.
5. Poll status, show every preview and `appUrl` first.
6. Verify every named fact in content and every expected source asset in previews.
7. Make targeted text edits only after first show. Missing structured images require replacement generation.

Report brand, execution path, source checklist, generation ID, email IDs, previews, canvas links, and anything not verified. Never say done while verification is incomplete.
