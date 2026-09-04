# Migma Agent Skills and Plugin

Official installable Migma skills and plugin for AI coding agents.

## Skills

- `setup` - audit an existing app, create or reuse Migma emails, and wire backend sends safely.
- `migma` - create, edit, test, send, campaign, validate, and export Migma emails through the CLI.
- `migma-public-api` - choose and use the REST API, SDK, CLI, or MCP server from app code.

## Install

One prompt sets up skills, CLI, and MCP in any AI coding agent. Paste into your agent:

```text
Fetch and execute the appropriate instructions to set me up for Migma from https://docs.migma.ai/agent-setup.md
```

Or install manually:

```bash
npx skills add MigmaAI/migma-skills --list
npx skills add MigmaAI/migma-skills
```

Install the CLI and all skills together:

```bash
curl -fsSL https://install.migma.ai/setup | sh
```

Install all skills globally with the script:

```bash
curl -fsSL https://install.migma.ai/skills | sh
```

Install only the CLI:

```bash
curl -fsSL https://install.migma.ai/cli | sh
```

Hosted redirect targets:

- `https://install.migma.ai/skills` -> `https://raw.githubusercontent.com/MigmaAI/migma-skills/main/install.sh`
- `https://install.migma.ai/setup` -> `https://raw.githubusercontent.com/MigmaAI/migma-skills/main/setup.sh`
- `https://install.migma.ai/cli` -> `https://raw.githubusercontent.com/MigmaAI/migma-skills/main/install-cli.sh`

Install one skill:

```bash
npx skills add MigmaAI/migma-skills --skill setup
npx skills add MigmaAI/migma-skills --skill migma
npx skills add MigmaAI/migma-skills --skill migma-public-api
```

## Plugin

### Codex

```bash
codex plugin marketplace add MigmaAI/migma-skills
codex plugin add migma@migma-plugins
```

### ChatGPT

Migma is available in ChatGPT's public Plugin Directory. Open **Plugins**, search for **Migma**, then select **Connect** or **Try now**. Invoke it with `@Migma` and complete browser OAuth when prompted.

Visual setup: [Connect Migma to ChatGPT](https://docs.migma.ai/tutorials/connect-migma-to-chatgpt). Workspaces that manage their own connector can still add `https://migma.ai/mcp` through custom MCP.

### Cursor

Paste `https://github.com/MigmaAI/migma-skills` into Settings > Plugins, then install Migma.

### Grok

Migma bundles its hosted MCP server and Grok operating guidance. In Grok Bot desktop, paste:

```text
Read https://docs.migma.ai/grok.md and connect this Grok Bot to Migma Remote MCP at https://migma.ai/mcp. Reuse the existing Migma connection when available. Ask before adding it. Use connected Migma tools for routine work. Complete access through browser OAuth, then verify by listing my Migma brands read-only.
```

After connection, Grok Bot uses Migma tools directly. Browser use is only for human sign-in/access approval or explicit browser fallback.

Agent-guided Remote MCP setup is beta. Marketplace availability varies by Grok build and workspace policy. Grok web and Grok Build are separate clients.

For Grok web, open `https://grok.com/connectors`, choose **New Connector → Custom**, and add `https://migma.ai/mcp`.

For Grok Build, add Migma from CLI:

```bash
grok mcp add --transport http migma https://migma.ai/mcp
```

Grok Build opens browser OAuth on first use. Grok Bot's cloud computer cannot receive an OAuth callback, so Grok Bot connects with claim-code from `https://api.migma.ai/auth.md`: it shows one approval link, the user approves in the browser, and it stores the returned credential. Confirm durable connector state after claim-code.

Verify with:

```bash
grok mcp doctor migma
```

Start read-only:

```text
Use Migma to list my brands read-only. State the Migma tool used.
```

Keep live sends, schedules, audience changes, and publishing behind explicit approval.

Runtime guidance: `skills/migma/SKILL.md` and `skills/migma/references/grok-bot.md`. Human tutorial: [Connect Migma to Grok Bot](https://docs.migma.ai/grok).

### Claude

```bash
claude plugin marketplace add MigmaAI/migma-skills
claude plugin install migma@migma-plugins
```

## Verify

After install, try one task:

- "Set up Migma in this app."
- "Create a transactional email with Migma."
- "Wire this selected Migma email into my backend."

For a local checkout:

```bash
npx skills add . --list
```

## Repository Structure

- `.codex-plugin/`, `.cursor-plugin/`, `.claude-plugin/` - plugin manifests
- `mcp.json`, `.mcp.json` - hosted Migma MCP definitions for compatible plugin hosts
- `.agents/plugins/marketplace.json` - Codex marketplace entry
- `install-cli.sh` - installs the public `@migma/cli` npm package
- `install.sh` - installs all public Migma skills
- `setup.sh` - installs CLI plus skills
- `skills/setup/` - app setup workflow
- `skills/migma/` - daily Migma CLI workflow
- `skills/migma-public-api/` - REST, SDK, CLI, and MCP guidance
- `assets/` - plugin artwork

## Source of Truth

Product behavior changes faster than this repo. Before implementation, verify details against:

- Docs: https://docs.migma.ai
- API reference: https://docs.migma.ai/api-reference/introduction
- CLI: https://docs.migma.ai/cli
- MCP server: https://docs.migma.ai/mcp-server
- Agent auth: https://api.migma.ai/auth.md

Keep `SKILL.md` files concise. Put long workflows in `references/`.
