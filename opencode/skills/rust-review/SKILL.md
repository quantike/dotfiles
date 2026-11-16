---
name: Rust Review
description: Assess and improve Rust style, API shape, error handling, and performance across a repository against the Google Rust style guide, the rust-lang style guide, and the Rust API guidelines. Use when the user asks to review Rust code, assess Rust style, find improvements for readability or performance, or turn such a review into fixes.
---

# Rust Review

A repo-wide Rust review pass. The deliverable is a triaged findings report
(`file:line`, one-line problem, one-line fix, ordered fix-first), and, when the
user asks, the fixes landed one concern per commit.

## Ground rules

1. Read the repository's AGENTS.md (and any nested AGENTS.md for crates you
   review) before anything else. House rules override the guides. When the
   guides and house rules conflict, house rules win and the conflict is worth
   naming in the report.
2. Bring the checkout current: `git fetch origin` then `git pull --ff-only`.
   Reviewing a stale tree wastes the whole pass.
3. A review is read-only. Fixes go in a worktree, one concern per commit, only
   when the user asks.
4. Frame every API-design rule through the Google guide's own distinction:
   library code binds, application code treats the rules as strong
   recommendations favoring simplicity. Do not demand library-grade API
   surface from a binary's internals, and do not flag a `String` error that
   nothing branches on.

## References

Fetch these once, in parallel, at the start:

- https://google.github.io/styleguide/rustguide.html (readability, ownership,
  flexible references, error reporting, library-vs-application framing)
- https://doc.rust-lang.org/nightly/style-guide/ (mostly rustfmt defaults; the
  advice page has naming and expression guidance)
- https://rust-lang.github.io/api-guidelines/checklist.html (the checklist is
  the working form; the topical chapters explain the items)

## Mechanical sweep

Run the pedantic lint as signal, not law:

```sh
cargo clippy --workspace --all-targets --quiet -- -W clippy::pedantic
```

Bucket the output. Treat as noise: `must_use` suggestions, missing doc
backticks and `# Errors` sections, and cast pedantry at wire/protobuf
boundaries where `as` is correct. Treat as leads: truncating or wrapping
casts, overflow-capable arithmetic, silent `unwrap_or` fallbacks, needless
Option wrapping, `let`-else rewrites, functions over a screen long.

Then check coverage and enforcement:

- Crates excluded from the workspace never see `cargo clippy --workspace`.
  Lint them explicitly with `--manifest-path`; unlinted code is where avoidable
  warnings survive.
- Check for `clippy.toml` and `[workspace.lints]`. House rules that exist only
  in review (unwrap-for-tests, expect-must-state-why) can usually move into a
  curated deny list with the test exemption in `clippy.toml`
  (`allow-unwrap-in-tests = true`). Do not enable pedantic wholesale; a curated
  list matches how these repos think.
- Skim the release profile: LTO, codegen-units, strip, panic strategy. Note
  what is deliberate so the report does not recommend against a documented
  trade.

## Manual review, in priority order

Read the biggest and hottest files fully; grep the rest for the patterns.

1. **Correctness-adjacent style** (fix first; style that hides a bug):
   - Exact quantities computed in `f64`: timestamps, money, sample counts.
     Epoch-scale values sit past `f64`'s 2^53 exact range; `%` on a possibly
     negative total breaks normalization invariants. Integer arithmetic with
     `div_euclid`/`rem_euclid` is both exact and shorter.
   - A lossy `as` cast whose safety rests on an unstated invariant (a division
     bounding a value into range, a length bounded by a validated config).
     Pin the invariant where it is used: `debug_assert`, `try_from`, or a
     named const bound enforced at the config boundary.
   - `expect`/`unwrap`/index panics reachable from bad input or a dependency
     misbehaving in a library path. One mismatched pairing can shift every
     later pairing; ask what the safe degradation is (refuse, drop, silence)
     instead of panicking.
   - Unvalidated bounds that feed a fixed-width field (a RIFF `u32` length, a
     proto `i32`). Enforce at the config boundary that owns the number.
   - Guards that only fire in debug builds (`debug_assert` with no release
     path) standing in for an error decision.

2. **API shape** (readability):
   - A handler or constructor past a screen that buries its happy path under
     repeated warn-refuse-return blocks. Extract one decide function that
     returns typed success or a refusal; the handler reads handshake, decide,
     accept, spawn.
   - Tuples crossing function boundaries (`(String, Window, Instant)`). Name
     them. Private two-field locals can stay.
   - Stringly `Result<_, String>` where a caller branches on the failure kind
     or the error is the crate's public API. Keep `String` where failures are
     opaque environment reasons with one call site.
   - Missing standard trait impls (`Display` without `Error`, `len` without
     `is_empty`), conventions (`into_` for consuming getters that collide with
     borrowed ones), duplicated literal lists or magic numbers encoding one
     fact twice.
   - Deliberate duplication is a feature when it makes a second contract fail
     to compile on change (enum mirrors across protos). Never "simplify" it
     into a wildcard.

3. **Performance** (cheap wins, no speculation):
   - Allocations in per-frame, per-block, or per-message loops. Add up even
     when each is small; the fix is usually reading the slice in place or
     sizing with capacity once.
   - `clone()` of large payloads where `bytes::Bytes` makes the clone a
     refcount bump (publish retries, multi-destination writes).
   - O(n*m) scans where a documented ordering guarantee allows
     `partition_point` or a merge join. Write the invariant on the field and
     pin it with a test; check for race windows before restructuring dedup or
     "seen" sets, where a lookup that misses before an insert can duplicate a
     record.
   - HashMap plus a parallel order Vec for two-to-four entries: one
     `Vec<(K, V)>` preserves order, removes the second source of truth, and
     scans faster than it hashes.
   - Clone-and-overwrite of owned values; mutate in place.
   - Measure before claiming speed. A refactor that removes allocations is a
     structural win; end-to-end latency claims need a benchmark.

4. **Verification discipline**:
   - Spot-check every finding at its cited lines before reporting, including
     findings from subagents. Findings are claims, not facts.
   - Run the tests after every behavior-adjacent edit. A "cleanup" that a test
     fails is a behavior change you did not intend.
   - Tests belong where a wrong answer still looks plausible: timestamp
     boundaries, normalization edge cases, invariant shape, wire round-trips.

## Report format

1. Open with where the repo already meets the guides, specifically enough that
   those invariants are named and do not drift back.
2. Findings by theme, ordered fix-first. Each: `file:line`, one-line what,
   one-line fix.
3. A "what the code does well" section. A review that only lists defects gets
   its good patterns eroded.
4. Triage: fix now (own commits), riders (do when the file is touched anyway),
   drop (with the reason). Estimate sizes honestly: a line range per item, a
   ±2x error bar, and the medium-risk ones named as medium (signature changes
   with many call sites, borrows moved across awaits).
5. State what is deliberately not done and why. A review list is not a
   backlog; items earn work when they prevent a wrong answer, remove cost that
   grows with scale, or ride on adjacent changes.

## Landing fixes

- Worktree first (`git worktree add <path> -b <branch>`), branch name at most
  three hyphenated words, then move the session into it.
- One concern per commit, conventional commits with a scope, tests of the
  touched crate per commit, full `make check` before push. A piped `| tail`
  or `| grep` hides exit codes; gate the next step on real exit status.
- If a commit lands incomplete, fix and `--amend` it while unpushed; verify
  the fix actually compiles and passes this time.
- Push and open the PR with the ticket prefix before the conventional
  summary. The PR body carries the themes, the behavior changes called out for
  review, and a "deliberately not done" section.
- Never commit unless the user asked.
