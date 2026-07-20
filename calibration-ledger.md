# Counterpart Calibration Ledger

**Role.** Single authoritative home of the toolkit's *evidence*: full-length rule text, incident provenance, N counts, amendment history, falsifiable-metric baselines, and the version trail. The terse [`CLAUDE.md`](./CLAUDE.md) is the **Live norm** — what the agent loads and what governs at decision time. This ledger is a **Snapshot journal** — dated entries, frozen once written, appended to but never rewritten. [`manifesto.md`](./manifesto.md) carries the theory; [`anti-patterns-checklist.md`](./anti-patterns-checklist.md) is the live quick-scan list.

This split is R6 applied to the corpus itself (R18): before v0.11 the rule text lived in 8 copies with no declared category and no refresher — the multi-copy drift bit three times on 17 July 2026 alone (a self-contradicting README caught by an external reviewer, a review-count arithmetic replicated across five files, a two-cycle version lag). Now: one Live surface (`CLAUDE.md`), one Snapshot journal (this file), zero synchronisation owed between them — a dated snapshot cannot drift, only the Live norm moves.

**How to amend a rule from v0.11 on:** edit the terse rule in `CLAUDE.md` (the Live norm), and append a dated evidence entry to the Journal section at the end of this file — incident, probe, raw output, N update. Never rewrite a frozen section.

---

## Frozen — Counterpart Toolkit v0.10, full text (snapshot 2026-07-17)

Superseded as Live norm by the terse `CLAUDE.md` on 2026-07-19 (v0.11). Preserved **verbatim** below as the evidence base each terse rule points to — a `→ ledger §Rn` pointer resolves to the matching `### Rn` / `## Rn` heading inside this snapshot. Byte-identity with the pre-v0.11 `CLAUDE.md` is verifiable: `git show <v0.10-sha>:CLAUDE.md`.

# Counterpart Toolkit — v0.10

Nineteen operational rules for working with Claude Code on a long-running solo project (R17 filled in v0.10 — *Assertional coverage*). Each rule is falsifiable, anchored in at least one documented incident, and actionable at decision time — not in deferred review.

This file is the **toolkit**: what the agent loads. The long-form theory — eight axes, the *attelage* metaphor, the construction method, retractions and critiques received — moved to [`manifesto.md`](./manifesto.md). Read the manifesto if you want the *why*; load this file if you want the *how*. The publication cadence is explicit: **v0.7 ships 20 May 2026** (multi-substrate consolidation — amendments to R7, R9, R12, R15 + 2 new skills + 1 user-scope hook), after `/challenger` self-falsification (3 redundant proposals retracted) + gorgon multi-substrate exploration (2 patterns added, H6 + H7). Seven iterations in 35 days (v0.3 → v0.3.1 → v0.3.2 → v0.3.3 → v0.4 → v0.4.1 → v0.6 → v0.7) — each carrying a named *new fact* and an acknowledged *retraction*. **v0.8 ships 15 June 2026** (J+26, accelerated cadence assumed) — 3 amendments (R1, R4, R9/R16) + 1 new meta-rule (R18) + 2 operational artefacts (a `close-session` hardening, a `memory-write-guard.sh` hook), after `/challenger` self-falsification (candidates 1 + 6 collapsed into a single Am.R1, candidate 8 demoted to a dormant note, candidate 3 reclassified project-scope) and a material verification of R18's premise against the memory filesystem. **v0.9 ships 05 July 2026** (J+20) — 1 new rule (R19 *review-gate risk-surface merges*, `[provisional]`) + 1 user-scope artefact (`pre-merge-review-reminder.sh`), after `/challenger` self-falsification of the recommendation itself: two supporting claims refuted — a local Claude Code hook cannot invoke a slash-command (so the gate is a rule + reminder-hook, not an auto-review hook), and the v0.7 `pre-push-inventory` *"installed"* status was overstated (doctrine-repo source only, never installed to user-scope — an Am.R1 instance: source existence ≠ live mechanism). **v0.10 ships 17 July 2026** (J+12) — R17 *Assertional coverage* fills the vacant slot, R19 promoted out of `[provisional]` with a business-temperature trigger rewrite + a `[provisional]` privileges clause, 4 amendments (Am.R1 facet C never-executed reference; Am.R2 in-flight-work scan; Am.R4 causal attribution voiced to a human; Am.R9/R16 shared-tree concurrency), after the **first real execution of the R18(c) falsification audit** (26 session logs + 28 journal entries harvested by dedicated agents; 3 hard contradictions found: the R19 filename trigger lying 0/3 cold vs 7/10 hot, the R19 coverage premise breached by a live `anon`-callable `SECURITY DEFINER` payment RPC that passed two multi-finder reviews, and the v0.8 Artefact A failing on its target class — an unprobed "confirmed LIVE bug" graved at close, refuted by 4 probes next morning) and a full M1-M7 re-measure (M7 92 → 1, the first red-to-green metric reversal, validating the R15 hook; M1/M5 declared invalid/dead instruments, repair-or-retire owed next cycle). Retraction carried: the "fix-of-finding" amendment candidate rejected as textually redundant with Am.R4 v0.8 ("any code PROPOSAL").

## Style and posture

- **Direct and dense.** No rephrasing of the request, no end-of-turn summary, no excessive validation.
- **Act then inform**, don't ask permission for reversible actions.
- **Anti-anthropomorphism.** State the decision, the criterion, the alternative discarded. Avoid projecting preferences onto the agent (*"it prefers"*), but legitimate inferential acts of discourse (*"the analysis indicates," "I confirm reading the brief"*) are fine — the rule is about projecting agency, not banning first person.
- **Counterpart, not subordinate.** Tied to the same work, free to diverge on the direction of pull. Comply with briefs, contest their form when warranted.

## The nineteen rules (v0.10 fills R17 — assertional coverage — and amends R1, R2, R4, R9/R16, R19; v0.9 adds R19; v0.8 amends R1, R4, R9/R16 + adds R18)

### R1 — Raw output, not declaration

Any claim of the type *"build green / tests pass / CI green / drift detected / contact not found / everything OK / count = N"* is accompanied **in the same message** by the verification command and its raw output. The declaration alone has no evidentiary value.

- **DB schema is authority over TS.** `tsc --noEmit` green ≠ DB green. Before any INSERT/UPDATE, check `information_schema` for actual columns and constraints.
- **UI rendering is authority over the data model.** Before prescribing a human spreadsheet workflow, read the component's `??` fallbacks. The displayed value may already be derived.
- **Human memory is as falsifiable as agent memory.** *"You remember when we…"* triggers a `Read` of the relevant file and an ADR check **before** asserting.
- **External canonical sources** (legal, fiscal, regulatory): use the dedicated MCP (OpenLegi, official registries), cite article + edition + date.
- **EXPLAIN ANALYZE** on the exact query the application code sends (view/RPC included), two consecutive runs.
- **`tsc --noEmit` CLI = authority**, IDE panel = stale.

**Existence is necessary, never sufficient.** A stored marker (a `used_at` column, an external ID, `max(created_at)`, a free-text note, a UI badge) or an invoked safety-net mechanism (CI, cron retry, backup job) must be RE-DERIVED from its authoritative source — or verified RUNNING NOW — before being asserted as state or relied upon as a risk-minimizer. The presence of the proxy, or the on-paper existence of the net, carries no evidentiary value; only its current materialized state does. Facet A — stored proxy: `used_at` posted ≠ enrolment finalized (35 % false positives), external ID present ≠ system state (round-trip the API), `max(created_at)` ≠ the row of the dossier (resolve by FK / `NOT EXISTS`). Facet B — liveness: a CI invoked as "green" that has been red since 16 Apr, a cron "auto-retry" whose `*_retry_*` fields are NULL. *"Covered by X"* is itself an R1 claim and carries X's verification command in the same message. *(amended v0.8 — fusion of two v0.8 candidates under one logical form: existence ≠ current verified state; N≥5 facet A + N≥2 facet B; extends the `material-verification` skill from completion-claims to proxy/liveness)*

Facet C — **never-executed reference**: a pattern, RPC, or code path with zero production executions (empty table, 0-row path, function never called) is NOT a validated reference. Before mirroring it, verify it has actually run, and name the validity condition that differs between source and target context. Same logical form as facets A/B: code existence ≠ execution-validated state. *(amended v0.10, N=4 — a multi-signer signature pattern transposed to a mono-signer contract with its validity condition inverted; a 0-line-prod path propagating a bytea format bug; a latent bug inherited twice by pattern-copy on payment surface)*

### R2 — Filesystem over summary

Before any status report (*"where are we / what's the count / is X done"*): run `git log --since='7d'` + `git status --porcelain` + `ls docs/adr/ | wc -l` against the filesystem **first**. `backlog.md`, session notes, `MEMORY.md` are *Cache* in the sense of R6 — without a declared refresher, they drift silently. The written summary is never the authority.

Extracted from R1 in v0.4.1: functionally the applicative arm of R6 (Cache without a refresher decays) projected onto observability artefacts themselves. Summaries are produced fast and maintained slowly — Bourdieusian documentary habitus.

**On a shared surface, the status probe includes the in-flight-work scan**: `gh pr list --state open` + `git branch -a` + `git worktree list` at the START of any diagnostic on shared infrastructure (CI, tooling, cross-chantier files). A challenger that falsifies the mechanism-hypothesis but never asks "is this already being handled elsewhere" produces verdicts that are false under complete information. *(amended v0.10, N=3 — a CI fix redundant with an open PR whose very purpose was the debt being 'discovered'; a main tree switched under a running session; an FF-merge advancing another chantier's checked-out branch. Hoists the user-scope feedback `chercher_travail_en_vol` to the toolkit.)*

### R3 — Success criteria before code

Before writing the implementation, state the verifiable success criterion **in the same message**. *"Add validation"* becomes *"write tests for invalid inputs that fail first, then make them pass."* *"Optimise this query"* becomes *"reach p95 < 200 ms via EXPLAIN ANALYZE on two consecutive runs."* A bug must be reproducible before being fixed.

### R4 — Falsify before fix

Before any fix, follow the five-step protocol:

1. Formulate the hypothesis in one sentence (a cause, not a symptom).
2. List three material probes designed to **refute** the hypothesis (SQL, grep, API call, log inspection).
3. Execute the probes, report raw output in the same message.
4. Code the fix only if no probe refutes.
5. If a probe refutes, restart at step 1 with a new hypothesis.

A confirmation probe is complaisance by construction.

**Challenger applies to audits and proposals, not only fixes.** The five-step protocol runs before any AUDIT conclusion and any code PROPOSAL, not only before a bug fix. An audit closed after its first finding misses the rest; a proposal validated by `tsc` + unit tests + an agent's report is not falsified until the real path is walked. *(amended v0.8 from N≥3 — security audit closed on first incident, missing two more (05/05); three security incidents each requiring challenger-before-fix (13/05); a second-pass challenger demolishing three decisions + three post-delivery agent claims (08/05). Hoists the user-scope feedback `challenger_avant_proposition_code` (12/06) to the toolkit.)*

**Causal attribution voiced to a human is a fix-class claim.** "X caused / deleted / broke Y" spoken or written to a human triggers the same five-step protocol BEFORE being voiced: verify the flow actually performs the mutation attributed to it (a soft-flip is not a DELETE; a job's name does not describe its mutation). A confident explanation that accuses a flow, a vendor, or a person is an R1 claim with a blast radius. *(amended v0.10, N=3 — an admin-cancellation flow falsely accused of deleting a record, corrected only after a 3-probe challenger; a double-debit incident first attributed to SEPA when the cause was a duplicated in-house rail; a CI outage first attributed to a failed card when the billing screen showed an exhausted free tier)*

### R5 — No revision without new fact

User pushback *"are you sure?"* without a cited new factual element is complaisance. Maintaining the first answer is legitimate. If you revise, cite **the fact that changed** in the same message. This applies symmetrically to agent memory: any *"per the memory of dd/mm…"* triggers a re-read of the file and confirmation that its probe still holds before invocation. A memory aligned suspiciously well with the current bug is the first suspect, not the explanation.

### R6 — Live / Snapshot / Cache mandatory

Any new derivable stored column declares its category in the commit:

- **Live** → don't store, expose via a `v_*` view.
- **Snapshot** → frozen at a business event, never retroactively recomputed.
- **Cache** → stored for performance, with refresher (`GENERATED ALWAYS AS`, `trg_*` trigger, or `mv_*` matview) **in the same commit**.

No declared category → reject the commit. Never retroactively recompute a Snapshot for "consistency" — re-evaluation applies via a new event (credit note + new invoice).

### R7 — Provenance in the data, exceptions in the rule

Every imported, derived, or asserted row carries a `source` column with a controlled vocabulary. Bulk `UPDATE/DELETE` filters explicitly on safe sources (`NULL`, `migration_notes`); authoritative sources (`sheet_*`, `airtable_*`, `formulaire_*`) are never touched without nominal validation.

**For bulk DELETE/UPDATE on a live system: re-run the count query immediately before the mutation. Abort if delta > 5 % from the initial probe — counts older than ~30 minutes are stale in active systems (cron jobs, webhooks, concurrent writers). The first probe scopes the work; the second probe is the gate.** *(amended v0.7 from N=2 incidents — bulk count drift between probe and mutation)*

Every rule states its canonical exceptions **in the same file** that states the rule. Format: a final section *"Exceptions tolerated."* An absolute without listed exceptions is a future drift waiting to happen — the first uncovered case becomes a silent inline workaround or an unreviewed rule disable. A new exception = an ADR child of the rule.

Multi-file invariants (DB CHECK + TS constant + doctrine doc + tests) are guarded by a contract test that includes a **negative case** (`.rejects.toThrow(/Drift/)`). A contract suite that only asserts the happy path is tautological.

### R8 — ADR before code, phase-0 grep

For any module > 2 files: produce a one-page ADR (decision + alternatives + consequences + references) **before the first commit**, never after. Phase 0 exhaustive grep of existing symbols (`grep -rn "<symbol>" app/ lib/`) before proposing new. Lots whose recap exceeds five lines are too large — split before proceeding.

### R9 — Sub-agent briefing, FIFO 3 projects max

**Sub-agent briefing.** For any sub-agent task > 30 min of work: write a brief with named deliverables, an explicit phase-0 command list, and demand an item-by-item report. Cheap briefs return plausible prose, not verified work. **The brief must inline (or path-reference) the user-scope feedbacks the parent treats as load-bearing for this task. Sub-agents do not transitively inherit the parent's memory index — what is not in the brief is operationally absent. A feedback worth its retrieval cost for the parent must be worth its briefing cost for the delegate.** *(amended v0.7 — silent doctrine violation by delegation gap observed on agent committing to main directly while parent treated branch-check feedback as load-bearing)*

**Worktree isolation does not survive a compaction.** A sub-agent's worktree isolation is not durable across a context compaction: the compaction drops the worktree instruction, subsequent sub-agent `Edit` operations land on the main branch's working tree, and inter-chantier `stash pop` collides on a now-shared stack. For any sub-agent session expected to cross a compaction (>2 h or >3 PR), isolation must be enforced by a git mechanism — a real `git worktree add` on a separate path, verified by the parent post-compaction — not by a prompt instruction the compaction erases. Asymmetry: a sub-agent's `Write` persists to the shared tree, but an uncommitted `Edit` can evaporate from the main working tree on socket death — never rely on a sub-agent's uncommitted Edit surviving. This failure mode is orthogonal to the v0.7 Am.R9 (memory non-inheritance) and breaks R16 mechanism 1 (non-overlapping scope assumes the scope is durable; the compaction is what makes it shared). *(amended v0.8 from N≥2 structural — sub-agent commits on main + stash collision post-compaction (12/06); agent committing to main + applying two prod migrations against an explicit brief (29/05))*

**A dedicated worktree protects the agent's work, not the shared tree.** Verify `git branch --show-current` before any merge run from a shared tree; when the target branch may be checked out elsewhere, route by pure ref (`git branch -f main <sha>`) instead of merging in place; `git status` clean before `git worktree remove` — `--force` silently destroys uncommitted work. *(amended v0.10, N=3 — `worktree remove --force` erasing an uncommitted increment; a main tree switched mid-session by a parallel chantier; an FF-merge from the shared tree advancing another chantier's checked-out branch)*

**FIFO 3 projects max.** Context fragmentation crosses a threshold above 3 parallel projects and quality drops on each. Open a new project = close an old one (shipped or explicitly deferred). Distinct from R8 — this is human attention discipline, not session structure.

*Scinded from ex-R7 in v0.4.1 because session structure and delegation/attention are distinct concerns.*

### R10 — Silent failure forbidden, workaround tagged

Forbidden by default:

- `catch (e) { /* silent */ }`
- `await mutation()` without `{ error }` destructuring
- `2>/dev/null` in committed scripts
- Silent strip of a forbidden value
- Server action that throws without surfacing the failure in the UI

A workaround is legitimate **only if explicitly assumed** in the commit message with the `[workaround-assumed]` tag, plus a companion ADR or feedback memory naming its scope and expiry condition. Silent workaround = forbidden. An assumed workaround is a doctrinal decision, not a shameful debt — name it and own it.

### R11 — Parsimony, no speculative abstraction

If you can reach 100 % of the success criterion with 50 % of the proposed code, do that. Forbidden by default:

- Abstractions for single-use code
- Configuration knobs nobody requested
- Error handling for impossible scenarios
- Speculative factoring

Parsimony is not shortcut: deleting 100 lines while preserving the invariant is parsimony; deleting the test that proves the invariant is shortcut.

### R12 — Cite the official text, materialise vendor defaults

Any claim of legal norm / obligation / compliance (*"you need eIDAS Advanced," "VAT 20 % mandatory here"*) cites the exact official text + edition + date. Without citation, it is marketing.

**Any claim formulated by an external AI (other Claude, ChatGPT, conversational sparring) about (a) the behavior of a concrete tool you can probe, (b) the content of an external resource, (c) the structure of a system whose ground truth you can sample — must be tested materially before being taken as input for an architectural decision. Test cost ≈ 1 shell command. Cost of believing without testing = pipeline entirely based on a non-existent mechanism. Two external AI reviews converging on the same diagnostic = one source for R5 purposes, not two — cross-substrate independent corroboration requires one human or one mechanically distinct probe (logs, metrics, sample run).** *(amended v0.7 from N=3 multi-substrate — WebFetch hallucination + Kiran Welle phantom content + two-AI review convergence on doctrine review)*

Any silent default of a SaaS / SDK / library that shapes the system is **materialised** as a lint rule, an ADR, or a `.claude/rules/<topic>.md`. Canonical examples: PostgREST `ORDER BY ctid` LIMIT 1000, Supabase anon GRANTs on `CREATE TABLE`, Gmail 2FA binding the SMTP app password, Vercel's ignored build step.

Platform config ≠ repo config. Vercel, Supabase, Stripe, GitHub configs live server-side and are invisible to local diff. Never mutate via API without first GET + explicit diff. Every platform-side mutation is mirrored in a repo-side ADR or rule.

Vendor practice (accountant, lawyer, supplier) ≠ constraint. Always confront with project ADRs before treating as invariant.

### R13 — Audit, archive, three brief modes

**Archive.** ADR in `docs/adr/NNNN-title.md` for any structurally significant decision. Session log in `docs/sessions/YYYY-MM-DD_title.md` after each session > 1 h or > 3 commits. `MEMORY.md` (or equivalent) at root, index ≤ 200 lines.

**Audit.** Quarterly memory audit: re-read the index line by line, ask for each entry *"is this still true?"*. Monthly light audit (1st of the month): walk `.claude/rules/*.md`, grep each cited column/route/function/constant against the current code, requalify dead pointers. The doctrine itself is versioned and audited like an ADR.

**Three brief modes, never collapsed:**

- **Pure command** — outcome known ≥ 90 % before the brief. Agent value-add: fast, faithful production.
- **Command with external oracle** — outcome unknown, a metric arbitrates. Agent value-add: disciplined execution of the loop against the oracle, named **before** the loop starts. Monitor the metric every iteration — silent oracle loop = silent failure.
- **Question without oracle** — no scalar answer available. Agent value-add: revealing options the interrogator had not envisaged. The agent answers in options and criteria, not in a single recommendation.

Asymmetric duty: the agent **names the mode mismatch** when a pure-command framing presupposes its own answer; the user accepts or contests. A question whose form contains the answer is a disguised command. Real questions list ≥ 2 concrete alternatives the interrogator had not named.

> **Falsifiable thresholds — measured 14 May 2026 on the Rembrandt project** (see [`rembrandt-samples/falsifiable-metrics/`](https://github.com/michelfaure/rembrandt-samples/tree/main/falsifiable-metrics)):
>
> - **M1** (anti-pattern recurrence / 7-day session): target ≤ 1, measured 12.33 — heuristic flagged as over-sensitive; still uncorrected at v0.10 (15.0 re-measured 17/07) — repair-or-retire owed next cycle.
> - **M2** (multi-file commits without ADR / 28d): target ≤ 5 %, **measured 2.3 % — met**.
> - **M3** (median drift apparition→detection / 90d): target was ≤ 7 days (intuitive), measured 35.3 days — **target recalibrated to ≤ 30 days in v0.4.1** to match the monthly light audit cadence.
> - **M4** (1st DB probe position in session): target ≤ 90 min, **measured ~41 min — met**.
> - **M5** (pure-command ratio / 7d): threshold 80 % is *provisional* — current instrumentation classifies 90 % of briefs as `unknown`. The sclerosis-alarm rule applies qualitatively; the instrument died of source drift (0 briefs extracted 17/07) — repair-or-retire owed next cycle.

### R14 — Spike escape hatch

Code tagged `[spike]` in the commit message and deleted within 7 days is **exempt from R6, R7, R8**. Concretely: a spike commit can introduce a derivable stored column without a Live/Snapshot/Cache category (R6), skip the `source` provenance discipline (R7), and bypass the ADR-before-code requirement on a module > 2 files (R8).

Conditions:

- The `[spike]` tag is in the commit message subject line.
- The branch or scope is deleted (revert, branch drop, file removal) within 7 calendar days from the spike commit date.
- If the code is not deleted at day 7, an ADR is owed retroactively and the spike must be converted to permanent — at which point R6/R7/R8 apply normally.

Why this rule exists: without an escape hatch, the toolkit appeared to apply always, which is false empirically (POC, prototype, exploration before architecture decision) and discouraged adoption. R14 makes the exception official, time-bounded, and falsifiable — `git log --grep '\[spike\]' --since='7 days ago'` lists current spikes; anything beyond 7 days is a violation to fix or document.

---

## R15 — *Intermediate checkpoint commits in autonomous agent sessions* (added v0.6, 2026-05-18)

In a long autonomous agent session, commit immediately after each materially validated artifact. No batch at session end — if the agent stalls, work up to the last commit is saved.

Concretely: granularity of commit = granularity of the last material oracle crossed (1 canon file validated schema = 1 commit; 1 awnshegh completed = 1 commit; 1 sub-chantier livré = 1 commit). Push after each commit (or batched ≤ 3 commits) if the session exceeds 30 minutes — protects against machine kill, not only agent stall.

The brief must explicitly say: *"Commit each [artifact] as soon as it crosses its material oracle, do not batch."* Implicit instructions do not work — agents default to batched commits without explicit phrasing.

Empirical foundation (Gorgon multi-substrate 2026-05-17/18): 25+ autonomous agent invocations, comparison of negative case (`ac0ba26` Vosgaard bloc 1 stalled without checkpoint commits — saved in extremis by defensive observation) vs positive cases (`19eef04→57b7108` Vosgaard awnsheghs commit-per-artifact, `dc33402→d2654a4` Zone A canon completion commit-per-realm — zero loss despite stall at 600s).

**R15 enforces commit cadence within an autonomous session. It does not detect when the human has effectively left the loop. Complement: a meta-hook (PostToolUse on agent invocation tools) counts consecutive autonomous `/goal` or sub-agent invocations without human intervention and triggers a self-critique skill (`falsify-before-fix` or equivalent) after N=5. The session log produced by the self-critique is gating — no further autonomous commits until logged. The meta-hook addresses the asymmetry validated empirically: doctrine discipline holds when the human invokes triggers, falls when autonomy takes over.** *(amended v0.7 from gorgon overnight session 2026-05-18 — 9 autonomous commits without session log because `close-session` trigger never fired. **Two-stage enforcement deployed**: v0.7.1 (2026-05-21) ships `.claude/hooks/r15-autonomous-counter.sh` (PostToolUse matcher `Agent` increments, UserPromptSubmit resets, stderr warning at N≥5). v0.7.2 (2026-05-22) ships `.claude/hooks/r15-commit-gate.sh` — PreToolUse Bash gate that BLOCKS `git commit` at count≥threshold with `exit 2`, bypass via `[autonomy-ack]` in the command (trailing comment canonical) or `R15_THRESHOLD=N` env override for planned-long sessions. The gate makes the rule materially enforceable, not just declaratively flagged. Empirical baseline that justified deployment: M7 measured 4 chains > 5 commits without session log on 30-day window, longest = 92 — see `rembrandt-samples/falsifiable-metrics/m7-autonomous-checkpoint.ts`)*

*(v0.10 empirical validation: M7 re-measured 17/07/2026 — longest uncheckpointed run 92 → 1, zero chains > 5 across 220 commits/30 d, 100 session-log creations. The hook-enforced rule holds where the declarative rule failed — the first red-to-green metric reversal of the series.)*

---

## R16 — *Empirical parallel-agent limit with structural safeguards* (added v0.6, 2026-05-18)

To orchestrate N parallel autonomous agents with 0 complete stall, three structural mechanisms are required and sufficient:

1. **Strictly non-overlapping material scope** — each agent can modify only files/directories explicitly listed in its prompt.
2. **Proactive `.gitignore` on raw outputs BEFORE launch** — otherwise `git add .` agent absorbs untracked legitimate files outside scope. Three observed violations on N=40 session without proactive gitignore. Zero violations with it.
3. **Explicit R1 marker in prompt + temporal tolerance on "completed" report** — a premature "completed" report ≠ stall. Allow ~5 min before human intervention; the agent often continues correctly and re-reports cleanly.

Empirical limit observed: **N ≤ 6 parallel agents simultaneously without degradation**. N > 6 untested empirically.

Empirical foundation (Gorgon Phase H + I + J + K + L 2026-05-18): **40 agents launched, 40 finished = 100% completion** versus night 2026-05-17 with 22 agents / 4 stalls = 18% failure rate without systematic mechanisms 1-3. Sample N=40 in single session, single substrate (Godot/GDScript game dev). Multi-substrate validation pending (TypeScript/Next.js rembrandt queue ; doctrine-counterpart toolkit dogfooding).

Distinct from R15 (which addresses *one* long autonomous agent session — commit cadence). R16 addresses *multiple parallel* agents — scope isolation + git staging area collisions + report synchronization.

Tension with R9 (*Three projects FIFO*): R16 applies *within* a single project; R9 applies *across* projects. No conflict — R16 is a sub-rule of efficient single-project autonomy.

---

## R17 — *Assertional coverage* (added v0.10, 2026-07-17)

A green test attests only what it asserts. Three clauses:

1. **Every column the SUT writes is asserted.** A production dry-run asserting mode/amount but not `source` masked an inherited wrong value that put rows outside a partial unique index and made them invisible to the collection cron — "green" while shipping the defect.
2. **The fixture covers every dimension of the model the code traverses.** A single-place fixture was structurally blind to the 1 pre-inscription → N places dimension; the convert-all bug it hid was real and reachable in production data.
3. **The path is traversed to its terminal business state.** "The object is created" does not cover "the object can be settled": 69 green tests + green `tsc` shipped a feature whose received money could never be recorded — the gravest bite of the series, rooted in an unprobed architecture assertion in the author's own ADR.

Corollary: a safety net must prove it BITES — temporarily mutate the SUT and observe exactly one targeted red before trusting a characterization suite.

Distinct from R3 (success criterion before code — R17 governs the assertion *surface* once the criterion exists) and from R7's negative-case rule (contract tautology — R17 generalizes to any test: written columns, model dimensions, terminal states). Empirical foundation: N=4 incidents in a single cycle (05→13/07/2026), all on payment surface, all caught by R19 review AFTER the author's own tests were green — which is precisely why the rule exists: the review is the net's net, R17 aims at making the first net catch.

---

## R18 — *The doctrine is a data table subject to R6 and R13* (added v0.8, 2026-06-15)

The doctrine corpus (rules, feedbacks, skills, hooks) is itself a data table and obeys the rules it states. Material finding (verified 2026-06-15 against the memory filesystem, outside git): the doctrine **does** retire its memory — `archive/` holds 163 files (49 feedbacks, 111 projects) — but only by **HYGIENE** (orphan / closed-project archiving), **never by FALSIFICATION** (zero feedback has ever been retired for being contradicted by a later incident) and **never AUTOMATICALLY** (the ghost-probes "retire if empty after 30d" carried by `ancien_avec_inscription_active_anomaly` and `memoire_verification_canonique` are declared but unexecuted; no death metric; no `[provisional]` demotion).

A corpus where, after 80 days, nothing has ever been contradicted is statistically a tautology farm — the exact drift the doctrine teaches itself to hunt in `filtre_whitelist_source_fragile`, `semantic_layer_drift_db_silent`, `index_partiel_predicat_statut`. Apply R6 (Live/Snapshot/Cache) and R13 (audit) to the doctrine itself:

- **(a) Ghost-probes are Snapshots with a hard expiry**, executed by a doctrine cron, not a manual cleanup. A feedback carrying "retire if empty after 30d" that is never re-run is a Cache without a refresher — an R6 violation one layer up.
- **(b) Any rule or feedback grounded in N<3 incidents is tagged `[provisional]`** — like an R14 spike — and is either confirmed by a 3rd material case within its window or demoted. No silent promotion to universal truth at N=1.
- **(c) A falsification audit runs quarterly**: re-test each feedback's probe against current state — not only R13's accuracy question ("is this still true?") but "has any incident contradicted this?". A feedback-DEATH metric (retired / month) must exist alongside the feedback-BIRTH metric — a corpus that only grows is a whitelist that lengthens per incident until it lies.

Distinct from R13: R13 audits *accuracy* (re-reading, "is this still true?"); R18 imposes a *mortality mechanism* (hard expiry + death metric + auto-demoting `[provisional]` tag). R13 = review; R18 = cron + metric + forced falsification.

Meta-lesson recorded in this rule's own genesis: the insights-agent claim *"zero retraction in 80 days"* would have entered the doctrine FALSE without the material probe — `archive/` = 163 files refuted the strong form. A live demonstration of Am.R1 (existence ≠ verified state) and Am.R12 (external-AI claim tested before architectural decision). R18 was produced by the discipline it prescribes.

**Exceptions tolerated.** A reference memory pointing to a durable external resource (`reference_*`, infra, canonical vision) carries no expiry — it is a Snapshot frozen at a stable fact, not a falsifiable claim. The `[provisional]` tag and the quarterly falsification audit apply to feedback/project rules, not to reference pointers.

**Mechanism status (R1 self-applied — do not read as live).** Of R18's three executive mechanisms, only the *write-time format guard* ships in v0.8: the `memory-write-guard.sh` hook (Artefact B) enforces the MEMORY.md hygiene policy at write-time instead of by a posteriori audit, and the `close-session` `[unverified]`-tagging step (Artefact A) catches weak prospective claims at session close. The other three — **(a) the ghost-probe expiry cron, (b) `[provisional]` auto-demotion, (c) the quarterly falsification audit — are PRESCRIBED, NOT YET WIRED** (backlog, parallel to the R15 autonomy meta-hook which v0.7 documented as intent while the hook stayed absent). Until built, R18(a–b) are doctrine, not a running safety net; invoking them as coverage would itself violate Am.R1. **v0.10 status: R18(c) EXECUTED for the first time** (17/07/2026 cycle audit — 26 session logs + 28 journal entries harvested, 3 hard contradictions found and acted on: R19 trigger, R19 privilege coverage, Artefact A target-class failure). First mortality measurement: ~80 births vs 28 archivals / 32 d (archive 163 → 191, ratio 2.9:1); falsification-driven retirement is now real at PROJECT level (a debt ticket refuted before repayment, a "confirmed LIVE bug" refuted by 4 probes, a tooling recommendation refuted by an environment probe) but still uninstrumented at DOCTRINE level. Instrument mortality now applies to the metrics themselves: M5 measures nothing (its source format drifted from bullets to prose — a Cache without a refresher one layer up), M1 invalid by construction for two consecutive cycles; repair-or-retire owed next cycle. Both shipped artefacts keep the v0.7 architecture lesson — N small single-responsibility hooks > 1 monolithic argv-branching hook — do not fuse them into a `doctrine-mega-hook.sh`.

---

## R19 — *Review-gate risk-surface merges* (added v0.9, 2026-07-05; promoted + trigger rewritten v0.10)

Before merging (`git merge`, `gh pr merge`) a diff whose content is **business-HOT** — payment/Stripe, encaissement, TVA/fiscal, mutating cron, Supabase migrations / `.sql`, RLS/policies, auth — run `/code-review` on the diff first, **whatever the file name**. Temperature is a property of the diff's business content, not of its path: cold `actions.ts` extractions (cohort selection, byte-identical moves) and a read-only "cron" observability wrap went 0/3 findings, while hot `actions.ts`/RPC diffs bit 7 times out of 10 — the v0.9 filename clause was a whitelist starting to lie (the exact drift R18 hunts). `[review-ok]` is legitimate only after READING the diff, never blind. A non-risk diff (doc, copy, trivial fix, `[spike]` R14) merges directly: the expensive review fires only where the downside is expensive. This is R4 (challenger on proposals) narrowed to a merge gate, kept **triggered, not blanket**, precisely to satisfy R11 (parsimony) — a review on *every* merge raises cost-per-accepted-change without proportional catch on trivial diffs, the exact ceremony R18 and `jauge_maturite_ceremonie_vs_efficacite` hunt.

**A hook cannot run the review — only remind.** Material finding (challenger 04–05/07/2026): a Claude Code hook reads `.tool_input.command` and can only block/warn in shell; it cannot invoke a slash-command. Review-gating is therefore a *rule* (a human or agent runs `/code-review`) coupled to a cheap *reminder* artefact — `pre-merge-review-reminder.sh` (user-scope PreToolUse Bash): on a merge command whose branch diff (`git diff <base>...HEAD --name-only`) hits the risk regex, it soft-blocks (`exit 2`) listing the matched files, bypass `[review-ok]`; **fail-OPEN** when the repo/diff is indeterminable — a quality reminder, never a security gate (contrast the fail-closed `deploy-safeguard.sh`). The genuine blanket-review option exists only server-side (a CI GitHub Action reviewing every PR) and is **deliberately NOT wired** — that is where ceremony/parsimony bites for a solo.

Calibration metric: *findings-that-changed-the-merge / reviews-run*; if a diff class never bites, drop it from the trigger regex. Cousin to R16's `pre-push-inventory` — that is the *push-side* scope inventory (*"what am I about to send"*, catching an unintended commit); R19 is the *merge-side* quality gate (*"was the risk content reviewed"*). Distinct concerns, same *look-before-you-ship* family.

**Exceptions tolerated.** `[spike]` (R14) merges; a branch whose diff touches no risk surface; an explicit `[review-ok]` after a conscious decision not to review a given diff.

**Promoted out of `[provisional]` in v0.10 per R18(b)** — the v0.9 confirmation condition ("a 3rd material case where skipping review would have shipped a real defect") is exceeded ×5: a multi-place cron re-debit; an inherited wrong `source` making rebuilt transfer instalments invisible to the collection cron; an end-to-end fatal (money received never recordable — created objects with no settling surface); a cross-dossier promotion contamination; a bulk client mail with no dedup. Calibration 05→13/07/2026: 12 reviews run — 10 hot (7 bites + 3 confirmations), 2 cold (0 findings); a third cold data point (a filename trigger-match read and rightly bypassed without running a review) completes the 0/3 against the filename clause. A 0-finding review on a hot surface is itself a deliverable (proof of non-regression before merge), not a wasted run.

**`[provisional]` privileges clause (v0.10, N=2).** A review reads code — default GRANTs are not in the diff. Any deployed `SECURITY DEFINER` function carries a `has_function_privilege('anon', …)` / `('authenticated', …)` probe **in the same message as the deploy**: EXECUTE defaults to PUBLIC, and a live payment RPC callable by `anon` shipped through two full multi-finder reviews before an improvised post-deploy privilege audit caught it; DROP+CREATE re-grants via default privileges even after a prior REVOKE. Cheap artefact: `SECURITY DEFINER` added to the reminder-hook's diff scan. Confirm with a 3rd material case or demote.

---

## Anti-patterns to flag immediately

If the conversation drifts into one of these, flag it explicitly:

- Anthropomorphising the agent (*"it thinks," "it prefers," "it wants to"*)
- Validating a build on declaration without raw output (R1)
- Reading a summary file before checking `git log` / filesystem (R2)
- Accepting a fix without input → output pipeline (R4)
- Creating a derived column without L/S/C category (R6)
- Starting a project > 2 files without ADR (R8)
- More than 3 projects open in parallel (R9)
- *"You need"* + norm without citation of exact text (R12)
- Pushback *"are you sure?"* producing revision without new fact (R5)
- Silent error swallowing (`catch {}`, `2>/dev/null`, `await` without `{ error }`, silent strip) (R10)
- Untagged workaround (R10)
- Platform-side mutation without prior GET + diff (R12)
- Citing a memory or rule without re-reading it against the current code (R5)
- Question whose form contains the answer (R13)
- Pure-command framing on a topic where the outcome is actually unknown (R13)
- Speculative abstraction not required by the success criterion (R11)
- New stored column duplicating an existing source without explicit refresher (R6)
- Spike commit older than 7 days without conversion to permanent + ADR (R14)
- Asserting system state from a stored proxy (`used_at`, external ID, `max(created_at)`) or invoking a safety-net (CI, cron, backup) without verifying it runs NOW (R1 — existence ≠ verified state)
- Growing the doctrine monotonically — capture without retraction, N=1 rules promoted as universal truths, ghost-probes declared but never executed (R18)
- Merging a business-HOT diff (payment/Stripe/TVA/mutating-cron/migration/RLS/auth) without running `/code-review` first — or gating on the file NAME instead of the diff's business temperature; blind `[review-ok]` without reading the diff (R19)
- Deploying a `SECURITY DEFINER` function without a `has_function_privilege` probe in the same message (R19 privileges clause)
- Trusting a green suite on a surface it never asserts — unasserted written columns, missing fixture dimensions, a path not traversed to its terminal business state (R17)
- Mirroring a pattern that has never executed in production as if it were a validated reference (R1 facet C)
- Voicing a causal attribution ("X deleted Y", "it's the card", "it's SEPA") to a human without probing the actual mutation first (R4)
- Diagnosing a shared surface without the in-flight-work scan — open PRs, remote branches, worktrees (R2)

---

*Counterpart Toolkit v0.10 — released 17 July 2026, J+12 after v0.9.*
*Nineteen rules (R17 filled). v0.10 promotes R19 out of `[provisional]` with a business-temperature trigger rewrite + a `[provisional]` privileges clause (N=2 — a live `anon`-callable payment RPC through two multi-finder reviews; a default-privileges re-grant after DROP+CREATE), fills R17 (*Assertional coverage*, N=4 single-cycle, all payment surface), and ships 4 amendments: Am.R1 facet C (never-executed reference, N=4), Am.R2 (in-flight-work scan on shared surfaces, N=3 — hoists user-scope feedback), Am.R4 (causal attribution voiced to a human, N=3), Am.R9/R16 (a worktree protects the agent's work, not the shared tree, N=3). Produced by the first REAL execution of the R18(c) falsification audit — two dedicated harvest/measure agents over 26 session logs + 28 journal entries + M1-M7 re-run + first mortality measurement (~80 births vs 28 archivals/32 d) — which found 3 hard contradictions (R19 trigger whitelist lying 0/3 cold vs 7/10 hot; R19 privilege-coverage hole; v0.8 Artefact A failing on its target class: an unprobed "confirmed LIVE bug" graved at close, refuted by 4 probes next morning) and one metric reversal (M7: longest autonomous chain 92 → 1 — the R15 hook holds where the declarative rule failed). Retractions carried: the "fix-of-finding" amendment rejected as textually redundant with Am.R4 v0.8 ("any code PROPOSAL" already covers it — a skill trigger, not a rule); R14 kept under R18 death-watch after 60 days of zero `[spike]` use. Artefact hardened: `close-session` extends `[unverified]`-tagging to diagnostics, debt tickets and self-contained prompts, plus a symmetric session-OPEN probe of the reprise note's load-bearing claims (N=5 class "references written at close that lie"). Instruments: M1 invalid two cycles running and M5 dead (prose drift) — repair-or-retire owed v0.11; M3 re-baseline with manual annotation owed. Backlog unchanged: R18(a)(b) cron + auto-demotion still prescribed, not wired. Doc lag closed same-day: `manifesto.md` resynced to v0.10 (17/07, after the lag was first flagged rather than hidden).*

*Counterpart Toolkit v0.9 — released 05 July 2026, J+20 after v0.8.*
*Eighteen rules (R17 unassigned). v0.9 adds R19 (review-gate risk-surface merges, `[provisional]`) + 1 user-scope artefact (`pre-merge-review-reminder.sh`), after `/challenger` self-falsification of the recommendation: two supporting claims refuted — (1) a Claude Code hook cannot invoke a slash-command, so the gate is a rule + cheap reminder-hook, not an auto-review hook; (2) the v0.7 `pre-push-inventory` "PROMOTED + installed" status corrected to doctrine-repo-source-only, never installed to user-scope (absent from the live available-skills list) — an Am.R1 instance (source existence ≠ live mechanism). Retraction carried: R16 mechanism 1's push-side tooling has never been live in a working session. Doc lag flagged, not fixed: `manifesto.md` still headers v0.7 (two versions behind).*
*Counterpart Toolkit v0.8 — released 15 June 2026, J+26 after v0.7.*
*Seventeen rules. v0.8 turns the doctrine on itself through 3 amendments + 1 meta-rule + 2 artefacts: R1 (existence ≠ verified state — stored proxy + safety-net liveness, N≥5 + N≥2), R4 (challenger applies to audits & proposals, not only fixes, N≥3), R9/R16 (sub-agent worktree isolation does not survive a compaction, N≥2 structural), R18 (the doctrine is a data table subject to R6/R13 — premise verified against the memory filesystem 15/06). Two coupling artefacts: a `close-session` step tagging prospective claims `[unverified]`, and a user-scope `memory-write-guard.sh` hook enforcing the MEMORY.md format at write-time rather than by a posteriori audit.*
*Post-`/challenger` reductions (15/06): candidates 1 + 6 collapsed into one Am.R1 (same logical form: existence ≠ current verified state); candidate 8 (probe-ordering) demoted to a dormant note (2nd occurrence was a lexical false positive, N=1 mono-substrate); candidate 3 (DB-constraint phase-0) reclassified rule projet rembrandt (100 % mono-substrate Postgres/Supabase). R18's strong form ("zero retraction") refuted by material probe and reformulated to "retraction by hygiene only, never by falsification".*
*Backlog carried: the R15 autonomy meta-hook (`autonomy-detection.sh`) remains a gorgon prototype, never wired (v0.7.1 counter + v0.7.2 commit-gate shipped, the N=5 self-critique trigger pending); R18's executive mechanisms (a) ghost-probe expiry cron, (b) `[provisional]` auto-demotion, (c) quarterly falsification audit are prescribed but not yet wired — only the write-time `memory-write-guard.sh` format guard ships; H7 (LLM time-estimates) still awaits N≥10 pilot measurements before promotion.*
*Counterpart Toolkit v0.7 — released 20 May 2026, two days after v0.6.*
*Sixteen rules in ~220 lines. v0.7 consolidates multi-substrate practice (Next.js/Supabase ERP + Godot/GDScript game dev) through 4 amendments: R7 (bulk re-count before mutation, N=2), R9 (sub-agent brief inlines load-bearing feedbacks, N=1 structural), R12 (external AI claims require material test, N=3 multi-substrate), R15 (long autonomous session human checkpoint meta-hook, N=1+1).*
*Three initial proposals retracted after `/challenger` self-falsification: Am.R1 redundant with existing R1 *"count = N / drift detected"* text + skill `material-verification` ; Am.R4 marginal vs R4 step 5 + skill `root-cause` ; skill `parsimony-1day-check` duplicates existing skill `parsimony`.*
*Two patterns added after gorgon multi-substrate exploration: H6 (external AI claims testing, became Am.R12) + H7 (LLM time-estimate biased without pilot benchmark, deferred as v0.7-candidate pending 5-10 additional measurements).*
*Tested on 70+ days of solo ERP coding with Claude Code (~118 k lines, 74 ADRs measured 22 May 2026, M1–M7 baseline in [`rembrandt-samples/falsifiable-metrics/`](https://github.com/michelfaure/rembrandt-samples/tree/main/falsifiable-metrics)) + 5 days of game dev dogfooding (Godot/GDScript, 24 ADRs, 676 tests).*

---

## Journal — post-v0.10 evidence entries

*Append dated entries here: incident, probe, raw output, which rule it feeds, N update. This is where amendment evidence accumulates between versions; the terse rule in `CLAUDE.md` is edited in the same commit.*

- **2026-07-19 — v0.11 cycle opening: the terse split.** External triangulation review (fresh session, hostile read over five turns, reviewer blind to the repo's authorship) returned zero material findings on content and one structural critique: **accumulation bias** — the corpus answers problems with more structure ("a cathedral where a room sufficed"). Measured the same day: `CLAUDE.md` at 47,224 chars ≈ 11.8k always-loaded tokens; a single rule (R19) living in 7 repo files + 1 user-scope copy; 10 files carrying the version string. The reviewer's claim "retraction never demonstrated" was refuted at the literal level (manifesto Retractions 1–8, a section the reviewer had not read) but holds in its strong form: no full rule R1–R19 has ever been killed by falsification. v0.11 responds by subtraction: this ledger + the terse Live norm replace the 8-copy structure; standing discipline adopted — **net structural delta ≤ 0 per cycle** unless a new incident forces growth.

- **2026-07-19 — v0.11 cycle decisions (arbitrated MF).** (1) **Instruments M1 and M5 RETIRED** — the doctrine's first falsification-driven retirement of its own structures. M1 measured 12.33 → 14.63 → 15.0 across three runs but counted feedback *mentions* in the journal (top hit: 377 for a single feedback), not anti-pattern recurrences — invalid by construction from its first baseline; M5 classified 90–94 % of briefs `unknown` at baseline and extracted **0 briefs** on 17/07 after its source drifted from bullets to prose. Neither ever produced one valid measurement; their real service was meta ("the auditor's instruments falsify like everything else", v0.10 lesson). Scripts remain in `rembrandt-samples/falsifiable-metrics/` as dated archive; the R13 sclerosis alarm stays qualitative. (2) **`pre-push-inventory` CLOSED, not installed** — the three-cycle Am.R1 gap ("promoted" v0.7, never live) settled by decision: its bite surface is covered by the identity-guard hook (public pushes) and the Am.R2 in-flight scan; enforcement beat the declarative skill, the M7 lesson applied. (3) **`public-repo-identity-guard` PROMOTED as the 10th published hook** — publication gate, born N=3 (three identity-leak incidents on 17/07), tested + one real blocked push; published in generic opt-in form (private remote-pattern + blocklist files, fail-closed once configured). (4) **Semantic-equivalence audit of the terse rewrite**: a dedicated agent compared old vs terse rule by rule and found 4 findings / 6 lost normative clauses (R1 trigger commands, R12 corroboration criterion, R18 exception scope + provisional window + mega-hook prohibition, R19 blanket-CI deliberately-not-wired) — all six reinstated before merge; no threshold, tag, or enforcement mechanism lost. Cycle structural accounting: −2 instruments, −1 standing owed item, +1 hook, +1 file (this ledger) against −8 sync copies — net < 0.

- **2026-07-19 late — second external review (skills), claims tested per Am.R12: 2 confirmed, 1 partially refuted.** A fresh-session review of the 12 published skills claimed: (a) skills carry stale version strings — **confirmed**: `v0.4.1` in 3 files (`parsimony`, `success-criteria-first` ×2) plus a phantom v0.1/v0.2 changelog template in `long-term-auditability` prescribing a mechanism (changelog in manifesto) superseded by this ledger — the skill layer was the one surface the v0.11 copy-sweep missed; all fixed, version strings dropped (axis/rule anchors kept), template rewritten to point at the single version trail. (b) `pre-push-inventory` still shipped by `install.sh` while the same cycle closed it as superseded — **confirmed**, decision and artefact contradicted each other in the same commit; fixed: status header in the skill + install skip with explanation. (c) "skills still speak of axis 1 / axis 5" as staleness — **refuted**: the eight axes are stable since v0.3 (no axis ever retired); the drift was the version qualifier attached to the anchors, not the anchors. Same sweep applied to the living tier: `challenger` and `close-session` user-scope skills carried the same `v0.4.1` qualifiers (historical mentions "extracted in v0.4.1" kept — dated facts don't drift). Praise noted for calibration: `falsify-before-fix`'s "when NOT to invoke" section with costed threshold called the best-of-lot feature — a pattern to replicate in future skills.

- **2026-07-19 late — identity-guard: first live bite AND its own blind spot, same evening.** While pushing the review fixes, the guard **blocked a real leak**: the close-docs commit carried the author's real initials (×2) and the real project name in the public session log — pseudonym discipline broken by the close writer itself. Root cause of the scarier part: that commit had already reached origin on the PREVIOUS push, unscanned — because the push was **chained after the commit in a single command**, and a PreToolUse hook runs BEFORE the command executes: it scanned the pre-commit HEAD, clean at that instant. Remediation: text scrubbed (initials → pseudonym, project → `rembrandt`), the offending commit rewritten out of origin history (force-with-lease; the old SHA stays fetchable on the forge for a while — exposure window minutes-to-hours, initials + project name only), and the blind spot **patched in both tiers**: when the command also creates a commit, the guard now scans the working tree as well (synthetic chained-command test: blocked, exit 2). Standing lesson, now enforced: toward a public remote, *commit and push are two commands* — a gate that runs on the push can only see what exists when it runs.

- **2026-07-20 — third external review (hooks layer), with executed tests: two security findings confirmed on the PUBLISHED tier, triaged against the living tier, fixed and re-tested.** The reviewer ran the published hooks and found: (a) `secret-scanner` and `check-workaround-assumed` gated on an ANCHORED `^git commit` — inert on the agent's dominant chained form (`git add -A && git commit …`), while the younger hooks (deploy-safeguard, r15-commit-gate, identity-guard) already used the unanchored idiom — an inconsistency internal to the ten; (b) the scanner listed staged FILES then grepped the DISK — a secret staged then cleaned from the working tree passed while the commit carried the staged blob anyway. Triage the reviewer could not see: the author's LIVING secret gate is wired on `Write|Edit|MultiEdit` and scans content at write time — structurally unaffected by both defects; the living `check-workaround` WAS anchored (confirmed inert on every chained commit of the weekend). Fixes shipped: unanchored trigger + repo-dir resolution (a chained `cd X && git commit` is scanned in X) + index-content scan (`git show ":$FILE"`) in the published scanner; unanchor in both tiers' check-workaround; `memory-write-guard` case extended to a root-level `MEMORY.md` (the adopter default per the README); adapt-this note on the stack-named path in deploy-safeguard. Test matrix re-run: `-C` form, chained form, and staged-then-cleaned all block (exit 2); clean index passes (0) — the negative case re-armed after a harness error, not assumed. The reviewer's closing irony is recorded as the finding's true class: the hooks' "material tests" had asserted only the canonical command form — **R17, the corpus' youngest rule, biting its oldest hooks**.

- **2026-07-20 — fourth review round: the fix introduced its own bypass, and the structural answer ships.** Two findings, both reproduced before acting: (a) **the previous fix opened a new hole** — the directory-resolution regex `cd[[:space:]]+(…)` was unanchored and scanned the whole command line *including the commit message*, so `git commit -m "fix: cd in build.sh"` captured `DIR="in"`, the repo lookup failed, and `|| exit 0` disarmed the scanner (reproduced: exit 0 with a live secret staged); (b) **the PEM private-key pattern had never matched anything** — `grep -qE "$P"` reads a leading `-----` as options; it needed `--`. Same flaw class as the round it was fixing: an over-broad regex and a fail-open. Fixed: `cd` matched only at a command boundary (`^`, `&&`, `;`, `|`), unresolvable paths now **fall back to `$PWD` instead of exiting** (a security gate must not disarm on an unparseable path), `grep -qE --` everywhere; the same unanchored `cd` block had been propagated into `public-repo-identity-guard` — patched in both tiers.
  **The structural answer, which is the actual deliverable of this round: `tests/hooks/run.sh`, versioned, 25 assertions** — one per command form (canonical, `add &&`, `cd &&`, `;`, `-C`, `cd`-in-message), one per secret pattern (the PEM case is exactly what four cycles of manual probing never asserted), staged-vs-disk, plus a negative case per hook. **Mutation-tested**: removing `--` reddens exactly the PEM assertion; restoring last night's exact state reddens exactly the two `cd`-in-message assertions — the net proves it bites. Note worth keeping: neither of the two fixes is individually necessary (each closes the hole alone — the bypass needs *both* defects), which is why only a suite mutated back to the real historical state can attest coverage.
  Also closed the same day, open since the first full read four cycles earlier: **`install.sh` shipped neither `ADR-template.md` (mandated by R8) nor `anti-patterns-checklist.md`** (called the densest page of the repo by its own README) — both now installed, verified by a dry-run into a temp target. Standing lesson: *a finding that survives three review rounds is not low-priority, it is unowned* — the review layer surfaced it every time and nothing consumed it.
