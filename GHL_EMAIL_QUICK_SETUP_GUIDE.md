# GHL Email Quick Setup Guide

## 45-Minute Execution Plan

## Goal
Get AI Automation Mastery onboarding emails sending automatically after purchase.

## Inputs Needed
- GHL admin access
- Trigger tag: AI Course Member (or student)
- Existing email templates ready to paste

## Fast Path Checklist

### 0-5 min: Tags
1. Open GHL -> Contacts -> Tags
2. Ensure tag exists: AI Course Member

### 5-15 min: Sequence
1. Marketing -> Emails -> Sequences
2. Create sequence: AI Automation Mastery Onboarding
3. Add first 5 core emails:
   - Day 0 Welcome
   - Day 1 Module 1
   - Day 3 Module 2
   - Day 5 Module 3
   - Day 7 Module 4

### 15-25 min: Workflow Trigger
1. Automations -> Workflows -> Create
2. Trigger: Contact Tag Added
3. Tag: AI Course Member
4. Action: Add to Sequence -> AI Automation Mastery Onboarding
5. Publish

### 25-35 min: Payment Mapping
Ensure successful checkout applies AI Course Member tag.
- If native GHL payment: set post-purchase automation rule
- If Stripe bridge: map success event to add tag in GHL

### 35-45 min: Test
1. Run one test checkout
2. Confirm contact has tag
3. Confirm workflow run appears
4. Confirm sequence enrollment
5. Confirm welcome email delivered

## Copy/Paste Operating Prompt (Copilot/Claude)
Use this prompt with any AI assistant:

Set up GHL onboarding email automation for AI Automation Mastery.
Requirements:
1) Trigger on tag AI Course Member.
2) Enroll contact into sequence AI Automation Mastery Onboarding.
3) Sequence includes day 0, day 1, day 3, day 5, day 7 core emails.
4) Confirm workflow is published.
5) Verify with one end-to-end test and report pass/fail for tag, workflow, enrollment, and welcome delivery.

## Quick Troubleshooting
- No emails: publish workflow and confirm exact tag match.
- Wrong contacts enrolling: tighten trigger filters.
- Duplicate sends: add "already in sequence" guard.
- Not triggered from payment: fix Stripe/GHL tag mapping.

## Success Criteria
- Purchase causes tag application.
- Tag triggers workflow immediately.
- Workflow enrolls contact in sequence.
- Welcome email is received by test inbox.
