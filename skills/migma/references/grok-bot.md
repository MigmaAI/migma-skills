# Grok Bot mode and recovery

Use this reference only in Grok, Grok Bot, or Grok Build.

## Primary path: Migma Remote MCP

Grok Bot desktop uses connected `migma_*` tools for routine work.

When Migma needs connection:

1. Read `https://docs.migma.ai/grok.md`.
2. Inspect existing plugins and MCP connections, then reuse the existing Migma connection when available.
3. Present `https://migma.ai/mcp` and ask before adding it.
4. Stop for human browser sign-in and access approval.
5. Verify access with a read-only `migma_list_projects` call.

Agent-guided hosted MCP setup is beta. Marketplace availability and authentication depend on Grok build and workspace policy.

Use one write path per task. Before switching paths, finish or pause current work, list existing Migma drafts read-only, reconcile them, then continue.

## Authentication order

1. Reuse existing `migma_*` tools.
2. When a Migma plugin listing with browser OAuth is installed, complete that approval.
3. Otherwise go straight to claim-code: fetch `https://api.migma.ai/auth.md`, register intent, and store the returned credential in Grok's secure credential storage. Grok Bot's cloud computer cannot receive an OAuth callback, so do not attempt connector OAuth first and do not retry it.
4. Human opens the approval link, signs in if needed, reviews the permissions, and approves.
5. Repeat `migma_list_projects` and confirm Grok reports a durable connected state. A connector badge that still says `needsAuth` after claim-code is expected; the read-only call is the proof, not the badge.

The user sees one thing: the approval link with one line of instruction. Connection mechanics (which flow, what was rejected, what is being retried) are not the user's problem; report them only if the user asks or the connection fails for good.

## After connecting

Follow the main skill's **After connecting** section. Write like WhatsApp: usually 1–2 short sentences, simple words, matching the user's language. Give the result and relevant returned links, with previews when available. No hype, headings, recaps, process narration, or forced follow-up question. Stop when done. Expand only when asked or needed for a decision; keep errors and send-approval details clear. Start with the user's goal; suggest an email only if they have no task in mind. Use `migma_get_context` to confirm the working brand. Never turn a failed read into "you have no brand kit."

If the website is needed: "What's your website?"

Ask for brand guidelines or emails they love when useful, save lasting rules and image style, and favorite liked designs for future emails. Offer to add their contact list and group people using the information available. Keep tool names, field mapping, and setup details internal. Skip completed steps and keep the user's current task moving.

Show previews and canvas links as soon as generation finishes. Before any send, show audience, count, sender, subject, timing, and preview, then wait for approval.

## Save designs the user likes

Treat "I like this design," "favorite this email," "save this style," and "use this next time" as a request to call `migma_save_reference` with `{"emailId":"<chosen emailId>"}`. Use the ID already returned for that draft; for a series, use the selected email's ID. Ask which one only when unclear. A one-off edit or send approval does not by itself ask to save a style.

The tool requires `project:write`. Wait for `favorite: true`, then say "Saved as a reference for future emails for this brand." Migma uses saved references by default for that brand, unless disabled; the favorite follows later saved edits. Do not export HTML, re-import the email, duplicate it as a knowledge-base entry, or create a new draft to verify the save. Repeating the same `emailId` is safe.

For an external email, use `projectId` + `title` + `html`. A screenshot alone is a generation input, not a saved standing reference. If the tool is missing, check `migma_get_capabilities` and the connection's `project:write` permission before reporting what is unavailable.

## Browser fallback

For browser fallback, use Grok Bot's cloud computer after the user explicitly chooses that path. Human takes over for password, passkey, two-factor code, and CAPTCHA. Every Bot shares one cloud computer and its browser sessions. Sign out after use.

## Permission truth

- `email:read email:write`: list/read/create/edit email drafts.
- `project:write`: save favorite emails, design references, and brand guidelines.
- `email:send`: test/direct sends.
- `campaign:read`: list campaigns, stats, logs.
- `campaign:write`: create, send, schedule, cancel, archive campaigns.

Omit `scope` when registering. The user approves the full permission set on the page. `campaign:write` covers create, send, and schedule, so confirm each send with the user in the chat before it goes out.

## Research-to-email sequence

1. Resolve exact Migma brand.
2. Research current primary sources outside Migma.
3. Build dated source brief: exact facts/features per email plus up to five public HTTPS image URLs: product shots as content, email/page screenshots as design reference. When the user names a style or a site like reallygoodemails.com, fetch the actual screenshot URL.
4. Call `migma_generate_email` once with `count`, distinct roles, full fact checklist in `prompt`, source URLs in structured `images` (say which are content and which are reference), and stable `idempotency_key`.
5. Poll status, show every preview and `appUrl` first.
6. Verify every named fact in content and every expected source asset in previews.
7. Make targeted text edits only after first show. Missing structured images require replacement generation.

Show previews and canvas links with one short result, then stop. Keep IDs, execution details, and checklists internal unless requested. Mark completion only after verification passes; name any unresolved issue briefly.
