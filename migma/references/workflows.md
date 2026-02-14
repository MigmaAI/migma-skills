# Migma Workflows

Detailed multi-step workflow examples for common email tasks.

## Generate, Validate, and Send

```bash
# 1. Generate an email and save HTML locally
migma generate "Black Friday sale — 40% off everything" --wait --save ./bf-sale.html --json

# 2. Validate the email (check all: compatibility, links, spelling, deliverability)
migma validate all --html ./bf-sale.html --json

# 3. Send a test to yourself first
migma send --to test@yourteam.com --subject "Black Friday Sale" --html ./bf-sale.html \
  --from hello@yourdomain.com --from-name "Your Brand" --json

# 4. Send to your VIP segment
migma send --segment <segmentId> --subject "Black Friday Sale" --html ./bf-sale.html \
  --from hello@yourdomain.com --from-name "Your Brand" --json
```

## Import Brand, Generate, and Export

```bash
# 1. Import your brand from a website (waits for completion)
migma projects import https://yourbrand.com --wait --json

# 2. Note the projectId from the JSON output, set as default
migma projects use <projectId>

# 3. Generate an email using that brand
migma generate "Monthly newsletter about product updates" --wait --save ./newsletter.html --json

# 4. Export to Klaviyo
migma export klaviyo <conversationId> --json

# 5. Or export HTML and save locally
migma export html <conversationId> --output ./newsletter-final.html
```

## Bulk Contact Import and Campaign

```bash
# 1. Import contacts from CSV
migma contacts import ./subscribers.csv --json

# 2. Create a tag for this campaign
migma tags create --name "Launch List" --json

# 3. Generate the campaign email
migma generate "Product launch announcement for early adopters" --wait --save ./launch.html --json

# 4. Validate before sending
migma validate all --html ./launch.html --json

# 5. Send to the tag
migma send --tag <tagId> --subject "We're Live!" --html ./launch.html \
  --from hello@yourdomain.com --from-name "Your Brand" --json
```

## Set Up Sending Domain

```bash
# Option A: Instant managed domain (no DNS required)
migma domains managed create mycompany --json
# Sends from: anything@mycompany.migma.email

# Option B: Custom domain (requires DNS records)
migma domains add mail.yourbrand.com --json
# Follow the DNS instructions in the output
migma domains verify mail.yourbrand.com --json
```

## Generate with Template Variables

```bash
# Generate a personalized email template
migma generate "Welcome email with personalization for {{name}} and {{company}}" \
  --wait --save ./welcome.html --json

# Send with variables filled in
migma send --to sarah@example.com --subject "Welcome, Sarah!" --html ./welcome.html \
  --from hello@yourdomain.com --from-name "Your Brand" \
  --var name=Sarah --var company=Acme --json
```

## Export to Multiple Platforms

```bash
# Generate once, export to multiple platforms
migma generate "Q1 product update email" --wait --json

# Export HTML for your own sending
migma export html <conversationId> --output ./q1-update.html

# Export for Klaviyo
migma export klaviyo <conversationId> --type hybrid --json

# Export for Mailchimp
migma export mailchimp <conversationId> --json

# Export for HubSpot
migma export hubspot <conversationId> --json

# Export as PDF for stakeholder review
migma export pdf <conversationId> --json
```

## Set Up Webhooks for Event Notifications

```bash
# Create a webhook for email generation events
migma webhooks create \
  --url https://your-server.com/webhooks/migma \
  --events email.generation.completed,email.test.sent --json

# Test the webhook
migma webhooks test <webhookId> --json

# List all webhooks
migma webhooks list --json
```
