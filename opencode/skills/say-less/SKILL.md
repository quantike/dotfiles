---
name: Say Less
description: Strip comments that do not earn their place. A read-only reviewer censuses and judges, this skill applies accepted deletions in a worktree, then reports before/after counts, retained comments, and open flags. Use before opening a PR or when asked to clean up comments.
---

# Say less

Comments must earn their place: an invariant the repo mandates, a public
contract, a foreign constraint, or a justified suppression. Everything else is
deletion, and the code it papered over is a fix target.

## House rules

Read AGENTS.md at the repo root and every nested AGENTS.md covering the scope
before judging. House rules override the reviewer keep-list. Name conflicts in
the final report.

## Scope

The caller's files or diff. Otherwise the working-tree diff against the base
branch, default `main`. Beyond roughly 30 files, census one crate or
directory per subagent run and merge the reports.

## Steps

1. Spawn the `comment-nuke` subagent with the scope. Do not restate its
   keep-list; it reads AGENTS.md itself.
2. Audit its report. Restore a deletion only when the comment is protected by
   the keep-list or house rules. When a call is ambiguous, delete. Reject
   `MUST KILL` flags whose reason misreads the code.
3. Create a worktree on a branch named `say-less`, unless the caller already
   names one. Confirm the worktree sits on a branch before committing; a
   freshly created worktree can be in a detached-HEAD state, so `git switch
   -c` first when needed. Apply accepted deletions there, plus any trivial
   root-cause fix
   the reviewer justified (dead path, unneeded parameter, real API). One
   commit, following the repo's commit conventions. Never widen the scope
   beyond accepted findings.
4. For constraints that survived review, offer the cheapest in-scope encoding:
   a type, runtime check, test, or CI lint that makes the comment deletable.
   In repos with a deterministic simulator, prefer a scenario that fails
   without the constraint. Encoding changes behavior, so wait for approval.
   Deletion alone needs none.
5. Recount comments in scope with the same census method the reviewer used.
   That count is the after number.
6. Report:
   - Before, deleted, and after counts.
   - Retained comments: category counts for the routine keeps (public API
     docs, license headers, house-mandated); file:line and reason for every
     judgment keep (constraints, external-forced behavior, suppressions).
   - `MUST KILL` flags left open, one line each.
   - Encoding offers: made, accepted, pending approval.
   - House-rule conflicts found.
