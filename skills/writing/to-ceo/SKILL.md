---
name: to-ceo
description: Use when reporting results, status, findings, or a recommendation to someone who has to act on it — a status update, a decision brief, a handoff, an agent reporting back on finished work, or any request for a to-CEO brief or an executive summary.
---

<!-- writing-style:disable — this file quotes banned words on purpose -->

# To-CEO Brief

## Overview

A report like this one arrives in a stack of them from coworkers and
agents. The reader gives it seconds, decides, and moves on. Your
thinking must be finished before it reaches them.

Core principle: the reader approves or rejects. They do not do your
thinking, and they do not read your process.

**When not to use:** for documentation, READMEs, help articles, and
announcements, use the clear-writing skill. For text inside a product
interface, use the product-copy skill. For commit messages and pull
requests, use the commit-messages skill. This skill sets what a report
contains and in what order; for the words and sentences inside it, use
the clear-writing skill after this one.

## The five elements

In this order. Headings are optional. The form scales from three lines
in chat to one page.

1. **Verdict.** The answer, status, or recommendation in the first
   sentence, with the number that controls it.
2. **What matters.** Two to five facts, sharpest first. What changed,
   not what you did.
3. **Risks and surprises.** Stated as what they cost the reader. If
   there are none, say "no risks".
4. **The ask.** One decision, with your recommendation. Or "no action
   needed" — never silence.
5. **Go deeper.** Links, file paths, an appendix. Detail is opt-in.

## The five rules

**Verdict first.** Reasoning follows the verdict and never precedes it.
If a deadline or a blank page stops you, write the most important
sentence and start there.

**Recommend, don't ask.** Bring one proposed action — the best of all
you considered — not a menu and not an open question. Propose even at
low confidence: a guess you label as a guess beats a question. State
the recommendation firmly and the confidence separately: "Deploy it. I
am about 60% sure the pool is the only cause."

**Bad news earliest.** People act on early signals of good news and
late signals of bad news, so bad news needs the top of the report to
survive. The reader must hear it from you before any other channel
carries it. Say what it costs them, not what it cost you to find.

**Depth is opt-in.** Main points in short paragraphs. Analysis,
statistics, and logs go elsewhere. The floor of the form is headings
alone, expanded on request.

**End with the ask.** Name the decision you need and when you need it.
"No action needed" carries real information — it forecloses the
inference that you are waiting on them.

## Numbers, not adjectives

Replace every evaluative word with the measurement behind it. Not
"performance improved significantly" but "p95 dropped from 840ms to
310ms". Not "most tests pass" but "14 of 15 pass; the failing one is
`test_retry_backoff`". If a number exists and you have not measured it,
measure it.

## What never appears

- Process narration. "First I searched, then I read, then I tried."
- Log dumps and command output pasted in place of a finding.
- An everything-I-did list with each item at equal weight.
- An open question with no recommendation attached.
- A blocker below the fold.
- The request restated back to the reader.
- Effort as evidence. How hard it was is not a finding.

## Two lengths

A **report-back** is read in seconds: verdict, a few facts, risk, ask.
A **decision document** is read in minutes and argued in full
sentences, with the data in it rather than gestured at.

## An example

**Before.** A typical agent report-back:

> I started by searching the codebase for the rate limiter and found it
> in `src/middleware/rate-limit.ts`. I then read through the tests and
> noticed a few things that looked off. After that I ran the test suite,
> which took a while. Eventually I traced it to the Redis connection
> pool. I've made a fix, though I wasn't able to fully verify it because
> staging was down. Let me know if you'd like me to try anything else!

**After.**

> The rate limiter drops about 3% of requests under load: the Redis pool
> caps at 10 connections and the limiter opens one per request. Fixed in
> `src/middleware/rate-limit.ts:42` by reusing a shared client.
>
> Not verified against load. Staging was down, so this passed unit tests
> only, 14 of 14. If the pool is not the only cause, the drops continue
> after deploy and we learn that within an hour.
>
> Ask: approve the staging deploy when staging is back, or tell me to
> hold for a load test. I would deploy — the change is six lines and
> reverts cleanly.

Note what the risk line does. It names what the reader will see and
when, so the unverified part becomes testable instead of a disclaimer.

## Common mistakes

| Pressure | Wrong response | Right response |
|---|---|---|
| "Cover everything you did" | Every step, equally weighted | The verdict, then what changed |
| "More detail" | Longer narration | More facts: numbers, names, conditions |
| "Be thorough" | Log output pasted inline | A finding, with the log linked |
| Nothing went wrong | Risks section dropped | "No risks" |
| Nothing needed from the reader | Ends with no ask | "No action needed" |
| Low confidence | An open question | A recommendation with the confidence stated |
| The work is unfinished | A short report that reads finished | Say which part is not done |

## Red flags, rewrite if you see

- A first sentence that is context rather than the answer
- "I started by", "I then", "After that"
- An evaluative adjective where a number exists
- A blocker or a caveat below the first third
- A question mark where a recommendation belongs
- No ask and no "no action needed"
- Any sentence whose subject is you rather than the work

## Before you output

Run this on your draft. Fix what fails, then output.

1. Does the first sentence carry the answer and its number?
2. Is every risk stated as a cost to the reader, and is anything the
   reader would not expect in there with them?
3. Is the worst news in the first third?
4. Is there exactly one recommendation, not a menu?
5. Does it end in an ask or an explicit "no action needed"?
6. Is anything unverified labeled as unverified?
7. Would you sign this yourself and stake your reputation on it being
   right? If not, work it over.

## Project instructions win

Project instructions win over these rules where they disagree.
In Claude Code that means `CLAUDE.md` and `AGENTS.md`.
Elsewhere it means the project's custom instructions.

Common overrides a project may set: a required status-report template,
a fixed cadence and section list, or a house rule about where risks are
recorded. Ask how the reader wants updates, and honor that.

Sources: the US Army doctrine of completed staff work (1942);
Army Regulation 25-50 (BLUF); Churchill, "Brevity" (1940); Barbara
Minto, *The Pyramid Principle*; Andy Grove, *High Output Management*;
Matt Mochary, *The Great CEO Within*; Bryar and Carr, *Working
Backwards*; VandeHei, Allen and Schwartz, *Smart Brevity*; Rogers and
Lasky-Fink, *Writing for Busy Readers*. Full notes and quotations are
in `references/source-notes.md`.
