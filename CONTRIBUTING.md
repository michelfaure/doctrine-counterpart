# Contributing to the Counterpart Doctrine

The doctrine's current version lives in the header of [`CLAUDE.md`](./CLAUDE.md) (the Live norm); the full version trail and release notes live in [`calibration-ledger.md`](./calibration-ledger.md). Feedback is precious and will structure the next cycle — calendar-uncommitted, paced by accumulated empirical material rather than fixed dates.

## If you're testing the doctrine on a project

The most useful feedback format follows the **four questions in the README**:

**(a) What did you actually load / use?**

Toolkit `CLAUDE.md` full or partial, which skills triggered, challenger agent invoked or not, hooks activated, `manifesto.md` read in full or in part.

**(b) What concretely changed in your practice?**

A decision taken differently, a bug avoided, useless friction, the net feeling (notable / marginal / negative).

**(c) Which of the 17 live rules can you name without rereading?**

Critical integration test: if the answer is weak (1-5 rules after 3 weeks), the loadable format has an intrinsic limit the next cycle will need to address.

**(d) Which rule is missing for your stack?**

Candidates for the next cycle. The full version trail — how the doctrine grew, amended, and retracted from v0.2 on — lives in [`calibration-ledger.md`](./calibration-ledger.md); real practice may reveal what the nineteen rules still miss.

## Feedback formats

- **GitHub Issue** on this repo, tag `feedback-test`
- **DEV.to comment** under the relevant arc-2 article
- **Email** to the address listed on the GitHub profile

No required format. Three paragraphs is enough. Raw feedback (transcribed audio, voice notes) is welcome — polished writing isn't necessary.

## If you spot a bug or exposure

- **Bug in a bash hook**: open an issue with the hook's raw output + the command that triggered it.
- **Security flaw** (exposed token, secret-scanner regex too lax or too strict): private email first, then public issue after fix.
- **Anonymization miss** (a real proper name, an internal identifier that survived audit): immediate private email signal. Will be fixed without question.

## If you want to propose a patch

Pull requests welcome, but prefer **discussion issues** first. The doctrine is still actively decanting — an isolated patch may conflict with a larger upcoming refactor or the next falsification cycle.

Useful PR format:
- Short title
- Description: which rule (R1–R19) / which skill / which hook is touched
- Justification: a concrete case that motivated the patch
- Test if applicable

## Counter-examples to the singularity hypotheses

The manifesto lists five hypotheses where the doctrine appears singular within the three audited public frameworks (Karpathy's *autoresearch*, multica-ai Karpathy-skills, SuperClaude). Any documented counter-example from another framework (Aider, Cursor, OpenHands, Devin, Cline, Continue, RooCode, or others) is welcome via GitHub issue tagged `[singularity-counter-example]`. The next falsifiability filter (end of arc 2, October 2026) will integrate every documented counter-example.

## Substantive critique

The doctrine explicitly refuses four dominant positions (see `manifesto.md` — Preface section). Critiques on these choices are the most precious:

- Is *AI as counterpart* truly superior to *AI as tool* / *AI as colleague* in your experience?
- Is bidirectional adversariality (R4) practicable, or too cognitively costly?
- Is the Live/Snapshot/Cache taxonomy (R6) useful or over-engineered for a solo?
- Does long-term auditability (R13) hold, or rot in practice despite the invariants?

These questions will structure the next cycles.

---

*Under CC-BY-4.0 — Michel Faure*
