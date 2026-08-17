# ChatGPT portal tool justifications

Portal copy. Scan Tools imports boolean hints and clears these fields. Paste each row after final production scan.

Wording stays short, specific, and affirmative. Server target: `@migma/mcp@1.3.9+`.

| Tool | Read Only | Open World | Destructive |
| --- | --- | --- | --- |
| `migma_list_projects` | Lists brands available to authenticated user. | Reads brand data inside authenticated Migma account. | Returns current brand records. |
| `migma_get_project` | Reads colors, fonts, logos, and voice for selected brand. | Reads brand data inside authenticated Migma account. | Returns current brand details. |
| `migma_import_brand` | Creates brand profile from supplied website URLs. | Stores imported results inside authenticated Migma account. | Creates editable brand profile. |
| `migma_get_field_catalog` | Reads subscriber fields, fill rates, and example values. | Reads audience data inside authenticated Migma account. | Returns current field catalog. |
| `migma_generate_email` | Creates email-generation job for selected brand. | Stores generated drafts inside authenticated Migma account. | Creates editable email drafts. |
| `migma_get_generation_status` | Reads generation status, previews, and result IDs. | Reads generation data inside authenticated Migma account. | Returns current generation state. |
| `migma_send_test_email` | Creates test send for selected email and address. | Delivers email to external test inbox. | Starts real email delivery to supplied address. |
| `migma_list_emails` | Lists designed emails for selected brand. | Reads email data inside authenticated Migma account. | Returns current email records. |
| `migma_get_email` | Reads selected email, preview, and Migma link. | Reads email data inside authenticated Migma account. | Returns current email. |
| `migma_edit_email` | Updates selected email design. | Stores updated design inside authenticated Migma account. | Replaces saved design with requested revision. |
| `migma_get_email_metrics` | Reads delivery and engagement metrics for selected email. | Reads metrics inside authenticated Migma account. | Returns current metrics. |
| `migma_get_email_logs` | Reads recipient delivery logs for selected email. | Reads logs inside authenticated Migma account. | Returns current delivery logs. |
| `migma_send_email` | Creates send job for selected email and audience. | Delivers email to external recipients. | Starts real recipient delivery. |
| `migma_validate_email` | Checks selected email for content and structure issues. | Runs check inside authenticated Migma account. | Returns validation results. |
| `migma_validate_compatibility` | Checks selected email across supported email clients. | Runs check inside authenticated Migma account. | Returns compatibility results. |
| `migma_validate_deliverability` | Checks selected email for inbox and spam risks. | Runs check inside authenticated Migma account. | Returns deliverability results. |
| `migma_export_html` | Creates HTML export from selected email. | Creates export inside authenticated Migma account. | Produces downloadable HTML file. |
| `migma_export_pdf` | Creates PDF export from selected email. | Creates export inside authenticated Migma account. | Produces downloadable PDF file. |
| `migma_export_png` | Creates PNG export from selected email. | Creates export inside authenticated Migma account. | Produces downloadable PNG file. |
| `migma_export_klaviyo` | Creates Klaviyo-ready export from selected email. | Creates export inside authenticated Migma account. | Produces reviewable Klaviyo export. |
| `migma_export_mailchimp` | Creates Mailchimp-ready export from selected email. | Creates export inside authenticated Migma account. | Produces reviewable Mailchimp export. |
| `migma_export_hubspot` | Creates HubSpot-ready export from selected email. | Creates export inside authenticated Migma account. | Produces reviewable HubSpot export. |
| `migma_list_domains` | Lists custom and managed sending domains. | Reads domain data inside authenticated Migma account. | Returns current domain records. |
| `migma_create_managed_domain` | Creates managed sending domain. | Creates externally reachable sending infrastructure. | Creates editable sending setup. |
| `migma_verify_domain` | Checks public DNS and updates verification status. | Stores verification result inside authenticated Migma account. | Updates domain verification status. |
| `migma_provision_stream` | Creates transactional or marketing sending identity. | Creates externally reachable sending infrastructure. | Creates new sending identity and DNS records. |
| `migma_setup_domain` | Creates transactional and marketing sending identities. | Creates externally reachable sending infrastructure. | Creates new sending setup and DNS records. |
| `migma_list_contacts` | Lists contacts for selected brand. | Reads audience data inside authenticated Migma account. | Returns current contact records. |
| `migma_add_contact` | Creates contact in selected brand. | Stores contact inside authenticated Migma account. | Creates editable contact record. |
| `migma_bulk_import_contacts` | Creates contact records from structured data. | Stores contacts inside authenticated Migma account. | Creates editable contact records. |
| `migma_get_contact` | Reads selected contact details. | Reads audience data inside authenticated Migma account. | Returns current contact. |
| `migma_remove_contact` | Deletes selected contact from brand. | Changes contact data inside authenticated Migma account. | Permanently deletes selected contact. |
| `migma_batch_delete_contacts_by_email` | Deletes contacts matching supplied addresses. | Changes contact data inside authenticated Migma account. | Permanently deletes matched contacts. |
| `migma_create_contact_import` | Starts CSV contact import for selected brand. | Stores imported contacts inside authenticated Migma account. | Creates reviewable import job and contact records. |
| `migma_get_contact_import` | Reads CSV import status and counts. | Reads audience data inside authenticated Migma account. | Returns current import state. |
| `migma_list_tags` | Lists contact tags for selected brand. | Reads tag data inside authenticated Migma account. | Returns current tags. |
| `migma_create_tag` | Creates contact tag for selected brand. | Stores tag inside authenticated Migma account. | Creates editable tag. |
| `migma_delete_tag` | Deletes selected contact tag. | Changes tag data inside authenticated Migma account. | Permanently deletes selected tag. |
| `migma_list_segments` | Lists audience segments for selected brand. | Reads segment data inside authenticated Migma account. | Returns current segments. |
| `migma_create_segment` | Creates audience segment for selected brand. | Stores segment inside authenticated Migma account. | Creates editable audience segment. |
| `migma_delete_segment` | Deletes selected audience segment. | Changes segment data inside authenticated Migma account. | Permanently deletes selected segment. |
| `migma_list_webhooks` | Lists configured webhooks. | Reads webhook data inside authenticated Migma account. | Returns current webhooks. |
| `migma_create_webhook` | Creates webhook configuration for supplied endpoint. | Stores endpoint inside authenticated Migma account. | Creates editable webhook configuration. |
| `migma_test_webhook` | Sends test event to configured webhook. | Calls configured external endpoint. | Sends immediate request to third-party endpoint. |
| `migma_delete_webhook` | Deletes selected webhook. | Changes webhook data inside authenticated Migma account. | Permanently deletes selected webhook. |
| `migma_list_campaigns` | Lists draft, scheduled, and sent campaigns. | Reads campaign data inside authenticated Migma account. | Returns current campaign records. |
| `migma_create_campaign` | Creates draft campaign from selected email. | Stores draft inside authenticated Migma account. | Creates reviewable campaign draft. |
| `migma_send_campaign` | Starts selected campaign send. | Delivers campaign to external recipients. | Starts real campaign delivery. |
| `migma_schedule_campaign` | Creates timed delivery for selected campaign. | Schedules delivery to external recipients. | Starts delivery automatically at selected time. |
| `migma_get_campaign_stats` | Reads delivery and engagement metrics for selected campaign. | Reads metrics inside authenticated Migma account. | Returns current campaign metrics. |
| `migma_get_campaign_logs` | Reads recipient delivery logs for selected campaign. | Reads logs inside authenticated Migma account. | Returns current campaign logs. |
| `migma_cancel_campaign` | Changes selected campaign schedule. | Updates campaign inside authenticated Migma account. | Revokes active delivery schedule. |
| `migma_archive_campaign` | Moves selected campaign into archive. | Updates campaign inside authenticated Migma account. | Keeps campaign available for later restore. |
| `migma_unarchive_campaign` | Restores selected campaign from archive. | Updates campaign inside authenticated Migma account. | Restores saved campaign to active list. |
| `migma_get_sending_metrics` | Reads sending usage, limits, and delivery outcomes. | Reads metrics inside authenticated Migma account. | Returns current sending metrics. |
| `migma_get_capabilities` | Reads Migma tool catalog and workflow guidance. | Reads metadata inside authenticated Migma server. | Returns current capability metadata. |
