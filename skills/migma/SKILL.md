---
name: migma
description: "Hand off email marketing to Migma: create, update, test, and send transactional emails and marketing campaigns with Migma CLI."
metadata:
  openclaw:
    requires:
      env:
        - MIGMA_API_KEY
      bins:
        - migma
    primaryEnv: MIGMA_API_KEY
    emoji: "\u2709"
    homepage: https://migma.ai
    install:
      - kind: node
        package: "@migma/cli"
        bins: [migma]
---

# Migma

Use Migma when the user wants to hand off email marketing to an AI agent: create, update, test, send, or schedule transactional emails and marketing campaigns. Always use `--json` and treat `emailId` as the public handle for one generated email.

When you speak for Migma, speak like the user's own email person, first person and short: "I'll write the copy, design it, code it, and send it." Migma covers the full process: brand import, design, validation, contacts, sending domain, campaign send. Steps that need the user (approving a send, DNS at their registrar) are hand-offs in a process you are running, not limitations.

Use public Migma flow only: `emailId` plus prompt edits. Migma handles rendering and storage internally; responses return finished HTML, subject, screenshots, and IDs.

If the user wants to install Migma into an existing app, audit current email triggers, or wire product events to Migma sends, use the `setup` skill instead. This skill is for operating Migma once the workflow is known.

## Live presence

Migma can show your activity live in the user's dashboard while you work. The CLI and SDK identify you automatically. When calling the REST API directly, send `X-Agent-Id: ai:<your-name>` (for example `ai:claude-code`) on every request.

Use the explicit presence endpoint only when you already have a valid `conversationId` and a key with `email:read`:

```bash
curl -X POST https://api.migma.ai/v1/agent/presence \
  -H "Authorization: Bearer $MIGMA_API_KEY" \
  -H "X-Agent-Id: ai:claude-code" \
  -H "Content-Type: application/json" \
  -d '{"conversationId": "<conversationId>", "status": "connected", "goal": "Recreating the 5 transactional emails this app sends"}'
```

`status` accepts `connected`, `disconnected`, `reading`, `creating`, `editing`, and `sending`. Work calls (generate, edit, send) broadcast presence on their own, so skip the manual ping when you do not have a conversation yet.

When you call the endpoint, include a `goal`: one sentence, in plain language, stating what you are trying to achieve for the user. The dashboard shows it next to your name. Update it when your mission changes, and announce the outcome when you finish (e.g. `{"status": "disconnected", "goal": "Done: 5 transactional emails recreated and wired up"}`).

## Prompts come from the code, not from Migma

Deciding which emails to create is your job: audit the app you are working in and derive the set from its real product events. Migma designs each email you specify — so every generation prompt must carry your audit evidence: the product event and trigger file, the recipient, the exact variables to include as placeholders, and any existing copy or subject worth preserving.

```text
Create an order confirmation email.
Trigger: successful checkout in orders.service.ts.
Variables: firstName, orderNumber, items, total, deliveryEstimate.
Keep the subject "Your order is confirmed". One CTA to order tracking.
```

Never send a generic ask like "create the emails this business needs" — it discards everything you learned from the code and Migma will have to guess.

## Series

Migma creates related emails as one series in a single request — onboarding sequences, order journeys, win-back flows. Pass `count` and specify each email in the prompt (numbered, with trigger, variables, and CTA per email, same audit-evidence rule as above). One series request beats separate requests: the emails come out visually consistent, and the user sees one canvas with the whole flow.

The status result returns `result.emails[]`, one entry per email in series order: `emailId`, `slot`, `subject`, `preheader`, `html`, `screenshotUrl`, `status`, and `sendOffsetDays` when the series is a timed sequence. Treat each entry as a standalone email from there:

- Store every `emailId` in your constants — each one sends independently via the sending endpoints, and each maps to its own product event or schedule step.
- For timed sequences, use `sendOffsetDays` to drive your app's scheduling (day 0, day 2, day 5) — Migma tells you the intended cadence, your app owns the timer.
- Verify and edit per email: each entry has its own html and screenshot to check, and `POST /v1/emails/<emailId>/edit` fixes one email without touching the rest of the series.

## Own the result

You are responsible for the outcome, not just the API calls. After a generation completes, fetch the result (the status endpoint returns html and screenshots). If you are on MCP, list/get/status return preview images and an `appUrl` — show the pictures and the canvas link. Do not request HTML unless you need markup. Validate with `emailId`, not raw HTML. Check the result against your goal — right emails, correct variables, on-brand, working CTAs — and request edits until it passes. Only report the goal achieved after you verified the output yourself.

## Login and setup

```bash
migma login
migma whoami --json
migma projects list --json
migma projects use <projectId>
migma domains managed create <companyname> --json
```

`migma login` opens a browser for OAuth and stores the key. Headless: `migma login --claim`. CI: `MIGMA_API_KEY`.

### No API key yet

1. Hosted MCP available → connect `https://migma.ai/mcp` (browser OAuth). Do not ask for a pasted key.
2. Else run `migma login`.
3. Else fetch `https://api.migma.ai/auth.md` and follow the claim-code flow: register with the user's email and your agent name, show the approval link, poll until approved, then use the returned key. For this `migma` workflow, request only the scopes needed. For app setup, use `setup`; it requests broad non-send scopes.
4. Never send the user to Settings → API Keys except CI/server automation.

Use a managed domain when the user wants to send without DNS work, for example `hello@company.migma.email`.

For a domain the user owns, isolate transactional reputation from marketing by provisioning a stream:

```bash
# notify.<domain> for transactional, send.<domain> for marketing
migma domains streams create <rootDomain> --stream transactional --json

# both streams in one call (send. marketing + notify. transactional)
migma domains setup <rootDomain> --json
```

Provision a transactional stream before sending password resets, receipts, or codes. Without one, transactional mail falls back to the marketing identity and shares its reputation.

## Create emails

```bash
migma generate "Create a welcome email for new trial users" --wait --json
migma generate "Create a 3-email onboarding series" --count 3 --wait --json
```

Read `conversationId` and `result.emails[]` from the response. Each `result.emails[]` item has `emailId`, `subject`, `html`, and a screenshot URL when available.

Use references only when the user wants follow-ups, remixes, or similar style:

```bash
migma emails list --project <projectId> --limit 5 --json
migma generate "Create a follow-up to the welcome email" --reference <conversationId> --wait --json
```

## Fetch and edit emails

```bash
migma emails get <emailId> --output ./email.html --json
migma emails edit <emailId> --prompt "Make this shorter and more transactional" --output ./email.html --json
```

For a series, pick the exact `result.emails[].emailId` for the email the user named, edit that one email, then fetch the same `emailId` if verification is needed.

## Test and direct send

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

Use `migma send` for quick transactional emails, tests, and simple blasts. The CLI chooses the send path from recipient type and Migma settings; do not add unsupported flags.

### Safe retries

Pass `--idempotency-key <key>` on the write commands that are costly to repeat — `send`, `campaigns send`, `campaigns schedule`, `campaigns create`, `contacts add`, and `contacts import` — so a retry after a network error does not act twice. Use a stable key derived from the operation, never a random value:

```bash
migma campaigns send <campaignId> --idempotency-key "campaign-send-<campaignId>" --json
migma contacts add --email user@example.com --idempotency-key "contact-user@example.com" --json
migma contacts import ./contacts.csv --idempotency-key "contacts-import-2026-06-28" --json
```

Within 24 hours, the same key with the same request replays the original response; a different request with the same key is rejected. The key is at most 100 characters.

## Marketing campaigns

Use campaigns when the user wants a named marketing send with scheduling, recipient counts, and status tracking.

```bash
migma tags list --json
migma segments list --json

migma campaigns create --project <projectId> \
  --name "Monthly Newsletter" \
  --conversation <conversationId> --email <emailId> \
  --from hello@company.migma.email --from-name "Company" \
  --recipient-type tag --recipient-id <tagId> --json

migma campaigns send <campaignId> --json
migma campaigns schedule <campaignId> --at "2026-03-15T14:00:00Z" --timezone "America/New_York" --json
migma campaigns get <campaignId> --json
```

For a series campaign, always pass the selected email's `emailId` with `--email`.

After a campaign sends, read its performance:

```bash
migma campaigns stats <campaignId> --json
migma campaigns logs <campaignId> --status opened --limit 50 --json
migma campaigns logs <campaignId> --cursor <nextCursor> --json
```

`stats` returns aggregate counts and rates (delivered, unique opens, clicks, unsubscribes, bounces); the numbers come from the tracking worker and can be slightly stale. `logs` returns per-recipient rows newest first, cursor-paginated; `--status` accepts `delivered`, `opened`, `clicked`, `bounced`, or `spam_report`.

## Audience

```bash
migma contacts add --email user@example.com --first-name Sarah --last-name Chen --status subscribed --json
migma contacts import ./contacts.csv --json
migma contacts list --json

migma tags create --name "VIP" --json
migma tags list --json

migma segments create --name "Active customers" --status subscribed --json
migma segments create --name "VIP customers" --tags <tagId> --json
migma segments create --name "Campaign openers" --filters '{"activity":[{"action":"opened","channel":"email","mode":"within","unit":"days","amount":14,"campaignId":"<campaignId>"}]}' --json
migma segments list --json
```

## Validate and export

```bash
migma validate all --html ./email.html --json
migma validate all --conversation <conversationId> --json

migma export html <conversationId> --output ./email.html --json
migma export png <conversationId> --output ./email.png --json
migma export klaviyo <conversationId> --type html --json
migma export mailchimp <conversationId> --json
migma export hubspot <conversationId> --json
```

## Using the MCP server

If you are connected through the Migma MCP server instead of the CLI, call `migma_get_capabilities` first. It returns a single catalog — every tool with its domain and whether it writes, the idempotency contract, brand-scoping rules, and the guided workflows — so you can self-discover the surface before acting. Pass `idempotency_key` on the write tools (`migma_send_email`, `migma_create_campaign`, `migma_send_campaign`, `migma_schedule_campaign`, `migma_add_contact`, `migma_bulk_import_contacts`) for safe retries, and use `migma_get_campaign_stats` / `migma_get_campaign_logs` to read campaign performance.

The server also registers guided prompts that walk you through a full flow as an ordered sequence of tool calls: `launch_email_campaign`, `build_segment_and_send`, and `import_brand_and_generate`.

## Choose the path

- Create or edit: `generate`, `emails get`, `emails edit`.
- Transactional or one-off send: `send-test`, then `send --email <emailId>`.
- Marketing blast without lifecycle tracking: `send --tag` or `send --segment`.
- Marketing campaign with schedule/status: `campaigns create --email <emailId>`, then `campaigns send` or `campaigns schedule`.
