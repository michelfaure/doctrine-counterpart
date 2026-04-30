---
name: session-discipline
description: Activate this skill when the user opens a multi-file project, mentions "module", "spec", "refactor", "ADR", "architecture", "phase", "lot", "feature", "implementation", creates a new migration or a new template. Also on "git push", "deploy", "production", when a cron is created or modified, and at session start to open a project FIFO. The skill enforces ADR before code, phase-0 exhaustive grep, lots of 5 lines max, project FIFO, manual trigger post-deploy, cleanup before push, calendar event for self-validation.
---

# Session discipline

The AI-native solo structures work before writing, archives while working, closes cleanly before moving on. Organizational friction saves hours of catch-up.

## ADR before code

**Any project > 2 files** triggers an ADR before the first commit.

Minimal format (1 page):

```markdown
# ADR-NNNN — [short title]

Date: YYYY-MM-DD
Status: proposed / accepted / deprecated / contradicted by ADR-XXXX

## Context
[1-2 paragraphs: why this decision arises]

## Decision
[1 paragraph: what is chosen]

## Alternatives discarded
- [option A] — discarded because [...]
- [option B] — discarded because [...]

## Consequences
- Positive: [...]
- Negative or debt: [...]

## References
- [links to neighboring ADRs, memories, sessions]
```

The ADR serves as oracle during implementation: when a UX detail wavers, return to the ADR rather than reopen the arbitrage.

## Phase 0 — exhaustive grep

**Before any spec of a new module or refactor > 2 files**: exhaustive grep of symbols, assets, formats of the concerned domain.

```bash
# Example for a post-meeting mail module
grep -rn "post_meeting_mail\|postMeetingMail\|calendar" app/ lib/ --include='*.ts' --include='*.tsx'

# Example for a new PDF format
find app/api/attendance/ -name "*.tsx" -o -name "*.ts" | xargs head -20
```

Report what exists *before* proposing new. If a module already produces or consumes the asset: branch onto it, don't create a parallel slot.

## Work lots

On step-by-step projects, **each lot must be validatable by a short recap (3-5 lines)**. If the recap of a lot exceeds 5 lines, the lot is too large — split before proceeding.

At each end of lot:
- Recap 3-5 lines (commits, files touched, next step)
- Explicit question "shall we move on?"
- User validation before next lot

## Project FIFO

**No more than 3 projects open in parallel.** Open a new = close an old (shipped, deferred, or explicitly abandoned with ADR).

At session start, list open projects. If > 3, refuse to open a new one until explicit closure.

## Manual trigger post-deploy

**Any new or modified cron** must be triggered manually *before* the cron takes over. Observe the real digest, adjust if false positives, *then* let it run.

```bash
# Example: immediate trigger of an audit-drift cron
curl -X POST https://app.../api/cron/audit-drift \
  -H "Authorization: Bearer $CRON_SECRET"
# Read Slack digest / log within the minute
```

Without this trigger, you get used to false positives in Slack for 30 days before discovering the bad calibration.

## Cleanup before push

**Before any multi-commit `git push`**: run ESLint + dead-code grep + build, report raw output.

```bash
npx eslint <touched files> 2>&1 | tail -20
grep -rn "TODO\|FIXME\|XXX" <touched files>
npm run build 2>&1 | tail -10
```

If orphan imports, dead functions, or undocumented warnings: clean up or open an explicit ticket. No silent cleanup, no dirty push.

## Calendar event for self-validation

On any project whose **real effect manifests at D+1/D+2** (cron activating tomorrow, sync refreshing overnight, deploy whose impact appears in production): create a calendar event or reminder to verify the result on the expected date.

```
[Calendar] Tomorrow 9:30 — Verify audit-drift cron digest,
           adjust probe 3 if false positives > 100
```

The signal always comes later than expected, oblivion always comes faster. The calendar blocks the mental cost of memory.

## Background subagent when scope locked

If an agent task is well-scoped (audit + commits + push), invoking it with `run_in_background: true` frees the main session for orchestration or doc. Condition: scope locked, no ambiguity possible. Otherwise you must be available for its questions.

## Ticket as portable cold context

For projects spanning multiple sessions, the ticket (GitHub issue, docs/projects/ file, etc.) serves as **portable cold context**. Cost of writing: 10 min. Savings: 30-45 min of rebriefing at next session start.

Ticket format:
- Scope (A / B / C / D)
- Explicit out-of-scope
- Checkable success criteria
- Open hypotheses
- Short prompt to copy-paste for session opening

## Project start checklist

- [ ] Project > 2 files? → ADR written
- [ ] Phase 0 exhaustive grep done
- [ ] Existing identified, "reuse or create" decision taken
- [ ] Lot decomposition previewed (recap < 5 lines per lot)
- [ ] If cron: manual trigger post-deploy planned
- [ ] If D+1/D+2 effect: calendar event set
- [ ] FIFO respected (≤ 3 projects open)
