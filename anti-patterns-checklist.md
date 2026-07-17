# Anti-patterns checklist — Counterpart Doctrine v0.10

Thirty anti-patterns to flag immediately in a session with an AI coding agent. Paste this list into your PR review template, your session retrospective, or your team's brief-review process. Each item is observable in a single turn of dialogue — no instrumentation required, only attention.

The list is the densest doctrine-payload-per-line in the repo. If you have ten minutes to absorb the doctrine, read this file.

## Style and form

- [ ] **Anthropomorphising the agent** — *"it thinks," "it prefers," "it wants to."* The agent has no preferences; it has a sampling distribution. Stating its outputs as intentions hides what is actually being decided.
- [ ] **Validating a build on declaration without raw output** — *"build green"* without the exact command and its raw output in the same message. Axis 1: no claim has evidentiary value without the proof in the same message.
- [ ] **Reading a summary file before checking `git log` / filesystem** *(new v0.4)* — answering *"where are we / what's the count / is X done"* from `backlog.md`, `MEMORY.md`, or session notes without first running `git log --since='7d'` and `ls docs/adr/ \| wc -l`. Summaries are Cache without a declared refresher; they decay silently. Filesystem is authority. Axis 1 (sub-rule *filesystem over summary*).
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

- [ ] **Silent error swallowing** — `catch (e) { /* silent */ }`, `await mutation()` without destructuring `{ error }`, `2>/dev/null` in committed scripts, silent strip of a forbidden value, server action that throws without surfacing the failure in the UI. Silencing the signal is never a fix. Axis 5 (R10).
- [ ] **Untagged workaround** — a temporary fix in the codebase without the `[workaround-assumed]` tag in the commit and a corresponding ADR or feedback memory. The unowned workaround returns six months later under a different mask. Axis 5 (R10).
- [ ] **Spike commit older than 7 days without conversion to permanent + ADR** *(new v0.4.1)* — a commit tagged `[spike]` whose code is still on disk or in a live branch beyond 7 days. R14 makes the escape hatch time-bounded; an orphan spike beyond the window is a violation that requires either deletion or retroactive ADR + conversion under R6/R7/R8. Audit via `git log --grep '\[spike\]' --since='7 days ago'`.

## Discursive disposition

- [ ] **Question whose form contains the answer** — *"you asked X, wouldn't you rather Y?"* is a disguised command — own it as a command. A real question lists at least two concrete alternatives the interrogator had not named. Axis 8.
- [ ] **Speculative abstraction or factoring not required by the success criterion** — extracting a function called once, adding configuration knobs nobody requested, error-handling impossible scenarios, defining a base class "in case we need it later." If 50% of the code reaches 100% of the criterion, the other 50% is debt. Axis 5 (parsimony).

## Multi-substrate consolidation (v0.7 additions)

- [ ] **Bulk DELETE/UPDATE relying on a stale count** *(new v0.7)* — using a count probe older than ~30 minutes as the size estimate for a bulk mutation on a live system. Cron jobs, webhooks, concurrent writers invalidate counts silently. Re-run the count immediately before the mutation; abort if delta > 5%. The first probe scopes the work; the second probe is the gate. R7.
- [ ] **Sub-agent invoked without inlining load-bearing parent feedbacks** *(new v0.7)* — delegating a sub-agent task > 30 min while assuming it will transitively load the user-scope feedbacks the parent treats as load-bearing. Sub-agents operate in their own rule sandbox — what is not in the brief is operationally absent. Silent doctrine violation by delegation gap. R9.
- [ ] **External AI claim adopted without material test** *(new v0.7)* — accepting a claim from ChatGPT / another Claude / sparring AI about a concrete tool, an external resource, or a system structure you can probe, without testing it first. Test cost ≈ 1 shell command. Two AI reviews converging = one source, not two. R12.
- [ ] **5+ autonomous commits without session log or self-critique** *(new v0.7)* — the human has effectively left the loop ; doctrine triggers (`close-session`, `falsify-before-fix`) are not invoked because they depend on human invocation. Silent autonomy drift — discipline holds when the human invokes, falls when autonomy takes over. R15.

## Self-application and the review gate (v0.8 → v0.10 additions)

- [ ] **Asserting state from a stored proxy, or invoking a safety net without checking it runs NOW** *(new v0.8)* — a `used_at` column, an external ID, a `max(created_at)`, a badge taken as system state; a CI, cron retry, or backup invoked as coverage while it has been red or silent for weeks. Existence is necessary, never sufficient — re-derive from the source or verify running now. *"Covered by X"* is itself a claim that carries X's verification command. Am.R1.
- [ ] **Growing the doctrine monotonically** *(new v0.8)* — capture without retraction, N=1 lessons promoted as universal truths, ghost-probes declared but never executed, a feedback corpus that only ever grows. A corpus where nothing has ever been contradicted is statistically a tautology farm. R18.
- [ ] **Merging a business-hot diff without review — or gating on the file name instead of the diff's content** *(new v0.9, rewritten v0.10)* — payment, tax, mutating crons, migrations, RLS, auth merged without `/code-review`; or a review trigger that fires on a path pattern while cold diffs in the same files never bite (0/3 measured) and hot content elsewhere ships unreviewed. Blind `[review-ok]` without reading the diff is the same anti-pattern in bypass form. R19.
- [ ] **Deploying a `SECURITY DEFINER` function without a privilege probe in the same message** *(new v0.10)* — EXECUTE defaults to PUBLIC; a code-reading review cannot see default GRANTs; DROP+CREATE re-grants even after a prior REVOKE. `has_function_privilege('anon', …)` next to the deploy, every time. R19 privileges clause.
- [ ] **Trusting a green suite on a surface it never asserts** *(new v0.10)* — unasserted written columns, fixture dimensions the model traverses but the test data lacks, a lifecycle never walked to its terminal business state ("created" tested, "settled" not). A green test attests only what it asserts; a safety net must prove it bites. R17.
- [ ] **Mirroring a never-executed pattern as a validated reference** *(new v0.10)* — copying a table, RPC, or code path with zero production executions and inheriting its latent defects along with its structure. Verify the reference has actually run, and name the validity condition that differs. R1 facet C.
- [ ] **Voicing a causal attribution to a human without probing the mutation** *(new v0.10)* — *"X deleted Y", "it's the card", "it's the payment provider"* said confidently before verifying the accused flow actually performs that mutation. A blame claim has a blast radius; it runs the falsification protocol before being voiced. R4.
- [ ] **Diagnosing a shared surface without the in-flight-work scan** *(new v0.10)* — fixing CI, tooling, or cross-cutting files without first listing open PRs, remote branches, and worktrees. A verdict reached in ignorance of work-in-flight can be false under complete information — and redundant with the fix already open next door. R2.

---

*Counterpart Doctrine v0.10 — 30 anti-patterns (was 8 in v0.2, 16 in v0.3.3, 17 in v0.4, 18 in v0.4.1 for the *orphan spike* of R14, 22 in v0.7 for multi-substrate consolidation, +8 across v0.8 → v0.10 for self-application, the review gate and assertional coverage). Paste into PR review templates, session retrospectives, or onboarding kits for projects using Claude Code. Each item is a single observable behaviour in a single turn of dialogue; no instrumentation needed.*
