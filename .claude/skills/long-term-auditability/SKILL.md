---
name: long-term-auditability
description: Activate this skill at the end of a significant session (> 1h or > 3 commits), on each ADR creation or modification, on mention of "MEMORY", "doctrine", "audit", "quarterly", "session log", "handover". Also when a feedback memory is created or modified, when a drift is documented without an associated probe, or when the MEMORY.md index exceeds 200 lines. The skill enforces ADR trace for structurally significant decisions, session log after significant session, quarterly memory audit, and the reminder that the doctrine applies to itself.
---

# Long-term auditability

The solo's individual memory is insufficient. The archive — ADR, session logs, MEMORY.md, doctrine itself — is the external organ that holds them, provided it is itself audited regularly. Without this axis, the other six dissolve into oblivion.

## ADR for structurally significant decisions

**Any structurally significant decision** (see *bidirectional-adversariality* skill) must be archived as an ADR (Architecture Decision Record) in `docs/adr/NNNN-title.md`.

Minimal format:

```markdown
# ADR-NNNN — [short title]

Date: YYYY-MM-DD
Status: proposed / accepted / deprecated / contradicted by ADR-XXXX

## Context
## Decision
## Alternatives discarded
## Consequences
## References
```

Git history answers *what was changed* — not *why*. The ADR archives the why that git log loses. Without ADR, the why remains in the solo's head, hence nowhere outside, hence lost.

## Session log after significant session

After each session **> 1h or > 3 commits**, produce a `docs/sessions/YYYY-MM-DD_title.md` file (or equivalent in the project's convention).

Minimal format:

```markdown
# YYYY-MM-DD — [title]

## What was shipped
[commits, files, ADRs]

## What worked
[3 lines]

## What failed or surprised
[3 lines]

## What I want to try next time
[bullets]
```

Hot capture, not literary. The pattern emerges from rereading, not from a single session.

## MEMORY.md — index ≤ 200 lines

Maintain an index file at root (`MEMORY.md` or equivalent) with:

- **One line per memory**, format: `- [title](file.md) — one-sentence hook < 150 chars`
- Detail in separate topic files
- **Strict 200-line limit** — beyond, Claude Code silently truncates

If the index exceeds 200 lines: refactor obligatory. Archive sessions > 6 days old in a `sessions/INDEX.md`. Move project detail into dedicated files.

## Feedback memory tied to drift = mandatory probe

**Any feedback memory documenting an active drift** must point to a probe that confirms it (SQL script, audit cron, alerting). Without a probe, the memory rots silently.

Typical case: memory says "drift on schedule statuses active since 04/26". At D+3, probe says 0 deviation. The memory is stale and must be deleted or requalified. Otherwise, it continues to bias future decisions.

Rule: *any feedback memory on an active drift must point to a probe that confirms it, otherwise it rots*.

## Mandatory quarterly audit

**Every 3 months**: re-read the MEMORY.md index line by line, ask for each entry "is this still true?".

Calendar recurrently:

```
Calendar: 1st Sunday of the quarter, 1h
Action: line-by-line audit MEMORY.md + reread recent ADRs + flag obsolete ones
```

Cost: 1h per quarter. Benefit: a memory that remains an asset instead of rotting.

## ADR obsolescence criterion

**ADR with > 30% obsolescence at 12 months** = doctrine to requalify as *research in progress*, not a stable framework.

Annual audit: for each ADR more than 12 months old, classify:
- **Still valid**: the decision holds, consequences materialized
- **Partially obsolete**: parts are outdated, keep partially
- **Contradicted by later ADR**: reference the contradictor, mark status
- **Abandoned**: the decision was never applied or was reversed

If > 30% in obsolete + contradicted + abandoned, the domain is still in exploration — avoid presenting the ADR corpus as "project doctrine."

## The doctrine applies to itself

**A doctrine that believes itself outside time betrays its own auditability principle.** This Counterpart Doctrine is versioned (v0.1, v0.2, etc.) and audited like an ADR.

Practical consequence: at each doctrine update, open a changelog in `doctrine.md`:

```markdown
## Changelog

### v0.2 (YYYY-MM-DD)
- Added skill X following feedback from Y
- Reformulation of axis Z after incident A
- Open question 4 resolved by hypothesis B tested over 6 weeks

### v0.1 (YYYY-MM-DD)
- First version
```

## Bus factor of the AI-native solo

The archive (ADR + sessions + MEMORY + doctrine) also serves as an implicit **handover dossier**: if the solo stops (vacation, illness, accident), another practitioner who loads the doctrine and reads the archives can pick up.

Periodically test: "if I stopped tomorrow, what could another solo dev who opens this repo pick up in 30 days?". If the answer is "nothing without me," the doctrine is not yet correctly applied.

## End-of-session checklist

- [ ] If structurally significant decision: ADR written
- [ ] If session > 1h or > 3 commits: session log created
- [ ] If new feedback memory: point to probe if drift
- [ ] If new recurring pattern identified: capture as rule or skill
- [ ] MEMORY.md updated, < 200 lines
- [ ] If end of quarter: memory audit planned

## Quarterly checklist

- [ ] MEMORY.md re-read line by line
- [ ] Stale memories deleted or requalified
- [ ] Probes verified (are documented drifts still active?)
- [ ] ADRs > 12 months audited (still valid / obsolete / contradicted)
- [ ] Doctrine itself: need a v0.X+1?
