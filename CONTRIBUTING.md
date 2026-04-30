# Contributing to the Counterpart Doctrine

This doctrine is at v0.2 — under empirical testing. Feedback is precious and will structure v0.3.

## If you're testing the doctrine on a project

The most useful feedback format follows the **three questions in the README**:

**(a) What did you actually load / use?**

Full or partial CLAUDE.md, which skills triggered, challenger agent invoked or not, hooks activated, doctrine.md read in full or in part.

**(b) What concretely changed in your practice?**

A decision taken differently, a bug avoided, useless friction, the net feeling (notable / marginal / negative).

**(c) Which axes can you name without rereading?**

Critical integration test: if the answer is weak (1-2 axes after 3 weeks), the loadable format has an intrinsic limit that v0.3 will need to address.

## Feedback formats

- **GitHub Issue** on this repo, tag `feedback-test-v0.2`
- **DEV.to comment** under the *Call for testing* article
- **Email** to the address listed on the GitHub profile

No required format. Three paragraphs is enough. Raw feedback (transcribed audio, voice notes) is welcome — polished writing isn't necessary.

## If you spot a bug or exposure

- **Bug in a bash hook**: open an issue with the hook's raw output + the command that triggered it.
- **Security flaw** (exposed token, secret-scanner regex too lax or too strict): private email first, then public issue after fix.
- **Anonymization miss** (a real proper name, an internal identifier that survived audit): immediate private email signal. Will be fixed without question.

## If you want to propose a patch

Pull requests welcome, but for v0.2 prefer **discussion issues** first. The doctrine is still forming — an isolated patch may conflict with a larger upcoming refactor.

Useful PR format:
- Short title
- Description: which axis / which skill / which rule is touched
- Justification: a concrete case that motivated the patch
- Test if applicable

## Substantive critique

The doctrine explicitly refuses four dominant positions (see `doctrine.md` — position section). Critiques on these choices are the most precious:

- Is *AI as counterpart* truly superior to *AI as tool* / *AI as colleague* in your experience?
- Is bidirectional adversariality practicable, or too cognitively costly?
- Is the Live/Snapshot/Cache taxonomy useful or over-engineered for a solo?
- Does long-term auditability hold, or rot in practice despite the invariants?

These questions will structure v0.3.

## Six open questions

See end of `doctrine.md`. Any empirical data, testimony, or argument that illuminates one of these six open questions accelerates their resolution:

1. What is the right dispositive for bidirectional adversariality?
2. What quantitative obsolescence criterion for an ADR?
3. Where does transversality stop, where does delegation to experts begin?
4. How to dose pedagogical friction?
5. How to address the bus factor of the AI-native solo?
6. What is the operational form of doctrine adoption?

---

*v0.2 — under CC-BY-4.0 — Michel Faure*
