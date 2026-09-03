---
name: commit-messages
description: Use when writing a commit message, a pull request title, or a pull request description, and when asked to add more detail to any of them.
---

<!-- writing-style:disable — this file quotes banned words on purpose -->

# Commit Messages and Pull Requests

## Overview

A commit message and a pull request tell a reader what changed and why.
The diff already shows how.

Core principle: the reader gets information, not decoration.

**When not to use:** for documentation, help articles, and
announcements, use the clear-writing skill. For text inside a product
interface, use the product-copy skill. For a report to a busy
decision-maker, use the to-ceo skill.

## The seven rules

1. Separate subject from body with a blank line.
2. Subject is 50 characters or fewer. 72 is the hard cap.
3. Capitalize the subject.
4. No period at the end of the subject.
5. Imperative mood. Test: "If applied, this commit will ___" must read
   as a sentence.
6. Wrap body lines at 72 characters.
7. The body explains what and why.

## The shape of a good message

- The subject names the single most important change. Write it as an
  imperative clause with a real verb: "Fix stale Escape handler in
  settings modal". Never a noun phrase with no verb. Never two changes
  joined with ";" or "and".
- Secondary changes go in the body, introduced with "Also".
- The body gives context in this order: symptom, cause, why this
  approach. It is not a file-by-file changelog.
- When someone asks for "more detail", add more why: what broke, who
  hit it, why this fix. Do not restate the diff.

A message for a diff that fixes a bug and also raises a debounce:

```
Fix stale Escape handler in settings modal

Three customers reported that Escape no longer closed the settings
modal. The keydown effect never cleaned up its listener, so after a
rerender it held a dead closure and the handler stopped firing.
Re-registering per render with cleanup keeps it bound to the live
onClose.

Also raise the search debounce from 200ms to 300ms; the search team
asked because 200ms overloaded the API.
```

## Pull requests

- **Title:** imperative and specific, 72 characters max. Name the
  change, not the theme. Never a bare ticket ID with no words.
- **Body:** use the repository's pull request template when one exists.
  Do not replace its sections with your own layout. Never leave the
  body empty.
- **Description:** the problem, why this approach, the user-facing
  impact, and the risks. It is not a commit list. Reviewers can read
  the diff.
- **Testing:** what you ran and what happened, for example "all 14 unit
  tests pass, verified in Chrome". List anything you did not verify as
  not run. A checklist of unchecked boxes is a plan, not testing.
- **Demo:** a screenshot or recording for visual changes. Otherwise one
  line saying why there is nothing to show.
- Call out unrelated changes that ship in the same pull request.
- "More detail" means more why and more evidence, never more narration.

## Words to avoid

Choose the short, common word in the subject and the body.

| Write | Not |
|---|---|
| use | utilize, leverage |
| do | perform |
| make sure | ensure |
| start | commence, initiate |
| stop | terminate |
| change | modification |
| before | prior to |
| about | approximately, regarding |
| also | additionally |
| so | consequently |

Delete "simply", "just", "easy", and exclamation points.

## Common mistakes

| Pressure | Wrong response | Right response |
|---|---|---|
| "Cover everything you did" | Semicolon-chained subject | Primary change in the subject, the rest in the body |
| "More detail" | Body lists each file's edits | Body gives symptom, cause, and reason |
| "Descriptions are too thin" | Body narrates every commit | Problem, approach, impact, and evidence |
| Nothing to show | Empty Demo section | One line saying why there is nothing to show |

## Red flags, rewrite if you see

- ";" or a second "and" in a subject or title
- A subject that fails "If applied, this commit will ___"
- Body bullets that mirror the diff hunks file by file
- A title that is only a ticket ID
- An empty pull request body

## Before you output

Run this on your draft. Fix what fails, then output.

1. Count the subject. 72 characters or fewer?
2. Does "If applied, this commit will ___" read as a sentence?
3. Is line 2 blank?
4. Does the body say why, rather than which files changed?
5. Scan for "simply", "just", "easy", and exclamation points.
6. For a pull request: does the body use the repository's template, and
   does Testing say what you actually ran?

## Project instructions win

Project instructions win over these rules where they disagree.
In Claude Code that means `CLAUDE.md` and `AGENTS.md`.
Elsewhere it means the project's custom instructions.

Common overrides a project may set: a ticket ID prefix such as
"[ENG-1234]", a conventional-commit prefix such as "fix(scope):"
(which wins over rule 3), or a required pull request template path.

Sources: Tim Pope, "A Note About Git Commit Messages" (tbaggery.com);
Chris Beams, "How to Write a Git Commit Message" (cbea.ms/git-commit).
