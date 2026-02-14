---
name: migma
description: Generate, send, validate, and export AI-powered emails from the terminal using the Migma CLI. Use when creating email campaigns, importing brands, managing contacts/tags/segments, validating email HTML, exporting to Klaviyo/Mailchimp/HubSpot, or managing sending domains and webhooks.
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

# Migma CLI

AI-powered email generation, validation, sending, and export — all from the terminal.

All commands support `--json` for machine-readable output. Always use `--json` when parsing results.

## Setup

```bash
# Install
npm install -g @migma/cli

# Authenticate (interactive)
migma login

# Or use environment variable
export MIGMA_API_KEY=sk_live_...

# Set default project
migma projects list --json
migma projects use <projectId>
```

## Generate Emails

```bash
# Generate and wait for result
migma generate "Summer sale — 30% off everything" --wait --json

# Save HTML locally
migma generate "Welcome email for new users" --wait --save ./email.html --json

# With reference image
migma generate "Recreate this design" --wait --image https://example.com/ref.png --json

# Fire-and-forget (returns conversationId)
migma generate "Product launch announcement" --json

# Check status
migma generate status <conversationId> --json
```

JSON output on `--wait` includes `conversationId`, `subject`, `html`, and `status`.

## Send Emails

```bash
# Send to individual
migma send --to user@example.com --subject "Hello" --html ./email.html \
  --from hello@yourdomain.com --from-name "Brand" --json

# Send from a generated email (auto-exports HTML)
migma send --to user@example.com --subject "Welcome" \
  --from-conversation <conversationId> \
  --from hello@yourdomain.com --from-name "Brand" --json

# Send to segment or tag
migma send --segment <segmentId> --subject "Campaign" --html ./email.html \
  --from hello@yourdomain.com --from-name "Brand" --json
migma send --tag <tagId> --subject "Update" --html ./email.html \
  --from hello@yourdomain.com --from-name "Brand" --json

# Template variables (repeatable --var)
migma send --to user@example.com --subject "Hi {{name}}" --html ./email.html \
  --from hello@yourdomain.com --from-name "Brand" \
  --var name=John --var discount=20 --json

# Test email
migma send test <conversationId> --to test@example.com --json

# Batch status
migma send batch-status <batchId> --json
```

## Validate Emails

All accept `--html <file>` or `--conversation <conversationId>`.

```bash
migma validate all --html ./email.html --json           # All checks + overall score
migma validate compatibility --html ./email.html --json  # Email client compatibility
migma validate links --html ./email.html --json          # Broken link detection
migma validate spelling --html ./email.html --json       # AI grammar/spelling
migma validate deliverability --html ./email.html --json # Spam score
```

## Export

All support `--output <file>` to save locally.

```bash
migma export html <conversationId> --json
migma export html <conversationId> --output ./email.html
migma export mjml <conversationId> --json
migma export pdf <conversationId> --json
migma export klaviyo <conversationId> --type hybrid --json
migma export mailchimp <conversationId> --json
migma export hubspot <conversationId> --json
```

## Contacts

```bash
migma contacts list --json
migma contacts add --email user@example.com --firstName John --json
migma contacts get <id> --json
migma contacts update <id> --firstName Jane --json
migma contacts remove <id> --json
migma contacts import ./contacts.csv --json   # Bulk CSV import
```

CSV columns: `email` (required), `firstName`, `lastName`, plus any custom fields.

## Tags

```bash
migma tags list --json
migma tags create --name "VIP" --json
migma tags delete <id> --json
```

## Segments

```bash
migma segments list --json
migma segments create --name "Active Users" --description "..." --json
migma segments get <id> --json
migma segments delete <id> --json
```

## Projects

```bash
migma projects list --json          # List projects
migma projects list --all --json    # All pages
migma projects get <id> --json      # Details
migma projects import <url> --wait --json  # Import brand
migma projects use <id>             # Set default
```

## Domains

```bash
migma domains list --json
migma domains add example.com --json
migma domains verify example.com --json
migma domains managed create myprefix --json    # Instant, no DNS
migma domains managed delete myprefix.migma.email --json
```

## Webhooks

```bash
migma webhooks list --json
migma webhooks create --url https://example.com/hook \
  --events email.generation.completed,email.test.sent --json
migma webhooks test <id> --json
migma webhooks delete <id> --json
```

## Common Workflows

For detailed multi-step workflow examples, see [workflows.md](references/workflows.md).

## Environment Variables

| Variable | Description |
|----------|-------------|
| `MIGMA_API_KEY` | API key (required) |
| `MIGMA_PROJECT_ID` | Default project ID |
| `MIGMA_BASE_URL` | Custom API base URL |

## Error Output

On error with `--json`:

```json
{
  "error": {
    "message": "Not found",
    "code": "not_found",
    "statusCode": 404
  }
}
```
