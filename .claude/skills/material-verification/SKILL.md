---
name: material-verification
description: Activate this skill when an agent or the user claims "build green", "tests pass", "CI green", "drift", "contact not found", "all OK", "it works", or returns a number/count meant to be relayed to a human. Also on perf diagnostics (EXPLAIN ANALYZE) and 400/422 errors on external webhooks. The skill enforces production of material proof in the same message as the claim.
---

# Material verification

Every declarative claim about system state is presumed false until the proof is materialized in the same message.

## Application rules

### Build / CI / Tests

On claim "build green / tests pass / CI green": produce the executed command and its raw output (last 20 lines minimum). Without that, do not claim.

```bash
# Example: verify TypeScript build
npx tsc --noEmit 2>&1 | tail -20
```

For GitHub CI:

```bash
gh pr view --json statusCheckRollup -q '.statusCheckRollup[] | select(.conclusion != "SUCCESS")'
```

### Numbers and counts

Any number returned by an agent ("X contacts affected", "all Y impacted", "drift detected on Z") must be verified by SQL query before being relayed.

Pattern to apply:

```sql
-- Before saying "26 ancien contacts", verify:
SELECT COUNT(*) FROM contacts WHERE statut = 'ancien' AND ...;

-- Before saying "drift detected on course X", verify:
SELECT COUNT(*), COUNT(*) FILTER (WHERE contact_id IS NULL)
FROM emargements WHERE cours_id = '...';
```

Report the verified number, not the claimed number. If discrepancy, correct.

### Performance — EXPLAIN ANALYZE

On perf optimization: execute EXPLAIN ANALYZE **on the exact application query** (view, RPC, subquery included), not on the target table in isolation. Run 2 consecutive runs:

```sql
EXPLAIN (ANALYZE, BUFFERS) <exact query>;
-- Run 1 = potential cold start
-- Run 2 = real measurement
```

Don't conclude on a single run.

### External webhooks — 400/422

On error from an external partner: demand the **RAW payload** (URL-encoded, raw JSON, complete headers) before proposing a fix. No diagnosis on the form values formatted by the sender — they mask anomalies in case, spaces, encoding.

### IDE vs CLI

Diagnostics "Cannot find module", "Type X not assignable" appearing in the IDE panel without obvious cause: validate by `tsc --noEmit` CLI before any action. CLI = authority, panel = potentially stale.

## Anti-complaisance checklist

Before answering "OK looks good":

- [ ] The verification command is in the message
- [ ] The raw output is in the message (not a summary)
- [ ] If number: the SQL query and its result are in the message
- [ ] If perf: 2 consecutive EXPLAIN runs
- [ ] If webhook: the RAW payload is cited
