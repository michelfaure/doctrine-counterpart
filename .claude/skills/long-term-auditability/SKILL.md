---
name: long-term-auditability
description: Activate this skill at the end of a significant session (> 1h or > 3 commits), on each ADR creation or modification, on mention of "MEMORY", "doctrine", "audit", "quarterly", "session log", "handover". Also when a feedback memory is created or modified, when a drift is documented without an associated probe, or when the MEMORY.md index nears the harness truncation limit. The skill enforces ADR trace for structurally significant decisions, session log after significant session, event-triggered memory audit, the quarterly R18(c) falsification audit, and the reminder that the doctrine applies to itself.
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

## MEMORY.md — index under the truncation limit

Maintain an index file at root (`MEMORY.md` or equivalent) with:

- **One line per memory**, format: `- [title](file.md) — one-sentence hook`, kept short enough that the whole index stays under the truncation limit (set your own per-line cap and state it in your project instructions)
- Detail in separate topic files
- **Stay under the harness truncation limit, measured in bytes** — a line cap is a proxy (measured 2026: a 200-line index can be ~2.7× over a byte budget); beyond, the tail is silently dropped

If the index nears the limit: refactor obligatory — split into domain indexes if compaction alone cannot hold it. Move project detail into dedicated files, and archive entries **per your own documented criterion** — age alone is not one: it retires durable references (canonical files, infra pointers) and future commitments while keeping noisy recent entries. State the criterion where your memory policy lives, then apply it manually.

## Feedback memory tied to drift = mandatory probe

**Any feedback memory documenting an active drift** must point to a probe that confirms it (SQL script, audit cron, alerting). Without a probe, the memory rots silently.

Typical case: memory says "drift on schedule statuses active since 04/26". At D+3, probe says 0 deviation. The memory is stale and must be deleted or requalified. Otherwise, it continues to bias future decisions.

Rule: *any feedback memory on an active drift must point to a probe that confirms it, otherwise it rots*.

## Audit on event, and the quarterly falsification audit

**v0.12**: the calendar memory audits were retired — never executed on schedule, and they missed a false authority rule for three months. What replaces them:

- **On event**: when a constant, policy or schema changes, ask "which memory or rule does this make false?" — and write rules that cite a constant's **name**, never its value.
- **Quarterly R18(c) falsification audit** (reminder hook `audit-memory-reminder`): read the practice journal and session logs since the last audit, per rule search contradictions and signs of death, record births and deaths.

## ADR obsolescence criterion

**ADR with > 30% obsolescence at 12 months** = doctrine to requalify as *research in progress*, not a stable framework.

Annual audit: for each ADR more than 12 months old, classify:
- **Still valid**: the decision holds, consequences materialized
- **Partially obsolete**: parts are outdated, keep partially
- **Contradicted by later ADR**: reference the contradictor, mark status
- **Abandoned**: the decision was never applied or was reversed

If > 30% in obsolete + contradicted + abandoned, the domain is still in exploration — avoid presenting the ADR corpus as "project doctrine."

## The doctrine applies to itself

**A doctrine that believes itself outside time betrays its own auditability principle.** This Counterpart Doctrine is versioned and audited like an ADR — its real version trail (every release with its named new fact and documented retraction) lives in `calibration-ledger.md`, never duplicated elsewhere.

Practical consequence for your own doctrine: keep ONE dated version trail in ONE file, and make each entry carry the new fact that justified the bump and anything retracted. A template entry:

```markdown
### vN (YYYY-MM-DD)
- New fact: <the incident or measurement that forced the change>
- Added / amended: <rule or skill, with its N count>
- Retracted: <what was removed or demoted, and why>
```

## Bus factor of the AI-native solo

The archive (ADR + sessions + MEMORY + doctrine) also serves as an implicit **handover dossier**: if the solo stops (vacation, illness, accident), another practitioner who loads the doctrine and reads the archives can pick up.

Periodically test: "if I stopped tomorrow, what could another solo dev who opens this repo pick up in 30 days?". If the answer is "nothing without me," the doctrine is not yet correctly applied.

## End-of-session checklist

- [ ] If structurally significant decision: ADR written
- [ ] If session > 1h or > 3 commits: session log created
- [ ] If new feedback memory: point to probe if drift
- [ ] If new recurring pattern identified: capture as rule or skill
- [ ] MEMORY.md updated, under the truncation limit
- [ ] If 90 days since the last R18(c) audit: audit planned

## Quarterly checklist

- [ ] MEMORY.md re-read line by line
- [ ] Stale memories deleted or requalified
- [ ] Probes verified (are documented drifts still active?)
- [ ] ADRs > 12 months audited (still valid / obsolete / contradicted)
- [ ] Doctrine itself: need a v0.X+1?
