# counterpart-doctrine/

Eleven operational rules for working with Claude Code on a long-running solo project, plus the long-form theory that produced them. The rules emerged after 60+ effective days of solo coding with Claude Code on a production ERP. Each rule was born from a recurring failure mode, not from upfront design. Versioned, dated, falsifiable — including the doctrine itself. **Current release: v0.4** (toolkit/manifesto split — see *From v0.3.3 to v0.4* in `manifesto.md`).

**Source article series**: *Building the Counterpart Doctrine in public* — 31 satellite articles + pillar (May–July 2026) on [DEV.to](https://dev.to/michelfaure). The v0.2 closing pillar is [*The Counterpart Doctrine: a seven-axis spec for working with an AI coding agent*](https://dev.to/michelfaure) (May 18, 2026). The v0.5 toolkit pillar follows on July 15, 2026, after the 31-article arc lands.

## Invariant rule

Working with an AI coding agent on the long run produces drift — silently. Claims that the build is green while CI is red. Patches that look like fixes and reappear six days later under a different mask. Derived columns that diverge from their source without a probe to tell you. Summaries (`backlog.md`, `MEMORY.md`, session notes) that quietly diverge from `git log` and the filesystem because no one set them up to refresh. Pushbacks where the agent revises its recommendation without bringing a single new fact. No human PR reviewer catches it. No peer challenges. And paranoia on every line is not sustainable.

The doctrine *constrains the exchanges* of the attelage — the two-horse team where solo and agent pull the same load. The better-rodé the attelage, the more it traces the same rail (Bourdieu's *habitus*). The form of the brief is the lever that keeps the attelage exploratory rather than sclerotic. Eleven rules materially enforced — not eleven pieties to maintain mentally.

## The two artefacts — toolkit and manifesto

V0.4 ships the doctrine as **two distinct artefacts**, each fit for one use:

- **The toolkit** — [`CLAUDE.md`](./CLAUDE.md). Eleven operational rules in ~150 lines, each falsifiable and anchored in at least one documented incident. This is what your Claude Code reads at session start. Loadable, dense, citable. **This is what you install.**
- **The manifesto** — [`manifesto.md`](./manifesto.md). The long-form theory: eight axes, the *attelage* metaphor, the construction method (phase A empirical extraction, phase B philosophical confrontation, phase B2 external audit, phase C falsifiability filter), the retractions, the critiques received and integrated. Read by humans who want to understand *why* the rules exist. ~50 k characters.

The two-cycle strategy is explicit. **v0.4 toolkit ships 15 May 2026** with the rules that 60+ days of practice and three external readings (two critiques + an Anthropic auto-analysis report on 24 days of usage) converge on. **v0.5 toolkit ships 15 July 2026** after the thirty-article arc has empirically decanted which of the eleven rules survive practice and which need re-formulation. Each version is the published output of a phase of decantation, not a final state.

## The eleven toolkit rules

| # | Rule | Anchor axis (manifesto) |
|---|---|---|
| R1 | **Raw output, not declaration** *(includes: filesystem over summary, DB schema authority, UI rendering authority, human memory falsifiability, EXPLAIN ANALYZE discipline)* | Axis 1 |
| R2 | **Success criteria before code** | Axis 1 |
| R3 | **Falsify before fix** *(five-step protocol: hypothesis → 3 refutation probes → execute → decide)* | Axis 2 |
| R4 | **No revision without new fact** | Axis 2 |
| R5 | **Live / Snapshot / Cache mandatory** | Axis 3 |
| R6 | **Provenance in the data, exceptions in the rule** | Axis 3 |
| R7 | **ADR before code, phase-0 grep** *(includes sub-agent briefing threshold)* | Axis 4 |
| R8 | **Silent failure forbidden, workaround tagged** | Axis 5 |
| R9 | **Parsimony, no speculative abstraction** | Axis 5 |
| R10 | **Cite the official text, materialise vendor defaults** *(includes platform config ≠ repo config)* | Axis 6 |
| R11 | **Audit, archive, three brief modes** | Axes 7 & 8 |

Each rule is fully formulated in [`CLAUDE.md`](./CLAUDE.md). Each rule's theoretical anchor — its thesis, its inaugural incident, its trade-off against alternatives — is in [`manifesto.md`](./manifesto.md).

## Files

| File | Role |
|---|---|
| [`CLAUDE.md`](./CLAUDE.md) | **Toolkit v0.4** — eleven operational rules, drop-in for project root. ~150 lines. |
| [`manifesto.md`](./manifesto.md) | **Manifesto v0.4** — long-form theory: 8 axes, *attelage*, retractions, critiques, the toolkit/manifesto split itself. ~50 k characters. |
| [`install.sh`](./install.sh) | Interactive installer. Default `[Y/n]` for hooks. |
| [`verify-install.sh`](./verify-install.sh) | Checks installation integrity, signals drift. |
| [`rembrandt-samples/falsifiable-metrics/`](https://github.com/michelfaure/rembrandt-samples/tree/main/falsifiable-metrics) | Five scripts (M1–M5) + measured baseline values from 60 days of Rembrandt. |
| [`ADR-template.md`](./ADR-template.md) | One-page Architecture Decision Record template (R7). |
| [`anti-patterns-checklist.md`](./anti-patterns-checklist.md) | 16 anti-patterns — paste into PR review. |
| [`.claude/skills/`](./.claude/skills/) | 9 universal skills. |
| [`.claude/agents/agent-challenger.md`](./.claude/agents/agent-challenger.md) | Adversarial sub-agent (R3, R4). |
| [`.claude/hooks/`](./.claude/hooks/) | 4 hooks: `deploy-safeguard`, `secret-scanner`, `audit-memory-reminder`, `check-workaround-assumed`. |

## Living vs Published — the two-tier doctrine

The toolkit/manifesto split (v0.4) is orthogonal to a second long-standing distinction: *Living* vs *Published*.

- **Published tier** (this repo) — generic, stack-agnostic, drop-in for any project using Claude Code. The hooks scan generic secret patterns (OpenAI, GitHub, AWS, GitLab). The skills target universal solo-coding failure modes. This is what you install.
- **Living tier** (the author's personal Claude Code config) — richer, specialised for the author's actual stack: Rembrandt ERP on Supabase, Vercel, Stripe, Brevo, Airtable, PennyLane. Hooks scan Rembrandt-specific secret patterns. Skills are tuned to the project's quirks (`liste_rouge` never reactivated, `inscriptions` schema, regime TVA mixte, cash vs engagement). The doctrine *applies to itself* on a stack with real failure modes — that is how candidate axes survive the 3-incident filter before being inscribed here.

This is not drift. It is a deliberate editorial dispositif. The published doctrine is what generalises across stacks; the lived doctrine is what proves the doctrine works against real production pressure. A contributor wishing to file a PR should target the published tier. A user installing the doctrine starts here and customises locally.

| Aspect | Published (this repo) | Living (author's local) |
|---|---|---|
| Secret patterns | Generic (OpenAI, GitHub, AWS, GitLab) | Specialised (Brevo, Stripe, Airtable, PennyLane) |
| Hook trigger | Pre-commit | Pre-edit (Write/Edit/MultiEdit) on critical paths |
| Block patterns | Generic dangerous commands | Stack-specific (`vercel --prod`, `supabase db push`) |
| Skills | 9 universal | 9 universal + project-specific rules in `.claude/rules/` |
| Memory layer | Empty `MEMORY.md` scaffold | 114 feedback memories + 27 session logs |

## How to read this folder

If you have **an hour**: read `manifesto.md` end to end, then pick the three rules whose anchor axes most fit your current pain (typically axes 1, 5, 8 — *material verification*, *root cause*, *three brief modes*) and inline them into your `CLAUDE.md`. Run `./install.sh` to install the hooks and skills.

If you have **ten minutes**: read the eleven rule titles in `CLAUDE.md`, paste `anti-patterns-checklist.md` into your next PR review, move on. The checklist is the densest doctrine-payload-per-line of the repo.

If you have **two minutes**: run `./install.sh /path/to/your/project` and answer Y when prompted for hooks. The default has flipped from `[y/N]` to `[Y/n]` in v0.3 — most of the doctrine's value lives in the material enforcement of the four hooks.

After installation, run `./verify-install.sh` to confirm the integrity of the installed stack and surface drift between the doctrine you installed and what currently lives in `.claude/`.

## How to adapt it

Three patterns observed:

1. **Drop-in then trim.** Install everything, run for a week, comment out what produces friction without payoff in your stack. Hooks have explicit bypass mechanisms — use them, log the bypass, decide later whether the rule was wrong or the bypass was lazy.
2. **Rule-by-rule adoption.** Pick the rule that maps to your current pain (failed deploy → R1, drifted derived column → R5, sycophantic agent → R3+R4, sclerosis → R11). Apply only that rule and its associated skill. Add the next rule after the first has stuck for two weeks.
3. **Two-tier yourself.** If you publish or share your own variant, maintain explicitly two tiers — the generic one others can install, and the specialised one you actually run. Mark the boundary in your `CLAUDE.md`. The drift between them is informative.

## Four questions for testers

The doctrine asks four things back. Free format, GitHub Issues with subject prefix `[v0.4 retour]`.

**(a) What did you actually load / use?** Toolkit `CLAUDE.md` full or partial, which skills triggered, challenger agent invoked or not, hooks activated, manifesto read in full or in part.

**(b) What concretely changed in your practice?** A decision taken differently? A bug avoided? Useless friction? Effect *notable*, *marginal*, or *negative*?

**(c) Which rules can you name without rereading?** Without reopening the file — how many of the 11 toolkit rules can you list? This metric measures whether the doctrine has been **integrated** (you think of it spontaneously) or merely **consulted**. This is the most important test.

**(d) Which rule is missing for your stack?** Candidates for v0.5 (July 15, 2026). The doctrine grew by one axis between v0.2 and v0.3, separated toolkit from manifesto between v0.3.3 and v0.4 — real practice may reveal what the eleven rules still miss.

Testers wanting attribution are cited by name in the v0.5 toolkit pillar on DEV.to (15 July 2026).

## Why this matters

Coding alone with an AI agent collapses two roles into one — you are both the producer and the only reviewer. The agent fills the role of pair without filling the role of adversary. Sycophancy compounds with speed: the longer the session, the harder it is to detect the moment the work started drifting. Short-term productivity is up. Long-term coherence is fragile, and the failure modes are silent.

The doctrine trades a small amount of upfront friction (ADRs, success criteria, raw-output proofs, brief-form discipline, refreshing summaries against the filesystem) against a much larger amount of downstream drift. It does not assume the agent is hostile. It assumes the attelage will sclerose if its form is left to inertia, and that the only sustainable counterweight is a versioned, dated, falsifiable discipline that applies to both the agent's outputs and the solo's own habits.

60 days of public construction produced v0.3 (14 May 2026). Within the first 24 hours of release, two external critiques arrived and v0.3 was amended through v0.3.1 (theoretical over-armour cut), v0.3.2 (axis-8 detheorised, retractions section added), v0.3.3 (M1–M5 instrumented with measured baseline). Day 61 (15 May 2026) integrated a third external reading — an auto-analysis report Anthropic produced on 24 days of the author's Claude Code usage — and resolved two structural problems v0.3.3 could not address simultaneously: the toolkit/manifesto separation, and the *filesystem over summary* sub-rule.

The amendment trail — *Critiques received*, *What v0.2 prescribed and v0.3 retracted*, *From v0.3.3 to v0.4 — separating toolkit from manifesto* in `manifesto.md` — is itself the first material application of the doctrine to itself: revise on new fact, never on pushback alone, publish the cicatrices. v0.5 will follow the same method in the open, with the thirty-article arc as the empirical substrate of the next decantation. Multi-substrate validation (Python/Postgres without Supabase) is slated for end of arc 2 (October 2026).

---

*Counterpart Doctrine v0.4 — toolkit/manifesto split released 15 May 2026, one day after v0.3.3, integrating the third external reading (Anthropic auto-analysis 17 April – 14 May 2026, 3 341 messages over 193 sessions). Five iterations in 31 days, each carrying a named fait nouveau and a documented retraction. v0.5 toolkit pillar on DEV.to: 15 July 2026.*
*Tested on 60+ days of solo ERP coding (35 k+ lines, 65+ ADRs).*
*Source repo: github.com/michelfaure/doctrine-counterpart*
*Companion samples: github.com/michelfaure/rembrandt-samples/counterpart-doctrine*
*License: CC-BY-4.0*
