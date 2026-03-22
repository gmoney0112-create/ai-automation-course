# GHL Email Sequence Setup Handoff

## Mission
Set up a production-ready 30-day onboarding email sequence in GoHighLevel (GHL) for AI Automation Mastery students, triggered after successful purchase.

## Project Context
- Product: AI Automation Mastery
- Price: $97 one-time
- Buyer destination: success page already prepared
- Objective: fully automated onboarding from purchase through day 30

## Required Outcome
1. Contacts who purchase are tagged as students.
2. Tag event triggers enrollment into one email sequence.
3. Sequence sends planned emails on day 0 through day 30.
4. Test checkout confirms the full trigger path works.

## Preconditions
- GHL sub-account admin access
- Stripe payment link/checkouts active
- Existing tag strategy approved
- Sender domain configured in GHL (SPF/DKIM recommended)

## Canonical Naming
Use these exact names unless your account already uses standards:
- Sequence name: AI Automation Mastery Onboarding
- Trigger tag: AI Course Member
- Backup trigger tag: student
- Workflow name: Course Purchase -> Email Onboarding

## 30-Day Sequence Schedule
- Day 0: Welcome + Access + What to do first
- Day 1: Module 1 kickoff
- Day 3: Module 2 (process identification)
- Day 5: Module 3 (tool stack)
- Day 7: Module 4 (first automation)
- Day 10: Progress checkpoint
- Day 14: Momentum + support invitation
- Day 21: Mid-course accountability
- Day 30: Completion + next steps + testimonial request

## Build Steps (Execution Order)

### Step 1: Create/Verify Trigger Tags
In GHL:
1. Contacts -> Tags
2. Create if missing:
   - AI Course Member
   - student

Acceptance check:
- Both tags exist and are selectable in automation filters.

### Step 2: Create Sequence Container
In GHL:
1. Marketing -> Emails -> Sequences
2. Create new sequence: AI Automation Mastery Onboarding

Acceptance check:
- Sequence exists and is in Draft state.

### Step 3: Add Email Steps
For each template, add one email step with delay from previous message.
Recommended delays:
- Email 1: send immediately
- Email 2: wait 1 day
- Email 3: wait 2 days
- Email 4: wait 2 days
- Email 5: wait 2 days
- Email 6: wait 3 days
- Email 7: wait 4 days
- Email 8: wait 7 days
- Email 9: wait 9 days

Template source:
- Use the already prepared 30-day template file in this project.

Acceptance check:
- All planned emails appear in sequence with correct delays.

### Step 4: Configure Workflow Trigger
In GHL:
1. Automations -> Workflows -> Create Workflow
2. Name: Course Purchase -> Email Onboarding
3. Trigger: Contact Tag Added
4. Tag filter: AI Course Member (or student if used)
5. Action: Add to Sequence -> AI Automation Mastery Onboarding
6. Publish workflow

Acceptance check:
- Workflow is published and active.

### Step 5: Stripe to Tag Mapping
Ensure purchase adds trigger tag.
Common paths:
- Native GHL payment product automation
- Stripe webhook to GHL
- Zapier/n8n bridge

Minimum rule:
- On successful paid checkout, add AI Course Member tag to contact.

Acceptance check:
- A test paid event produces contact with tag attached.

### Step 6: Sender + Compliance
Confirm:
- From name and from email are branded
- Physical mailing address in footer
- Unsubscribe handling enabled

Acceptance check:
- Test email passes spam/compliance sanity check.

### Step 7: End-to-End Test
Use test payment flow (or staging-equivalent):
1. Submit checkout
2. Confirm contact created/updated in GHL
3. Confirm AI Course Member tag applied
4. Confirm workflow entry recorded
5. Confirm sequence enrollment
6. Confirm Day 0 welcome email delivered

Acceptance check:
- All six checks pass.

## Troubleshooting Playbook

### Symptom: Contact exists but no emails sent
Checks:
1. Is workflow published?
2. Is tag exactly matching trigger filter?
3. Is action set to Add to Sequence (correct sequence)?
4. Is sequence status active?

### Symptom: Duplicate enrollments
Fix:
- Add guard condition in workflow: if already in sequence, stop.

### Symptom: Email deliverability poor
Fix:
- Verify domain authentication (SPF/DKIM)
- Avoid spam trigger words in subject/body
- Warm sender if new domain

### Symptom: Stripe purchase not tagging contact
Fix:
- Inspect payment integration mapping
- Validate webhook/event logs
- Add fallback automation for successful order events

## Handoff Notes For Any AI Assistant
When continuing this task, prioritize this order:
1. Verify trigger tags
2. Verify workflow publish state
3. Verify sequence enrollment action
4. Run end-to-end test and capture evidence

Ask user for only these items if missing:
- GHL sub-account access
- Current trigger tag name in production
- Which payment path is active (native GHL, Stripe direct, Zapier, n8n)

## Definition of Done
- Production workflow active
- 30-day sequence active
- Purchase event triggers enrollment automatically
- Day 0 email received in test inbox
- No blocking errors in workflow history
