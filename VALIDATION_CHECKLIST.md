# 3-TIER PAYMENT SYSTEM VALIDATION CHECKLIST

## 🎯 TODAY'S MISSION: FINAL VALIDATION BEFORE LAUNCH

### ⏰ ESTIMATED TIME: 30 MINUTES

---

## ✅ STEP 1: CORE TIER TEST ($97)

### Test 1: New Contact Creation
1. **Purchase Link:** https://buy.stripe.com/test_3cIaEZgKR4k470G6lh3Ru00
2. **Email:** test-core-9@test.com (NEW email)
3. **Card:** 4242 4242 4242 4242
4. **Expiry:** 12/27
5. **CVC:** 123
6. **ZIP:** 10001

**Expected Results:**
- [ ] Stripe: Payment successful
- [ ] n8n: New execution appears (green)
- [ ] n8n Path: Search → Contact Exists? (false) → Create New Contact
- [ ] GHL: Contact `test-core-9@test.com` created
- [ ] GHL Tag: `course-core-purchased` applied

**Verification Steps:**
1. Check n8n executions: https://soulprosperity.app.n8n.cloud/workflow/5zzkYEiCcjOOccoZ/executions
2. Check GHL contacts: Search for `test-core-9@test.com`
3. Verify tag: Click contact → check Tags tab

### Test 2: Existing Contact Update
1. **Purchase Link:** SAME LINK as above
2. **Email:** test-core-9@test.com (SAME email - now exists)
3. **Same card details**

**Expected Results:**
- [ ] n8n: New execution appears (green)
- [ ] n8n Path: Search → Contact Exists? (true) → Update Existing Contact
- [ ] GHL: Contact updated (not duplicate created)
- [ ] GHL Tag: Still has `course-core-purchased`

**Note:** GHL may reject duplicate with 409 error, but workflow should continue green.

---

## 🚀 STEP 2: LAUNCH SYSTEM TIER TEST ($497)

### Test 3: New Launch System Contact
1. **Purchase Link:** https://buy.stripe.com/test_3cI14pgKR8Ak2KqdNJ3Ru01
2. **Email:** test-launch@test.com (NEW email)
3. **Same card details**

**Expected Results:**
- [ ] Stripe: Payment successful
- [ ] n8n: New execution appears (green)
- [ ] n8n Path: Should route through Launch System logic
- [ ] GHL: Contact `test-launch@test.com` created
- [ ] GHL Tag: `course-launch-purchased` applied

**Critical Check:** Different tag than Core tier!

---

## 💎 STEP 3: MEMBERSHIP TIER TEST ($197/month)

### Test 4: New Membership Contact
1. **Purchase Link:** https://buy.stripe.com/test_fZu9AV3Y5g2M1GmcJF3Ru02
2. **Email:** test-membership@test.com (NEW email)
3. **Same card details**

**Expected Results:**
- [ ] Stripe: Subscription created (not one-time)
- [ ] n8n: New execution appears (green)
- [ ] n8n Path: Should route through Membership logic
- [ ] GHL: Contact `test-membership@test.com` created
- [ ] GHL Tag: `course-membership-purchased` applied

### Test 5: Membership Cancellation Test
1. **Go to Stripe Dashboard:** https://dashboard.stripe.com/test/subscriptions
2. **Find subscription** for `test-membership@test.com`
3. **Click Cancel subscription**
4. **Choose "Immediately"** (not end of period)

**Expected Results:**
- [ ] Stripe: Subscription cancelled
- [ ] n8n: New execution for cancellation event
- [ ] n8n Path: Cancel Contact Found? (true) → Add Membership Cancelled Tag
- [ ] GHL: Contact gets `membership-cancelled` tag added
- [ ] GHL: `membership-active` tag removed (if exists)

---

## 🔄 STEP 4: PRODUCTION SWITCH

### Test 6: Update Live Sales Page
1. **File:** `C:\Users\gmone\Desktop\ai-automation-course\index.html`
2. **Find test links** (containing `/test_`)
3. **Replace with production links:**
   - Core: `https://buy.stripe.com/eVq3cx1PX9Eoet8aBx3Ru0c`
   - Launch: `https://buy.stripe.com/4gM8wRdyFbMw4Sy7pl3Ru0j`
   - Membership: `https://buy.stripe.com/3cI5kFfGN7wg84K2513Ru0k`

4. **Commit & push to GitHub:**
```bash
cd "C:\Users\gmone\Desktop\ai-automation-course"
git add index.html
git commit -m "Switch to production Stripe payment links"
git push origin main
```

5. **Verify live site:** https://gmoney0112-create.github.io/ai-automation-course/
6. **Click each CTA button** - should open production Stripe checkout

### Test 7: $1 Production Test
**WARNING:** This will charge $1 real money (refundable)

1. **Use production Core link:** `https://buy.stripe.com/eVq3cx1PX9Eoet8aBx3Ru0c`
2. **Email:** real-test@yourdomain.com (use real email you control)
3. **Card:** Real card (will charge $1)
4. **Complete purchase**

**Expected Results:**
- [ ] Stripe: $1 charged (real money)
- [ ] n8n: Execution appears
- [ ] GHL: Contact created with tag
- [ ] **Refund:** Issue refund in Stripe dashboard after verification

**Alternative:** Skip this test if uncomfortable with real charge.

---

## 📊 VALIDATION SUMMARY TABLE

| Test | Tier | Email | Expected Tag | Status |
|------|------|-------|--------------|--------|
| 1 | Core (New) | test-core-9@test.com | course-core-purchased | [ ] |
| 2 | Core (Existing) | test-core-9@test.com | (still) course-core-purchased | [ ] |
| 3 | Launch System | test-launch@test.com | course-launch-purchased | [ ] |
| 4 | Membership | test-membership@test.com | course-membership-purchased | [ ] |
| 5 | Membership Cancel | test-membership@test.com | membership-cancelled | [ ] |
| 6 | Production Links | N/A | N/A | [ ] |
| 7 | $1 Real Test | real@email.com | course-core-purchased | [ ] |

---

## 🚨 TROUBLESHOOTING GUIDE

### If n8n execution fails:
1. **Check node outputs:** Click failed execution, step through nodes
2. **Common issues:** 
   - GHL API authentication
   - Wrong field paths in expressions
   - Tag format incorrect (should be array `["tag"]`)
3. **Debug:** Add Code node to log data: `console.log(JSON.stringify($input.all(), null, 2))`

### If GHL contact not created:
1. **Check GHL API key:** Still valid?
2. **Check location ID:** Correct in API calls?
3. **Manual test:** `curl -H "Authorization: Bearer YOUR_KEY" "https://rest.gohighlevel.com/v1/contacts/?email=test@example.com"`

### If wrong tag applied:
1. **Check n8n switch conditions:** Verify routing logic
2. **Check metadata in Stripe:** Each product should have `tier: core/launch_system/membership`
3. **Check n8n Extract Event node:** Pulling correct metadata field

### If duplicate contact created:
1. **This is OK for test** - GHL will reject with 409
2. **n8n should continue** (green execution despite error)
3. **Verify Update path works** for existing contacts

---

## 🎯 SUCCESS CRITERIA

**System is VALIDATED when:**
- [ ] All 5 test purchases complete successfully
- [ ] All 3 tags applied correctly in GHL
- [ ] Production links updated on live site
- [ ] At least one real test works (optional)

**System is READY FOR LAUNCH when:**
- [ ] Validation checklist complete
- [ ] Email sequences set up
- [ ] Intake form created
- [ ] Documentation templates ready
- [ ] Telegram community created

---

## 📝 NOTES & OBSERVATIONS

**Record any issues found during testing:**
1. 
2. 
3. 

**Record any improvements needed:**
1. 
2. 
3. 

**Test execution times:**
- Start: _____
- End: _____
- Total: _____ minutes

---

## 🎬 NEXT STEPS AFTER VALIDATION

1. **Set up email sequences** (60 min)
2. **Create intake form** (30 min)
3. **Set up Calendly** (15 min)
4. **Soft launch to inner circle** (30 min)
5. **Create Day 2 content** (60 min)

---

**Validation Completed By:** ____________________
**Date:** March 21, 2026
**Time:** ____________________