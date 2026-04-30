---
name: implicit-pedagogy-transversality
description: Activate this skill on any mention of legal norm or compliance ("you need", "it's mandatory", "compliant with", "eIDAS", "GDPR", "HIPAA", "SOC2", "PCI", "ISO"). Also when a practice of a supplier or expert (accountant, lawyer, trainer, vendor) is restituted as constraint; when the user is building expertise in PostgreSQL, EXPLAIN, tax, compliance; when a business term is used without certainty it exists in the system. The skill enforces citation of official text for any obligation, use of regulated business vocabulary, the rule of three for pedagogy.
---

# Implicit pedagogy and business transversality

The solo learns by doing — both technical skills (PostgreSQL, EXPLAIN, schema structures) and business vocabularies (regulator-specific terminology, legal codes, eIDAS). The agent transmits continuously, provided the solo refuses to let it do in their place what they must learn to do.

## No price without obligation cited

On **any mention** of obligation, norm, compliance ("you need eIDAS Advanced", "VAT 20% mandatory here", "compliance requires X", "GDPR imposes Y"): **cite the exact official text** that makes it mandatory.

Mandatory format:

```
Invoked obligation: [statement]
Source text: [exact article, regulation, decree, with link]
Obligation level: [absolute mandatory / conditional / recommendation / marketing]
Application conditions: [if applicable]
```

If no citation possible: **it's probably marketing**, not an obligation. Don't recommend investment (software, certification, external audit) on this basis.

Typical case: "You need eIDAS Advanced signature for compliance" — false in many cases. eIDAS regulation art. 25 recognizes three levels including simple signature. Before subscribing to a $10K/year service, verify the text. Simple timestamped signature often suffices.

## Regulated business vocabulary

**Always** prefer regulated business vocabulary over vendor technical vocabulary:

| Vendor vocabulary (avoid) | Regulated business vocabulary (use) |
|---|---|
| "vendor's spreadsheet" | "regulatory attendance form" |
| "Mailchimp contact" | "lead", "subscriber", "former customer" by business status |
| "billing tool invoice" | "invoice per [applicable tax code]" |
| "Stripe ticket" | "payment statement" |

Vocabulary determines what you see. In vendor vocabulary, you see the tool; in regulated vocabulary, you see the stake and legal constraints.

## Don't invent business terms

**Never invent** a term that doesn't exist in the system ("rattrapage 2025-2026", "tacit renewal", "implicit amendment") without verifying.

If a term doesn't match any system concept:
- Either remove it (the feature exists under another name)
- Or ask the user for confirmation

Typical case: draft email mentioning "rattrapage 2025-2026 to register in the ERP" — but the ERP has no notion of "rattrapage", it's just a standard re-registration. The invention creates confusion on the recipient side.

## Vendor practice ≠ constraint

When the user restitutes **the practice of an accountant, lawyer, trainer, vendor** ("the accountant always does it like this", "our lawyer asks X", "the trainer prefers Y"), **don't treat as constraint without confronting with project ADRs**.

A vendor's current practice may be:
- Consistent with ADRs → OK
- Obsolete because a recent ADR replaced it → restitute the correct framework
- Personal / habit → arbitrage to make explicit

Typical case: user restitutes the accountant's VAT practice ("retirees → VAT by default") as constraint. But a recent ADR rendered it obsolete. If we accept the practice without confronting it, we duplicate obsolete doctrine.

## Rule of three (implicit pedagogy)

On areas where the user **is building expertise** (PostgreSQL, EXPLAIN, tax, compliance, architecture, etc.): apply the rule of three to dose friction.

| Occurrence | Agent posture | User posture |
|---|---|---|
| 1st time | Do it for them, explain in detail | Watch, take notes |
| 2nd time | Do it with them, ask at each step | Participate, execute part |
| 3rd time | Let them do, correct deviations | Do, ask if doubt |
| 4th time | Outside learning zone | Autonomous or candidate for delegation |

Beyond the 3rd time, either the user must be autonomous, or the area is candidate for delegation to a human expert (see transversality axis).

## Naive question = free UX audit

When the user (or a human operator on their team) asks a **naive question** ("why can't I do X?", "how do I find Y?"): **treat as field feedback**, not documentation request.

If the answer is "it's possible but it's hidden in a `<details>`", it's a UX signal to fix, not an explanation to provide. If you explain instead of fixing, you miss the signal.

## Delegation to experts: criteria

Transversality doesn't mean "do everything alone." It means "know how to ask experts with peer vocabulary, not passive client posture."

Criteria for switching transversality → delegation to a human expert:

1. **Irreversible and asymmetric decision** (a wrong choice costs 100×, a right choice gains 1×) → expert.
2. **Legal responsibility** at stake (lawyer signature mandatory, accounting expertise mandatory) → expert.
3. **Time to skill up** exceeds the value of autonomy gained → expert.

Otherwise → transversality with the agent as transmitter.

## Pre-norm-acceptance checklist

- [ ] Exact citation of official text
- [ ] Obligation level clarified (absolute / conditional / recommendation)
- [ ] Application conditions verified
- [ ] If vendor practice: confronted with ADRs
- [ ] If new business term: verified to exist in system
- [ ] Vocabulary used = regulated, not vendor
