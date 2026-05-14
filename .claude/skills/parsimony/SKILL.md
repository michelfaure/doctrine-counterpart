---
name: parsimony
description: Activate this skill when the agent or the user is about to propose an implementation that could be smaller, when a refactor adds abstraction layers, when error handling guards against scenarios that cannot happen, when configuration knobs are added "for flexibility", or when "let's make this generic" appears in the reasoning. The skill enforces an asymmetric simplification rule and lists forbidden anti-patterns.
---

# Parsimony

Reach 100 % of the success criterion with the minimum code that satisfies it. Every line beyond that is debt waiting to be paid.

Parsimony is **not shortcut**. Deleting code while preserving the invariant is parsimony. Deleting the test that proves the invariant is shortcut.

## Application rules

### The 50 % test

Before locking an implementation, run this thought:

> If I can reach 100 % of the success criterion with 50 % of the proposed code, I do that.

If you cannot reach the criterion with less, the size is justified. If you can, refactor before committing.

### Forbidden by default

- **Abstractions for single-use code.** A function called once, used in one place, with no scheduled second caller: inline it. Wait for the third caller to extract.
- **Configuration knobs nobody requested.** `options.timeout`, `options.retries`, `options.format`: each one is a parameter that must be tested, documented, and maintained. Default values only when explicitly required.
- **Error handling for impossible scenarios.** `try/catch` around code paths that cannot fail per type system. `if (x === null)` when the type signature forbids null. Each impossible-case guard hides the real assumption.
- **Speculative factoring.** "Let's extract this in case we need it later." Wait for the second case. Three lines repeated is preferable to a premature abstraction.

### Asymmetric simplification

> Improvement of zero behaviour with simpler code: keep the simplification.
> Improvement of zero behaviour with more complex code: reject.

Adapted from Karpathy's autoresearch directive: *"An improvement of ~0 but much simpler code? Definitely keep."* Same logic applies to refactors — a refactor that does not improve behaviour must at least reduce complexity, or it is debt.

### Anti-pattern detection

Flag these patterns immediately:

```ts
// Single-use abstraction
const buildUserPayload = (u: User) => ({ name: u.name, email: u.email })
// Used once:
sendEmail(buildUserPayload(user))
// → Inline. Save the abstraction for the third caller.

// Configuration knob nobody asked for
async function fetchData(url: string, options: { retries?: number; timeout?: number; cacheTtl?: number } = {}) { ... }
// Used once:
fetchData(url)
// → Drop the options object. Add knobs when a second call site requires them.

// Impossible-case guard
function reverse(s: string): string {
  if (s == null) return ''       // ← type signature forbids null
  return s.split('').reverse().join('')
}
```

## When parsimony does not apply

- **Domain-driven invariants** (axis 3 — taxonomy). A `CHECK` constraint at the DB level is not redundant with a TS check at the boundary: both express the same invariant in different regimes. Keep both.
- **Defence in depth** (axis 5). A workaround assumed + a probe + an ADR is not redundancy: each layer survives a different failure mode. Keep all.
- **Audit trail** (axis 7). Logging the path of a critical decision is not "extra code": it is the only evidence later that the decision happened.

Parsimony applies to the **scaffolding**, not the **invariants and the audit trail**.

## Anti-complaisance checklist

Before committing an implementation:

- [ ] The 50 % test was applied; if the implementation passed unchanged, the criterion is documented.
- [ ] No abstraction is single-use.
- [ ] No configuration knob is unused at any call site.
- [ ] No guard exists for a type-impossible case.
- [ ] No factoring is "for later".

## Sources

- Karpathy, *autoresearch* (2026), `program.md`: *"A 0.001 improvement that adds 20 lines of hacky code? Probably not worth it."*
- multica-ai, `karpathy-guidelines/SKILL.md`: *"No abstractions for single-use code. No flexibility that wasn't requested. If you write 200 lines and it could be 50, rewrite it."*
- SuperClaude_Framework, `PRINCIPLES.md`: *"Efficiency > verbosity."*
- Counterpart Doctrine v0.3, axis 5 (parsimony as qualification of a correct fix).
