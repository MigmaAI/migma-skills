---
name: setup
description: Install and wire Migma into an existing app. Use when the user wants an AI agent to audit the app's current email triggers, install or configure the Migma SDK/REST path, create missing Migma emails, store email IDs, and wire backend sends safely.
---

# Setup

Use this skill when the user says they want to install, set up, wire, migrate, or hand off app email sending to Migma.

Plain requests count. If the user says "install Migma to handle my email marketing", "set up Migma in this app", or similar, run this workflow. Inspect the codebase before asking about triggers, providers, or strategy.

This is a setup workflow, not a general command reference. For one-off email creation, editing, testing, sending, exporting, or audience work, use `migma`.

## Goal

Audit the app's current email surface, identify every real email touchpoint, create or reuse the matching Migma emails, and wire safe backend sends where the app already has trustworthy server-side triggers.

## Start Gate

1. Detect the app stack and where backend/server code lives.
2. Find existing email systems: providers, templates, transactional sends, campaigns, lifecycle jobs, webhooks, queues, and notification services.
3. Reuse an existing connected Migma MCP. OAuth-capable hosted MCP clients connect to `https://migma.ai/mcp` and complete browser approval.
4. If there is no connected MCP, run `migma login` (browser OAuth) when a CLI is available. Then check whether `MIGMA_API_KEY` or `~/.migma/config.json` already has a key for SDK, REST, CLI, Local MCP, or server-side automation.
5. For a direct agent that needs credential-based access, use the claim-code flow at `https://api.migma.ai/auth.md`. Start draft work with `email:read email:write`; add scopes that match the audited task. `campaign:write` includes campaign send and schedule. CI uses `MIGMA_API_KEY` from the server secret store.
6. Continue the local audit while access is pending.
7. Once access is ready, proceed through discovery and email creation without further approval: list projects, reuse or create emails, store IDs, and write send-wiring code. Creating an email only makes a draft; nothing is delivered.
8. Stop and ask for explicit approval before, and only before, these hard gates: installing packages, skills, or plugins; sending a test email; sending live email; or requesting send-capable scopes (`email:send` or `campaign:write`).

## Setup Flow

1. Inventory existing Migma tooling and reuse it before installing: a connected Migma MCP (`migma_*` tools), or an already-installed `migma` SDK / `@migma/mcp` (`migma-mcp` binary) in the app's dependencies. If present, use it and skip install.
2. Choose the integration surface:
   - Connected hosted Migma MCP: use it directly. Its browser OAuth connection is the primary remote path.
   - Installed SDK or Local MCP: use its existing `MIGMA_API_KEY`, no install.
   - TypeScript/Node backend with nothing installed: prefer the official SDK, but adding the dependency is a hard gate that needs approval.
   - Other backend stacks: use REST.
   - Shell-only setup or quick checks: use CLI commands from `migma`.
3. Resolve the Migma project/brand:
   - list projects
   - pick the one matching the app
   - ask when more than one is plausible
4. List existing Migma emails for that project and reuse matches.
5. Create missing emails with prompts grounded in the code audit:
   - product event and trigger file
   - recipient
   - variables/placeholders
   - existing subject/copy to preserve
   - CTA and timing
6. For related lifecycle emails, create one series with `count`, not separate unrelated requests.
7. Store every `emailId`, subject, from email, and from name in server-side constants/config.
8. Wire sends into the app's real backend path: service, queue, webhook, cron, or job.
9. Add idempotency so retries do not send duplicate transactional emails.
10. Add a test or dry-run path that verifies each trigger selects the correct `emailId` without sending.

## Agent-Copy Prompts

When a Migma UI surface gives you a "Copy for AI" prompt, treat it as a compact user request plus context. The first sentence is the task. The details below it are constraints and identifiers. Follow them without asking the user to paste docs again.

Expected first sentences:

- `I want to set up Migma to handle email marketing in this app.`
- `I want to use this Migma email from my app.`

If selected `emailId` values are present, wire those emails. If no `emailId` is present but a `conversationId` is present, list project emails and locate the matching generated email before wiring.

## Migma API Essentials

- Base URL: `https://api.migma.ai`
- Auth: `Authorization: Bearer $MIGMA_API_KEY`
- Generate: `POST /v1/projects/emails/generate`
- Status: `GET /v1/projects/emails/{conversationId}/status`
- One generated email: use `emailId` from `result.emails[]`
- Test send before live send.

## Guardrails

- Keep all Migma API keys server-side.
- Keep send calls in server code.
- Approval tiers: audit and read are free; creating email drafts is authorized by `email:write`; installing, test-sending, live-sending, and requesting send-capable scopes (`email:send` or `campaign:write`) are hard gates that each need explicit user approval. Treat `campaign:write` as send-capable.
- Use opted-in subscribed contacts.
- Wire real product triggers.
- For a frontend-only app, complete audit and email creation, then ask for backend setup before wiring sends.

## Final Report

Report:

- stack detected
- email systems found
- Migma project used
- emails created or reused with `emailId`
- files changed
- tests or dry-run checks added
- remaining manual steps, especially missing backend triggers, variables, sender/domain setup, or user approval needed before live send
