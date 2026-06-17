# Migma Agent Skills and Plugin

Official installable Migma skills and plugin for AI coding agents.

## Skills

- `setup` - audit an existing app, create or reuse Migma emails, and wire backend sends safely.
- `migma` - create, edit, test, send, campaign, validate, and export Migma emails through the CLI.
- `migma-public-api` - choose and use the REST API, SDK, CLI, or MCP server from app code.

## Install

```bash
npx skills add MigmaAI/migma-skills --list
npx skills add MigmaAI/migma-skills
```

Install all skills globally with the script:

```bash
curl -fsSL https://raw.githubusercontent.com/MigmaAI/migma-skills/main/install.sh | sh
```

Optional hosted redirect target:

- `https://install.migma.ai/skills` -> `https://raw.githubusercontent.com/MigmaAI/migma-skills/main/install.sh`

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

### Cursor

Paste `https://github.com/MigmaAI/migma-skills` into Settings > Plugins, then install Migma.

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
- `.agents/plugins/marketplace.json` - Codex marketplace entry
- `skills/setup/` - app setup workflow
- `skills/migma/` - daily Migma CLI workflow
- `skills/public-api/` - REST, SDK, CLI, and MCP guidance
- `assets/` - plugin artwork

## Source of Truth

Product behavior changes faster than this repo. Before implementation, verify details against:

- Docs: https://docs.migma.ai
- API reference: https://docs.migma.ai/api-reference/introduction
- CLI: https://docs.migma.ai/cli
- MCP server: https://docs.migma.ai/mcp
- Agent auth: https://api.migma.ai/auth.md

Keep `SKILL.md` files concise. Put long workflows in `references/`.
