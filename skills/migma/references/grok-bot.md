# Grok mode and recovery

Use this reference only in Grok, Grok Bot, or Grok Build.

## Choose one mode

- **Grok Bot computer**: operate signed-in `migma.ai` through browser. Human takes over for password, passkey, two-factor code, or CAPTCHA.
- **Hosted connector / MCP**: use connected `migma_*` tools. Prefer browser OAuth.
- **Grok Build / terminal**: use hosted MCP OAuth or direct CLI/API with securely stored credentials.

Use one write mode per task. Before changing modes, stop or await current generation, list existing Migma drafts read-only, reconcile what already exists, then continue. Never generate through browser and MCP in parallel.

## Auth order

1. Reuse connected `migma_*` tools.
2. Connect `https://migma.ai/mcp` and complete browser OAuth.
3. If host rejects callback, do not ask for Settings API key. Fetch `https://api.migma.ai/auth.md`.
4. Use claim-code only for direct client/terminal path that can keep `claim_token` and returned `access_token` out of chat, logs, shell history, and shared files. Claim-code does not repair hosted connector OAuth.
5. Human opens approval link, reviews signed-in Migma account and scopes, then approves. Agent polls. Never approve own request.
6. Manual `MIGMA_API_KEY` belongs to CI/server automation only.

If secure credential storage is unverified, stop and use Grok Bot computer mode. Every Grok Bot shares one cloud computer and browser session.

## Permission truth

- `email:read email:write`: list/read/create/edit email drafts.
- `email:send`: test/direct sends.
- `campaign:read`: list campaigns, stats, logs.
- `campaign:write`: create, send, schedule, cancel, archive campaigns.

Never call `campaign:write` no-send. For draft email work, omit both `email:send` and `campaign:write`. Migma cannot currently permission-separate campaign draft creation from campaign delivery; written approval is behavioral protection, not least privilege.

## Research-to-email sequence

1. Resolve exact Migma brand.
2. Research current primary sources outside Migma.
3. Build dated source brief: exact facts/features per email plus up to 5 public HTTPS image URLs.
4. Call `migma_generate_email` once with `count`, distinct roles, full fact checklist in `prompt`, source URLs in structured `images`, and stable `idempotency_key`.
5. Poll status, show every preview and `appUrl` first.
6. Verify every named fact in content and every expected source asset in previews.
7. Make targeted text edits only after first show. Missing structured images require replacement generation.

Report project, execution mode, source checklist, generation ID, email IDs, previews, canvas links, and any fact or image not verified. Never say done while verification is incomplete.
