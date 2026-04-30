# Counterpart Doctrine

> A stack that prevents Claude Code from lying to you. For solo developers shipping production code without a human PR reviewer.

## The problem

You're coding alone with Claude Code on a non-trivial project. This month, probably:

- Claude told you "build green, let's push" while CI was red on pre-existing tests — and you believed it without asking for raw output.
- You accepted a fix that "seemed to fix the bug." The bug came back six days later wearing a different mask, and you'd forgotten encountering it.
- You added a derived column to your DB, never refreshed, now silently drifting with no probe to tell you.
- You pushed back with "are you sure?" and the agent changed its mind without bringing you a single new fact.

No human PR reviewer to catch it. No peer to challenge. And no desire to become paranoid about every line. This stack addresses exactly these patterns.

## What you see in the first session

Once installed, here's what changes immediately:

- You write "build green" to Claude → Claude requires `tsc --noEmit` + raw output in the same message before validating.
- You commit a message containing `fix`/`hack`/`workaround` without explicit assumption → a hook blocks and demands `[workaround-assumed]` or an ADR reference.
- You push to `main` without `[deploy-ok]` in the last commit → blocked, forces conscious re-verification.
- You add a derived column → an auto-invoked skill demands the *Live / Snapshot / Cache* category and refresher in the same commit.
- You take a structurally significant decision (ADR, pattern, model switch) → you can invoke the challenger agent which produces objections + empirical tests + confidence 0-10.
- You commit a file containing a plaintext secret (API key, token, JWT) → blocked, unless explicit `[secret-ok]` bypass.
- You re-open Claude Code after 90 days without memory audit → automatic reminder at session start.

Seven invariants, materially enforced. No discipline to maintain mentally — the stack does it for you.

## Installation

```bash
git clone https://github.com/michelfaure/doctrine-counterpart.git
cd doctrine-counterpart
./install.sh /path/to/your/project
```

The script is interactive: it copies `CLAUDE.md` (with merge prompt if you already have one), installs the 7 skills + challenger agent, asks if you want to activate the 4 enforcement hooks.

Hook prerequisite: `jq` (`brew install jq` on macOS).

Uninstall: delete `CLAUDE.md` and the `.claude/` directory from the target project. No persistent side effects elsewhere.

## Architecture — 4-layer stack

| Layer | File | Effect | Activation |
|---|---|---|---|
| Human | `doctrine.md` | Intellectual framework, read to understand | Reading |
| Agent prior | `CLAUDE.md` | Orients Claude Code from session start | Auto |
| Activatable rules | 7 skills + challenger agent in `.claude/` | Auto-invoked on triggers (precise keywords) | Auto / manual for challenger |
| Material enforcement | 4 bash hooks in `.claude/hooks/` | Block commit/push if invariants violated | Optional, activated via `install.sh` |

**Without the hooks**, the stack orients without constraining — Claude can follow the rules or forget them under context-length pressure.

**With the hooks**, certain critical invariants (assumed workaround, explicit deploy, secrets, memory audit) become materially enforced. Every hook has a documented explicit bypass mechanism. They never modify code silently — they only block or warn.

## The 7 operational axes

See `doctrine.md` for the full prose. One-line summary per axis:

1. **Material verification** — every agent claim is presumed false until materialized as proof in the same message.
2. **Bidirectional adversariality** — both agent and solo are sycophantic; robust decisions are fabricated through third-party protocol, not soft dialogue.
3. **Data taxonomy** — Live / Snapshot / Cache mandatory for any derivable stored value. Silent drift forbidden.
4. **Session discipline** — ADR before code, phase-0 exhaustive grep, FIFO open projects, calendar event for self-validation post-deploy.
5. **Root cause, not patch** — workaround legitimate *only if explicitly assumed*; silent workaround forbidden.
6. **Implicit pedagogy and business transversality** — learn by doing, regulated business vocabulary, no price without obligation cited.
7. **Long-term auditability** — ADR + session logs + MEMORY index + mandatory quarterly audit. The doctrine applies to itself.

## Central concept

*AI as counterpart* — neither tool (master-instrument verticality), nor colleague (naive anthropomorphic horizontality), but **partner of a hybrid arrangement where each actor forms the other**. The solo forms the agent through memory, ADR, feedback, doctrine. The agent forms the solo through questions, challenges, imposed methodology, transmission of technical skills. Productive asymmetry, not symmetry.

For intellectual development: `doctrine.md`.

## Test request

This doctrine is at **v0.2**. It has not been empirically tested at scale before this publication — this is precisely the test. If you install it, I'm waiting for your feedback within 2-3 weeks, free format, via GitHub Issue or DEV.to comment.

Three targeted questions (see `CONTRIBUTING.md` for detailed format):

**(a) What did you actually load / use?**
Full or partial CLAUDE.md, which skills triggered, challenger agent invoked or not, hooks activated, doctrine.md read in full or in part.

**(b) What concretely changed in your practice?**
A decision taken differently? A bug avoided? Useless friction? Effect *notable*, *marginal*, or *negative*?

**(c) Which axes can you name without rereading?**
Without reopening the file — how many of the 7 axes can you list? This metric measures whether the doctrine has been **integrated** (you think of it spontaneously) or merely **consulted**. This is the most important test.

**Additional question for users of Cursor / Codex / Aider / Cline**: the v0.2 stack was designed for Claude Code (auto-invoked skills, Claude-specific hooks, sub-agents). The `doctrine.md` + `CLAUDE.md` layer remains portable, but the operational mechanisms assume Claude Code. **If you use another client, tell me what was missing.** v0.3 will have a universal layer (native git hooks + portable compacted doctrine) if demand is there.

Three paragraphs is enough.

## Honesty disclaimer

- v0.2 not empirically validated at scale before publication.
- Strong efficacy expected on axes 1, 3, 5 (clear rules, triggerable). More variable on 2, 4, 6. Deferred on 7 (utility visible at 6+ months).
- Six open questions remain to be settled (see end of `doctrine.md`). Your feedback can shift each of them.
- If the doctrine doesn't work for you, say so. Negative feedback is more useful than polite silence.

## License

[CC-BY-4.0](LICENSE) — free use, modification, and redistribution with attribution.

Suggested citation:

> Faure, M. (2026). *Counterpart Doctrine — a manifesto for the AI-native solo developer*.
> Available under CC-BY-4.0 at https://github.com/michelfaure/doctrine-counterpart

## Links

- Full manifesto: [`doctrine.md`](doctrine.md)
- Feedback format: [`CONTRIBUTING.md`](CONTRIBUTING.md)
- License: [`LICENSE`](LICENSE)

---

*Michel Faure — April 2026*
