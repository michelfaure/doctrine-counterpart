# Counterpart Doctrine — a manifesto for the AI-native solo developer

*Version 0.2 — April 2026*

---

## Position of the text

This doctrine addresses **practitioners conscious of the human-agent dialogue**: entrepreneurs and CEOs who want to recognize the quality of AI-native work without suffering it or celebrating it naively, semi-pro solo developers seeking to structure their practice, and anyone who simultaneously pilots and executes a substantial project with an agent like Claude Code.

It is **both an operational framework and a model of thought**. Operational, because it loads into a project — a markdown file the reader can integrate into their `CLAUDE.md`, whose application directly changes the quality of what their agent produces. Theoretical, because it offers an articulated grammar for understanding what plays out in a human-agent dialogue, applicable beyond code, all the way to anthropological analysis of other practices. The format aims at the manifesto: every technical rule carries its theoretical charge, every theoretical thesis produces a rule. Neither layer precedes the other, neither is decorative.

The central concept around which the rest is structured is **AI as counterpart**. Neither tool (master-instrument verticality, the position of "AI as tool" advocates), nor colleague (naive horizontality, the anthropomorphic projection of "AI as colleague" advocates), but **partner of a hybrid arrangement where each actor forms the other**. The solo developer forms the agent through memory, ADRs, feedback, doctrine — persistent layers that orient its outputs. The agent forms the solo through questions, challenges, imposed methodology, departures from comfort zones — but also through direct transmission of skills from other trades, foremost among them development itself. A structured technical-foundations roadmap built by the agent is a concrete example: targeted exercises (PostgreSQL reading, schema structures, EXPLAIN ANALYZE) through which the solo gains autonomy of reading and judgment. **Pedagogy is implicit: one learns by doing, on real work, not on a detached course.** Horizontality is not symmetry: it is asymmetry of a different kind — the solo has embodied temporality (continuity of identity, fatigue, lived memory), the agent has instantaneous invariance (no mood drift, no progression between sessions without a dispositive). The pair produces what neither alone could. This is what actor-network theory (Latour, Callon) calls an *assemblage*: singularity emerges from the arrangement, not from the individual terms.

This doctrine explicitly refuses four currently dominant positions:

— **Against agent autonomy.** For the solo, the autonomous agent is a trap. It amplifies drifts without control, and the solo loses their only asset — material verification. The agent must be reined in to remain useful.

— **Against declarative trust.** Every declarative claim by an agent ("build green," "tests pass," "drift detected," "contact not found") is presumed false until materially verified by raw output, SQL count, or visual rendering. The burden of proof is inverted relative to dominant usage.

— **Against domain specialization.** The AI-native solo thrives in transversality. The real work is not domain knowledge — which can be acquired in weeks with an agent — but dialectical engagement with the agent on arbitrary business processes. The doctrine takes years to learn; it reuses on any terrain.

— **Against bidirectional complaisance.** The agent is sycophantic (sycophancy documented by Anthropic and the research). The solo is too, toward their own work (self-validation, confirmation bias, attachment to the first formulation). The doctrine imposes **bidirectional adversariality**: the agent challenges the solo, the solo challenges the agent, and a third-party protocol (parallel sessions, blank context, quantified confidence) decides.

The **success criterion** is testable. This doctrine will have succeeded the day another practitioner — semi-pro solo dev, entrepreneur, informed CEO — loads it into their project, ships a non-trivial module at comparable or better quality than they did before, and **names in their feedback** the axes of the doctrine that made the difference. No views, no audience as a metric. The operational adoption of a file as an artifact that changes outcomes.

---

## The seven operational axes

### Axis 1 — Material verification

**Thesis.** No declarative claim by an agent has evidentiary value. Only raw output, SQL count, EXPLAIN ANALYZE, visual rendering count as proof. The burden of proof is inverted relative to dominant usage: the solo presumes any claim false until materialized.

**Trade-off against the alternative.** The credible alternative is pragmatic declarative trust — accept what the agent says by default, verify only suspicious cases. A defensible and widely adopted position: verifying everything = paralysis, modern models are reliable 90% of the time, systematic friction kills the velocity that justifies AI use in the first place. This is the philosophy of dominant tools (Cursor, Devin, Copilot Workspace): autonomous agent + downstream human review at PR time.

The solo has no downstream PR reviewer — the solo *is* the PR reviewer. If verification isn't done in real time by them, it isn't done by anyone. The velocity trade-off is a long-horizon lie: the debt of undetected errors costs 10× what was gained 18 months later. The more asymmetric the consequence (a false negative costs little, a false positive much), the more systematic verification must be. For the solo, material verification isn't an architectural option — it's the survival condition of production.

### Axis 2 — Bidirectional adversariality

**Thesis.** Complaisance is bidirectional. The agent is sycophantic by construction (RLHF), the solo is self-validating by humanity (confirmation bias, attachment to first formulation). The robust decision is fabricated through third-party protocol — parallel sessions, blank context, quantified confidence — not soft dialogue. The solo challenges the agent, the agent challenges the solo, an external dispositive decides.

**Trade-off against the alternative.** The alternative is open dialogue and mutual trust — the humanist position, cognitively cheaper, cultivating a cooperative mode judged more productive. The suspicion projected onto the agent costs you cognitively; authentic trust between humans holds well, why not imitate it?

Because authentic trust between humans holds thanks to *friction* of interests: each has their own agenda, reputation, time to defend. The agent has no proper interests, hence no natural friction, hence no basis for robust trust. Without a human peer in the loop, open dialogue with a sycophantic agent *systematically* produces complaisant decisions — it's mechanical, not affective. Bidirectional adversariality is not a moral posture, it's the mechanic that produces the missing intersubjectivity. You manufacture friction by protocol.

### Axis 3 — Data taxonomy and single source

**Thesis.** Every stored value derivable from other data must declare its nature: *Live* (computed on the fly, never stored), *Snapshot* (frozen at a business event, never retroactively recomputed), or *Cache* (stored for performance, with an explicit refresher declared in the same commit). Every dispersed rule is a drift waiting to happen. Every irrevocable business invariant must be protected at the DB level, not just in TypeScript.

**Trade-off against the alternative.** The alternative is tolerated synchronization — duplications allowed with periodic sync scripts, point fixes when drift is detected. Faster to code, more flexible, doesn't constrain architecture with rigid invariants. Eventual-consistency position: in modern distributed systems, transient drift is accepted in the name of performance and resilience.

For the solo, silent drift isn't detected in time — there's no team developer who one morning notices the divergence. The *Live / Snapshot / Cache* taxonomy is more precise than naive "single source": it acknowledges that not all duplications are illegitimate, but that none should exist without a **declared coherence contract**. Precision is what saves: the solo who strictly adopts "single source" blocks legitimate Caches; the solo who adopts "tolerated synchronization" suffers silent drift. The taxonomy decides between the two and provides the vocabulary that prevents ambiguity.

### Axis 4 — Session discipline

**Thesis.** The AI-native solo structures work before writing, archives while working, closes cleanly before moving on. ADR before code on any project > 2 files. Phase 0 exhaustive grep of existing symbols before any spec. Lots whose recap fits in 5 lines. Strict FIFO on open projects. Calendar event for self-validation post-deploy when effects manifest at D+1/D+2. Organizational friction saves hours of catch-up.

**Trade-off against the alternative.** The alternative is flow and vibe coding — organizational friction kills creativity, good code emerges from flow, ADR before code = bureaucracy that stifles invention. The startup move-fast position: ship first, formalize later. A position defended by the entire lean culture.

For the AI-native solo, velocity is no longer the bottleneck — the agent produces 1000 lines in 10 minutes. The bottleneck has shifted to your capacity to **find why you took a decision 3 months ago**. Session discipline is no longer an opportunity cost against creativity — it's an investment in your external memory, and it's what allows the solo to *remain solo* without becoming captive to their undocumented past.

### Axis 5 — Root cause, not patch

**Thesis.** Before any fix, identify the root cause. A workaround is legitimate *provided it is explicitly assumed* (commit message, ADR, feedback memory). It is the absence of explicit assumption that is forbidden, not the workaround itself. Widen before acting: 1 confirmed case → grep the complete pattern. Drift identified on an object → scoped ticket, not cascading patches. Dispersed rule → complete refactor + ADR, never minimal option.

**Trade-off against the alternative.** The alternative is the shortest fix that resolves the observed symptom. Pragmatic position: you can't redesign the system at every bug, the well-placed patch frees time for real work, root cause is a luxury. YAGNI position: digging deeper than necessary = over-engineering.

The AI-native solo lacks the team memory that allows tracking 3 recurrences of the same bug. A workaround placed without explicit assumption returns with a different face 6 months later, and the solo will have forgotten encountering it. The agent won't remind them — it has no long-term cross-session memory without a dispositive. So either dig now, or pay three times.

### Axis 6 — Implicit pedagogy and business transversality

**Thesis.** The solo learns by doing — both technical skills (PostgreSQL, EXPLAIN, schema structures) and business vocabularies (regulator-specific terminology, regulatory codes, compliance frameworks). The agent transmits continuously, provided the solo refuses to let it do in their place what they must learn to do. Regulated business vocabulary > vendor technical vocabulary. No price without obligation cited — every mention of a norm verifies by citation of the exact text.

**Trade-off against the alternative.** The alternative is domain specialization + delegation to experts. Classical position: the solo is a developer, not a fiscal expert. For tax, you call an accountant. Division of labor = an organizing principle of economies since Adam Smith. Wanting to master everything = bad allocation: better to be excellent in one domain than mediocre in ten.

The agent transmits in the course of real work — near-zero marginal cost to become competent in PostgreSQL while optimizing an RPC, in eIDAS while framing an electronic timestamp. Specialization-by-division-of-labor held in an economy where knowledge was costly to mobilize. In an economy where it can be mobilized on demand, the AI-native solo no longer specializes *by discipline* but *by posture* — being the one who knows how to ask the agent what needs to be known when it comes up, and who can challenge the human expert with vocabulary sufficient not to suffer them. Delegation to experts remains useful in high-stakes zones, but it happens with peer vocabulary, not passive client posture.

### Axis 7 — Long-term auditability

**Thesis.** The solo's individual memory is insufficient. The archive — ADR, session logs, MEMORY.md, doctrine itself — is the external organ that holds them, provided it is itself audited regularly. Mandatory quarterly audit: re-read the memory index line by line, ask for each entry "is this still true?". ADRs with > 30% obsolescence at 12 months = research in progress, not stable doctrine. The doctrine applies to itself.

**Trade-off against the alternative.** The alternative is individual memory + git history — git log + good commit messages suffice, the classical engineering position. ADRs are ceremony that will become obsolete. Maintaining archived artifacts (ADR, sessions, MEMORY) = double work that ends up rotting if not audited. Move-fast position: readable code + clean git history is more durable than a documentation cathedral.

Git history answers *what was changed* — not *why*. For the solo, the why exists only in their head, hence nowhere outside, hence lost upon fatigue, vacation, or context shift. ADRs and session logs are the external organ that makes the solo truly solo: capable of functioning 12 months later without reconstructing their reasoning. The rot risk is real — that's precisely why the **quarterly audit** isn't optional but invariant: memory that isn't audited rots, but memory that is audited remains an asset. Without this axis, the other six dissolve into oblivion.

---

## Open questions for v0.3

A mature doctrine lists its uncertainties. Six points remain to be settled empirically before v1 freeze.

**1. What is the right dispositive for bidirectional adversariality?** Known variants: subagent challenger invoked manually, two parallel Claude Code sessions, PostToolUse hook, custom agent SDK with heterogeneous model. Critical sub-question: does model heterogeneity change the game? A Claude-Opus challenger against a Claude-Opus proposer shares 90% of cognitive biases; a Gemini or GPT challenger would break sycophancy more. Test to run over 4-8 weeks.

**2. What is the quantitative obsolescence criterion for an ADR?** The 30% obsolescence-at-12-months threshold for distinguishing stable doctrine from research-in-progress is plausible but empirically unvalidated. The real number probably sits between 15% and 40%, and varies by domain.

**3. Where does transversality stop, where does delegation to experts begin?** Competing hypotheses: delegation when the decision is irreversible and asymmetric (a wrong choice costs 100×); delegation when legal responsibility is at stake; delegation when the cost of skilling up exceeds the value of autonomy gained. Likely a combination of the three.

**4. How to dose pedagogical friction?** The agent must not do in the solo's place what the solo must learn to do. But the threshold isn't operational. Working hypothesis: the rule of three. First time: agent does it for them, solo watches. Second time: agent does it with them, solo participates. Third time: solo does it, agent corrects. Beyond that, either the solo is autonomous, or the zone is a candidate for delegation.

**5. How to address the bus factor of the AI-native solo?** The doctrine makes the solo more solo. It doesn't explicitly address bus factor: if the solo stops, the project stops. Structural question: is this out of scope, or should the doctrine prescribe an operational dimension of transmissibility?

**6. What is the operational form of doctrine adoption?** Does a single loadable markdown file suffice? Does it require a complete stack (CLAUDE.md + skills + challenger agent + hooks)? The form directly conditions adoption — but also rigidity. Empirical testing distinguishes what truly changes outcomes.

---

*Doctrine v0.2 — subject to revision in v0.3 after empirical testing.*
