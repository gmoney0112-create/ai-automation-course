# OpenClaw Chrome Iframe Access Recovery Handoff

**Date:** March 18, 2026  
**Audience:** Codex / Copilot / Claude / engineering operator  
**Primary recommendation:** Hand this off to **Codex first**, then use **Copilot** for PR cleanup and GitHub workflow

## Executive Summary

OpenClaw can connect to Chrome tabs, but it cannot reliably inspect or interact with iframe content, especially Stripe-hosted payment iframes. Restarts have not permanently fixed the problem.

This handoff is designed to force a real root-cause investigation across:

- browser relay extension scope
- Chrome site access permissions
- CDP frame discovery and target attachment
- OpenClaw browser abstraction and frame-aware tooling
- session stability during deep inspection

The objective is not just to make the iframe work once. The objective is to produce a permanent, documented fix that survives restart and reconnect.

---

## Why Codex First

Use **Codex first** because this is a multi-layer engineering/debugging task that likely requires:

- auditing a codebase
- tracing architecture across extension + CDP + runtime
- patching code/config
- validating behavior end to end
- writing durable diagnostics and a runbook

Use **Copilot second** if you want the resulting fix turned into clean GitHub PRs, issue-linked changes, or scoped repo follow-up work.

Use **Claude** if you want a strong parallel reviewer, architecture explainer, or second-opinion debugger after the first code-path audit.

**Recommended sequence**

1. Codex — root cause + patch
2. Copilot — PR workflow, cleanup, follow-up repo tasks
3. Claude — optional second review or architecture critique

---

## Problem Statement

OpenClaw browser control reaches Chrome, but it cannot reliably discover, target, or interact with iframe content on payment pages, especially Stripe-hosted fields.

### Observed symptoms

- OpenClaw can connect to tabs
- Browser relay/extension appears attached
- Stripe/payment iframe content is not reliably visible or usable
- Deep inspection attempts may appear unstable
- Restarting Chrome/OpenClaw changes behavior temporarily, but does not solve the problem

### Likely failure layers

1. Extension permissions or content-script scope
2. CDP frame discovery / child-target attachment
3. Cross-origin iframe targeting limitations
4. OpenClaw browser abstraction missing frame-aware primitives
5. Session instability during deep frame inspection

---

## What Is Proven vs Hypothesized

### Proven

- OpenClaw reaches Chrome tabs
- The issue clusters around iframe interaction
- Stripe/payment iframes are involved
- Restart-only guidance has not produced a durable fix

### Not proven

- that extension permissions are the sole root cause
- that `all_frames` is currently missing
- that CSP bypass solves the issue
- that OpenClaw supports a browser config key like `iframeHandling`
- that the primary failure is extension-only rather than CDP or runtime abstraction

---

## Success Criteria

The issue is fixed only when all of the following are true:

1. OpenClaw can enumerate the live frame tree for a failing page
2. The Stripe/payment iframe appears in that frame tree
3. OpenClaw can explicitly target the correct child frame
4. OpenClaw can read or interact with iframe content when the browser architecture permits it
5. The fix survives restart and reconnect
6. The team can explain exactly why the old behavior failed

---

## Required Diagnostic Plan

### Phase A — Identify the control path

Determine whether the active browser-control path is:

- extension-based
- CDP-based
- hybrid extension + CDP

#### Required outputs

- `control_path`
- `extension_role`
- `cdp_role`
- `frame_access_method`
- `likely_failure_layer`

---

### Phase B — Capture frame discovery behavior

On a known failing Stripe/payment page, capture:

- top frame id
- child frame ids
- frame URLs
- whether the Stripe iframe appears in the frame tree
- whether OpenClaw can select a child frame explicitly

#### Required outputs

- frame tree summary
- whether Stripe iframe was discovered
- whether child-frame targeting exists in the current runtime

---

### Phase C — Audit extension permissions and injection scope

Inspect the actual installed browser relay extension and confirm:

- manifest version
- host permissions
- site access mode in Chrome
- `content_scripts`
- `all_frames`
- `match_about_blank`
- whether the extension is injected into child frames
- whether the Stripe iframe origin is covered

#### Required outputs

- current manifest settings
- whether subframe injection is enabled
- whether extension is allowed on all sites
- whether iframe origin is covered

---

### Phase D — Audit CDP frame handling

Inspect whether OpenClaw:

- enables Page domain
- enumerates frame tree
- attaches to child targets if needed
- supports frame-aware query/eval/click behavior
- is incorrectly trying to act only on the top-level DOM

#### Required outputs

- current CDP frame strategy
- missing APIs or attachment steps
- whether the runtime lacks frame-context selection

---

### Phase E — Audit session stability

Check whether session drops are interfering with deep frame operations:

- relay disconnects
- websocket reconnects
- browser-control timeouts
- deep inspection failure timing

#### Required outputs

- whether session instability is primary, secondary, or irrelevant
- where disconnect happens relative to frame inspection

---

## Most Likely Permanent Fixes

### Fix Group 1 — Extension scope

If subframes are not covered:

- grant site access on all sites
- expand host permissions
- enable `all_frames`
- enable `match_about_blank` where needed
- verify child-frame injection actually occurs

### Fix Group 2 — Frame-aware tooling

If OpenClaw only operates on top-frame DOM:

- add frame enumeration support
- expose frame ids and URLs
- add frame-selection primitives
- add child-frame selector/eval/click support

### Fix Group 3 — CDP child-target attachment

If cross-origin frames require explicit handling:

- attach to child targets where needed
- use frame tree inspection
- run commands in the correct frame context

### Fix Group 4 — Browser abstraction update

If the current browser tool is not frame-aware:

- patch the OpenClaw browser-control layer
- expose diagnostics for discovered frames
- expose selected frame id in logs
- improve error messages for cross-origin frame limitations

### Fix Group 5 — Stability hardening

If the relay/browser session drops during frame work:

- harden reconnect behavior
- raise timeouts where needed
- prevent reconnect loops during deep inspection
- add lifecycle logs for frame inspection

---

## What Not To Do

Do not assume these are sufficient without verification:

- repeated Chrome restarts
- repeated gateway restarts
- blanket CSP bypass
- invented config keys not backed by the codebase
- top-level selector attempts against Stripe iframes
- "it worked once after restart" as proof of a fix

Do not close the task until the iframe is:

1. discovered
2. targetable
3. actually usable or cleanly explained if browser security blocks a specific action

---

## Implementation Steps

### Step 1

Audit the actual OpenClaw browser-control architecture in this setup.

### Step 2

Instrument frame discovery on a known failing page and capture the real frame tree.

### Step 3

Audit the browser relay extension manifest and Chrome site access settings.

### Step 4

Patch the failing layer:

- extension
- CDP frame handling
- OpenClaw browser abstraction
- or session stability

### Step 5

Add durable diagnostics:

- discovered frames
- chosen frame id
- query/eval context
- failure reason for iframe interaction

### Step 6

Retest on the Stripe/payment page.

### Step 7

Write a runbook documenting:

- root cause
- exact fix
- how to verify after redeploy
- known remaining limitations

---

## Deliverables

The engineering agent should produce:

1. **Root cause report**
   - exact failing layer
   - why iframe interaction fails today

2. **Patch**
   - extension manifest changes if needed
   - OpenClaw browser-control changes if needed
   - CDP/frame-targeting changes if needed

3. **Diagnostics**
   - frame tree logging
   - selected frame logging
   - better cross-origin iframe failure messages

4. **Validation**
   - frame tree includes Stripe iframe
   - correct child frame can be targeted
   - at least one real iframe read/interaction works if the platform allows it

5. **Runbook**
   - verification steps
   - troubleshooting decision tree
   - restart is no longer the primary instruction

---

## Prompt for Codex / Copilot / Claude

```text
Audit and permanently fix OpenClaw iframe handling in Chrome browser control.

Problem:
OpenClaw can connect to Chrome tabs, but it cannot reliably inspect or interact with iframe content, especially Stripe-hosted payment iframes. Restarts do not permanently solve the problem.

Do not assume the issue is only extension permissions. Determine whether the root cause is:
1. extension injection scope
2. CDP frame discovery/attachment
3. cross-origin iframe targeting limitations
4. OpenClaw browser abstraction missing frame-aware tooling
5. session instability during deep inspection

Tasks:
1. Identify the actual browser control architecture in this setup (extension, CDP, or hybrid)
2. Audit current iframe/frame discovery behavior on a known failing Stripe page
3. Inspect the browser relay extension manifest and Chrome site access behavior
4. Inspect how the current OpenClaw browser layer enumerates and targets frames
5. Determine whether Stripe iframe is:
   - not discovered
   - discovered but not targetable
   - targetable but not interactable
6. Patch the actual failing layer
7. Add durable diagnostics:
   - frame tree logging
   - selected frame logging
   - clear cross-origin failure logging
8. Validate with a real iframe test and provide a runbook

Output:
- root cause summary
- files changed
- exact permanent fix
- why restarts were insufficient
- validation steps
- remaining limitations, if any
```

---

## Definition of Done

This issue is resolved only when:

- OpenClaw discovers the Stripe/payment iframe in the live frame tree
- the correct child frame can be selected or targeted
- browser control can read or interact in that frame as supported by the architecture
- the fix survives restart/reconnect
- the runbook explains the original failure clearly

---

## Final Recommendation

**Best assistant to perform the work:** Codex first.  
Why: this task spans architecture discovery, code auditing, runtime debugging, code patching, and validation across multiple layers. That maps best to Codex's software engineering agent workflow.

**Best assistant after that:** Copilot.  
Why: once the root-cause patch exists, Copilot is very good for turning it into PRs, follow-up fixes, issue-linked changes, and repo cleanup inside GitHub.

**Optional reviewer:** Claude.  
Why: Claude is strong for codebase reasoning and architecture review, so it is useful as a second-opinion reviewer after the first patch lands.
