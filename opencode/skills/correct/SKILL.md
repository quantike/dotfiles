---
name: Correct
description: Make repeated agent mistakes impossible in this repo. Mines corrections, reverts, and review comments for mistake classes, fixes each at the highest level that works (architecture, types, lint, test, docs last), proves every check on a real past mistake, and keeps the rule table in AGENTS.md. Use when the same correction happens twice, a review comment repeats, or the operator asks to harden the repo.
---

# Correct

The operator keeps correcting agents in this repo for the same mistakes.
Change the repo so the next agent cannot make them.

Assume every contributor is an agent that sees only the files it opened,
copies the nearest example, and takes the shortest path that compiles. Design
the repo so a change that looks right from one file is right for the whole
repo.

## Find the mistake classes

Read recent commits, reverts, review comments, agent instruction files, and
comments that explain workarounds. Group the mistakes into classes. A class
counts once it has happened twice. When the list is long, ask the operator
which classes hurt most.

## Fix each class at the highest level that works

1. Eliminate it with architecture. Give each piece of state one owner and
   each task one supported way. Hide internals so the wrong import fails.
   Replace hand-synced lists with one source of truth. Delete dead code an
   agent would copy.
2. Enforce it with types so the bad state cannot be written. If bad code
   still compiles, add a lint or CI check whose error names the file, type,
   or function to use instead. If the pattern is already common, fail only
   when a change adds more of it.
3. Test the behavior. Fix or delete any test that still passes when the
   behavior it checks breaks, or that fails when only internals change. In
   repos with a deterministic simulator, the check is a scenario that fails
   without the fix.
4. Write docs or agent rules last, and only for judgment calls. Nothing
   fails when an agent skips them.

## Prove it

Every new check must fail on a real past mistake. Run the proof locally,
then in CI. A check that passes on both the old code and the new code checks
nothing. Run the repo's gate (`make check`, `make gate`, or the repo's
equivalent) before reporting done.

Fix the most frequent classes first, one class per commit, in a worktree on
a branch. Confirm the worktree sits on a branch before committing; a
freshly created worktree can be in a detached-HEAD state. Exceptions go on
the offending line with a reason, an expiry date, and the operator's
approval.

## Keep the rule table

AGENTS.md at the repo root carries a table at the bottom: rule, what
enforces it, evidence. Keep it terse. This skill is the only writer of the
table, and the table lands through normal review with the fixes.

When the operator corrects you, fix the mistake and add the rule. If the
rule is already in the table and nothing enforces it, that is a repeat:
promote the enforcement one level in the same change. Drop a rule once its
mistake cannot happen.

## Report

List each class with its evidence, the enforcement level chosen, and why a
higher level did not work. Name the proof command for each new check and its
result.
