---
name: clear-writing
description: Use when writing anything people read to learn or decide — documentation, a README, a help article, release notes, an announcement, a memo, a report, or an email — and when asked to make writing more detailed, friendlier, more apologetic, punchier, or more memorable.
---

<!-- writing-style:disable — this file quotes banned words on purpose -->

# Clear Writing

## Overview

This skill applies the sentence and structure rules of ASD-STE100
(Simplified Technical English) and the Google developer documentation
style guide.

Core principle: the reader gets information, not decoration.

**When not to use:** casual chat messages keep their own tone.
For text inside a product interface, use the product-copy skill. For
commit messages and pull requests, use the commit-messages skill.

## Structure

- **Instructions:** 20 words maximum per sentence. One instruction per
  sentence. Imperative mood. Put the condition or the goal first:
  "To restore a snapshot, run:".
- **Descriptive text:** 25 words maximum per sentence. Paragraphs of
  6 sentences maximum, one topic each.
- A warning comes before the instruction it protects, and reads as a
  command: "Do not run the backfill on a weekday."
- No more than three nouns in a row. Break a noun cluster with "of",
  "for", or a hyphen: "the setup flow for the meeting recorder", not
  "the meeting recorder capture setup flow".
- Use simple verb forms: imperative, simple present, simple past.
  Avoid -ing forms when a simple form works: "when the upload stops",
  not "upon the upload stopping".
- Use the active voice and the present tense: "Restore takes under a
  minute", not "you'll be back to work in no time".
- Keep the articles ("the", "a").
- State the result after a step: "The command prints a snapshot ID."
- Lead with the point. Put the most important fact in the first
  sentence of a paragraph.

## Words

- Address the reader as "you".
- One term, one meaning. Call a thing the same name everywhere.
- Keep the names your source material uses. Do not rename something in
  passing (a "recording link" does not become a "meeting link").
- Use the verb, not its noun: "check the cable", not "perform a check
  of the cable"; "back up the directory", not "perform a backup".
- "can" is ability, "might" is possibility, "must" is a requirement.
  Use "may" only for permission. Do not soften a requirement to
  "should".
- Do not write "and/or". Write "a or b, or both".
- Do not write "etc.". Complete the list, or give examples with "for
  example".
- Link text names the destination: "see the restore guide", never
  "click here". Do not point with "above" or "below"; name the section.
- Write "for example", not "e.g.", and "that is", not "i.e.".
- Use sentence-case headings and the Oxford comma. Use numbered lists
  for sequences and bullets otherwise.
- No idioms, metaphors, or jokes.

Choose the short, common word:

| Write | Not |
|---|---|
| use | utilize, leverage |
| do | perform |
| make sure | ensure |
| start | commence, initiate |
| stop | terminate |
| change (noun) | modification |
| feature | functionality |
| before | prior to |
| if | in the event of |
| about | approximately, regarding |
| also | additionally |
| so | consequently |
| many | numerous |
| enough | sufficient |
| show | demonstrate, indicate |
| try to, help | attempt to, assist |

Delete these wherever they appear: "please", "simply", "just", "easy",
"kindly", "note that", "That's it", "no problem", "don't worry",
"we're happy to help", "Happy <tool>-ing", and exclamation points.

Delete marketing varnish: "seamless", "powerful", "blazing fast",
"cutting-edge", "best-in-class", "game-changing", "supercharge".

The full list, with replacements, is in
`references/plain-words.txt`. Read it when you want the complete set or
when you are checking someone else's draft.

## Say it once

The most common failure in analysis and summary writing is stating a fact,
then restating it as a metaphor for emphasis. The second version carries no
information. Delete it.

Avoid these shapes:

- A statement, a colon, then a slogan: "Retention held at 40%: the floor is
  the feature."
- Antithesis for rhythm: "the loss is at the door, not in the dialogs".
- A short fragment echoing a word from the sentence before it, used as a
  closing beat.
- Openers that promise a reveal: "the real question is", "here is the tell",
  "that is the whole story".

Every sentence must add a fact, a number, a condition, or a consequence. If a
sentence would survive deletion without losing information, delete it.

> **Before:** But 91% grant once they start: the loss is at the door, not in
> the OS dialogs. Accessibility is the door.
>
> **After:** 91% of users who start the permission flow grant accessibility.
> The drop-off happens before the flow starts, not inside the OS dialogs.

The rewrite keeps both facts and drops the metaphor, the antithesis, and the
echo.

## Two examples

**Developer documentation.**

> **Before:** In order to utilize the snapshot functionality, you'll
> first want to simply ensure that the CLI has been installed, and then
> you can go ahead and kick off a restore — it's really easy!
>
> **After:** To restore a snapshot, install the CLI, then run
> `snap restore <id>`. The command prints a snapshot ID when it
> finishes. A restore takes under a minute.

**An announcement for people who do not write code.**

> **Before:** We're excited to announce that we'll be rolling out some
> changes to our expense policy in the near future! Please note that
> receipts will now need to be submitted within a 30 day timeframe.
> Don't worry — reach out if you have any questions!
>
> **After:** The expense policy changes on 1 March. Submit receipts
> within 30 days of the purchase. Expenses submitted after 30 days need
> manager approval. Ask the finance team if your expense does not fit
> the policy.

## Common mistakes

| Pressure | Wrong response | Right response |
|---|---|---|
| "Make it friendlier" | "That's it!", "Happy restoring!" | Short, clear, second person |
| "More detail" | Longer sentences, more hedging | More facts: numbers, names, conditions |
| "Be apologetic" | An apology before the facts | Facts first; the remedy is the reassurance |
| Describing behavior | "You'll get back an ID" | "The command prints a snapshot ID" |
| Listing options | "formats, sizes, etc." | Complete the list |
| "Make it punchy" | Antithesis, a colon punch, a metaphor | The number first, then what follows from it |
| "Make it memorable" | A slogan the reader repeats | A fact the reader can act on |
| Summarizing data | A metaphor restating the number | The number, then what follows from it |

## Red flags, rewrite if you see

- "simply", "just", "easy", "please", or an exclamation point
- "will" or "you'll" describing how something behaves
- A sentence over 25 words, or an instruction over 20
- Four nouns in a row
- "click here", "see above", "and/or", "e.g.", "etc."
- A term that changed names halfway through the document
- A metaphor restating a fact you already stated plainly
- A sentence under six words that echoes the sentence before it

## Before you output

Run this on your draft. Fix what fails, then output.

1. Does the first sentence of each paragraph carry its point?
2. Any sentence over 25 words, or any instruction over 20?
3. Scan for the delete list: please, simply, just, easy, note that, "!"
4. Scan for the short-word table: utilize, leverage, perform, ensure,
   prior to, additionally, functionality.
5. Any noun cluster longer than three?
6. Does every link name its destination?
7. Is every term the same term it was in paragraph one?
8. Does any sentence restate the one before it as a metaphor or a punch
   line? Delete it.

## Project instructions win

Project instructions win over these rules where they disagree.
In Claude Code that means `CLAUDE.md` and `AGENTS.md`.
Elsewhere it means the project's custom instructions.

Common overrides a project may set: a house copy guide, a required
glossary, or a product name that breaks one of these rules on purpose.

Sources: ASD-STE100 Simplified Technical English (asd-ste100.org);
Google developer documentation style guide (developers.google.com/style).
