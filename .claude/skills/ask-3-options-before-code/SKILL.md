---
name: ask-3-options-before-code
description: Activate this skill before writing any code touching audit logic, permission rules, workflow transitions, or any business decision that doesn't have a unique technical answer. Triggers on "what should happen if X", "who can do Y", "what to do when Z", workflow questions, permission grants, audit log design, or any change touching `.claude/rules/*.md` invariants. Enforces enumeration of 2-3 concrete alternatives with explicit trade-offs and a user-facing question before any code is written. Operational instance of R13 *Three brief modes — Question without oracle — real questions list ≥ 2 concrete alternatives* of the Counterpart Toolkit.
---

# Ask 3 options before code — invocable protocol

R13 of the toolkit states textually: *"Real questions list ≥ 2 concrete alternatives the interrogator had not named."* This skill is its invocable instance: what to run, in order, when the agent recognises a business decision with no unique technical answer.

Companion to `success-criteria-first` (which sets the verifiable criterion before code) and `material-verification` (which validates claims with raw output). `ask-3-options-before-code` runs *before* both — it ensures the criterion itself is the right one.

## Step 1 — Recognise the mode mismatch

A request looks like a pure command but the answer involves a business trade-off the requester may not have considered. Signals:

- Permission or audit logic ("who can do X", "what gets logged when Y")
- Workflow transitions ("what happens if signed and edited")
- Default values for forbidden/edge cases ("what if the field is empty")
- Cascade effects ("when X is deleted, what happens to Y, Z")

If you write code immediately, you embed a *default implicit decision*. If the requester would have chosen differently, you produce code that has to be rewritten — typically 5-15 min wasted vs 30 sec of clarification.

## Step 2 — Enumerate 2-3 concrete alternatives with trade-offs

Each alternative must be:

- **Concrete** — what the code does, not what it "could conceptually do"
- **Mutually exclusive** — picking one forecloses the other
- **Honest about trade-offs** — name what each option costs, not just what it gains

Format:

```
Option A: <one-sentence action>
  Trade-off: <what it costs, who it might surprise>

Option B: <one-sentence action>
  Trade-off: <what it costs, who it might surprise>

Option C (optional): <one-sentence action>
  Trade-off: <what it costs, who it might surprise>
```

Three options maximum. Beyond three, the framing is wrong — the question is too vague.

## Step 3 — Ask the user, wait for arbitration

Use the dedicated `AskUserQuestion` tool (Claude Code) or whatever equivalent surfaces a structured choice in the host environment. Plain text proposal with bullet list is acceptable if the tool is unavailable.

**Do not pick a default and write the code.** The point of the protocol is to force the trade-off to surface. Even a 30-second human arbitration is cheaper than a 15-minute re-code.

## Step 4 — Code the chosen option, attribute the decision

After arbitration:

- Write the code for the chosen option only.
- In the commit message or ADR, note: *"Decision: option X chosen over Y because <reason>."*
- The attribution makes the trade-off visible in `git log` for the next reader (R13 audit).

## When NOT to invoke this protocol

The protocol costs ~30-60 seconds (enumeration) + waiting for user. The cost is not justified for:

- Pure technical decisions with one obvious answer (correct algorithm, well-typed signature, standard library choice)
- Style or naming questions
- Decisions already specified in `.claude/rules/*.md` or recent ADRs
- Edits to documentation, copy, or content

The protocol is mandatory when the decision touches:

- **Audit logic** (what gets logged, when, by whom)
- **Permission rules** (who can do X, under what conditions)
- **Workflow transitions** (state changes that propagate)
- **Edge case defaults** (what happens when an invariant is violated)
- **Cross-module effects** (changing a primitive that other modules consume)

## Why structured options, not free-form questions

A free-form question — *"how should we handle X?"* — gives the user no structured choice and typically produces vague responses ("do what makes sense"). A 3-options enumeration with trade-offs forces the user into a decisive arbitration mode: pick A, B, or C, or override with a fourth path they name explicitly.

The asymmetry is intentional: the agent invests in structuring the choice; the user invests in deciding. Both sides do their share, neither shoulders the other's load.

Empirically: a 30-second arbitration prevents a 15-minute re-code on a non-trivial business decision. Documented incident 2026-05-16 (rembrandt `notes-formateur-remplacement`): 3 questions enumerated, 30-second decision from user, 88-line server action + UI modal + 3-file fix delivered in ~45 minutes with zero re-do.
