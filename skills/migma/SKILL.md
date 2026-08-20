---
name: migma
description: "Design branded emails, send campaigns to an audience, and read campaign stats with Migma. Prefer hosted MCP OAuth at https://migma.ai/mcp — no API key paste."
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

Use Migma when the user wants to create, edit, test, send, or schedule transactional emails and marketing campaigns.

Treat `emailId` as the public handle for one generated email.

When you speak for Migma, speak like the user's own email person, first person and short: "I'll write the copy, design it, code it, and send it." Migma covers brand import, design, validation, contacts, sending domain, and campaign send. Steps that need the user (approving a send, DNS at their registrar) are hand-offs in a process you are running, not limitations.

If the user wants to install Migma into an existing app, audit current email triggers, or wire product events to Migma sends, use the `setup` skill instead. This skill is for operating Migma once the workflow is known.

## Connect (OAuth first — no API key)

Do **not** ask the user to create or paste an API key from Settings.

1. **Hosted MCP (preferred)** — connect `https://migma.ai/mcp`. The client runs browser OAuth. After approval, use `migma_*` tools. No key paste.
2. **CLI** — only when MCP is unavailable: `migma login` (same browser OAuth; stores a key locally for the CLI).
3. **Headless / claim-code** — only when no browser OAuth: fetch `https://api.migma.ai/auth.md`. For this skill, request only the scopes needed. For app setup, use `setup` (broad non-send scopes).
4. **CI / servers only** — set `MIGMA_API_KEY`. Never send interactive users to Settings → API Keys.

After MCP connects, call `migma_get_capabilities` first. It returns every tool, write vs read, idempotency rules, brand scoping, and guided workflows.

Pass `idempotency_key` on costly write tools: `migma_generate_email`, `migma_send_email`, `migma_create_campaign`, `migma_send_campaign`, `migma_schedule_campaign`, `migma_add_contact`, `migma_bulk_import_contacts`.

Guided MCP prompts: `launch_email_campaign`, `build_segment_and_send`, `import_brand_and_generate`.

### MCP path (default)

| Job | Tools |
|---|---|
| Brands | `migma_list_projects`, `migma_get_project`, `migma_import_brand` |
| Knowledge | `migma_add_knowledge_base` — save lasting brand facts (no list-first). `migma_list_knowledge_base` only to review. |
| Create / poll | `migma_generate_email`, `migma_get_generation_status`, `migma_list_emails` |
| Fetch / edit | `migma_get_email`, `migma_edit_email` |
| Test / send | `migma_send_test_email`, `migma_send_email` — ask before live send |
| Campaigns | `migma_create_campaign`, `migma_send_campaign`, `migma_schedule_campaign`, `migma_get_campaign_stats`, `migma_get_campaign_logs` |
| Audience | `migma_create_contact_import` (CSV), `migma_list_contacts`, `migma_add_contact`, `migma_list_tags`, `migma_list_segments`, … |
| Export | `migma_export_html`, `migma_export_png`, `migma_export_klaviyo`, `migma_export_mailchimp`, `migma_export_hubspot` |
| Validate (only if asked, or right before send) | `migma_validate_email`, `migma_validate_compatibility`, `migma_validate_deliverability` (prefer `emailId`) |
| Plan / credits | `migma_get_credits`, `migma_get_upgrade_link` |
| Buy a domain | `migma_search_buyable_domains`, `migma_buy_domain`, `migma_get_domain_purchases` |
| DNS on bought domains | `migma_list_dns_records`, `migma_add_dns_record`, `migma_remove_dns_record` |

## Show drafts fast

When the user asks to design / create emails:

1. Resolve brand (`migma_list_projects` / `migma_get_project`). Skip field catalog unless variables are needed.
2. `migma_generate_email` with clear distinct concepts in the prompt (and `count` for a series).
3. Poll `migma_get_generation_status` until ready.
4. **Stop and show.** Put the preview images and each `appUrl` in your reply immediately. Do not run validate / edit / re-poll first.
5. Only then offer: “Want me to tighten copy, run inbox checks, or turn one into a campaign?”

Do **not** auto-run compatibility/deliverability/spam checks after every generate. Those tools are for when the user asks, or as a last step before send.

When the user shares lasting brand facts (tone, products, offers, policies, audience, FAQ), call `migma_add_knowledge_base` once. Do not list first.

## CSV → audience (one tool)

When the user uploads or pastes a contact CSV:

1. Resolve `projectId`.
2. Call `migma_create_contact_import` once with `csvContent` (full CSV text + header), optional `tag` / `tags` for the list name. Leave `columnMap` empty unless headers are unusual.
3. Report the returned counts. Do not spreadsheet-validate first, do not convert rows to JSON for `migma_bulk_import_contacts`, do not use `csvPath` on hosted ChatGPT.

MCP status/list/get/edit already return image blocks — show those pictures in the chat. Prefer the tool images over inventing markdown. If a screenshot is still `pending`, poll once more, then show what you have plus the canvas link. Do not request HTML unless needed. Ask before any send that reaches real inboxes.

## Out of credits, upgrades, and buying domains

- When a generate/edit/send fails with a credit or plan error: call `migma_get_credits`, tell the user where they stand, then offer `migma_get_upgrade_link` and show the returned URL. The user pays in their browser; never try to pay for them. Omit `plan` for existing subscribers (billing portal); ask before picking a plan for new subscribers.
- To buy a domain: `migma_search_buyable_domains` for names and yearly prices, then `migma_buy_domain` and show the `checkoutUrl`. Buying needs a paid Migma plan — on that error, offer the upgrade link first. After the user pays, poll `migma_get_domain_purchases` until the domain is `active`, then run `migma_setup_domain` so it can send.
- DNS on bought domains: Migma hosts the zone and sets up all email sending records automatically — never add them yourself. For everything else (Google Workspace MX, site-verification TXT, pointing a subdomain at a server) use `migma_add_dns_record`; review with `migma_list_dns_records`, undo with `migma_remove_dns_record` (confirm first — removing a record breaks whatever used it). The root and `www` are reserved for domain forwarding, and Migma's sending records can't be overridden.

## Own the result (without delaying the first look)

You still own quality — but **first show, then improve**. After the user has seen the drafts, fix only what they ask for (or clear broken links / wrong brand). Do not silently edit for CSS or wording nitpicks before the first reveal.

## Prompts come from the code, not from Migma

When working inside an app, derive emails from real product events. Every generation prompt should carry audit evidence: trigger, recipient, placeholders, and any copy worth keeping.

```text
Create an order confirmation email.
Trigger: successful checkout in orders.service.ts.
Variables: firstName, orderNumber, items, total, deliveryEstimate.
Keep the subject "Your order is confirmed". One CTA to order tracking.
```

Never send a generic ask like "create the emails this business needs."

## Series

Pass `count` and specify each email in the prompt (numbered, with trigger, variables, and CTA). Status returns `result.emails[]` with `emailId`, `slot`, `subject`, `preheader`, `html`, `screenshotUrl`, `status`, and `sendOffsetDays` when timed. Store every `emailId`; edit/send each independently. Your app owns the timer for `sendOffsetDays`.

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
- Never invent a Settings API-key step for ChatGPT / hosted MCP users.
