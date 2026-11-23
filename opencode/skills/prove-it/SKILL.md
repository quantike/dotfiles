---
name: Prove It
description: Kill or rewrite tests that prove nothing. A read-only reviewer judges each test by the two-edits rule and house rules, this skill applies accepted kills and rewrites in a worktree, then reports before/after counts and coverage gaps. Use before opening a PR, after refactoring internals, or when asked to vet tests.
---

# Prove it

A test earns its place by proving behavior: it fails when the behavior breaks
and passes when only internals change. Everything else is rewrite or deletion
work.

## House rules

Read AGENTS.md at the repo root and every nested AGENTS.md covering the scope
before judging. House rules decide which tests belong at all. House rules
override the reviewer's lists. Name conflicts in the final report.

## Scope

The caller's files or diff. Otherwise the test files touched by the
working-tree diff against the base branch, default `main`. With an empty
diff, as in a fresh worktree, census the scope the caller names.

## Steps

1. Spawn the `test-nuke` subagent with the scope. Do not restate its rules;
   it reads AGENTS.md itself.
2. Audit the report. Restore a kill only when the test is protected by house
   rules or proves behavior the reviewer missed. When a call is ambiguous,
   downgrade kill to rewrite, never the reverse.
3. Create a worktree on a branch named `prove-it`, unless the caller already
   names one. Confirm the worktree sits on a branch before committing; a
   freshly created worktree can be in a detached-HEAD state, so `git switch
   -c` first when needed. Apply accepted kills in one commit and accepted
   rewrites in another, following the repo's commit conventions. Never widen
   the scope beyond accepted findings.
4. Run the repo's test suite after each commit. Every rewrite must pass, and
   each rewrite names the behavior break that would make it fail. A kill
   that turns the suite red is a coverage gap: restore the test and report
   the gap instead.
5. Recount tests in scope with the same census method the reviewer used.
   That count is the after number.
6. Report:
   - Before, killed, rewritten, and after counts.
   - Kills: file, test name, one-line reason.
   - Rewrites: file, test name, the proof the old test missed, what the
     rewrite asserts.
   - Coverage gaps: behaviors left with no passing test, plus sanctioned
     test targets that house rules name and that carry no test at all.
   - House-rule conflicts found.
