# counterpart-doctrine/

Sixteen operational rules for working with Claude Code on a long-running solo project, plus the long-form theory that produced them. The rules emerged after 70+ effective days of solo coding with Claude Code on a production ERP + 5 days of game dev dogfooding (Godot/GDScript multi-substrate test). Each rule was born from a recurring failure mode, not from upfront design. Versioned, dated, falsifiable — including the doctrine itself. **Current release: v0.7** (R7/R9/R12/R15 amendments + 2 new skills `ask-3-options-before-code` + `pre-push-inventory` + 1 user-scope hook `pre-bulk-mutation-count-staleness` — multi-substrate consolidation after `/challenger` self-falsification and gorgon exploration ; see [`v0.7-candidates.md`](./v0.7-candidates.md) for the full audit).

## Quick install (one command)

```bash
git clone https://github.com/michelfaure/doctrine-counterpart.git && \
  cd doctrine-counterpart && \
  ./install.sh --yes /path/to/your/project
```

This installs the **toolkit** (`CLAUDE.md`, 16 rules, ~220 lines), the **12 skills**, the **agent-challenger**, the **5 hooks** (`deploy-safeguard`, `secret-scanner`, `audit-memory-reminder`, `check-workaround-assumed`, `r15-autonomous-counter`), and the optional `manifesto.md` (in `docs/`) — without asking. Defaults `Y` on every prompt; an existing `CLAUDE.md` is placed alongside as `CLAUDE.md.doctrine-counterpart` for safe manual merge.

**Interactive install** (control each step) : `./install.sh /path/to/your/project` — same components, prompts on each one.

After install : open Claude Code in your project. The toolkit is loaded automatically; skills auto-invoke on triggers; hooks block dangerous commands unless bypassed with `[deploy-ok]` / `[workaround-assumed]`. **You do not need to read `manifesto.md` for the doctrine to operate** — it is optional long-form theory for humans who want to understand the *why*.

**Source article series**: *Building the Counterpart Doctrine in public* — 31 satellite articles + pillar (May–July 2026) on [DEV.to](https://dev.to/michelfaure). The v0.2 closing pillar is [*The Counterpart Doctrine: a seven-axis spec for working with an AI coding agent*](https://dev.to/michelfaure) (May 18, 2026). v0.6 added R15+R16 post-Gorgon empirical session (May 18). v0.7 ships May 20, 2026 — multi-substrate consolidation after `/challenger` self-falsification.

## Why this matters

Coding alone with an AI agent collapses two roles into one — you are both the producer and the only reviewer. The agent fills the role of pair without filling the role of adversary. Sycophancy compounds with speed: the longer the session, the harder it is to detect the moment the work started drifting. Short-term productivity is up. Long-term coherence is fragile, and the failure modes are silent.

The doctrine trades a small amount of upfront friction (ADRs, success criteria, raw-output proofs, brief-form discipline, refreshing summaries against the filesystem) against a much larger amount of downstream drift. It does not assume the agent is hostile. It assumes the attelage will sclerose if its form is left to inertia, and that the only sustainable counterweight is a versioned, dated, falsifiable discipline that applies to both the agent's outputs and the solo's own habits.

## What this doctrine measures and what it doesn't

Seven metrics (M1–M7) instrument the doctrine's own self-application, and a single-script orchestrator (`doctrine-metrics.ts`) runs all of them at once. Scripts and measured values live in [`rembrandt-samples/falsifiable-metrics/`](https://github.com/michelfaure/rembrandt-samples/tree/main/falsifiable-metrics) — the empirical half of the doctrine.

| Metric | Rule | Target | Measured (21 May 2026) | Verdict |
|---|---|---|---|---|
| **M1** anti-pattern recurrence / 7-day session | R13 | ≤ 1 | 14.63 | Overshoot — heuristic over-sensitive, recalibration v0.5 |
| **M2** multi-file commits without ADR / 28d | R8 | ≤ 5 % | 0.8 % | **Met** |
| **M3** median drift apparition → detection / 90d | R13 | ≤ 30 days *(recalibrated v0.4.1)* | 35.7 days | Within 6 days of target |
| **M4** position of 1st DB probe in session | R13 | ≤ 90 min | ~58 min | **Met** |
| **M5** pure-command ratio / 7d (sclerosis alarm > 80 %) | R13 | threshold provisional | 94 % `unknown` | Instrumentation insufficient — v0.5 |
| **M6** spike orphans > 7 days *(new v0.7)* | R14 | 0 | 0 (1 spike valid < 7d) | **Met** |
| **M7** runs > 5 uncheckpointed commits *(new v0.7)* | R15 | 0 | 4 runs (longest = 92) | Miss — R15 meta-hook not yet active |

**4/7 targets met empirically** (M2, M4, M5 alarm-side, M6). M1 awaits heuristic refinement, M3 is within 6 days of the recalibrated target. M5 awaits instrumentation (currently 94 % unclassified). **M7 confirms matériellement that R15's autonomous-session meta-hook is not yet operational** — the metric exposed 4 commit chains > 5 in the last 30 days, the longest being 92 commits without a session log. The amendment that R15 v0.7 prescribes is empirically necessary, not yet enforced.

The doctrine **does not retro-fit cibles to fit measurements** — it acknowledges the gap explicitly and recalibrates only when the gap reveals an intuition-set threshold (M3) rather than a doctrinal one. Of 16 toolkit rules, 7 are instrumented (R8, R13 partial, R14, R15) and 9 remain qualitative or candidate for future metrics (R6, R7, R10, R11 instrumentable in principle, see `doctrine-metrics.ts` for the full coverage map). See *How to adopt* in `manifesto.md` for the full reasoning.

## Invariant rule

Working with an AI coding agent on the long run produces drift — silently. Claims that the build is green while CI is red. Patches that look like fixes and reappear six days later under a different mask. Derived columns that diverge from their source without a probe to tell you. Summaries (`backlog.md`, `MEMORY.md`, session notes) that quietly diverge from `git log` and the filesystem because no one set them up to refresh. Pushbacks where the agent revises its recommendation without bringing a single new fact. No human PR reviewer catches it. No peer challenges. And paranoia on every line is not sustainable.

The doctrine *constrains the exchanges* of the attelage — the two-horse team where solo and agent pull the same load. The better-rodé the attelage, the more it traces the same rail (Bourdieu's *habitus*). The form of the brief is the lever that keeps the attelage exploratory rather than sclerotic. Sixteen rules materially enforced — not sixteen pieties to maintain mentally.

## The two artefacts — toolkit and manifesto

V0.4 shipped the doctrine as **two distinct artefacts**, each fit for one use. v0.4.1 refined the toolkit. v0.6 added R15 + R16 post-Gorgon empirical session. v0.7 ships multi-substrate consolidation (R7/R9/R12/R15 amendments) without changing the structural choice:

- **The toolkit** — [`CLAUDE.md`](./CLAUDE.md). Sixteen operational rules in ~220 lines, each falsifiable and anchored in at least one documented incident. This is what your Claude Code reads at session start. Loadable, dense, citable. **This is what you install.**
- **The manifesto** — [`manifesto.md`](./manifesto.md). The long-form theory: eight axes, the *attelage* metaphor, the construction method (phase A empirical extraction, phase B philosophical confrontation, phase B2 external audit, phase C falsifiability filter), the retractions, the critiques received and integrated. Read by humans who want to understand *why* the rules exist. ~55 k characters.
- **v0.7 candidates audit** — [`v0.7-candidates.md`](./v0.7-candidates.md). The full audit material that produced the v0.7 amendments: `/challenger` self-falsification (3 redundant proposals retracted), gorgon multi-substrate exploration (2 patterns added), final scope (4 amendments + 1 candidate + 5 artifacts).

## The sixteen toolkit rules

| # | Rule | Anchor axis (manifesto) | Status / change |
|---|---|---|---|
| R1 | **Raw output, not declaration** *(DB schema authority, UI rendering authority, human memory falsifiability, external sources, EXPLAIN ANALYZE)* | Axis 1 | stable since v0.4.1 |
| R2 | **Filesystem over summary** *(git log + filesystem before backlog/MEMORY/session notes)* | Axis 1 | extracted from R1 in v0.4.1 |
| R3 | **Success criteria before code** | Axis 1 | stable |
| R4 | **Falsify before fix** *(5-step protocol)* | Axis 2 | stable |
| R5 | **No revision without new fact** | Axis 2 | stable |
| R6 | **Live / Snapshot / Cache mandatory** | Axis 3 | stable |
| R7 | **Provenance + bulk re-count before mutation** | Axis 3 | **amended v0.7 — bulk re-count <30min** |
| R8 | **ADR before code, phase-0 grep** | Axis 4 | session structure (split in v0.4.1) |
| R9 | **Sub-agent briefing inlines load-bearing feedbacks, FIFO 3 projects max** | Axis 4 | **amended v0.7 — inline feedbacks** |
| R10 | **Silent failure forbidden, workaround tagged** | Axis 5 | stable |
| R11 | **Parsimony, no speculative abstraction** | Axis 5 | stable |
| R12 | **Cite the official text, materialise vendor defaults, test external AI claims** | Axis 6 | **amended v0.7 — external AI material test** |
| R13 | **Audit, archive, three brief modes** *(M1–M5 inline)* | Axes 7 & 8 | M1–M5 propagation in v0.4.1 |
| R14 | **Spike escape hatch** *(`[spike]` tag + 7-day deletion = R6/R7/R8 exempt)* | (cross-cutting) | new in v0.4.1 |
| R15 | **Long autonomous session checkpoint + meta-hook autonomy detection** | (autonomy) | **amended v0.7 — meta-hook complement to R15 commit cadence** ; new in v0.6 |
| R16 | **Empirical parallel-agent limit with structural safeguards** *(3 mechanisms)* | (autonomy) | new in v0.6 |

Each rule is fully formulated in [`CLAUDE.md`](./CLAUDE.md). Each rule's theoretical anchor is in [`manifesto.md`](./manifesto.md). The v0.7 amendment material is in [`v0.7-candidates.md`](./v0.7-candidates.md).

## Files

| File | Role |
|---|---|
| [`CLAUDE.md`](./CLAUDE.md) | **Toolkit v0.7** — sixteen operational rules, drop-in for project root. ~220 lines. |
| [`anti-patterns-checklist.md`](./anti-patterns-checklist.md) | **22 anti-patterns** — densest doctrine-payload-per-line. Paste into PR review. |
| [`manifesto.md`](./manifesto.md) | **Manifesto v0.7** — long-form theory: 8 axes, *attelage*, retractions, critiques. ~55 k characters. |
| [`v0.7-candidates.md`](./v0.7-candidates.md) | **v0.7 audit material** — `/challenger` self-falsification + gorgon multi-substrate exploration. Source for the 4 v0.7 amendments. |
| [`rembrandt-samples/falsifiable-metrics/`](https://github.com/michelfaure/rembrandt-samples/tree/main/falsifiable-metrics) | Five M1–M5 scripts + measured baseline + honest diagnosis of overshoots. The empirical half of the doctrine. |
| [`install.sh`](./install.sh) | Interactive installer. Default `[Y/n]` for hooks. |
| [`verify-install.sh`](./verify-install.sh) | Checks installation integrity, signals drift. |
| [`ADR-template.md`](./ADR-template.md) | One-page Architecture Decision Record template (R8). |
| [`.claude/skills/`](./.claude/skills/) | 12 universal skills. |
| [`.claude/agents/agent-challenger.md`](./.claude/agents/agent-challenger.md) | Adversarial sub-agent (R4, R5). |
| [`.claude/hooks/`](./.claude/hooks/) | 5 hooks: `deploy-safeguard`, `secret-scanner`, `audit-memory-reminder`, `check-workaround-assumed`, `r15-autonomous-counter` *(new v0.7.1 — meta-hook implementing R15 amendment)*. |

## Living vs Published — the two-tier doctrine

The toolkit/manifesto split (v0.4) is orthogonal to a second long-standing distinction: *Living* vs *Published*.

- **Published tier** (this repo) — generic, stack-agnostic, drop-in for any project using Claude Code. The hooks scan generic secret patterns (OpenAI, GitHub, AWS, GitLab). The skills target universal solo-coding failure modes. This is what you install.
- **Living tier** (the author's personal Claude Code config) — richer, specialised for the author's actual stack: Rembrandt ERP on Supabase, Vercel, Stripe, Brevo, Airtable, PennyLane. Hooks scan Rembrandt-specific secret patterns. Skills are tuned to project quirks. Outputs (ADRs, incidents, M1–M5 baseline) are partially published in [`rembrandt-samples/`](https://github.com/michelfaure/rembrandt-samples/tree/main/falsifiable-metrics) so the auditable trail is shared even when the project code itself isn't.

| Aspect | Published (this repo) | Living (author's local) |
|---|---|---|
| Secret patterns | Generic (OpenAI, GitHub, AWS, GitLab) | Specialised (Brevo, Stripe, Airtable, PennyLane) |
| Hook trigger | Pre-commit | Pre-edit (Write/Edit/MultiEdit) on critical paths |
| Block patterns | Generic dangerous commands | Stack-specific (`vercel --prod`, `supabase db push`) |
| Skills | 9 universal | 9 universal + project-specific rules in `.claude/rules/` |
| Memory layer | Empty `MEMORY.md` scaffold | 114 feedback memories + 27 session logs |

## How to read this folder

If you have **an hour**: read `manifesto.md` end to end, then pick the three rules whose anchor axes most fit your current pain (typically R1, R10, R13 — *material verification*, *root cause*, *three brief modes*) and inline them into your `CLAUDE.md`. Run `./install.sh` to install the hooks and skills.

If you have **ten minutes**: read the fourteen rule titles in `CLAUDE.md`, paste `anti-patterns-checklist.md` into your next PR review, move on. The checklist is the densest doctrine-payload-per-line of the repo.

If you have **two minutes**: run `./install.sh /path/to/your/project` and answer Y when prompted for hooks. The default has been `[Y/n]` since v0.3 — most of the doctrine's value lives in the material enforcement of the four hooks.

After installation, run `./verify-install.sh` to confirm the integrity of the installed stack and surface drift between the doctrine you installed and what currently lives in `.claude/`.

## How to adapt it

Three patterns observed:

1. **Drop-in then trim.** Install everything, run for a week, comment out what produces friction without payoff in your stack. Hooks have explicit bypass mechanisms — use them, log the bypass, decide later whether the rule was wrong or the bypass was lazy.
2. **Rule-by-rule adoption.** Pick the rule that maps to your current pain (failed deploy → R1, drifted derived column → R6, sycophantic agent → R4+R5, sclerosis → R13). Apply only that rule and its associated skill. Add the next rule after the first has stuck for two weeks.
3. **Two-tier yourself.** If you publish or share your own variant, maintain explicitly two tiers — the generic one others can install, and the specialised one you actually run. Mark the boundary in your `CLAUDE.md`. The drift between them is informative.

## Four questions for testers

The doctrine asks four things back. Free format, GitHub Issues with subject prefix `[v0.4.1 retour]`.

**(a) What did you actually load / use?** Toolkit `CLAUDE.md` full or partial, which skills triggered, challenger agent invoked or not, hooks activated, manifesto read in full or in part.

**(b) What concretely changed in your practice?** A decision taken differently? A bug avoided? Useless friction? Effect *notable*, *marginal*, or *negative*?

**(c) Which rules can you name without rereading?** Without reopening the file — how many of the 14 toolkit rules can you list? This metric measures whether the doctrine has been **integrated** (you think of it spontaneously) or merely **consulted**. This is the most important test.

**(d) Which rule is missing for your stack?** Candidates for v0.5 (July 15, 2026). The doctrine grew by one axis between v0.2 and v0.3, separated toolkit from manifesto between v0.3.3 and v0.4, and refactored to fourteen rules in v0.4.1 — real practice may reveal what those rules still miss.

Testers wanting attribution can opt-in via the issue (default is anonymous). Cited contributors appear in the v0.5 toolkit pillar on DEV.to (15 July 2026).

---

*Counterpart Doctrine v0.7 — released 20 May 2026. Eight iterations in 35 days (v0.2 → v0.3 → v0.3.1 → v0.3.2 → v0.3.3 → v0.4 → v0.4.1 → v0.6 → v0.7). v0.4.1 split R1 → R1+R2 (filesystem over summary), split ex-R7 → R8+R9 (session structure / delegation), added R14 (spike escape hatch). v0.6 added R15+R16 (autonomous session checkpoint, parallel-agent limit) post-Gorgon empirical session (40 agents / 40 finished). v0.7 amends R7 (bulk re-count <30 min before mutation), R9 (sub-agent brief inlines load-bearing feedbacks), R12 (external AI claims require material test), R15 (meta-hook autonomy detection) — multi-substrate consolidation after `/challenger` self-falsification (3 redundant proposals retracted) + gorgon multi-substrate exploration (2 patterns added). M1–M5 findings propagated from `rembrandt-samples/falsifiable-metrics/` into the manifesto and toolkit. Each iteration carries a named fait nouveau and a documented retraction. v0.5 toolkit pillar on DEV.to: 15 July 2026.*
*Tested on 70+ days of solo ERP coding (~118 k lines, 76+ ADRs) + 5 days of game dev dogfooding (Godot/GDScript, 24 ADRs, 676 tests).*
*Source repo: github.com/michelfaure/doctrine-counterpart*
*Companion samples: github.com/michelfaure/rembrandt-samples/counterpart-doctrine*
*License: CC-BY-4.0*
