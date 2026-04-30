---
name: data-taxonomy-single-source
description: Activate this skill when the user or an agent considers adding a stored column derived from other data, creates a schema migration, mentions "duplication", "synchronization", "cache", or adds a business constant (VAT rate, school year, threshold) in a file. Also on any irrevocable business invariant (terminal status, closed enum). The skill enforces the declaration of Live/Snapshot/Cache category and the refresher in the same commit.
---

# Data taxonomy and single source

Every stored value derivable from other data must be categorized explicitly. Duplication by negligence — without declared category — is forbidden.

## The three categories

### Live

The value must always reflect the current state of the system. No business reason to freeze.

**Implementation**: don't store. Read via SQL view `v_*` or query on the source.

Example:

```sql
-- ❌ DON'T DO
ALTER TABLE contacts ADD COLUMN nb_active_subscriptions integer;
-- This column will silently drift.

-- ✅ DO
CREATE VIEW v_contact_active_subscriptions AS
SELECT c.id AS contact_id, COUNT(s.*) AS nb
FROM contacts c
LEFT JOIN subscriptions s ON s.contact_id = c.id AND s.status = 'active'
GROUP BY c.id;
```

### Snapshot

The value must remain **frozen at the moment of a business event**. Modifying it retroactively = functional fault (history theft).

**Implementation**: store, never recompute. Document via SQL comment.

Typical examples: `applied_price` at registration day, `expected_amount` of a contractual schedule, `vat_rate` of an invoice.

```sql
COMMENT ON COLUMN registrations.applied_price IS
  'SNAPSHOT: price at registration day. Never recompute.';
```

### Cache

The value is derivable but expensive to compute on the fly. Storage accepted for performance, **provided** an explicit refresher is declared in the same commit.

**Implementation**: store + declare the mechanism. Three accepted mechanisms:

- `GENERATED ALWAYS AS (...)` — intra-row derivation
- `trg_*` trigger — on tables that feed the value
- Materialized view `mv_*` — with planned REFRESH (cron) or manual after bulk

Example:

```sql
-- Cache with refresh trigger
ALTER TABLE courses ADD COLUMN seats_taken integer DEFAULT 0;
COMMENT ON COLUMN courses.seats_taken IS
  'CACHE: refreshed by trg_registrations_sync_seats';

CREATE OR REPLACE FUNCTION fn_sync_seats_taken() RETURNS trigger AS $$
BEGIN
  UPDATE courses SET seats_taken = (
    SELECT COUNT(*) FROM registrations
    WHERE course_id = NEW.course_id AND status = 'active'
  ) WHERE id = NEW.course_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_registrations_sync_seats
AFTER INSERT OR UPDATE OR DELETE ON registrations
FOR EACH ROW EXECUTE FUNCTION fn_sync_seats_taken();
```

## Decision algorithm

For any new field that resembles a duplication:

1. **Must the value evolve with upstream data?**
   - No — frozen past event → **Snapshot**.
   - Yes — proceed to 2.

2. **Is on-the-fly computation acceptable performance-wise?**
   - Yes → **Live** (`v_*` view).
   - No — proceed to 3.

3. **What refresh mechanism for this Cache?**
   - Intra-row derivation → `GENERATED ALWAYS AS`.
   - Derivation from another frequent table → `trg_*` trigger.
   - Heavy derivation + intensive reading → `mv_*` matview.

If none of the three Cache implementations is tenable, the value shouldn't be stored — fall back to Live.

## Business constants

Any constant (school year, VAT rate, thresholds) hardcoded in multiple TS files = drift waiting. Centralize:

```typescript
// lib/constants.ts
export const ACTIVE_SCHOOL_YEAR = '2025-2026';
export const STANDARD_VAT_RATE = 0.20;
export const BATCH_TIMEOUT_THRESHOLD = 200;
```

Reject any dispersed hardcoded occurrence. Refactor + ADR if dispersed pattern identified.

## Cash vs accrual

If the project involves finance: never mix the two accounting axes in a view. Cash = when paid/received. Accrual = when invoiced/booked. Explicitly announce the axis in the title of the view or export.

## Irrevocable invariants

Terminal statuses (`banned`, `cancelled_transaction`), closed enums, values that must never go down: protect at DB level via CHECK constraint or trigger, not just in TS. Application code can be bypassed, the DB cannot.

## Pre-migration checklist

- [ ] L / S / C category explicitly declared in the commit
- [ ] If Cache: refresher declared in the same commit
- [ ] SQL `COMMENT ON COLUMN` documenting the category
- [ ] If invariant: protected at DB level, not just TS
- [ ] Business constant centralized if applicable
