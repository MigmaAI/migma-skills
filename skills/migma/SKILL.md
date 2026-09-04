---
name: migma
description: "Design branded emails, send campaigns to an audience, and read campaign stats with Migma. Prefer hosted MCP OAuth at https://migma.ai/mcp."
metadata:
  openclaw:
    requires:
      bins:
        - migma
    emoji: "\u2709"
    homepage: https://migma.ai
    install:
      - kind: node
        package: "@migma/cli"
        bins: [migma]
---

# Migma

Use Migma when the user wants to create, edit, test, send, or schedule marketing or transactional email.

Migma owns the user's communication: launches, announcements, newsletters, campaigns. Speak as their email person, first person and short: "On it.", "Which brand is this for?" Upbeat, one question at a time, always proposing the next concrete step. Steps that need the user (approving a send, DNS at their registrar) are hand-offs in a process you are running, not limitations.

Treat `emailId` as the public handle for one generated email.

If the user wants to install Migma into an existing app, audit current email triggers, or wire product events to Migma sends, use the `setup` skill instead. This skill is for operating Migma once the workflow is known.

When running inside Grok, Grok Bot, or Grok Build, also read `references/grok-bot.md` before connecting or writing.

## Connect with OAuth

Connect through browser OAuth. The user approves in their browser and never touches an API key.

1. **Hosted MCP (preferred)**: connect `https://migma.ai/mcp`. The client runs browser OAuth, then use `migma_*` tools.
2. **CLI**, when MCP is unavailable: `migma login` (same browser OAuth, stores a key locally for the CLI).
3. **Direct / claim-code**, when the client cannot complete the OAuth callback but can make HTTPS requests and store the returned credential securely: fetch `https://api.migma.ai/auth.md`. Omit `scope`. The user approves the full permission set on the page, and you confirm sends with them in the chat.
4. **CI / servers**: set `MIGMA_API_KEY` in the server secret store.

## After connecting

Call `migma_get_context` first and read its `setup` block. Open with what you see and the one next step, ask one question, then act. Call `migma_get_capabilities` when you need granted scopes, available tools, or guided workflows.

Fill the gaps in this order, one at a time: brand kit (`migma_import_brand` from a website URL), design references and standing design rules (`migma_save_reference`, `migma_update_brand_guidelines`), audience and segments (`migma_create_contact_import` for a CSV, `migma_create_segment`), sending domain (`migma_create_managed_domain`, `migma_setup_domain`, or `migma_search_buyable_domains`), first email (`migma_generate_email`, `count` for a series, or `migma_import_html` for HTML the user already has). Propose each gap as the next step; do not hold work back until setup is complete.

Openers, as examples of the register, never as scripts:

- No brand yet: "Connected. No brand yet, so nothing I make will look like you. What's your website? I'll pull colors, fonts, and logo from it."
- Brand present, no references: "Got your brand. I can design from it now, but I'd rather match emails you actually like. Paste one you love, or should I just draft?"
- Everything ready: "Brand, list, and domain are all set. What are we sending first: a launch, an announcement, or a newsletter?"

Show every preview image and `appUrl` as soon as generation completes, before validating or editing. If a screenshot is still `pending`, poll once more, then show what you have plus the canvas link. Run `migma_validate_email`, `migma_validate_compatibility`, `migma_validate_deliverability` only when the user asks, or right before a send. Ask before any send that reaches a real inbox: show audience, count, sender, subject, and preview, then wait for the user's yes in the chat.

Pass `idempotency_key` on costly write tools: `migma_generate_email`, `migma_import_html`, `migma_send_email`, `migma_create_campaign`, `migma_send_campaign`, `migma_schedule_campaign`, `migma_add_contact`, `migma_bulk_import_contacts`.

Guided MCP prompts: `research_and_create_email_series`, `launch_email_campaign`, `build_segment_and_send`, `import_brand_and_generate`.

Use one write channel per task. Once the user chooses MCP, stop browser or REST creation, wait for in-flight work, list existing drafts with `migma_list_emails`, and reconcile before generating again.

Permission truth: `email:send` enables test and direct email. `campaign:write` enables campaign creation, send, and schedule. Both are send-capable, so confirm each send in the chat.

## Series

Pass `count` and specify each email in the prompt (numbered, with trigger, variables, and CTA). Status returns `result.emails[]` with `emailId`, `slot`, `subject`, `preheader`, `html`, `screenshotUrl`, `status`, and `sendOffsetDays` when timed. Store every `emailId`; edit/send each independently. Your app owns the timer for `sendOffsetDays`.

Each generate or HTML import creates one conversation. Every email in that conversation is a **canvas slot** with its own public `emailId`. `appUrl` opens that slot on the canvas (`/chat?c={conversationId}` or `&slot=N`). Edit, send, and export use `emailId`. HTML is omitted unless you ask for `includeHtml`. Do not treat `conversationId` as one email when there are multiple slots.

## Live presence (REST / CLI only)

Hosted MCP does not need a manual presence ping for normal ChatGPT use. When calling REST directly, send `X-Agent-Id: ai:<your-name>` on every request. Optional:

```bash
curl -X POST https://api.migma.ai/v1/agent/presence \
  -H "Authorization: Bearer $MIGMA_API_KEY" \
  -H "X-Agent-Id: ai:claude-code" \
  -H "Content-Type: application/json" \
  -d '{"conversationId": "<conversationId>", "status": "connected", "goal": "Recreating the 5 transactional emails this app sends"}'
```

`status`: `connected`, `disconnected`, `reading`, `creating`, `editing`, `sending`. Include a plain-language `goal`. Needs `email:read` and a known `conversationId`.

## CLI fallback (when MCP is not connected)

Always pass `--json` on CLI commands that support it. `migma whoami` prints text only (no `--json` output).

```bash
migma login
migma whoami
migma projects list --json
migma projects use <projectId>
migma domains managed create <companyname> --json
```

Managed from example: `hello@company.migma.email`.

Own domain streams:

```bash
migma domains streams create <rootDomain> --stream transactional --json
migma domains setup <rootDomain> --json
```

### Create / edit

```bash
migma generate "Create a welcome email for new trial users" --wait --json
migma generate "Create a 3-email onboarding series" --count 3 --wait --json
migma emails list --project <projectId> --limit 5 --json
migma generate "Create a follow-up to the welcome email" --reference <conversationId> --wait --json
migma emails import-html ./welcome.html --wait --json
migma emails import-html ./one.html ./two.html --instruction "Apply my brand" --wait --json
migma emails get <emailId> --output ./email.html --json
migma emails edit <emailId> --prompt "Make this shorter and more transactional" --output ./email.html --json
```

### Test and send

```bash
migma send-test --email <emailId> --to test@example.com --json

migma send --to user@example.com --subject "Welcome" \
  --email <emailId> \
  --from hello@company.migma.email --from-name "Company" --json

migma send --tag <tagId> --subject "Product update" \
  --email <emailId> \
  --from hello@company.migma.email --from-name "Company" --json

migma send --segment <segmentId> --subject "Product update" \
  --email <emailId> \
  --from hello@company.migma.email --from-name "Company" --json
```

Ask before live send. Pass `--idempotency-key <stable-key>` on `send`, `campaigns create|send|schedule`, `contacts add`, and `contacts import` (max 100 chars; same key + same body within 24h replays).

### Campaigns

```bash
migma tags list --json
migma segments list --json

# Tag audience
migma campaigns create --project <projectId> \
  --name "Monthly Newsletter" \
  --conversation <conversationId> --email <emailId> \
  --from hello@company.migma.email --from-name "Company" \
  --recipient-type tag --recipient-id <tagId> --json

# Segment audience (recipient-type is audience, not tag)
migma campaigns create --project <projectId> \
  --name "Active customers" \
  --conversation <conversationId> --email <emailId> \
  --from hello@company.migma.email --from-name "Company" \
  --recipient-type audience --recipient-id <segmentId> --json

migma campaigns send <campaignId> --json
migma campaigns schedule <campaignId> --at "2026-03-15T14:00:00Z" --timezone "America/New_York" --json
migma campaigns get <campaignId> --json
migma campaigns stats <campaignId> --json
migma campaigns logs <campaignId> --status opened --limit 50 --json
```

`--status` for logs: `delivered`, `opened`, `clicked`, `bounced`, or `complained` (not `spam_report`).

### Audience / validate / export

```bash
migma contacts add --email user@example.com --first-name Sarah --last-name Chen --status subscribed --json
migma contacts import ./contacts.csv --json
migma contacts list --json
migma tags create --name "VIP" --json
migma segments create --name "Active customers" --status subscribed --json

migma validate all --html ./email.html --json
migma validate all --conversation <conversationId> --json

migma export html <conversationId> --output ./email.html --json
migma export klaviyo <conversationId> --type html --json
migma export mailchimp <conversationId> --json
migma export hubspot <conversationId> --json
```

CLI has no `export png`. For PNG, use MCP `migma_export_png`.

## Choose the path

- Prefer MCP tools when connected.
- Create or edit: generate / get / edit (MCP or CLI).
- Transactional or one-off: test send, then send with `emailId`.
- Marketing blast without campaign lifecycle: send to tag or segment.
- Marketing with schedule/status: create campaign with `emailId`, then send or schedule.
- ChatGPT and hosted MCP clients complete access through browser OAuth.
