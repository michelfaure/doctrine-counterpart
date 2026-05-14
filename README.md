# counterpart-doctrine/

The eight-axis discipline that emerged after 60 effective days of solo coding with Claude Code on a production ERP. Each axis was born from a recurring failure mode, not from upfront design. Versioned, dated, falsifiable — including the doctrine itself. **Current release: v0.3.3** (amended from v0.3 through two external critiques and one instrumentation pass — see *Critiques received* and *What v0.2 prescribed and v0.3 retracted* in `doctrine.md`). v0.3 is the result of a hybrid method: empirical extraction of patterns, philosophical confrontation, external repo audit, then a 3-incident filter before any candidate was inscribed.

**Source article series**: *Building the Counterpart Doctrine v0.3 in public* — 30 satellite articles + pillar (May–July 2026) on [DEV.to](https://dev.to/michelfaure). The v0.2 closing pillar is [*The Counterpart Doctrine: a seven-axis spec for working with an AI coding agent*](https://dev.to/michelfaure) (May 18, 2026). The v0.3 closing pillar follows in mid-July, after the 30-article arc lands.

## Invariant rule

Working with an AI coding agent on the long run produces drift — silently. Claims that the build is green while CI is red. Patches that look like fixes and reappear six days later under a different mask. Derived columns that diverge from their source without a probe to tell you. Pushbacks where the agent revises its recommendation without bringing a single new fact. No human PR reviewer catches it. No peer challenges. And paranoia on every line is not sustainable.

The doctrine *constrains the exchanges* of the attelage — the two-horse team where solo and agent pull the same load. The better-rodé the attelage, the more it traces the same rail (Bourdieu's *habitus*). The form of the brief is the lever that keeps the attelage exploratory rather than sclerotic. Eight axes materially enforced — not eight pieties to maintain mentally.

The eight axes:

1. **Material verification** — claims come with proof in the same message; success criteria stated before implementation; numbers re-queried against ground truth; platform configs GET before PATCH; DB schema authority over TS; UI rendering authority over data model; human memory as falsifiable as agent memory.
2. **Bidirectional adversariality** — challenger before locking structural decisions; specialised pre-production adversariality in parallel with the producer agent; falsifiable memory re-probed before invocation; no revision without new fact.
3. **Data taxonomy and single source** — Live/Snapshot/Cache mandatory for every derivable stored value; provenance inside the data (`source` with controlled vocabulary); canonical exceptions listed in the same file as the rule; multi-file invariants guarded by contract tests including a negative case.
4. **Session discipline** — ADR before code, phase-0 exhaustive grep, FIFO 3 projects max, sub-agent briefing threshold (cheap briefs return plausible prose, not verified work), manual cron trigger post-deploy, calendar event for D+1/D+2 self-validation.
5. **Root cause, not patch** — workaround legitimate *only if owned* with `[workaround-assumed]` tag; silencing the signal forbidden by default (`catch {}`, `2>/dev/null`, silent strip); parsimony — 50% of the code for 100% of the criterion when reachable.
6. **Implicit pedagogy and business transversality** — regulated regulator-specific vocabulary, never invent business terms, cite the exact official text on any compliance claim, materialise implicit vendor dependencies as lint rules or ADRs, platform config never confused with repo config.
7. **Long-term auditability** — ADR archive, session logs, MEMORY index ≤ 200 lines, quarterly memory audit calendared, monthly light audit walking `.claude/rules/*.md` against the live code, doctrine itself versioned and audited.
8. **Discursive adversariality against harness sclerosis** *(new v0.3)* — three modes never collapsed: pure command (outcome known ≥ 90%), command with external oracle (outcome unknown but a metric arbitrates), question without oracle (no scalar answer). Asymmetric duty: the IA names the mode mismatch, the user accepts or contests. Pure-command share above 80% across a 7-day window = sclerosis alarm.

## Files

| File | Role |
|---|---|
| [`CLAUDE.md`](./CLAUDE.md) | v0.3.3 prescriptive rules, drop-in for project root. **8 axes**, full operational |
| [`doctrine.md`](./doctrine.md) | v0.3.3 long-form theory, read by humans (~50k characters, including retractations and critiques received) |
| [`install.sh`](./install.sh) | Interactive installer. Default `[Y/n]` for hooks in v0.3 (was `[y/N]` in v0.2) |
| [`verify-install.sh`](./verify-install.sh) | *(new v0.3)* — checks installation integrity, signals drift |
| [`rembrandt-samples/falsifiable-metrics/`](https://github.com/michelfaure/rembrandt-samples/tree/main/falsifiable-metrics) | *(new v0.3.3)* — five scripts (M1–M5) + measured baseline values from 60 days of Rembrandt. The empirical half of the doctrine's auto-application. |
| [`ADR-template.md`](./ADR-template.md) | One-page Architecture Decision Record template (axis 4) |
| [`anti-patterns-checklist.md`](./anti-patterns-checklist.md) | 16 anti-patterns *(was 8 in v0.2)* — paste into PR review |
| [`.claude/skills/`](./.claude/skills/) | 9 skills *(was 7 in v0.2)*. Two new: `parsimony`, `success-criteria-first` |
| [`.claude/agents/agent-challenger.md`](./.claude/agents/agent-challenger.md) | Adversarial sub-agent (axis 2) |
| [`.claude/hooks/`](./.claude/hooks/) | 4 hooks: `deploy-safeguard`, `secret-scanner`, `audit-memory-reminder`, `check-workaround-assumed` (reformulated in v0.3) |

## Living vs Published — the two-tier doctrine

The doctrine has two tiers by design, and conflating them is a category error.

- **Published tier** (this repo) — generic, stack-agnostic, drop-in for any project using Claude Code. The hooks scan generic secret patterns (OpenAI, GitHub, AWS, GitLab). The skills target the universal failure modes of solo coding with an AI agent. This is what you install.
- **Living tier** (the author's personal Claude Code config) — richer, specialised for the author's actual stack: Rembrandt ERP on Supabase, Vercel, Stripe, Brevo, Airtable, PennyLane. Hooks scan Rembrandt-specific secret patterns. Skills are tuned to the project's quirks (`liste_rouge` never reactivated, `inscriptions` schema, regime TVA mixte, cash vs engagement, etc.). The doctrine *applies to itself* on a stack with real failure modes — that's how the candidate axes survive the 3-incident filter before being inscribed here.

This is not a drift. It is a deliberate editorial dispositif, documented as debt D5c in the v0.3 working draft. The published doctrine is what generalises across stacks; the lived doctrine is what proves the doctrine works against real production pressure. A contributor wishing to file a PR should target the published tier. A user installing the doctrine starts here and customises locally.

| Aspect | Published (this repo) | Living (author's local) |
|---|---|---|
| Secret patterns | Generic (OpenAI, GitHub, AWS, GitLab) | Specialised (Brevo, Stripe, Airtable, PennyLane) |
| Hook trigger | Pre-commit | Pre-edit (Write/Edit/MultiEdit) on critical paths |
| Block patterns | Generic dangerous commands | Stack-specific (`vercel --prod`, `supabase db push`) |
| Skills | 9 universal | 9 universal + project-specific rules in `.claude/rules/` |
| Memory layer | Empty `MEMORY.md` scaffold | 60+ feedback memories + sessions index |

The dispositif means: do not expect the published version to match the author's lived practice exactly. The published version is the doctrine; the lived version is its application. Each tier audits the other — the published tier prevents the lived one from drifting into project-specific lore that doesn't generalise, the lived tier prevents the published one from drifting into abstraction that no incident has tested.

## How to read this folder

If you have an hour: read `doctrine.md` end to end, then pick the three axes most relevant to your current pain (probably 1, 5, 8) and inline them into your `CLAUDE.md`. Run `./install.sh` to get the hooks and skills in place.

If you have ten minutes: read the eight axis titles in `doctrine.md`, paste `anti-patterns-checklist.md` into your next PR review, move on. The checklist is the densest doctrine-payload-per-line of the repo.

If you have two minutes: run `./install.sh /path/to/your/project` and answer Y when prompted for hooks. The default has flipped from `[y/N]` to `[Y/n]` in v0.3 — most of the doctrine's value lives in the material enforcement of the four hooks.

After installation, run `./verify-install.sh` (new in v0.3) to confirm the integrity of the installed stack and surface drift between the doctrine you installed and what currently lives in `.claude/`.

## How to adapt it

Three patterns observed:

1. **Drop-in then trim**. Install everything, run for a week, comment out what produces friction without payoff in your stack. Hooks have explicit bypass mechanisms — use them, log the bypass, decide later whether the rule was wrong or the bypass was lazy.
2. **Axis-by-axis adoption**. Pick the axis that maps to your current pain (failed deploy, drifted derived column, sycophantic agent, sclerosis). Apply only that axis's prescriptions and skill. Add the next axis after the first has stuck for two weeks.
3. **Two-tier yourself**. If you publish or share your own variant, maintain explicitly two tiers — the generic one others can install, and the specialised one you actually run. Mark the boundary in your `CLAUDE.md`. The drift between them is informative.

## Three questions for testers

The doctrine asks three things back. Free format, GitHub Issues with subject prefix `[v0.3 retour]`.

**(a) What did you actually load / use?** Full or partial CLAUDE.md, which skills triggered, challenger agent invoked or not, hooks activated, doctrine.md read in full or in part.

**(b) What concretely changed in your practice?** A decision taken differently? A bug avoided? Useless friction? Effect *notable*, *marginal*, or *negative*?

**(c) Which axes can you name without rereading?** Without reopening the file — how many of the 8 axes can you list? This metric measures whether the doctrine has been **integrated** (you think of it spontaneously) or merely **consulted**. This is the most important test.

**(d) Which axis is missing for your stack?** *(new v0.3)* — candidates for v0.4. The doctrine grew by one axis between v0.2 and v0.3 because real practice revealed a pattern no existing axis covered. Yours may reveal the ninth.

Testers wanting attribution are cited by name in the v0.3 closing pillar on DEV.to (mid-July 2026).

## Why this matters

Coding alone with an AI agent collapses two roles into one — you are both the producer and the only reviewer. The agent fills the role of pair without filling the role of adversary. Sycophancy compounds with speed: the longer the session, the harder it is to detect the moment the work started drifting. Short-term productivity is up. Long-term coherence is fragile, and the failure modes are silent.

The doctrine trades a small amount of upfront friction (ADRs, success criteria, raw-output proofs, brief-form discipline) against a much larger amount of downstream drift. It does not assume the agent is hostile. It assumes the attelage will sclerose if its form is left to inertia, and that the only sustainable counterweight is a versioned, dated, falsifiable discipline that applies to both the agent's outputs and the solo's own habits.

60 days of public construction produced v0.3. v0.4 will follow the same method, in the open.

---

*Counterpart Doctrine v0.3.3 — released July 14, 2026 after 60 days of public construction. Amended from v0.3 through v0.3.1 (first external critique), v0.3.2 (second external critique), v0.3.3 (M1–M5 instrumented).*
*Tested on 60+ days of solo ERP coding (35k+ lines, 65+ ADRs).*
*Source repo: github.com/michelfaure/doctrine-counterpart*
*Companion samples: github.com/michelfaure/rembrandt-samples/counterpart-doctrine*
*License: CC-BY-4.0*