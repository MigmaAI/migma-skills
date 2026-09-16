# Migma for Cursor and Grok Bot

Run your entire email marketing from Cursor and Grok Bot. Migma designs on-brand campaigns, sends when you approve, and gets better with every send.

## Description

Migma brings email marketing into Cursor and Grok Bot. Share your website and a goal, and Migma creates on-brand campaigns, sends them to the right people when you approve, and shows you what worked.

Start with your brand. Migma reads your site and builds your Brand DNA: logo, colors, fonts, and tone of voice. Save lasting facts such as products, offers, and policies, and every new email starts from what you already know.

Already on Klaviyo, Mailchimp, or HubSpot? Connect it and bring your recent emails and your audience with you. Migma learns from the emails that already work for you and creates new ones in the same style, for the same people. Got HTML emails from anywhere else? Bring those in too.

Create campaigns, welcome series, and transactional emails. Previews appear right in the conversation. Ask for changes in plain language, or open any email in Migma's visual editor and perfect it by hand. Every email is built on six research-backed principles: personalization, tone, visuals, emotion, values, and clarity.

Skip the filters. Describe who you want to reach and Migma suggests segments with AI. Relevant emails keep subscribers around, lift engagement, and help every campaign convert.

Beautiful is only half the job. Migma's email engine draws on insights from 100,000+ emails and renders across modern and legacy inboxes, from Gmail to Outlook 2003. Deliverability checks help you stay out of spam, and consent and unsubscribe tools help you follow email laws like CAN-SPAM and GDPR.

Nothing goes out until you say yes. Review the audience, recipient count, sender, subject, and final preview, then send from Migma or push your finished emails straight to Klaviyo, Mailchimp, or HubSpot.

Then see what landed. Ask for delivery, opens, clicks, and bounces, and Cursor and Grok Bot turn your strongest signals into the brief for your next email. Every campaign teaches you something, and the next one starts smarter.

## Workflow screenshots and example prompts

### 1. Import your brand

> Import my brand from https://starface.world.

![Import a brand and its Brand DNA](https://cdn.migma.ai/public/media/images/1789495403634-01-brand-import.png)

### 2. Prepare a campaign

> Prepare our Halloween campaign.

![Prepare an on-brand Halloween campaign](https://cdn.migma.ai/public/media/images/1789495405494-02-halloween-campaign.png)

### 3. Find your audience

> Find US subscribers who opened our last email but didn’t click.

![Find an audience segment](https://cdn.migma.ai/public/media/images/1789495407240-03-audience-segment.png)

### 4. Send an approved campaign and review results

> Send the approved campaign to this segment and show me the results.

![Review campaign results](https://cdn.migma.ai/public/media/images/1789495408647-04-campaign-results.png)

### 5. Plan the next campaign

> What should we try next?

![Use campaign results to plan the next email](https://cdn.migma.ai/public/media/images/1789495409936-05-next-campaign.png)

## More ways to use Migma

- Import your brand: “Import my brand from example.com and show me the colors, fonts, and tone you found.”
- Create editable email drafts: “Create a three-email welcome series for my brand. Show previews and keep all emails as drafts.”
- Check an email: “Check this email for compatibility, broken links, and deliverability issues.”
- Build a segment: “Create a segment of US subscribers who opened our last email but didn't click.”
- Manage opted-in audiences: “Import this CSV of subscribers who consented to marketing into a list named Newsletter.”
- Prepare a campaign: “Create a draft launch campaign using this approved email and subscriber list. Show the subject, sender, and recipient count before any send.”
- Export to your ESP: “Export this approved email to Klaviyo as a template.”
- Review campaign results: “Show delivery logs and performance for my latest campaign.”

## Connection requirements

Requires a Migma account and authorization for the connection. The hosted MCP server is `https://migma.ai/mcp`. Review the requested permissions before granting access. Follow the setup guide for your client: [Cursor](https://docs.migma.ai/agents/mcp-cursor) or [Grok Bot](https://docs.migma.ai/grok).

Brand setup is recommended for branded drafts. Features depend on the account plan, available credits, and granted permissions. Sending requires an eligible sender and sending permissions; marketing campaigns require opted-in recipients. Revoke access in Migma under **Settings > Developers > API Keys**.

Start read-only:

> Use Migma to list my brands read-only. State the Migma tool used.

## Permissions and data

Depending on granted permissions, Migma can read and change your brands, email content, contacts, lists, segments, campaigns, sending domains, DNS records, and webhooks; read campaign results, delivery logs, plan details, and credits; send test or live email; schedule campaigns; and export emails to connected services. Billing and domain tools create links for the account owner to complete checkout. Access is limited to the connected Migma account. Revoke the connection in Migma under Settings > Developers > API Keys.

Data types include contact names and email addresses, email content and brand knowledge, campaign engagement and delivery records, and account plan and billing information.

Creating an email draft does not send it. Compatibility and deliverability checks report findings, not guarantees of identical rendering or inbox placement. Export tools can transfer an approved email to a connected Klaviyo, Mailchimp, or HubSpot account.

## Publisher and links

- Publisher: Migma
- Handle: `migma`
- Contact: info@migma.ai
- Website: https://migma.ai/
- Plugin repository: https://github.com/MigmaAI/migma-skills
- Logo: https://migma.ai/brandkit/cube/PNG/gradient-light.png
- Support: support@migma.ai
- Privacy: https://docs.migma.ai/legal/privacy-policy
- Terms: https://docs.migma.ai/legal/terms-of-use
- Security and permissions: https://docs.migma.ai/security/mcp
