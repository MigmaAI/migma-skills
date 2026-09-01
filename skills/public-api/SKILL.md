---
name: migma-public-api
description: Use when integrating Migma from app code through the REST API, TypeScript SDK, CLI, or MCP server. Helps choose the right surface, wire authentication, create or fetch generated emails, send tests, schedule campaigns, validate emails, and avoid stale internal contracts.
---

# Migma Public API

Use this skill when a user wants to build with Migma from code or automation. Do not treat this file as an endpoint reference. Verify details against the official docs and OpenAPI before writing code.

Official sources:

- Docs: https://docs.migma.ai
- API reference: https://docs.migma.ai/api-reference/introduction
- SDK: https://docs.migma.ai/sdk
- CLI: https://docs.migma.ai/cli
- MCP server: https://docs.migma.ai/mcp-server

## Choose the Surface

- TypeScript/Node backend: use the official SDK when adding a dependency is approved. Use REST only when the SDK is unavailable or exact HTTP control is needed.
- Shell workflow, scripts, or CI: use the Migma CLI.
- Remote MCP clients: connect to `https://migma.ai/mcp`. OAuth-capable clients complete browser sign-in, approval, and credential exchange automatically.
- Else run `migma login` (browser OAuth). A direct client with secure credential storage can fetch `https://api.migma.ai/auth.md` (claim-code); omit `scope` for the full permission set — the user approves it in the browser. CI and servers use `MIGMA_API_KEY`.
- Local command-based MCP clients: use `@migma/mcp`. It reads `MIGMA_API_KEY` or the key stored by `migma login` in `~/.migma/config.json`.
- Installing Migma into an existing app and wiring product-triggered sends: use `setup`.
- Creating, editing, testing, sending, and exporting emails from an agent workflow: use `migma`.
- "Copy for AI" prompts from Migma UI: follow the compact user request first, then use included context such as `emailId`, `conversationId`, sender, project, or Contacts API details to choose the right API/SDK/CLI path.

## Core Contracts

- REST, SDK, CLI, Local MCP, server automation, and manual Remote MCP requests authenticate with `Authorization: Bearer $MIGMA_API_KEY`. Acquire that key with `migma login` or `auth.md`; CI uses a Settings key from its secret store. OAuth-capable hosted MCP clients acquire and send their bearer credential automatically.
- Keep Migma calls server-side. Never put API keys or send calls in frontend/browser code.
- Resolve the brand/project first. If there are multiple plausible projects, ask the user before creating emails.
- Generate with `POST /v1/projects/emails/generate`, then poll generation status.
- Convert existing HTML or `.eml` with `POST /v1/projects/emails/import-html` (or MCP `migma_import_html`), then poll the same status endpoint. Do not put HTML into generate.
- Treat `result.emails[]` as the source of truth for generated emails.
- Use `emailId` for one generated email, especially series slots.
- Use `conversationId` only for whole-generation status or single-email fallback where explicitly supported.
- Test before live send.
- `email:send` permits test/direct sends. `campaign:write` permits campaign creation, send, and schedule.
- Use campaigns when the user needs a named marketing send with scheduling, recipient counts, status, and history.
- Use direct send for transactional messages, one-off sends, and test flows.
- For contacts work, keep API keys server-side, use `projectId`, preserve consent/status fields, and import opted-in subscribed contacts.

## Email Setup Pattern

When integrating Migma into an app:

1. Audit existing email sends, templates, campaigns, notifications, and lifecycle jobs.
2. Map each product event to one Migma email or one series slot.
3. Create missing emails in Migma with prompts grounded in code evidence: trigger file, recipient, variables, existing subject/copy, and CTA.
4. Store `emailId`, subject, from email, and from name in server-side constants or config.
5. Wire sends into existing backend services, queues, webhooks, and logging.
6. Add idempotency before calling Migma so retries do not send duplicate transactional emails.
7. Add a smoke test or dry-run path that verifies each trigger selects the right `emailId` without sending.

## Safety

- Use opted-in subscribed contacts.
- Keep package installs, key creation, live sends, and production traffic migrations behind current user approval.
- Use one write channel per task. When MCP is selected, stop browser/REST creation and reconcile existing drafts before generating again.
- For a frontend-only app, complete the audit and generated emails, then ask for a backend/server prerequisite before wiring sends.
- For one-off API work, request only the scopes needed for the task. For full app setup, use the `setup` skill's non-send registration rule.

## Output Checklist

Leave the user with:

- chosen integration surface and why
- project/brand used
- generated `emailId` values and matching product events
- sender/domain status
- files changed or exact code snippets to add
- validation/test-send status
- any email that could not be wired, with reason
