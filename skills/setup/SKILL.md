---
name: setup
description: Install and wire Migma into an existing app. Use when the user wants an AI agent to audit the app's current email triggers, install or configure the Migma SDK/REST path, create missing Migma emails, store email IDs, and wire backend sends safely.
---

# Setup

Use this skill when the user says they want to install, set up, wire, migrate, or hand off app email sending to Migma. This is a setup workflow, not a general command reference. For one-off email creation, editing, testing, sending, exporting, or audience work, use `migma`.

## Goal

Audit the app's current email surface, identify every real email touchpoint, create or reuse the matching Migma emails, and wire safe backend sends where the app already has trustworthy server-side triggers.

## Start Gate

1. Detect the app stack and where backend/server code lives.
2. Find existing email systems: providers, templates, transactional sends, campaigns, lifecycle jobs, webhooks, queues, and notification services.
3. Check whether `MIGMA_API_KEY` is available.
4. If no key exists, use Migma agent registration at `https://api.migma.ai/auth.md` when possible, or ask the user to approve/generate access.
5. Do not install packages, create credentials, call the Migma API, test-send, or live-send without user approval.

## Setup Flow

1. Choose the integration surface:
   - TypeScript/Node backend: prefer the official SDK if adding a dependency is approved.
   - Other backend stacks: use REST.
   - Shell-only setup or quick checks: use CLI commands from `migma`.
2. Resolve the Migma project/brand:
   - list projects
   - pick the one matching the app
   - ask when more than one is plausible
3. List existing Migma emails for that project and reuse matches.
4. Create missing emails with prompts grounded in the code audit:
   - product event and trigger file
   - recipient
   - variables/placeholders
   - existing subject/copy to preserve
   - CTA and timing
5. For related lifecycle emails, create one series with `count`, not separate unrelated requests.
6. Store every `emailId`, subject, from email, and from name in server-side constants/config.
7. Wire sends into the app's real backend path: service, queue, webhook, cron, or job.
8. Add idempotency so retries do not send duplicate transactional emails.
9. Add a test or dry-run path that verifies each trigger selects the correct `emailId` without sending.

## Migma API Essentials

- Base URL: `https://api.migma.ai`
- Auth: `Authorization: Bearer $MIGMA_API_KEY`
- Generate: `POST /v1/projects/emails/generate`
- Status: `GET /v1/projects/emails/{conversationId}/status`
- One generated email: use `emailId` from `result.emails[]`
- Test send before live send.

## Guardrails

- Keep all Migma API keys server-side.
- Do not put send calls in client code.
- Do not send cold email.
- Do not send to unsubscribed contacts.
- Do not create demo-only send functions when real product triggers exist.
- If a frontend-only app has no server path, stop after audit/email creation and ask for backend setup before wiring sends.

## Final Report

Report:

- stack detected
- email systems found
- Migma project used
- emails created or reused with `emailId`
- files changed
- tests or dry-run checks added
- remaining manual steps, especially missing backend triggers, variables, sender/domain setup, or user approval needed before live send
