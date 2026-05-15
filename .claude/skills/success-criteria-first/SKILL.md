---
name: success-criteria-first
description: Activate this skill when the user issues a brief in imperative form ("add X", "fix Y", "optimise Z"), when the implementation could be locked before the verification step, when the agent is about to "start coding" without stating what success means. The skill enforces a TDD-inverted discipline — state the verifiable success criterion in the same message as the brief, before any implementation.
---

# Success criteria first

A bug must be reproducible before being fixed. A feature must be testable before being written. A perf target must be measured before being optimised. The success criterion is stated **in the same message** as the implementation plan — never after.

This is the **a priori** half of axis 1 (material verification). The **a posteriori** half (proof in the same message as the claim) remains obligatory.

## Application rules

### Imperative → verifiable transformation

Every imperative brief is transformed into a declarative criterion before implementation:

| Imperative brief | Verifiable criterion |
|---|---|
| *"Add validation"* | *"Write tests for invalid inputs (empty, too long, malformed). They fail. Then make them pass."* |
| *"Fix the slow query"* | *"Reach p95 < 200 ms measured by EXPLAIN ANALYZE on 2 consecutive runs of the exact production query."* |
| *"Refactor for clarity"* | *"Reduce cyclomatic complexity from N to N/2 measured by a static analyser, with all existing tests still passing."* |
| *"Improve UX"* | *"Replace the modal with inline edit. Acceptance: a tester can complete the workflow without leaving the page."* |
| *"Sync data with vendor"* | *"After sync, `SELECT COUNT(*) WHERE ...` returns exactly N rows, where N is the source count."* |

If the brief resists transformation, the brief is itself the problem — it is a question dressed up as a command. Surface this and ask before implementing.

### Reproduce before fixing

Before fixing a bug:

```bash
# 1. Write the test that reproduces the bug
npm test -- failing-case.spec.ts
# Expected: fails (red)

# 2. Confirm the failure mode matches the report
# (read the error message, compare to user's description)

# 3. Implement the fix

# 4. Re-run the test
npm test -- failing-case.spec.ts
# Expected: passes (green)
```

No reproduction step = no proof the fix targets the actual bug.

### Strong vs weak criteria

A criterion is **strong** if a sub-agent can loop on it independently. Examples:

- *"Reach 0 ESLint warnings in `src/`"* — strong (binary, machine-verifiable)
- *"All tests pass"* — strong (binary, machine-verifiable)
- *"p95 < 200 ms over 100 requests"* — strong (measurable, threshold explicit)

A criterion is **weak** if validation requires human judgment at each iteration:

- *"Make it more elegant"* — weak (subjective, no termination)
- *"It works"* — weak (no acceptance test)
- *"Like before but better"* — weak (no reference)

Weak criteria force constant clarification and convert what should be a command-with-oracle (axis 8) into a question without oracle. Reformulate before delegating.

### When success-criteria-first does not apply

- **Pure question mode** (axis 8). When the brief is *"where am I blind here?"* or *"is X the right problem?"*, there is no implementation to verify yet — the criterion is the discovery itself. Skill suspended.
- **Exploratory probes** with informational goal. *"Show me the distribution of statut in contacts"* — the query is the deliverable. Skill suspended.

## Anti-complaisance checklist

Before any implementation:

- [ ] The success criterion is stated in the message preceding the implementation.
- [ ] The criterion is measurable (binary, numeric, or test-pass).
- [ ] For bug fixes: the reproducing test is written first.
- [ ] For perf: the metric, threshold, and measurement method are stated.
- [ ] For features: at least one acceptance test is defined.

## Sources

- multica-ai, `karpathy-guidelines/SKILL.md`: *"Transform tasks into verifiable goals: 'Add validation' → 'Write tests for invalid inputs, then make them pass.' Strong success criteria let you loop independently. Weak criteria require constant clarification."*
- Karpathy, *autoresearch* (2026): metric-driven loops (val_bpb < threshold) as canonical command-with-oracle pattern.
- SuperClaude_Framework, `confidence.ts`: 90 % confidence threshold computed from declared criteria, before execution.
- Counterpart Doctrine v0.4.1, axis 1 / R3 (material verification, *a priori* half).
- Counterpart Doctrine v0.4.1, axis 8 / R13 (discursive adversariality, command-with-oracle mode).
