# ChatGPT portal annotation justifications

Generated for `@migma/mcp@1.3.9`.
After **Scan Tools**, paste each block into that tool's three required fields.
OpenAI does **not** import these from MCP.

## Stale after 1.3.9 (re-scan then re-paste)

These tools changed annotation booleans vs 1.3.8. Portal "Mismatched / Stale" until Scan Tools + new paste:

- `migma_import_brand` (openWorld true→false)
- `migma_generate_email` (openWorld true→false)
- `migma_edit_email` (openWorld true→false)
- `migma_verify_domain` (openWorld true→false)
- `migma_create_webhook` (openWorld true→false)
- `migma_test_webhook` (destructive false→true)

## migma_add_contact
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_archive_campaign
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_batch_delete_contacts_by_email
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (true):**
Can cause hard-to-undo effects such as sending mail to real inboxes, overwriting designs, deleting records, or firing external webhooks.

## migma_bulk_import_contacts
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_cancel_campaign
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (true):**
Can cause hard-to-undo effects such as sending mail to real inboxes, overwriting designs, deleting records, or firing external webhooks.

## migma_check_domain_availability
**Read Only (true):**
Only reads authenticated domains data (Check whether a managed <prefix>.migma.email address is free, with the reason when it is not); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_create_campaign
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_create_contact_import
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_create_managed_domain
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (true):**
May reach outside this account — for example email delivery, DNS provisioning, or posting to an external webhook URL.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_create_segment
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_create_tag
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_create_webhook
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_delete_segment
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (true):**
Can cause hard-to-undo effects such as sending mail to real inboxes, overwriting designs, deleting records, or firing external webhooks.

## migma_delete_tag
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (true):**
Can cause hard-to-undo effects such as sending mail to real inboxes, overwriting designs, deleting records, or firing external webhooks.

## migma_delete_webhook
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (true):**
Can cause hard-to-undo effects such as sending mail to real inboxes, overwriting designs, deleting records, or firing external webhooks.

## migma_edit_email
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (true):**
Can cause hard-to-undo effects such as sending mail to real inboxes, overwriting designs, deleting records, or firing external webhooks.

## migma_export_html
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_export_hubspot
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_export_klaviyo
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_export_mailchimp
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_export_pdf
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_export_png
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_generate_email
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_get_campaign_logs
**Read Only (true):**
Only reads authenticated campaigns data (Per-recipient delivery logs for a campaign, cursor-paginated); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_get_campaign_stats
**Read Only (true):**
Only reads authenticated campaigns data (Aggregated engagement metrics for a campaign (cached, may be slightly stale)); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_get_capabilities
**Read Only (true):**
Only reads authenticated meta data (Self-describe this server: tools, workflows, idempotency, and brand scoping. Call this first); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_get_contact
**Read Only (true):**
Only reads authenticated contacts data (Get details about a contact by id); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_get_contact_import
**Read Only (true):**
Only reads authenticated contacts data (Get a CSV contact import's status and counts); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_get_email
**Read Only (true):**
Only reads authenticated emails data (Fetch one email: preview image, appUrl, screenshotStatus. HTML off unless includeHtml); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_get_email_logs
**Read Only (true):**
Only reads authenticated emails data (Per-recipient send log for one generated email, cursor-paginated); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_get_email_metrics
**Read Only (true):**
Only reads authenticated emails data (Aggregate performance for one generated email across its API sends: delivery, opens, clicks, bounces, unsubscribes + time series); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_get_field_catalog
**Read Only (true):**
Only reads authenticated projects data (List subscriber fields, fill rates, and example values for template variables); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_get_generation_status
**Read Only (true):**
Only reads authenticated emails data (Poll a generation. Returns preview images, appUrl, screenshotStatus. HTML off by default); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_get_project
**Read Only (true):**
Only reads authenticated projects data (Get brand colors, fonts, logos, and voice); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_get_sending_metrics
**Read Only (true):**
Only reads authenticated sending data (Get account sending usage, limits, remaining capacity, and monthly delivery outcomes); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_import_brand
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_list_campaigns
**Read Only (true):**
Only reads authenticated campaigns data (List draft, scheduled, and sent audience campaigns); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_list_contacts
**Read Only (true):**
Only reads authenticated contacts data (List contacts with optional filters and pagination); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_list_domains
**Read Only (true):**
Only reads authenticated domains data (List all sending domains (custom and managed)); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_list_emails
**Read Only (true):**
Only reads authenticated emails data (List generated email designs with preview images and appUrl); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_list_projects
**Read Only (true):**
Only reads authenticated projects data (List brands as compact id/name/domain rows. Pass search to find a name); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_list_segments
**Read Only (true):**
Only reads authenticated segments data (List all audience segments for a project); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_list_tags
**Read Only (true):**
Only reads authenticated tags data (List all tags for a project); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_list_webhooks
**Read Only (true):**
Only reads authenticated webhooks data (List all configured webhooks); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_provision_stream
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (true):**
May reach outside this account — for example email delivery, DNS provisioning, or posting to an external webhook URL.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_remove_contact
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (true):**
Can cause hard-to-undo effects such as sending mail to real inboxes, overwriting designs, deleting records, or firing external webhooks.

## migma_save_reference
**Read Only (false):**
Writes a favorite pointer on one generated email or a design-reference entry in the brand's knowledge base; both are reversible and send nothing.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Adds or flips a reference marker inside the account; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_schedule_campaign
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (true):**
May reach outside this account — for example email delivery, DNS provisioning, or posting to an external webhook URL.

**Destructive (true):**
Can cause hard-to-undo effects such as sending mail to real inboxes, overwriting designs, deleting records, or firing external webhooks.

## migma_send_campaign
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (true):**
May reach outside this account — for example email delivery, DNS provisioning, or posting to an external webhook URL.

**Destructive (true):**
Can cause hard-to-undo effects such as sending mail to real inboxes, overwriting designs, deleting records, or firing external webhooks.

## migma_send_email
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (true):**
May reach outside this account — for example email delivery, DNS provisioning, or posting to an external webhook URL.

**Destructive (true):**
Can cause hard-to-undo effects such as sending mail to real inboxes, overwriting designs, deleting records, or firing external webhooks.

## migma_send_test_email
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (true):**
May reach outside this account — for example email delivery, DNS provisioning, or posting to an external webhook URL.

**Destructive (true):**
Can cause hard-to-undo effects such as sending mail to real inboxes, overwriting designs, deleting records, or firing external webhooks.

## migma_setup_domain
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (true):**
May reach outside this account — for example email delivery, DNS provisioning, or posting to an external webhook URL.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_test_webhook
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (true):**
May reach outside this account — for example email delivery, DNS provisioning, or posting to an external webhook URL.

**Destructive (true):**
Can cause hard-to-undo effects such as sending mail to real inboxes, overwriting designs, deleting records, or firing external webhooks.

## migma_unarchive_campaign
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.

## migma_update_brand_guidelines
**Read Only (false):**
Replaces the brand's standing design rules and image style notes inside the authenticated Migma account; Migma snapshots the previous version first.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Reversible from project history and returns the replaced text; it cannot delete accounts, send, publish, or perform any irreversible action.

## migma_validate_compatibility
**Read Only (true):**
Only reads authenticated validation data (Check email-client compatibility by emailId); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_validate_deliverability
**Read Only (true):**
Only reads authenticated validation data (Check inbox and spam risks by emailId); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_validate_email
**Read Only (true):**
Only reads authenticated validation data (Validate selected email by emailId); it does not create, update, delete, send, or publish anything.

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Only returns existing data; it cannot delete, overwrite, send, publish, or perform any irreversible action.

## migma_verify_domain
**Read Only (false):**
Performs a write or side effect in Migma (create, update, delete, send, schedule, export, or similar).

**Open World (false):**
Only accesses Migma authenticated APIs for this account; it does not browse arbitrary URLs or change public internet state by itself.

**Destructive (false):**
Does not delete records, overwrite irreversibly, or send live mail by itself; outcomes stay reversible or limited to drafts, exports, or reads.
