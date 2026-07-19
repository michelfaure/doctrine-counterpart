# counterpart-doctrine/

Nineteen operational rules for working with Claude Code on a long-running solo project, plus the long-form theory that produced them. The rules emerged from solo coding with Claude Code on a production ERP (70+ effective days measured 22 May 2026, running daily through July 2026) + game dev dogfooding (Godot/GDScript multi-substrate test). Each rule was born from a recurring failure mode, not from upfront design. Versioned, dated, falsifiable — including the doctrine itself. **Current release: v0.11** (the terse split, 19 July 2026 — `CLAUDE.md` reduced to a ~3.5k-token Live norm, the full-length rule text and all provenance frozen verbatim in [`calibration-ledger.md`](./calibration-ledger.md); a response by *subtraction* to an external review's one structural critique, accumulation bias. v0.10 two days earlier filled R17, promoted R19 on measured bite, and ran the first real R18(c) falsification audit — see [`v0.10-candidates.md`](./v0.10-candidates.md)).

## Quick install (one command)

```bash
git clone https://github.com/michelfaure/doctrine-counterpart.git && \
  cd doctrine-counterpart && \
  ./install.sh --yes /path/to/your/project
```

This installs the **toolkit** (`CLAUDE.md`, 19 terse rules, ~60 lines — plus `calibration-ledger.md`, the evidence base its pointers resolve to), the **12 skills**, the **agent-challenger**, the **10 hooks** (`deploy-safeguard`, `secret-scanner`, `audit-memory-reminder`, `check-workaround-assumed`, `r15-autonomous-counter`, `r15-commit-gate`, `pre-merge-review-reminder`, `memory-write-guard`, `pre-bulk-mutation-count-staleness`, `public-repo-identity-guard`), and the optional `manifesto.md` — without asking. Defaults `Y` on every prompt; an existing `CLAUDE.md` is placed alongside as `CLAUDE.md.doctrine-counterpart` for safe manual merge.

**Interactive install** (control each step) : `./install.sh /path/to/your/project` — same components, prompts on each one.

After install : open Claude Code in your project. The toolkit is loaded automatically; skills auto-invoke on triggers; hooks soft-block risky commands unless bypassed with their documented tokens (`[deploy-ok]`, `[workaround-assumed]`, `[review-ok]`, `[autonomy-ack]`, `-- count-fresh:…`). **You do not need to read `manifesto.md` for the doctrine to operate** — it is optional long-form theory for humans who want to understand the *why*.

**Source article series**: *Building the Counterpart Doctrine in public* — 31 satellite articles + pillar (May–July 2026) on [DEV.to](https://dev.to/michelfaure). The v0.2 closing pillar is [*The Counterpart Doctrine: a seven-axis spec for working with an AI coding agent*](https://dev.to/michelfaure) (May 18, 2026).

## Why this matters

Coding alone with an AI agent collapses two roles into one — you are both the producer and the only reviewer. The agent fills the role of pair without filling the role of adversary. Sycophancy compounds with speed: the longer the session, the harder it is to detect the moment the work started drifting. Short-term productivity is up. Long-term coherence is fragile, and the failure modes are silent.

The doctrine trades a small amount of upfront friction (ADRs, success criteria, raw-output proofs, brief-form discipline, refreshing summaries against the filesystem) against a much larger amount of downstream drift. It does not assume the agent is hostile. It assumes the attelage will sclerose if its form is left to inertia, and that the only sustainable counterweight is a versioned, dated, falsifiable discipline that applies to both the agent's outputs and the solo's own habits.

## What this doctrine measures and what it doesn't

Seven metrics (M1–M7) instrument the doctrine's own self-application, and a single-script orchestrator (`doctrine-metrics.ts`) runs all of them at once. Scripts, the 21 May 2026 baseline, and the dated 17 July 2026 re-measure live in [`rembrandt-samples/falsifiable-metrics/`](https://github.com/michelfaure/rembrandt-samples/tree/main/falsifiable-metrics) — the empirical half of the doctrine.

| Metric | Rule | Target | Baseline (21 May) | Re-measure (17 July) | Verdict |
|---|---|---|---|---|---|
| **M1** anti-pattern recurrence / 7-day session | R13 | ≤ 1 | 14.63 | 15.0 | **Retired v0.11** — invalid by construction two cycles running (counted feedback *mentions*, not recurrences); never produced one valid measurement |
| **M2** multi-file commits without ADR / 28d | R8 | ≤ 5 % | 0.8 % | 3.7 % | **Met** (degrading, concentrated on one day's cluster) |
| **M3** median drift apparition → detection / 90d | R13 | ≤ 30 days | 35.7 d | 66.5 d | Miss — population ×3 since baseline, chiffre-à-chiffre comparison fragile ; manual-annotation re-baseline owed |
| **M4** position of 1st DB probe in session | R13 | ≤ 90 min | ~58 min | ~66 min | **Met** (sliding 41 → 58 → 66) |
| **M5** pure-command ratio / 7d (sclerosis alarm > 80 %) | R13 | provisional | 94 % `unknown` | **0 briefs extracted** | **Retired v0.11** — dead instrument (source drifted to prose); the sclerosis alarm stays qualitative in R13 |
| **M6** spike orphans > 7 days | R14 | 0 | 0 (1 valid spike) | 0 (**0 spikes in 60 d**) | Met — by vacuity ; R14 under R18 death-watch |
| **M7** runs > 5 uncheckpointed commits | R15 | 0 | 4 runs (longest = **92**) | 0 runs (longest = **1**) | **Met — the series' first red-to-green reversal ; the R15 hook holds where the declarative rule failed** |

The headline of the 17 July re-measure is M7: the chain of 92 autonomous commits without a session log that justified the R15 commit-gate has collapsed to 1 under hook enforcement — direct empirical validation of *enforced over declared*. The honest column is the instruments themselves: **v0.11 retired M1 and M5** — neither ever produced a valid measurement, and a metric kept "just in case" is the exact unrefreshed Cache the doctrine hunts everywhere else. This is the doctrine's first falsification-driven retirement of its own structures (R18's mortality mechanism producing its first kills); the scripts remain in the samples repo as dated archive. Five live metrics instrument four rules (R8, R13, R14, R15); the other rules remain qualitative or candidates for future instrumentation (see `doctrine-metrics.ts` for the coverage map). The doctrine **does not retro-fit targets to fit measurements** — gaps are acknowledged and recalibrated only when they reveal an intuition-set threshold rather than a doctrinal one.

## Invariant rule

Working with an AI coding agent on the long run produces drift — silently. Claims that the build is green while CI is red. Patches that look like fixes and reappear six days later under a different mask. Derived columns that diverge from their source without a probe to tell you. Summaries (`backlog.md`, `MEMORY.md`, session notes) that quietly diverge from `git log` and the filesystem because no one set them up to refresh. Pushbacks where the agent revises its recommendation without bringing a single new fact. No human PR reviewer catches it. No peer challenges. And paranoia on every line is not sustainable.

The doctrine *constrains the exchanges* of the attelage — the two-horse team where solo and agent pull the same load. The better-rodé the attelage, the more it traces the same rail (Bourdieu's *habitus*). The form of the brief is the lever that keeps the attelage exploratory rather than sclerotic. Nineteen rules materially enforced — not nineteen pieties to maintain mentally.

## The corpus — four surfaces, one category each

v0.11 declares an R6 category for every corpus surface (the doctrine's own Live/Snapshot/Cache taxonomy, applied to itself — before this, the rule text lived in 8 copies and the drift bit three times in a single day):

- **The toolkit** — [`CLAUDE.md`](./CLAUDE.md). **Live norm.** Nineteen terse rules (rule + trigger + action + exceptions), ~60 lines / ~3.5k tokens. This is what your Claude Code loads at session start, and what governs on conflict. **This is what you install.**
- **The calibration ledger** — [`calibration-ledger.md`](./calibration-ledger.md). **Snapshot journal.** The full-length v0.10 rule text frozen verbatim, all incident provenance, N counts, metric baselines, the version trail, and a dated journal where post-v0.10 evidence appends. Append-only — a dated snapshot cannot drift.
- **The manifesto** — [`manifesto.md`](./manifesto.md). **Theory.** Eight axes, the *attelage* metaphor, the construction method, the retractions, the critiques received and integrated. ~71 k characters. Read by humans who want the *why*; never loaded by the agent.
- **The candidates audits** — [`v0.7-candidates.md`](./v0.7-candidates.md), [`v0.8-candidates.md`](./v0.8-candidates.md), [`v0.10-candidates.md`](./v0.10-candidates.md). Dated audit material behind each promotion. (v0.9's audit trail lives in its session log.)

## The nineteen toolkit rules

R1 *Raw output, not declaration* · R2 *Filesystem over summary* · R3 *Success criteria before code* · R4 *Falsify before fix* · R5 *No revision without new fact* · R6 *Live / Snapshot / Cache mandatory* · R7 *Provenance + bulk re-count* · R8 *ADR before code, phase-0 grep* · R9 *Sub-agent briefing, FIFO 3* · R10 *Silent failure forbidden* · R11 *Parsimony* · R12 *Cite the official text, test external-AI claims* · R13 *Audit, archive, three brief modes* · R14 *Spike escape hatch* · R15 *Checkpoint commits in autonomous sessions* · R16 *Parallel-agent limit* · R17 *Assertional coverage* · R18 *The doctrine is a data table* · R19 *Review-gate on business-hot merges*

The rule text lives in **one place**: [`CLAUDE.md`](./CLAUDE.md) (Live norm). Amendment history, incident anchors and per-rule provenance: [`calibration-ledger.md`](./calibration-ledger.md). Theoretical anchors (eight axes): [`manifesto.md`](./manifesto.md).

## Files

| File | Role |
|---|---|
| [`CLAUDE.md`](./CLAUDE.md) | **Toolkit — the Live norm.** Nineteen terse rules, drop-in for project root. ~60 lines, ~3.5k tokens. |
| [`calibration-ledger.md`](./calibration-ledger.md) | **Snapshot journal** — full v0.10 rule text frozen verbatim, provenance, N counts, metrics, version trail, dated evidence journal. |
| [`anti-patterns-checklist.md`](./anti-patterns-checklist.md) | **30 anti-patterns** — densest doctrine-payload-per-line. Paste into PR review. |
| [`manifesto.md`](./manifesto.md) | **Manifesto** — long-form theory: 8 axes, *attelage*, retractions, critiques. ~71 k characters. |
| [`v0.10-candidates.md`](./v0.10-candidates.md) | **v0.10 audit material** — the first executed R18(c) falsification audit: harvest of 26 session logs, 3 hard contradictions, challenger screen, promotion scope. |
| [`v0.8-candidates.md`](./v0.8-candidates.md) / [`v0.7-candidates.md`](./v0.7-candidates.md) | Prior cycles' audit material. |
| [`rembrandt-samples/falsifiable-metrics/`](https://github.com/michelfaure/rembrandt-samples/tree/main/falsifiable-metrics) | Seven M1–M7 scripts + `doctrine-metrics.ts` orchestrator + 21 May baseline + dated 17 July re-measure. The empirical half of the doctrine. |
| [`install.sh`](./install.sh) | Interactive installer. Default `[Y/n]` for hooks. |
| [`verify-install.sh`](./verify-install.sh) | Checks installation integrity, signals drift. |
| [`ADR-template.md`](./ADR-template.md) | One-page Architecture Decision Record template (R8). |
| [`.claude/skills/`](./.claude/skills/) | 12 universal skills. |
| [`.claude/agents/agent-challenger.md`](./.claude/agents/agent-challenger.md) | Adversarial sub-agent (R4, R5). |
| [`.claude/hooks/`](./.claude/hooks/) | 10 hooks, each single-responsibility: `deploy-safeguard`, `secret-scanner`, `audit-memory-reminder`, `check-workaround-assumed`, `r15-autonomous-counter`, `r15-commit-gate`, `pre-merge-review-reminder` *(R19 — business-temperature + SECURITY DEFINER content scan)*, `memory-write-guard` *(R18 — write-time format guard)*, `pre-bulk-mutation-count-staleness` *(R7 — bulk re-count gate)*, `public-repo-identity-guard` *(publication gate — blocks a public push carrying blocklisted identifiers; opt-in, fail-closed once configured)*. All wired in [`settings.json.template`](./.claude/settings.json.template). |

## Living vs Published — the two-tier doctrine

The toolkit/manifesto split (v0.4) is orthogonal to a second long-standing distinction: *Living* vs *Published*.

- **Published tier** (this repo) — generic, stack-agnostic, drop-in for any project using Claude Code. The hooks scan generic secret patterns (OpenAI, GitHub, AWS, GitLab). The skills target universal solo-coding failure modes. This is what you install.
- **Living tier** (the author's personal Claude Code config) — richer, specialised for the author's actual stack (a production ERP on Supabase/Vercel/Stripe). Hooks scan stack-specific secret patterns. Skills are tuned to project quirks. Outputs (metric baselines and re-measures, anonymised) are partially published in [`rembrandt-samples/`](https://github.com/michelfaure/rembrandt-samples/tree/main/falsifiable-metrics) so the auditable trail is shared even when the project code itself isn't. Some living mechanisms are deliberately *not* published — the R19 calibration journal, for instance, carries business specifics and lives user-scope only; the public repo carries the rule and the hook.

| Aspect | Published (this repo) | Living (author's local) |
|---|---|---|
| Secret patterns | Generic (OpenAI, GitHub, AWS, GitLab) | Specialised (payment/email/CRM vendors) |
| Hook trigger | As wired in `settings.json.template` | Same + stack-specific guards (deploy, migrations, primary-tree) |
| Skills | 12 universal | Universal + project-scoped skills and `.claude/rules/` |
| Memory layer | Empty `MEMORY.md` scaffold | 136 feedback memories (measured 17 July 2026) + session logs at ~100/month cadence (M7 measure) |

## How to read this folder

If you have **an hour**: read `manifesto.md` end to end, then pick the three rules whose anchor axes most fit your current pain (typically R1, R10, R13 — *material verification*, *root cause*, *three brief modes*) and inline them into your `CLAUDE.md`. Run `./install.sh` to install the hooks and skills.

If you have **ten minutes**: read the nineteen rule titles in `CLAUDE.md`, paste `anti-patterns-checklist.md` into your next PR review, move on. The checklist is the densest doctrine-payload-per-line of the repo.

If you have **two minutes**: run `./install.sh /path/to/your/project` and answer Y when prompted for hooks. The default has been `[Y/n]` since v0.3 — most of the doctrine's value lives in the material enforcement of the ten hooks.

After installation, run `./verify-install.sh` to confirm the integrity of the installed stack and surface drift between the doctrine you installed and what currently lives in `.claude/`.

## How to adapt it

Three patterns observed:

1. **Drop-in then trim.** Install everything, run for a week, comment out what produces friction without payoff in your stack. Hooks have explicit bypass mechanisms — use them, log the bypass, decide later whether the rule was wrong or the bypass was lazy.
2. **Rule-by-rule adoption.** Pick the rule that maps to your current pain (failed deploy → R1, drifted derived column → R6, sycophantic agent → R4+R5, green-tests-but-broken-feature → R17, sclerosis → R13). Apply only that rule and its associated skill. Add the next rule after the first has stuck for two weeks.
3. **Two-tier yourself.** If you publish or share your own variant, maintain explicitly two tiers — the generic one others can install, and the specialised one you actually run. Mark the boundary in your `CLAUDE.md`. The drift between them is informative.

## Four questions for testers

The doctrine asks four things back. Free format, GitHub Issues with subject prefix `[retour]`.

**(a) What did you actually load / use?** Toolkit `CLAUDE.md` full or partial, which skills triggered, challenger agent invoked or not, hooks activated, manifesto read in full or in part.

**(b) What concretely changed in your practice?** A decision taken differently? A bug avoided? Useless friction? Effect *notable*, *marginal*, or *negative*?

**(c) Which rules can you name without rereading?** Without reopening the file — how many of the 19 toolkit rules can you list? This metric measures whether the doctrine has been **integrated** (you think of it spontaneously) or merely **consulted**. This is the most important test.

**(d) Which rule is missing for your stack?** Candidates for the next cycle are harvested continuously (the standing open items: a loop-until-dry review protocol awaiting its first measured run, an M3 re-baseline with manual annotation, R18's cron and auto-demotion mechanisms still prescribed-not-wired). Real practice may reveal what the nineteen rules still miss.

Testers wanting attribution can opt-in via the issue (default is anonymous).

---

*The full version trail — v0.2 through the current release, each version carrying a named fait nouveau and a documented retraction — lives in [`calibration-ledger.md`](./calibration-ledger.md) and [`manifesto.md`](./manifesto.md).*
*Tested on 70+ effective days of solo ERP coding measured 22 May 2026 (~118 k lines, 74 ADRs then — 192 ADRs by 17 July 2026), running daily through July 2026, + 5 days of game dev dogfooding (Godot/GDScript, 24 ADRs, 676 tests).*
*Source repo: github.com/michelfaure/doctrine-counterpart*
*Companion samples: github.com/michelfaure/rembrandt-samples*
*License: CC-BY-4.0*
