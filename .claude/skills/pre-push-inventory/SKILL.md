---
name: pre-push-inventory
description: Activate this skill before any `git push` on a long-running branch (default branch, shared feature branch, release branch). Triggers on "git push", "deploy", "ship", "merge to main", "release", "publish". Enforces explicit enumeration of the commits the push will send to the remote — not just the latest commit — and exhibition of the raw `git log origin/<branch>..HEAD` output in the same message as the push intent. Operational instance of R16 mechanism 1 *strictly non-overlapping material scope* of the Counterpart Toolkit, applied to the local git chain that builds up between pushes when multiple sub-agents commit in parallel.
---

# Pre-push inventory — invocable protocol

> **Status (v0.11, 2026-07-19): CLOSED in the author's living tier — kept as a repo example, no longer installed by default.** Promoted in v0.7 but never installed user-scope across three cycles (an Am.R1 gap: source existence ≠ live mechanism). Its bite surface is now covered by *enforcement*, which held where this declarative protocol never ran: the `public-repo-identity-guard` hook gates public pushes mechanically, and the Am.R2 in-flight-work scan covers the "what else is on this chain" question. Adopt it manually if your setup lacks those layers — the protocol below remains valid.

R16 of the toolkit states textually: *"Strictly non-overlapping material scope — each agent can modify only files/directories explicitly listed in its prompt."* This skill extends that mechanism to a related class: the local git chain that accumulates when multiple sub-agents (or a sub-agent + manual edits) commit in parallel, and where the next `git push` will send not just the latest commit but the entire ahead chain.

Companion to `material-verification` (raw output for build/test claims). `pre-push-inventory` runs *before* the push itself — it materially answers *"what am I about to send"*.

## Step 1 — Inventory the commits ahead

Before any `git push`, run these three commands in order and report their raw output:

```bash
git log origin/<branch>..HEAD --oneline
git diff origin/<branch>..HEAD --stat
git status --porcelain
```

The first command lists every commit that will be pushed. The second shows the file-level change summary. The third confirms there is no uncommitted working-copy change about to surprise the next reader.

If the first command returns more than one commit, **stop and inventory**: each commit must be explicitly recognised as intended to ship. A commit that is on `HEAD` because a sub-agent committed it locally without the parent noticing is exactly the class of incident this skill prevents.

## Step 2 — Verify each commit's intent

For each commit in the ahead list, answer matter-of-factly:

- **Intent**: feature being pushed? bugfix? doc? unrelated work that landed here by accident?
- **Migrations or external side effects**: is there a DB migration, env var change, or third-party config tied to this commit? Has it been applied?
- **Tests**: are the tests in this commit verified green by raw output (combined with `material-verification`)?

A commit that fails any of these is **not** ready to push as-is.

## Step 3 — Decide

- **All commits intentional and ready** → proceed to push. Cite the inventory output as evidence in the commit/PR description or session log.
- **One or more commits unintended** → isolate via feature branch:
  ```bash
  git checkout -b feat/<isolate> origin/<branch>
  # cherry-pick the intended commits
  git cherry-pick <hash1> <hash2>
  git push origin feat/<isolate>
  # Then fast-forward main:
  git push origin feat/<isolate>:<branch>
  ```
  This pattern (`git push origin <branch>:<target>`) is the under-used primitive that allows isolated pushes without destructive history rewrites.
- **Migration pending** → either apply the migration first (preferred for additive schema changes), or revert the commit locally and re-do via the standard migration discipline.

## Step 4 — Post-push verification

Immediately after `git push`:

```bash
git log origin/<branch>..HEAD  # should be empty
git log origin/<branch>~3..origin/<branch> --oneline  # remote saw the right commits
```

If the post-push log shows commits that weren't in the pre-push inventory, **investigate** — that's a sign of force-push, hook bypass, or branch confusion.

## When NOT to invoke this protocol

The protocol costs ~10-30 seconds. The cost is not justified for:

- Push of a single commit on a feature branch you fully control
- Push to a personal scratch branch (your own dev sandbox)
- First push of a new branch (no ahead chain by definition)

The protocol is mandatory when:

- **Pushing to default branch** (`main`, `master`, `trunk`)
- **Pushing to a shared branch** (release, staging)
- **Sub-agent committed locally in this session** — the chain may have grown beyond your awareness
- **Multiple parallel agents have been active** during the session — R16 territory

## Why the entire ahead chain, not just the latest commit

`git log -1` shows the latest commit. `git push` sends everything from the remote tip to `HEAD`. The asymmetry is what produces the silent incident: developer sees latest commit, push includes earlier ones the developer didn't write or didn't intend.

Documented incident 2026-05-19 (rembrandt Phase 2): a push titled *"SMS phone test override"* embarked an earlier sub-agent commit (Sprint 1 Agent B Backend) onto production without the corresponding database migration being applied. The breakage was avoided only because the surface impacted wasn't in the immediate user path — pure luck. Detection 10 minutes after push via `git log origin/main..HEAD` ran manually.

Empirical cost: 10-30 seconds per push to inventory. Empirical avoidance: a class of incidents whose median resolution cost is ~30 minutes (migration emergency apply + Slack notification + post-mortem).
