---
name: migma-public-api
description: Expert guide for the Migma public-facing API surface — V1 REST API, TypeScript SDK, CLI, MCP server, skills, and documentation. Use this skill to make changes across these packages, keep them in sync, and deploy.
metadata:
  openclaw:
    emoji: "🔌"
    homepage: https://migma.ai
---

# Migma Public API Surface

This skill covers everything user/developer-facing: the V1 REST API, the `migma` npm SDK, the `@migma/cli` CLI, the `@migma/mcp` MCP server, the OpenClaw skill, and the `migma-docs` documentation site. These six packages must stay in sync.

## Package Map

| Package | Location | npm | Version | Purpose |
|---------|----------|-----|---------|---------|
| **V1 API** | `n/migma-backend/src/routes/api/v1/` | — | — | REST endpoints |
| **SDK** | `migma/` | `migma` | 1.0.8 | TypeScript client library |
| **CLI** | `migma-cli/` | `@migma/cli` | 1.0.2 | Terminal commands |
| **MCP** | `migma-mcp/` | `@migma/mcp` | 1.0.2 | AI agent tools (Model Context Protocol) |
| **Skill** | `migma-skills/migma/` | — | — | OpenClaw AI skill definition |
| **Docs** | `migma-docs/` | — | — | Mintlify documentation site |

## Dependency Chain

```
V1 API (backend)
  ↑ called by
SDK (migma npm)
  ↑ used by
CLI (@migma/cli)  +  MCP (@migma/mcp)
  ↑ documented by
Skill (SKILL.md)  +  Docs (migma-docs)
```

When you change the V1 API, you must update **up the chain**. When you add a CLI command, you must update the skill + docs **sideways**.

---

## V1 REST API

### Auth

All V1 endpoints use API key authentication via `ApiKeyMiddleware`.

**Header options** (priority order):
1. `Authorization: ApiKey <key>` (preferred)
2. `Authorization: Bearer <key>` (backward compatible)
3. `X-API-Key: <key>` (fallback)

**Permissions** (stored on API key, checked per-endpoint):
```
audience:read    audience:write
email:send       email:read      email:validate   email:preview
template:read    domain:read     domain:write
webhook:read     webhook:write   project:write
```

**Rate limits** (Redis-based, per API key):
- Free: 100 req/min, 1,000 req/day
- Standard: 500 req/min, 10,000 req/day
- Enterprise: 1,000 req/min, 50,000 req/day

### Endpoint Reference

All routes are mounted at `/api/v1/`.

#### Projects

| Method | Path | Permission | Service |
|--------|------|------------|---------|
| `GET` | `/projects/:projectId` | `email:read` | `ProjectService` |
| `POST` | `/projects/import` | `email:send` | `ProjectImporter` |
| `POST` | `/projects/:projectId/emails/generate` | `email:send` | Agent pipeline |
| `GET` | `/projects/:projectId/emails` | `email:read` | `ConversationService` |
| `GET` | `/projects/:projectId/emails/:id/status` | `email:read` | `ConversationService` |
| `POST` | `/projects/:projectId/knowledge-base` | `project:write` | `KnowledgeBaseService` |
| `PATCH` | `/projects/:projectId/knowledge-base/:entryId` | `project:write` | `KnowledgeBaseService` |
| `DELETE` | `/projects/:projectId/knowledge-base/:entryId` | `project:write` | `KnowledgeBaseService` |
| `POST` | `/projects/:projectId/images` | `project:write` | `ProjectImageService` |
| `PATCH` | `/projects/:projectId/images/:imageId` | `project:write` | `ProjectImageService` |
| `DELETE` | `/projects/:projectId/images/:imageId` | `project:write` | `ProjectImageService` |
| `PATCH` | `/projects/:projectId/logos` | `project:write` | `ProjectService` |

#### Emails

| Method | Path | Permission | Service |
|--------|------|------------|---------|
| `POST` | `/emails/test/send` | `email:send` | `SystemEmailService` |

#### Sending

| Method | Path | Permission | Service |
|--------|------|------------|---------|
| `POST` | `/sending` | `email:send` | `EmailAudienceService` |
| `GET` | `/sending/:batchId` | `email:read` | `EmailBatchModel` |

**Send request shape:**
```json
{
  "recipientType": "email|audience|segment|tag",
  "recipientId": "string (for audience/segment/tag)",
  "recipientEmail": "string (for email)",
  "from": "sender@domain.com",
  "fromName": "Sender Name",
  "replyTo": "optional@reply.com",
  "subject": "Email Subject",
  "template": "HTML (if no conversationId)",
  "conversationId": "string (auto-resolves HTML + projectId)",
  "variables": { "key": "value" },
  "providerType": "ses|resend|sendgrid|mailgun|migma",
  "projectId": "string (if no conversationId)",
  "topicId": "string (optional)",
  "transactional": false
}
```

#### Contacts

| Method | Path | Permission | Notes |
|--------|------|------------|-------|
| `GET` | `/contacts` | `audience:read` | `?projectId=&page=&limit=&tags=&status=&search=` |
| `POST` | `/contacts` | `audience:write` | Create single contact |
| `GET` | `/contacts/:email` | `audience:read` | `?projectId=` |
| `PATCH` | `/contacts/:email` | `audience:write` | `?projectId=` |
| `POST` | `/contacts/:email/change-status` | `audience:write` | `?projectId=` |
| `DELETE` | `/contacts/:email` | `audience:write` | `?projectId=` |
| `POST` | `/contacts/bulk-import` | `audience:write` | Async via BullMQ, returns jobId |

**Backward-compatible alias:** `/subscribers` → `/contacts`

#### Segments

| Method | Path | Permission | Notes |
|--------|------|------------|-------|
| `GET` | `/segments` | `audience:read` | `?projectId=` |
| `POST` | `/segments` | `audience:write` | |
| `GET` | `/segments/:id` | `audience:read` | `?projectId=` |
| `PATCH` | `/segments/:id` | `audience:write` | `?projectId=` |
| `DELETE` | `/segments/:id` | `audience:write` | `?projectId=` |

**Backward-compatible alias:** `/audiences` → `/segments`

#### Tags

| Method | Path | Permission | Notes |
|--------|------|------------|-------|
| `GET` | `/tags` | `audience:read` | `?projectId=&page=&limit=&search=&sortBy=&sortOrder=` |
| `POST` | `/tags` | `audience:write` | |
| `GET` | `/tags/:id` | `audience:read` | `?projectId=` |
| `PATCH` | `/tags/:id` | `audience:write` | `?projectId=` |
| `DELETE` | `/tags/:id` | `audience:write` | `?projectId=` |

#### Topics

| Method | Path | Permission | Notes |
|--------|------|------------|-------|
| `GET` | `/topics` | `audience:read` | `?projectId=&includeInactive=` |
| `POST` | `/topics` | `audience:write` | |
| `GET` | `/topics/:id` | `audience:read` | `?projectId=` |
| `PATCH` | `/topics/:id` | `audience:write` | `?projectId=` |
| `DELETE` | `/topics/:id` | `audience:write` | `?projectId=` |

#### Campaigns

| Method | Path | Permission |
|--------|------|------------|
| `GET` | `/campaigns` | `email:read` |
| `POST` | `/campaigns` | `email:send` |
| `GET` | `/campaigns/:id` | `email:read` |
| `PATCH` | `/campaigns/:id` | `email:send` |
| `DELETE` | `/campaigns/:id` | `email:send` |
| `POST` | `/campaigns/:id/send` | `email:send` |
| `POST` | `/campaigns/:id/schedule` | `email:send` |
| `POST` | `/campaigns/:id/cancel` | `email:send` |
| `POST` | `/campaigns/:id/duplicate` | `email:send` |
| `POST` | `/campaigns/:id/test` | `email:send` |
| `GET` | `/campaigns/:id/stats` | `email:read` |
| `GET` | `/campaigns/:id/logs` | `email:read` |
| `POST` | `/campaigns/ab-test` | `email:send` |
| `POST` | `/campaigns/:id/ab-test/select-winner` | `email:send` |
| `GET` | `/campaigns/:id/ab-test/stats` | `email:read` |

#### Domains

| Method | Path | Permission | Notes |
|--------|------|------------|-------|
| `GET` | `/domains` | `domain:read` | List all domains |
| `POST` | `/domains` | `domain:write` | Add custom domain |
| `GET` | `/domains/:domain` | `domain:read` | |
| `POST` | `/domains/:domain/verify` | `domain:write` | Verify DNS |
| `PATCH` | `/domains/:domain` | `domain:write` | Update tracking settings |
| `DELETE` | `/domains/:domain` | `domain:write` | |
| `POST` | `/domains/managed/check-availability/:prefix` | `domain:write` | |
| `POST` | `/domains/managed` | `domain:write` | Create managed domain |
| `DELETE` | `/domains/managed/:domain` | `domain:write` | |

#### Validation

| Method | Path | Permission |
|--------|------|------------|
| `POST` | `/emails/validate/all` | `email:validate` |
| `POST` | `/emails/validate/compatibility` | `email:validate` |
| `POST` | `/emails/validate/links` | `email:validate` |
| `POST` | `/emails/validate/spelling` | `email:validate` |
| `POST` | `/emails/validate/deliverability` | `email:validate` |

#### Previews

| Method | Path | Permission | Notes |
|--------|------|------------|-------|
| `POST` | `/emails/previews` | `email:preview` | Standard previews (2 credits) |
| `GET` | `/emails/previews/:id` | `email:preview` | |
| `GET` | `/emails/previews/:id/status` | `email:preview` | Lightweight status check |
| `GET` | `/emails/previews/:id/devices/:key` | `email:preview` | |
| `GET` | `/emails/devices/supported` | `email:preview` | |
| `POST` | `/emails/advanced-previews` | `email:preview` | Mailgun-based (2 credits, cached) |
| `GET` | `/emails/advanced-previews/:id` | `email:preview` | |
| `GET` | `/emails/advanced-previews/:id/status` | `email:preview` | |
| `GET` | `/emails/advanced-previews/:id/devices/:key` | `email:preview` | |
| `GET` | `/emails/advanced-devices/supported` | `email:preview` | |

#### Export

| Method | Path | Permission |
|--------|------|------------|
| `GET` | `/export/html/:conversationId` | `email:read` |
| `GET` | `/export/klaviyo/:conversationId` | `email:read` |

#### Webhooks

| Method | Path | Permission |
|--------|------|------------|
| `POST` | `/webhooks` | `webhook:write` |
| `GET` | `/webhooks` | `webhook:read` |
| `GET` | `/webhooks/:id` | `webhook:read` |
| `PATCH` | `/webhooks/:id` | `webhook:write` |
| `DELETE` | `/webhooks/:id` | `webhook:write` |
| `GET` | `/webhooks/:id/deliveries` | `webhook:read` |
| `POST` | `/webhooks/:id/deliveries/:deliveryId/retry` | `webhook:write` |

#### Shopify

| Method | Path | Permission |
|--------|------|------------|
| `POST` | `/shopify/connect` | `email:read` |

### Webhook Event Types

```
email.generation.started     email.generation.completed    email.generation.failed
email.test.sent
project.import.started       project.import.processing
project.import.completed     project.import.failed
export.completed             export.failed
subscriber.added             subscriber.updated
subscriber.unsubscribed      subscriber.bulk_imported
api_key.created              api_key.revoked
```

---

## SDK (`migma/`)

### Architecture

```
migma/src/
├── index.ts          # Main export (Migma class + all types)
├── migma.ts          # Migma class — instantiates all resources
├── client.ts         # MigmaClient — fetch-based HTTP with retry
├── errors.ts         # MigmaError + MigmaErrorCode enum
├── polling.ts        # poll() helper for async operations
├── resources/        # One file per API resource (15 files)
│   ├── contacts.ts
│   ├── tags.ts
│   ├── segments.ts
│   ├── topics.ts
│   ├── sending.ts
│   ├── projects.ts
│   ├── emails.ts
│   ├── validation.ts
│   ├── previews.ts
│   ├── export.ts
│   ├── domains.ts
│   ├── webhooks.ts
│   ├── knowledge-base.ts
│   ├── images.ts
│   └── campaigns.ts
└── types/            # One file per resource type definitions
    ├── contacts.ts
    ├── tags.ts
    ├── segments.ts
    ├── topics.ts
    ├── sending.ts
    ├── projects.ts
    ├── emails.ts
    ├── validation.ts
    ├── previews.ts
    ├── export.ts
    ├── domains.ts
    ├── webhooks.ts
    ├── knowledge-base.ts
    ├── images.ts
    └── campaigns.ts
```

### Key Patterns

**Result type (never throws):**
```typescript
type MigmaResult<T> = { data: T; error: null } | { data: null; error: MigmaError }
```

**All SDK methods return `MigmaResult<T>`.** The SDK never throws exceptions.

**HTTP client retry:** Retries on 5xx and 429, exponential backoff, respects `Retry-After` header.

**Polling helpers** for async operations:
- `migma.emails.generateAndWait()` — polls `getGenerationStatus()`
- `migma.projects.importAndWait()` — polls `getImportStatus()`
- `migma.previews.createAndWait()` — polls `get()`
- Default: 2s interval, 150 max attempts (~5 min)

**Resource ↔ API mapping:** Each resource class maps 1:1 to a V1 API section. Methods call `this.client.get/post/patch/delete()` with the V1 path.

### Build

```bash
cd migma
yarn build        # tsup: CJS + ESM + .d.ts
yarn test:live    # Live integration tests (needs MIGMA_API_KEY)
```

**tsup config:** Entry `src/index.ts`, formats `cjs` + `esm`, declarations enabled, Node 18+.

### Publishing

```bash
cd migma
npm version patch   # or minor/major
npm publish         # publishes to npm as 'migma'
```

---

## CLI (`migma-cli/`)

### Architecture

```
migma-cli/src/
├── bin.ts            # Entry point — registers all commands
├── client.ts         # Creates Migma SDK instance from config
├── config.ts         # ~/.migma/config.json management
├── output.ts         # Human + JSON output formatting
└── commands/         # One file per command group
    ├── auth.ts       # login, logout, whoami
    ├── projects.ts   # list, get, import, use
    ├── generate.ts   # generate, generate-status
    ├── send.ts       # send, send-test, batch-status
    ├── contacts.ts   # list, add, get, update, remove, import
    ├── tags.ts       # list, create, delete
    ├── segments.ts   # list, create, get, delete
    ├── validate.ts   # all, compatibility, links, spelling, deliverability
    ├── export.ts     # html, mjml, pdf, klaviyo, mailchimp, hubspot
    ├── domains.ts    # list, add, verify, managed create, managed delete
    ├── webhooks.ts   # list, create, test, delete
    ├── emails.ts     # list
    └── campaigns.ts  # list, create, get, send, schedule, cancel
```

### Config Storage

```
~/.migma/config.json
{
  "apiKey": "sk_...",
  "defaultProjectId": "proj_...",
  "baseUrl": "https://..." (optional override)
}
```

**Config priority:** env vars (`MIGMA_API_KEY`, `MIGMA_PROJECT_ID`, `MIGMA_BASE_URL`) > config file > CLI flags.

### Global Flag

`--json` — All commands support JSON output for machine consumption. Without it, outputs human-readable tables and formatted text.

### Command → SDK Mapping

| CLI Command | SDK Method |
|-------------|-----------|
| `migma generate <prompt> --wait` | `emails.generateAndWait()` |
| `migma generate <prompt>` | `emails.generate()` |
| `migma generate-status <id>` | `emails.getGenerationStatus()` |
| `migma send --to/--segment/--tag` | `sending.send()` |
| `migma send-test <id> --to` | `emails.sendTest()` |
| `migma batch-status <id>` | `sending.getBatchStatus()` |
| `migma contacts list` | `contacts.list()` |
| `migma contacts add` | `contacts.create()` |
| `migma contacts import <csv>` | `contacts.bulkImport()` |
| `migma validate all` | `validation.all()` |
| `migma export html <id>` | `export.html()` |
| `migma domains managed create` | `domains.createManaged()` |
| `migma projects import <url> --wait` | `projects.importAndWait()` |
| `migma webhooks create` | `webhooks.create()` |
| `migma campaigns list` | `campaigns.list()` |
| `migma campaigns create` | `campaigns.create()` |
| `migma campaigns get <id>` | `campaigns.get()` |
| `migma campaigns send <id>` | `campaigns.send()` |
| `migma campaigns schedule <id>` | `campaigns.schedule()` |
| `migma campaigns cancel <id>` | `campaigns.cancel()` |

### Build & Publish

```bash
cd migma-cli
yarn build        # tsup → dist/bin.mjs
npm version patch
npm publish        # publishes as '@migma/cli'
```

**Note:** `SKILL.md` is included in the npm package (`"files": ["dist", "SKILL.md"]`).

---

## MCP Server (`migma-mcp/`)

### Architecture

```
migma-mcp/src/
├── index.ts          # MCP server init + tool registration
├── client.ts         # Lazy-loads Migma SDK
├── config.ts         # Zod-validated config (apiKey, projectId, baseUrl)
└── tools/            # One file per tool group
    ├── projects.ts   # 3 tools
    ├── emails.ts     # 3 tools
    ├── sending.ts    # 1 tool
    ├── validation.ts # 3 tools
    ├── export.ts     # 6 tools
    ├── domains.ts    # 3 tools
    ├── contacts.ts   # 4 tools
    ├── tags.ts       # 3 tools
    ├── segments.ts   # 3 tools
    ├── webhooks.ts   # 4 tools
    └── campaigns.ts  # 5 tools
```

### Tools (38 total)

Each tool maps directly to an SDK method. Tool names are prefixed with `migma_`.

| Tool Group | Tools | Count |
|-----------|-------|-------|
| Projects | `list_projects`, `get_project`, `import_brand` | 3 |
| Emails | `generate_email`, `get_generation_status`, `send_test_email` | 3 |
| Sending | `send_email` | 1 |
| Validation | `validate_email`, `validate_compatibility`, `validate_deliverability` | 3 |
| Export | `export_html/mjml/pdf/klaviyo/mailchimp/hubspot` | 6 |
| Domains | `list_domains`, `create_managed_domain`, `verify_domain` | 3 |
| Contacts | `list/add/get/remove_contact` | 4 |
| Tags | `list/create/delete_tag` | 3 |
| Segments | `list/create/delete_segment` | 3 |
| Webhooks | `list/create/test/delete_webhook` | 4 |
| Campaigns | `list_campaigns`, `create_campaign`, `send_campaign`, `schedule_campaign`, `cancel_campaign` | 5 |

**Config:** `MIGMA_API_KEY` (required), `MIGMA_PROJECT_ID` (optional default), `MIGMA_BASE_URL` (optional).

### Build & Publish

```bash
cd migma-mcp
yarn build        # tsc → dist/
npm version patch
npm publish        # publishes as '@migma/mcp'
```

**Smithery registry:** `smithery-config.json` defines the config schema for the Smithery MCP registry.

---

## Skill (`migma-skills/migma/`)

### Structure

```
migma-skills/migma/
├── SKILL.md              # OpenClaw skill definition (YAML frontmatter + Markdown)
└── references/
    └── workflows.md      # 15 example conversation workflows
```

### What It Contains

The skill teaches AI agents how to use the CLI. It covers:
- Authentication (`login`, `whoami`, `logout`)
- First-time setup (managed domain + default project)
- Email generation (`generate` with `--wait`, `--reference`, `--image`, `--save`, `--open`)
- Sending (`send` with `--to`, `--segment`, `--tag`, `--from-conversation`, `--var`, `--transactional`)
- Validation (`validate all/compatibility/links/spelling/deliverability`)
- Export (`export html/mjml/pdf/klaviyo/mailchimp/hubspot`)
- Contact management (CRUD + bulk import)
- Tag/segment management
- Domain management (custom + managed)
- Webhook management
- Error handling (JSON format)

### When to Update

Update the skill whenever you:
- Add a new CLI command
- Change CLI flags or output format
- Add a new workflow pattern

---

## Documentation (`migma-docs/`)

### Structure

Mintlify-based static site. Config in `docs.json`.

```
migma-docs/
├── docs.json                   # Navigation, theme, tabs, OpenAPI spec
├── index.mdx                   # Homepage
├── get-started/                # 6 getting started pages
├── tutorials/                  # Step-by-step tutorials
├── creating-emails/            # Email creation guides (7 pages)
├── creative-studio/            # Image/GIF/social guides (3 pages)
├── email-editor/               # Editor docs (3 pages)
├── campaigns/                  # Campaign docs (5 pages)
├── audience/                   # Audience management (6 pages)
├── sending-domains/            # Domain setup (11 pages)
├── integrations/               # Integration guides (6 pages)
├── advanced-features/          # Advanced features
├── api-reference/              # API reference
│   ├── introduction.mdx
│   ├── quickstart.mdx
│   ├── authentication.mdx
│   ├── sdk.mdx                 # SDK docs
│   ├── cli.mdx                 # CLI docs
│   ├── openclaw.mdx            # OpenClaw skill docs
│   ├── skills.mdx              # Skills overview
│   ├── mcp.mdx                 # MCP server docs
│   ├── webhooks.mdx            # Webhook guide
│   ├── n8n.mdx                 # n8n integration
│   └── endpoints/              # Auto-generated from OpenAPI
├── referral/                   # Referral program
├── comparisons/                # Competitor comparisons
├── case-studies/               # Case studies
├── security/                   # Security & compliance
├── legal/                      # Terms & privacy
└── about/                      # About pages
```

### Deploy

Mintlify auto-deploys on push to the `migma-docs` repo/directory.

```bash
cd migma-docs
npx mintlify dev    # Local preview at localhost:3000
# Push to deploy
```

### When to Update Docs

- New API endpoint → add to `api-reference/endpoints/`
- New SDK resource → update `api-reference/sdk.mdx`
- New CLI command → update `api-reference/cli.mdx`
- New MCP tool → update `api-reference/mcp.mdx`
- Changed auth/rate limits → update `api-reference/authentication.mdx`

---

## Change Workflow

### Adding a New V1 Endpoint

1. **Backend** (`n/migma-backend/src/routes/api/v1/`)
   - Add route with `apiKeyMiddleware.requirePermissions()`
   - Add rate limiting
   - Define types in `src/types/`
   - Wire to service

2. **SDK** (`migma/src/`)
   - Add method to relevant resource class in `resources/`
   - Add types in `types/`
   - Export new types from `index.ts`
   - Run `yarn build` and test

3. **CLI** (`migma-cli/src/commands/`)
   - Add command in relevant command file
   - Wire to SDK method via `client.ts`
   - Handle `--json` output
   - Run `yarn build`

4. **MCP** (`migma-mcp/src/tools/`)
   - Add tool in relevant tool file
   - Define Zod input schema
   - Wire to SDK method
   - Run `yarn build`

5. **Skill** (`migma-skills/migma/SKILL.md`)
   - Add CLI usage example
   - Add workflow if applicable to `references/workflows.md`

6. **Docs** (`migma-docs/`)
   - Add endpoint to API reference
   - Update SDK/CLI/MCP pages if applicable

### Publishing After Changes

```bash
# 1. Build and test SDK
cd migma && yarn build && MIGMA_API_KEY=... npx tsx test-live.ts

# 2. Bump SDK version
cd migma && npm version patch && npm publish

# 3. Update CLI dependency and publish
cd migma-cli && yarn upgrade migma && yarn build && npm version patch && npm publish

# 4. Update MCP dependency and publish
cd migma-mcp && yarn upgrade migma && yarn build && npm version patch && npm publish

# 5. Deploy docs (auto on push)
cd migma-docs && npx mintlify dev  # verify locally first
```

### Versioning Rules

- **Patch** (1.0.x): New endpoints, bug fixes, new CLI commands
- **Minor** (1.x.0): New resource classes, new features
- **Major** (x.0.0): Breaking changes to existing methods/types

SDK, CLI, and MCP don't need to share the same version number, but the CLI and MCP must depend on a compatible SDK version.

---

## Type Sync Reference

Types must stay aligned across packages. Here's where each resource's types live:

| Resource | Backend Types | SDK Types | CLI Uses |
|----------|--------------|-----------|----------|
| Contacts | `src/types/api/subscriber.ts` | `migma/src/types/contacts.ts` | SDK types |
| Tags | (inline in route) | `migma/src/types/tags.ts` | SDK types |
| Segments | `src/types/audience.ts` | `migma/src/types/segments.ts` | SDK types |
| Topics | (inline in route) | `migma/src/types/topics.ts` | SDK types |
| Sending | `src/types/email-queue.ts` | `migma/src/types/sending.ts` | SDK types |
| Projects | `src/types/project.ts` | `migma/src/types/projects.ts` | SDK types |
| Emails | `src/types/generation.ts` | `migma/src/types/emails.ts` | SDK types |
| Validation | (inline in route) | `migma/src/types/validation.ts` | SDK types |
| Previews | `src/types/api/v1-previews.types.ts` | `migma/src/types/previews.ts` | SDK types |
| Export | (inline in route) | `migma/src/types/export.ts` | SDK types |
| Domains | `src/types/ses-tenant.ts` | `migma/src/types/domains.ts` | SDK types |
| Webhooks | `src/types/api-webhook.ts` | `migma/src/types/webhooks.ts` | SDK types |
| Knowledge Base | (inline in route) | `migma/src/types/knowledge-base.ts` | SDK types |
| Images | (inline in route) | `migma/src/types/images.ts` | SDK types |
| Campaigns | `src/types/campaign.ts` | `migma/src/types/campaigns.ts` | SDK types |

The CLI and MCP never define their own types — they use the SDK's types directly.

---

## Testing

### SDK Live Tests
```bash
cd migma
MIGMA_API_KEY=sk_... npx tsx test-live.ts
# Optional: MIGMA_PROJECT_ID=... MIGMA_BASE_URL=http://localhost:3001/api/v1
```

Tests: projects list/get, tags CRUD, contacts CRUD, segments list, topics list, domains list, webhooks list, export formats, knowledge base list, error handling.

### Backend Tests
```bash
cd n/migma-backend
yarn test:dev          # Dev tests
yarn build             # TypeScript compilation check
```

### CLI Manual Testing
```bash
cd migma-cli && yarn build
node dist/bin.mjs login
node dist/bin.mjs projects list --json
node dist/bin.mjs generate "Welcome email" --wait --json
```

### MCP Manual Testing
```bash
cd migma-mcp && yarn build
# Test via MCP inspector or Claude Desktop
```
