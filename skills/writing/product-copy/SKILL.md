---
name: product-copy
description: Use when writing text inside a product interface — error messages, empty states, notifications, toasts, confirmation dialogs, banners, or button labels — and when asked to make product copy friendlier or more apologetic.
---

<!-- writing-style:disable — this file quotes banned words on purpose -->

# Product Copy

## Overview

Product copy is read by someone who is mid-task and often stuck.
They need to know what happened and what to do next.

Core principle: a clear fix path is the friendliest tone.

**When not to use:** for documentation, help articles, and
announcements, use the clear-writing skill. For commit messages and
pull requests, use the commit-messages skill.

## Errors

An error message states three things, in this order:

1. **What happened.** In the reader's terms, not the system's.
2. **Why.** The condition or limit that caused it.
3. **What to do.** A specific action the reader can take now.

The facts come before any feelings. Do not open with an apology, a
greeting, or "Oops".

**A developer-facing example.**

> **Before:** Sorry — this file didn't make it. It's over the 50 MB
> limit for your plan, so we couldn't finish the upload.
>
> **After:** This file is larger than 50 MB, the limit on free plans.
> Compress it to under 50 MB, or upgrade to Pro to upload files up to
> 5 GB.

**An example with no technical reader at all.**

> **Before:** Oops! Something went wrong with your payment. Please try
> again later or contact our friendly support team — we're happy to
> help!
>
> **After:** Your bank declined this card. Cards are declined most
> often for an expired date or an incorrect billing ZIP code. Check
> those two fields, or use a different card.

Never write "Something went wrong" as the whole message. If the cause
is genuinely unknown, say what the reader can do: retry, wait, or
contact support with a specific reference.

## Empty states

An empty state says what belongs here and how to put something in it.

> **Before:** No results found!
>
> **After:** No shared folders yet. Folders people share with you
> appear here. Ask a teammate to share one, or create your own.

## Notifications, toasts, and banners

- Name the thing that changed and its new state: "Report exported to
  Downloads", not "Success".
- A toast that reports a failure carries the same three parts as an
  error, shortened.
- Do not thank the reader for waiting.

## Buttons and labels

- A button label is a verb phrase naming the action: "Delete workspace",
  not "OK" or "Confirm".
- The label matches the words in the sentence above it. If the dialog
  says "Archive this project", the button says "Archive project".
- Destructive actions name what they destroy.

## Words

- Address the reader as "you". Use "we" only for an action your company
  takes.
- Present tense, active voice: "Restore takes under a minute", not
  "you'll be back to work in no time".
- Keep the product's own names. Do not rename a feature in passing.
- One term, one meaning, everywhere in the interface.
- "can" is ability, "must" is a requirement. Do not soften a
  requirement to "should".

| Write | Not |
|---|---|
| use | utilize, leverage |
| make sure | ensure |
| start | initiate |
| stop | terminate |
| change | modification |
| before | prior to |
| about | approximately |

Delete: "please", "simply", "just", "easy", "Oops", "That's it",
"no problem", "don't worry", "we're happy to help", "Happy <tool>-ing",
and exclamation points.

## Common mistakes

| Pressure | Wrong response | Right response |
|---|---|---|
| "Make it friendly" | "Oops!", "Happy exporting!" | Short, clear, second person |
| "Be apologetic" | Apology as the first sentence | Facts first; the fix is the reassurance |
| "Soften the error" | Hide the limit that caused it | Name the limit and the way past it |
| Unknown cause | "Something went wrong" | What the reader can do now |
| Describing behavior | "You'll get an email" | "We send a confirmation email" |

## Red flags, rewrite if you see

- An apology, a greeting, or "Oops" as the first sentence
- "Something went wrong" with no action for the reader
- A button labeled "OK", "Confirm", or "Submit" on a destructive action
- An exclamation point
- A message that names no cause and no next step
- A feature called by a different name than the interface uses

## Before you output

Run this on your draft. Fix what fails, then output.

1. Does the first sentence state a fact, not a feeling?
2. Are all three parts present: what happened, why, what to do?
3. Is the action specific enough to perform without asking anyone?
4. Does the button label name the action in the same words as the text
   above it?
5. Scan for: please, simply, just, easy, Oops, "!"
6. Does every feature keep the name the interface uses?

## Project instructions win

Project instructions win over these rules where they disagree.
In Claude Code that means `CLAUDE.md` and `AGENTS.md`.
Elsewhere it means the project's custom instructions.

A house copy guide, a brand voice document, or a localization
constraint wins over this skill. Follow it, and apply these rules to
whatever it leaves open.

Sources: ASD-STE100 Simplified Technical English (asd-ste100.org);
Google developer documentation style guide (developers.google.com/style).
