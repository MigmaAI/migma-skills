# Example Conversations

Real examples of what users ask and how to handle them.

## "Create a welcome email and send it to sarah@example.com"

```bash
# Generate the email
migma generate "Welcome email for new subscribers" --wait --json
# Use result.emails[0].emailId from the JSON output, then send it
migma send --to sarah@example.com --subject "<subject from generate>" \
  --email <emailId> \
  --from hello@company.migma.email --from-name "Company" --json
```

## "Design a Black Friday sale email with 40% off"

```bash
migma generate "Black Friday sale — 40% off everything, highlight our best sellers" --wait --json
```

Show the user the subject line, `emailId`, HTML output, and screenshot URL when available. If they want to preview, add `--save ./bf.html` and tell them where the file is.

## "Send that email to all our VIP customers"

```bash
# Find the VIP tag or segment
migma tags list --json
# Send to the tag
migma send --tag <tagId> --subject "Black Friday: 40% Off" \
  --email <emailId> \
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
migma contacts add --email john@example.com --first-name John --last-name Doe --json

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
# Generate the connected series in one call
migma generate "Three-email launch series: announcement, feature deep dive, and last chance" --count 3 --wait --json
# Use each result.emails[].emailId when the user wants to fetch, edit, test-send, or send one slot.
```

## "Update the second email in this series and show me the result"

```bash
# Pick the second slot's result.emails[].emailId from generation status.
migma emails edit <emailId> --prompt "Make the second email more concise and add a stronger CTA" --output ./series-2.html --json

# Fetch the same email if the user asks to verify the current saved version.
migma emails get <emailId> --output ./series-2.html --json
```

Show the updated subject, HTML file path, and screenshot URL when available.

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
migma send-test --email <emailId> --to test@company.com --json

# Send to segment
migma send --segment <segmentId> --subject "Product Launch" --email <emailId> \
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
  --email <emailId> \
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

## "Send my investor update"

Full campaign workflow — generate email, find recipients, create campaign, send:

```bash
# Generate the email
migma generate "Monthly investor update — Q1 revenue up 40%, launched campaigns feature" --wait --json

# Find the investors tag
migma tags list --json

# Create a campaign targeting the investors tag
migma campaigns create --project <projectId> \
  --name "March Investor Update" --conversation <conversationId> --email <emailId> \
  --from hello@company.migma.email --from-name "Company" \
  --recipient-type tag --recipient-id <investorsTagId> --json

# Send it
migma campaigns send <campaignId> --json
```

## "Schedule a newsletter for next Tuesday"

```bash
# Generate the email
migma generate "Weekly newsletter — product updates and tips" --wait --json

# Create and schedule the campaign
migma campaigns create --project <projectId> \
  --name "Weekly Newsletter" --conversation <conversationId> --email <emailId> \
  --from hello@company.migma.email --from-name "Company" \
  --recipient-type audience --recipient-id <segmentId> --json

migma campaigns schedule <campaignId> --at "2026-03-10T10:00:00Z" --timezone "America/New_York" --json
```

## "Track the status of my email send"

```bash
# Check generation status
migma generate-status <conversationId> --json

# After sending to a segment/tag, check batch delivery status
migma batch-status <batchId> --json

# Send a test before the real send
migma send-test --email <emailId> --to test@company.com --json
```
