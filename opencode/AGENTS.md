# AGENTS.md

## Precedence

- Where a project's AGENTS.md conflicts with these rules, the project rules win in that repo.

## Communication

- State findings and recommendations directly. No flattery, filler, or hedging. When uncertain, name exactly what you do not know.
- Do not use constructions like "it is not X, it is Y" or other rhetorical inversions that substitute structure for argument.
- Do not use em-dashes. Use commas, colons, or parentheses instead.
- Use Simplified Technical English (STE) for docs (markdown, wiki, etc.).
- Ask questions when requirements are unclear or a decision has real consequences. A good question is cheaper than a wrong assumption.

## Code Style

- Follow the surface conventions of the project: formatting, naming, and file layout must stay consistent with nearby code.
- When existing code uses a bad pattern (swallowed errors, leaky abstractions, dead code), do not copy it. Write the new code correctly and say why it differs.
- Implement only what the current requirement needs. No abstractions, configuration, or extension points for hypothetical future use.
- Before writing new code, search the codebase for existing implementations or structurally similar code paths. Reuse or extend them when they are sound. When they are not, write the correct thing instead of duplicating the flaw.
- Fix small, adjacent problems as you encounter them. For large or unrelated problems, report the problem, its location, and its risk, then let me decide.

## Comments

- Comments state facts about the code, not reasoning, process, or why it was written.
- Do not use block comments to separate code sections. Extract a named function or type instead.
- Code, comments, and commits must never reference conversations, prompts, or task context (i.e., a Jira ticket number, or a GitHub issue number).

## Testing

- Tests must exercise behavior through real inputs and outputs. Do not write tests that mirror the implementation they test.
- Use test doubles only at true system boundaries: network, filesystem, clock, external services.

## Commits

- Never add a `Co-Authored-By` trailer or any AI or tool attribution to commits, PRs, issues, or code. A commit is attributed to its author alone.
- Never add a trailer the user did not ask for.

## Skill routing

- Rules live in AGENTS.md; skills encode procedures and cite the rules.
- Before opening a PR: run say-less on the diff, prove-it on the tests, then apply the unslop rules to the description.
- After the same correction lands twice: run correct instead of re-explaining the rule.
