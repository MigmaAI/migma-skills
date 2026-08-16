# OpenAI Plugin Directory submission packet

Use this packet for Migma's public OpenAI plugin submission. Never add reviewer credentials, OAuth tokens, API keys, or domain-verification tokens to this repository.

## Submission type

- Type: With MCP, plus uploaded skills
- MCP URL type: Universal
- MCP URL: `https://migma.ai/mcp`
- Skills: `skills/setup`, `skills/migma`, `skills/public-api`
- UI: None in first submission

Do not submit `migma-chatgpt-app/`. That prototype is not the production hosted MCP service.

## Listing

- Name: Migma
- Category: Productivity
- Short description: Create, improve, validate, and send branded email from ChatGPT.
- Long description: Connect Migma to prepare branded transactional and marketing emails, review existing designs, run email checks, manage contacts and campaigns, export finished work, and send only with the permissions and approvals you grant.
- Developer: Migma
- Website: `https://migma.ai`
- Support: `https://migma.ai/support`
- Privacy: `https://docs.migma.ai/legal/privacy-policy`
- Terms: `https://docs.migma.ai/legal/terms-of-use`
- Logo source: `assets/logo-square.svg`

## Starter prompts

1. List my Migma brands. Do not create, export, or send anything.
2. Show my recent email designs for this brand and open the newest preview.
3. Validate this email for compatibility and deliverability. Do not change it.
4. Create a draft welcome email for this brand. Stop before sending.
5. Prepare a test send to my address and ask before sending it.

## Positive review cases

### 1. Read-only brand discovery

Prompt: `List my Migma brands. Do not change anything.`

Expected: OAuth requests only needed read scopes. Migma lists accessible brands. No write tool runs.

### 2. Email preview

Prompt: `Show the latest email for <brand> without returning raw HTML.`

Expected: Migma finds the brand, lists emails, and returns preview image plus Migma link. Raw HTML stays omitted.

### 3. Email validation

Prompt: `Run compatibility and deliverability checks on <emailId>. Do not edit it.`

Expected: Validation tools return findings. Email remains unchanged.

### 4. Draft creation

Prompt: `Create a draft launch email for <brand>. Do not send it.`

Expected: Migma requests draft-write permission, starts generation, polls status, and returns preview plus link. No send tool runs.

### 5. Confirmed test send

Prompt: `Send <emailId> as a test to reviewer@example.com.`

Expected: ChatGPT shows action confirmation because tool sends external email. After approval, Migma sends once and returns delivery result.

## Negative review cases

### 1. Missing authentication

Prompt: `List my Migma contacts.`

Expected: ChatGPT starts Migma OAuth. No account data appears before successful authentication.

### 2. Insufficient scope

Setup: Connect with `email:read` only.

Prompt: `Send this email now.`

Expected: Send tool is unavailable or request returns permission error. Migma does not widen scope silently and sends nothing.

### 3. Invalid or inaccessible resource

Prompt: `Open emailId <id owned by another account or unknown>.`

Expected: Migma returns not-found/access error without leaking resource data or account identity.

## Release notes

Initial public submission. Includes scoped browser OAuth, Migma email and campaign workflows, complete MCP action annotations, and public Migma skills for setup and API use.

## Portal checklist

- [ ] Submitter has Apps Management write permission in correct OpenAI organization.
- [ ] Migma business identity is verified in same organization.
- [ ] OpenAI project uses global data residency.
- [ ] Reviewer demo account has sample brands, emails, contacts, and campaigns; no inaccessible 2FA step.
- [ ] Production MCP scan passes with every tool showing correct `readOnlyHint`, `openWorldHint`, and `destructiveHint`.
- [ ] OAuth consent grants exactly requested scopes.
- [ ] Privacy text receives human legal review.
- [ ] Domain challenge token is served alone from `/.well-known/openai-apps-challenge`.
- [ ] Country availability is selected.
- [ ] After developer-mode registration returns real `plugin_asdk_app…` ID, add `.app.json` binding and `apps` manifest field through plugin-creator workflow.
