---
name: root-cause
description: Activate this skill when the user or an agent mentions "fix", "bug", "patch", "workaround", "hack", "quick fix", "temporary", "band-aid", or proposes a correction on an observed symptom. Also when an arbitrary cap appears in a comment (`// limit = X`, `// don't exceed Y`), when a test documents an exclusion as intentional, when a fix seems too simple for the symptom. The skill enforces root cause identification, pattern widening, and explicit assumption of any workaround.
---

# Root cause, not patch

Before any fix, identify the root cause. A workaround is legitimate *only if explicitly assumed*. It's the absence of explicit assumption that's forbidden, not the workaround itself.

## Full input → output pipeline

When a fix is proposed for a bug, **before accepting**: demand the full input → output pipeline.

```
Data source → query / sync / import →
transformation → storage → read query → UI display
```

At what level does the bug actually appear? If the agent fixes at level N while the cause is at level N-2, the fix is cosmetic and the bug will return wearing a different mask.

Typical case: a UI display bug that's actually a PostgREST 1000 truncation on the source query. The fix on the component is useless; the cause is 4 levels up.

## When a fix seems too simple

If the fix complexity is manifestly disproportionate to the observed symptom: **suspicious**.

```
Symptom: "the total displays $1200 instead of $2300"
Proposed fix: "UPDATE contacts SET total_amount = 2300 WHERE id = X"
```

Too simple. The real question: why is total_amount stored and out-of-sync? If the answer is "field not refreshed," the correct fix is to migrate the field's category (Live instead of mis-classified Snapshot), not to correct 1 row.

## Widen before acting

**1 confirmed case of a pattern → grep the complete pattern** in DB or code before correcting.

```sql
-- If "S. has banned status while still subscribed",
-- search the complete pattern:
SELECT * FROM contacts
WHERE status = 'banned'
  AND id IN (SELECT contact_id FROM subscriptions WHERE status = 'active');
```

Typical lived case: an isolated case reveals 12 affected contacts, not 1. Without widening, you "fix the reported case" and leave 11 drifts that will resurface at the next sync.

The cost of widening = 1 SQL query. The ROI is massive.

## Arbitrary cap in a comment

When a comment posits a constraint (`// parallel = OOM probable`, `// limit 200 sessions`, `// max 5 retries`): **treat as hypothesis to challenge**, not as established fact.

Especially if dated less than 48h ago: the justification is probably a workaround bias from the previous session, not an empirical finding.

When the cap comes back to bite in a subsequent project: dig, don't accept passively.

## Drift identified → scoped ticket

On diagnosis of a missing object (table, function, trigger, untracked migration):

- **DO NOT** chain `IF NOT EXISTS` or cascading `CREATE OR REPLACE`.
- **ASK**: "by what was this object created?"
- If the answer is "untracked migrations" or "manually created," it's a wide drift, not an exception.
- **OPEN** a scoped A/B/C/D ticket with explicit out-of-scope, accept red CI or temporary flag until clean resync.

The useful criterion: if the 1st patch reveals a 2nd missing object, it's a drift, not an exception. Stop and formalize.

## Assumed workaround vs silent workaround

A workaround is **legitimate** under 4 conditions:

1. Explicit commit message: "workaround," "assumed band-aid," "TODO root cause," or `[workaround-assumed]` tag
2. ADR or feedback memory reference documenting the debt
3. Calendar event or ticket for clean resolution
4. No adjacent scope creep: the workaround addresses exactly the symptom, no more

A **silent** workaround (without these 4 traces) = forbidden. It's blind debt that returns wearing a different mask.

## Adjacent refactor under cover of fix: forbidden

The fix scope is strict. If reading the code reveals another problem: **note it in a feedback memory or open a ticket**, don't fix it in the same commit. Scope creep dilutes diagnosis and prevents clean review.

Exception: if the bug *is* in adjacent code and the fix requires the modification, it enters scope explicitly and is documented as such.

## Dispersed rule → refactor + ADR

When the same invariant or rule is dispersed across multiple files or levels (TS + DB + comments): **complete refactor + ADR**, never minimal option that "fixes only where it hurts."

Typical case: a constant `SCHOOL_YEAR = '2025-2026'` hardcoded in 5 TS files. The correct fix is to centralize in `lib/constants.ts` and migrate the 5 occurrences. The minimal fix (correcting only the buggy occurrence) recreates the drift.

## Pre-fix-acceptance checklist

- [ ] Full input → output pipeline present in the discussion
- [ ] Root cause identified (not just symptom)
- [ ] Pattern widened (1 case → complete grep)
- [ ] If workaround: 4 conditions above respected
- [ ] No silent adjacent refactor
- [ ] If object drift: scoped ticket, not cascading patch
