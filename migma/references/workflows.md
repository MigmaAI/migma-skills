# Example Conversations

Real examples of what users ask and how to handle them.

## "Create a welcome email and send it to sarah@example.com"

```bash
# Generate the email
migma generate "Welcome email for new subscribers" --wait --json
# Send it
migma send --to sarah@example.com --subject "<subject from generate>" \
  --from-conversation <conversationId> \
  --from hello@company.migma.email --from-name "Company" --json
```

## "Design a Black Friday sale email with 40% off"

```bash
migma generate "Black Friday sale — 40% off everything, highlight our best sellers" --wait --json
```

Show the user the subject line and let them know the email is ready. If they want to preview, add `--save ./bf.html` and tell them where the file is.

## "Send that email to all our VIP customers"

```bash
# Find the VIP tag or segment
migma tags list --json
# Send to the tag
migma send --tag <tagId> --subject "Black Friday: 40% Off" \
  --from-conversation <conversationId> \
  --from hello@company.migma.email --from-name "Company" --json
```

## "Check if this email will land in spam"

```bash
migma validate deliverability --conversation <conversationId> --json
# Or for a full check:
migma validate all --conversation <conversationId> --json
```

## "Import our brand from our website"

```bash
migma projects import https://theirwebsite.com --wait --json
migma projects use <projectId>
```

## "Export this email to Klaviyo"

```bash
migma export klaviyo <conversationId> --json
```

## "Add these contacts to our list"

```bash
# Single contact
migma contacts add --email john@example.com --firstName John --lastName Doe --json

# Bulk from CSV
migma contacts import ./contacts.csv --json
```

## "Set up a sending domain for us"

```bash
# Instant (no DNS)
migma domains managed create companyname --json
# → hello@companyname.migma.email is ready immediately
```

## "Create a follow-up to my last email"

```bash
# List recent emails to find the one to follow up on
migma emails list --project <projectId> --limit 5 --json
# Generate a follow-up referencing the previous email
migma generate "Follow-up email — remind them about the offer" --reference <conversationId> --wait --json
```

## "Make a series of 3 emails for our launch"

```bash
# Email 1: The announcement
migma generate "Product launch announcement — we're live!" --wait --json
# Email 2: Follow-up (references email 1)
migma generate "Launch follow-up — key features deep dive" --reference <email1ConversationId> --wait --json
# Email 3: Last chance (references email 2)
migma generate "Last chance — launch offer ends tomorrow" --reference <email2ConversationId> --wait --json
```

## "Create something similar to that welcome email"

```bash
# Find the welcome email
migma emails list --project <projectId> --search welcome --json
# Remix it
migma generate "Welcome email for our premium tier" --reference <conversationId> --wait --json
```

## "Create a product launch email, validate it, then send to our launch list"

```bash
# Generate
migma generate "Product launch announcement — our new feature is live" --wait --save ./launch.html --json

# Validate
migma validate all --html ./launch.html --json

# Send test first
migma send --to test@company.com --subject "Product Launch" --html ./launch.html \
  --from hello@company.migma.email --from-name "Company" --json

# Send to segment
migma send --segment <segmentId> --subject "Product Launch" --html ./launch.html \
  --from hello@company.migma.email --from-name "Company" --json
```

## "Set up a webhook to track email events"

```bash
# Create a webhook for delivery events
migma webhooks create \
  --url https://yourserver.com/hooks/email \
  --events email.sent,email.delivered,email.bounced,email.complained \
  --description "Delivery tracking" --json

# Test it to make sure the endpoint is reachable
migma webhooks test <webhookId> --json

# List all configured webhooks
migma webhooks list --json
```

## "Set up a custom sending domain"

Full domain lifecycle — add, verify DNS, then use for sending:

```bash
# Add the domain
migma domains add yourdomain.com --json
# → Returns DNS records to configure (DKIM, SPF, DMARC)

# After configuring DNS, verify
migma domains verify yourdomain.com --json
# → Shows which records are verified and which are still pending

# Once verified, list to confirm
migma domains list --json

# Now use it to send
migma send --to user@example.com --subject "Hello" \
  --html ./email.html \
  --from hello@yourdomain.com --from-name "Company" --json
```

## "Validate this email and fix any issues"

Validate, review results, then regenerate if needed:

```bash
# Run full validation
migma validate all --conversation <conversationId> --json

# If deliverability score is low, check specifics
migma validate deliverability --conversation <conversationId> --subject "Your subject" --json

# If links are broken
migma validate links --conversation <conversationId> --json

# If compatibility issues, check which clients fail
migma validate compatibility --conversation <conversationId> --json

# Regenerate with fixes if needed
migma generate "Same email but fix the broken links and improve spam score" \
  --reference <conversationId> --wait --json
```

## "Track the status of my email send"

```bash
# Check generation status
migma generate-status <conversationId> --json

# After sending to a segment/tag, check batch delivery status
migma batch-status <batchId> --json

# Send a test before the real send
migma send-test <conversationId> --to test@company.com --json
```
