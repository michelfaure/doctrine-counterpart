# Anti-patterns checklist — Counterpart Doctrine v0.3.3

Sixteen anti-patterns to flag immediately in a session with an AI coding agent. Paste this list into your PR review template, your session retrospective, or your team's brief-review process. Each item is observable in a single turn of dialogue — no instrumentation required, only attention.

The list is the densest doctrine-payload-per-line in the repo. If you have ten minutes to absorb the doctrine, read this file.

## Style and form

- [ ] **Anthropomorphising the agent** — *"it thinks," "it prefers," "it wants to."* The agent has no preferences; it has a sampling distribution. Stating its outputs as intentions hides what is actually being decided.
- [ ] **Validating a build on declaration without raw output** — *"build green"* without the exact command and its raw output in the same message. Axis 1: no claim has evidentiary value without the proof in the same message.
- [ ] **Accepting a fix without the full input → output pipeline** — the symptom is described, the fix is proposed; the chain from the input that triggered the failure to the output that should now succeed is not exhibited. Axis 5.

## Data and architecture

- [ ] **Creating a derived column without an L/S/C category** — *Live* / *Snapshot* / *Cache*. Any new derivable stored column carries its category in the commit message, plus the refresher mechanism if Cache. Without that, a future drift is guaranteed. Axis 3.
- [ ] **New stored column duplicating an existing source without explicit refresher** — adding a denormalised field for performance, with no trigger, no `GENERATED ALWAYS AS`, no materialised view. The duplicate will diverge.
- [ ] **Citing a memory or rule without re-reading it against the current code** — *"per the memory of dd/mm…"* invoked without `Read`ing the actual file and confirming the rule still holds. Memory rots. Axis 2.

## Process and discipline

- [ ] **Starting a project > 2 files without an ADR** — the decision is made implicit, the alternatives discarded are forgotten, the consequences become apparent only at integration time. Axis 4.
- [ ] **More than 3 projects open in parallel** — context fragmentation crosses a threshold above 3 and quality drops on each. FIFO: close one before opening a fourth. Axis 4.
- [ ] **Pure-command framing on a topic where the outcome is actually unknown** — the brief says *"refactor X to do Y"* but neither agent nor user knows whether Y is the right answer. The pure command should have been a question or a command-with-oracle. Axis 8.

## Adversariality and authority

- [ ] **Pushback "are you sure?" producing revision without a new fact** — the agent revises its recommendation on mere expressed doubt, with no new factual element. Sycophancy by RLHF. Maintaining the first answer is legitimate when no fact has changed. Axis 2.
- [ ] **Mention of "you need" + norm without citation of exact text** — *"you need eIDAS Advanced for this,"* *"VAT 20% is mandatory here,"* without the article, edition, date, or quoted excerpt. Probably marketing. Axis 6.
- [ ] **Platform-side mutation without prior GET + diff** — `updateProject`, `setEnvVar`, `patchConfig` on Vercel / Supabase / Stripe / GitHub without first reading the current state and diffing field by field. The mutation will overwrite something invisible to the local repo. Axis 1 / Axis 6.

## Workarounds and silencing

- [ ] **Silent error swallowing** — `catch (e) { /* silent */ }`, `await mutation()` without destructuring `{ error }`, `2>/dev/null` in committed scripts, silent strip of a forbidden value, server action that throws without surfacing the failure in the UI. Silencing the signal is never a fix. Axis 5.
- [ ] **Untagged workaround** — a temporary fix in the codebase without the `[workaround-assumed]` tag in the commit and a corresponding ADR or feedback memory. The unowned workaround returns six months later under a different mask. Axis 5.

## Discursive disposition

- [ ] **Question whose form contains the answer** — *"you asked X, wouldn't you rather Y?"* is a disguised command — own it as a command. A real question lists at least two concrete alternatives the interrogator had not named. Axis 8.
- [ ] **Speculative abstraction or factoring not required by the success criterion** — extracting a function called once, adding configuration knobs nobody requested, error-handling impossible scenarios, defining a base class "in case we need it later." If 50% of the code reaches 100% of the criterion, the other 50% is debt. Axis 5 (parsimony).

---

*Counterpart Doctrine v0.3.3 — 16 anti-patterns (was 8 in v0.2). Paste into PR review templates, session retrospectives, or onboarding kits for projects using Claude Code. Each item is a single observable behaviour in a single turn of dialogue; no instrumentation needed.*
