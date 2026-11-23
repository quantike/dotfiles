---
name: Unslop
description: Cut AI tells from docs, PR descriptions, Linear issues, and commit bodies. Rewrites against a numbered rule list; other skills cite rules by number. Load by ID when another skill needs it.
disable-model-invocation: true
---

# Unslop

Edit text to remove AI patterns. Scan for the patterns below, then rewrite.
Preserve meaning and match the intended tone. The repo's AGENTS.md wins where
it sets a stricter rule.

Rule numbers are stable IDs that other skills cite. A removed rule leaves a
gap.

## Structure

1. One idea per sentence. Split a sentence the reader must reread.
2. Active voice. Name the actor unless it is unknown or does not matter.
3. Whole sentences with their articles and verbs. Spell out arrows and
   abbreviations.
4. Say what it does, not how it feels. Name the mechanism or the number.
5. Cut a sentence that could appear unchanged in another project's docs.
6. No generic conclusions. State specific plans or facts.

## Words and patterns

7. Cut filler. "In order to" becomes "to". Delete "it is important to note
   that".
8. Cut adverbs or use a stronger verb. Give the number.
9. Use the plain word: "use", not "utilize" or "leverage".
10. No AI vocabulary: additionally, crucial, delve, enhance, foster,
    landscape, pivotal, showcase, testament, underscore, vibrant.
11. No chatbot phrases ("I hope this helps!", "Let me know if...").
12. No praise or agreement openers. Respond directly.
13. One hedge at most: "may".
14. No "not just X, but Y". State the point.
15. No "it is not X, it is Y". State the point.
16. No vague attributions ("experts believe"). Name the source or delete.
17. No abstract metaphor nouns: substrate, wedge, vector, nexus, paradigm,
    ratchet, north star, flywheel. Use the concrete word.
18. No metaphor, aphorism, personified code, or figurative verb where a
    literal phrase exists.
19. No trailing "-ing" phrases that add no fact ("highlighting...",
    "ensuring...").

## Punctuation and formatting

20. No em dashes or en dashes used as dashes. Use a comma, colon, or
    parentheses.
21. A colon goes before a list or an example, never mid-sentence as a
    connector.
22. No bold label and colon that restates its line. A bold lead-in that ends
    in a period and adds new detail is fine.
23. Sentence case headings.
24. No decorative emoji.
25. Straight quotes.
26. Don't bold every proper noun or acronym.

## Names

27. One name per thing. Repeat it. The same term for the same concept
    everywhere.
28. No "from X to Y" unless X and Y sit on a real scale.
29. Don't force ideas into threes.
