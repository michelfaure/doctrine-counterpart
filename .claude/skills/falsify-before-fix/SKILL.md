---
name: falsify-before-fix
description: >-
  Activate this skill before writing the fix code on a bug or incident, OR before posting an unverified claim of feature-future / residual limitation at the close of a session. Bug-side triggers: "fix", "bug", "patch", "hotfix", "workaround", "doesn't work", "diagnose", "hypothesis", "root cause", any commit subject in `fix:` / `hotfix:` / `bugfix:` on a production incident. Feature-future triggers: "V3-candidate", "v-suivante", "vN candidate", "next version will", "TODO:", "to-do:", "limite résiduelle", "residual limitation", "amélioration possible", "future enhancement", "à ajouter plus tard", "to be tested later", any "À suivre" / "Next steps" entry in a session log or PILOTAGE-IA draft. Distinct from `root-cause` (defensive checklist applied when *evaluating* a proposed fix): this skill is the invocable protocol the agent runs when it is about to *write* the fix OR *post* the unverified limitation. Enforces a single-sentence causal or descriptive hypothesis and three material probes designed to refute it before code is committed or claim is published. Operational instance of R4 *Falsify before fix* of the Counterpart Toolkit.
---

# Falsify before fix — invocable protocol

R4 of the toolkit states the five-step protocol textually. This skill is its invocable instance: what to run, in order, without skipping a step, when the agent is about to write fix code.

Companion to `root-cause` (which checks a proposed fix against the full pipeline). `falsify-before-fix` runs *upstream* of `root-cause`: it produces the hypothesis and the refutation evidence that `root-cause` then audits.

## Step 1 — Formulate the hypothesis in ONE sentence

A single sentence stating *the supposed cause*. Not a symptom — a cause.

- Bad: *"the segment counter is wrong"* (symptom)
- Good: *"the segment counter reads from `old_table` instead of `new_table` after the 12 May migration"* (cause)

If the hypothesis doesn't fit in one sentence, the diagnosis is still vague. Restart from a material observation (logs, error trace, exploratory SQL) before continuing.

## Step 2 — List three probes designed to REFUTE the hypothesis

Not to confirm. To **refute**. A confirmation probe is complaisance by construction (R4).

Each probe has three fields:

- **Tool** — SQL, grep, curl/API, file read, EXPLAIN ANALYZE
- **Question** — *"If the hypothesis holds, I expect X. What does reality say?"*
- **Refutation criterion** — *"If I see Y, the hypothesis falls."*

Example (cache invalidation suspected):

```
Probe 1 — SQL
  Q: SELECT updated_at FROM source_table WHERE id = N.
     If hypothesis holds, updated_at > cache_refreshed_at.
  R: If updated_at ≤ cache_refreshed_at, source is stale not the cache → hypothesis false.

Probe 2 — grep
  Q: grep -rn 'cache_invalidate' app/.
     If hypothesis holds, ≥ 1 call site on the relevant event.
  R: If zero, no invalidation code exists at all → different hypothesis.

Probe 3 — curl
  Q: GET /api/debug/cache-stats.
     If hypothesis holds, hit_rate ≈ 1.0 just before the bug.
  R: If hit_rate ≈ 0, cache is bypassed → hypothesis false.
```

## Step 3 — Execute the three probes and report raw output

Raw output, not paraphrased (R1). If a probe returns ambiguous output, cite it as-is — do not interpret in favour of the hypothesis.

## Step 4 — Decision

- **No probe refutes** → proceed to the fix. The fix can be written.
- **At least one probe refutes** → restart at step 1 with a new hypothesis. No fix as long as the hypothesis is not falsifiable and unrefuted.
- **Ambiguous probes** (neither clear refutation nor confirmation) → observation is insufficient. Design a fourth sharper probe before coding.

## Step 5 — If fix: the output includes

- The retained hypothesis (1 sentence)
- The three probes executed with raw output
- The fix diff
- The post-fix observation criterion (*"if X returns to Y, the fix holds"*)

## Feature-future variant — claims of residual limitation

The same protocol applies when, at the close of a session (or anywhere else), the agent is about to *post* a claim of the form:

- *"V3 candidate: extend the gate to `git commit --amend`"*
- *"Residual limitation: the parser does not handle nested quotes"*
- *"À suivre: l'amend n'est pas couvert par V2"*
- *"TODO: the cache invalidator probably misses event X"*

Each of these is a hypothesis about a feature / system / regex behaviour that is not yet tested. Posting it without a probe is exactly the failure mode the doctrine condemns under R1 (*existence is not verified state*). The cost is doubled because such a claim typically survives until the next session, where it triggers code-writing on a hypothesis that may be false — wasting hours.

Apply the same five steps:

1. **Hypothesis in one sentence** — *"The gate regex `git[[:space:]]+commit([[:space:]]|$)` does not match `git commit --amend`."*
2. **Three refutation probes** — for a regex claim: `for v in "git commit --amend" ...; do grep -qE 'regex' <<< "$v"; echo $?; done`. For a parser claim: feed three nested-quote samples to the parser and observe the output.
3. **Execute, raw output in the same message.**
4. **Decision** — if any probe refutes, the claim is false. Do not post it. If all probes are consistent with the hypothesis, post it WITH the probe output appended, tagged `[verified <date>]`.
5. **If posting** — the published claim includes the probes that survived. An unverified claim never reaches `docs/sessions/*.md` or `PILOTAGE-IA.md` without the `[unverified]` tag.

This applies in particular to the *À suivre* / *Next steps* section of session logs produced by `/close-session`. The closure of a session is statistically the moment of production of weak claims (fatigue + need to "wrap up cleanly"); this section is a risk zone, not a free-form notebook.

## When NOT to invoke this protocol

The protocol costs roughly 5-10 minutes. The cost is not justified for:

- Renaming a variable, fixing a typo, formatting
- Adding an optional field to a form
- Copy / content editing
- Doc, memory or ADR update
- Creating a new file from scratch (not a fix, a creation)
- Proposing a genuinely new feature for which there is no claim of pre-existing limitation (a feature spec is a brief, not a hypothesis to refute — use `success-criteria-first` instead)

The protocol is mandatory whenever there is a word *"bug"*, *"fix"*, *"doesn't work"*, *"unexpected behaviour"*, *"diagnose"*, or an incident surfaced by error monitoring (Sentry, log aggregator, alerting) — OR when an unverified limitation / V-candidate / TODO is about to be posted in a session log or in `PILOTAGE-IA.md`.

## Why refutation, not confirmation

A confirmation probe finds what it was looking for, by selection. Three confirmation probes on the same hypothesis produce mutual reinforcement, not evidence. A refutation probe is the only one that can return a genuinely *new fact* — and the only one that breaks the fix-first reflex when the first plausible cause is wrong.

Empirically, the cost of one fix-then-rollback cycle (typically 30-90 minutes plus a misleading commit) dominates the 5-10 minute cost of three probes. The protocol pays for itself on the first incident where the first hypothesis was wrong.
