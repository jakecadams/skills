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

## Three forms

- **Report-back** — finished work, read in seconds. The default.
- **Aide-memoire** — a standing update on lines the reader tracks
  every week. Headings only, expanded on request.
- **Decision document** — a decision that is hard to reverse, or one
  where the analysis is the deliverable rather than the conclusion.
  Read `references/decision-document.md` before writing one.

Everything below applies to all three.

## The five elements

In this order. Headings are optional.

1. **Verdict.** The answer, status, or recommendation in the first
   sentence, with the number that controls it.
2. **What matters.** Two to five facts, sharpest first. What changed,
   not what you did. Each says why it matters to this reader, written
   out rather than implied. Keep the facts separate from your read.
3. **Risks and surprises.** Stated as what they cost the reader. A
   surprise is the thing already found that they did not expect, not
   only the thing that might go wrong later. If there are none, say
   "no risks".
4. **The ask.** One decision: what, who, and by when. Or "no action
   needed", which forecloses the inference that you are waiting on
   them. Never silence.
5. **Go deeper.** Links, file paths, an appendix. Detail is opt-in.

## The four rules

**Verdict first.** Reasoning follows the verdict and never precedes it.
If a deadline or a blank page stops you, write the most important
sentence and start there. One exception, only in a decision document:
when the reader does not yet see a problem, one sentence of what they
already accept and one of what changed may come first. The answer lands
by the third sentence or it is late.

**Recommend, don't ask.** Bring one proposed action — the best of all
you considered — not a menu and not an open question. Propose even at
low confidence: a guess you label as a guess beats a question. State
the recommendation firmly and the confidence separately: "Deploy it. I
am about 60% sure the pool is the only cause."

**Bad news earliest.** People act on early signals of good news but
only on late signals of bad news, so bad news needs the top of the
report to survive. The reader must hear it from you before any other
channel carries it. Say what it costs them, not what it cost you to
find.

**Depth is opt-in.** Main points in short paragraphs. Logs and
supporting tables go elsewhere. A decision document is the exception:
its data belongs in it rather than gestured at. The floor of the form
is headings alone, expanded on request.

## Separate the facts from your read

The reader must be able to reject your interpretation without
relitigating what happened. Give what a camera would have recorded,
then give your reading of it, labeled.

> **Before:** The pool is misconfigured: it caps at 10 connections, the
> limiter opens one per request, and above 600 rpm we drop 3% of
> requests because nobody revisited it after the worker change.
>
> **After:** The pool caps at 10 connections. The limiter opens one per
> request. Above 600 rpm we measured 3% of requests dropped. My read:
> the cap was copied from the old single-worker setup and never
> revisited. I have not confirmed that.

Same facts in both. The second one lets the reader keep the
measurements and throw out the explanation.

## Numbers, not adjectives

Replace every evaluative word with the measurement behind it. If a
number exists and you have not measured it, measure it.

> **Before:** Performance improved significantly and most tests pass.
>
> **After:** p95 dropped from 840ms to 310ms. 14 of 15 tests pass; the
> failure is `test_retry_backoff`.

## Shorter is not the goal

The goal is the reader's processing cost, and cutting words is only one
way to lower it. Moving detail to an appendix, ordering the verdict
first, and putting the bad news at the top all cost nothing in length.

So compression has a floor. When a decision deserves analysis, the
correct revision of a thin memo is a longer finished one.

> **Before:** Recommend we move to per-plan rate limits. It scales
> better.
>
> **After:** Move to per-plan rate limits, with the enterprise ceiling
> at 10,000 rpm. Two customers now exceed the flat 1,000 rpm cap during
> nightly syncs and have asked for exemptions. Per-customer exemptions
> stop scaling at about ten: each is a config entry nobody owns and a
> support ticket when it drifts. Per-plan limits move the exemption into
> the plan, which billing already tracks. The cost is a migration for
> the 40 keys currently exempted, about a day. The risk is the cutover:
> a key landing on the wrong plan gets throttled mid-sync, which shows
> up as 429s from a named customer within the hour and undoes in
> minutes. Ravi decides by Friday; the enterprise renewal needs an
> answer by the 20th.

The first version is shorter and decides nothing. This rule and
depth-is-opt-in do not compete: move detail, never delete reasoning.
Never ship a short report over unfinished work — say which part is not
done instead.

## What never appears

- Process narration. "First I searched, then I read, then I tried."
- Log dumps and command output pasted in place of a finding.
- An everything-I-did list with each item at equal weight.
- An open question with no recommendation attached.
- A blocker below the fold.
- The request restated back to the reader.
- Effort as evidence. How hard it was is not a finding.

## The report-back

> **Before.** A typical agent report-back:
>
> I started by searching the codebase for the rate limiter and found it
> in `src/middleware/rate-limit.ts`. I then read through the tests and
> noticed a few things that looked off. After that I ran the test suite,
> which took a while. Eventually I traced it to the Redis connection
> pool. I've made a fix, though I wasn't able to fully verify it because
> staging was down. Let me know if you'd like me to try anything else!

> **After.**
>
> The rate limiter drops about 3% of requests under load: the Redis pool
> caps at 10 connections and the limiter opens one per request. Fixed in
> `src/middleware/rate-limit.ts:42` by reusing a shared client.
>
> Not verified against load. Staging was down, so this passed unit tests
> only, 14 of 14. If the pool is not the only cause, the drops continue
> after deploy and we learn that within an hour.
>
> Ask: Dana decides today whether I deploy the moment staging returns,
> or hold for a load test. I would deploy — the change is six lines and
> reverts cleanly.

Note what the risk line does. It names what the reader will see and
when, so the unverified part becomes testable instead of a disclaimer.

## Bad news

The temptation is to earn the bad news by giving the context first,
which is how it gets missed.

> **Before:** The migration went well overall. The team put in a lot of
> hours and most of the cutover steps landed clean. One thing worth
> flagging is that we did lose some rows in step 4 — we're still
> counting.
>
> **After:** We lost about 4,000 order rows in last night's step-4
> cutover. Support will start seeing "missing order" tickets this
> morning and you will want to reach them before the 9am standup; I have
> not told them yet. The rows are recoverable from the pre-cutover
> snapshot, about three hours of work. Ask: Priya approves pausing new
> writes until 1pm so the restore is clean, decided by 9am.

## The aide-memoire

Headings only, each carrying its point. The bad news still goes first,
even when the reader reads the same lines every week.

> **Blocked** — DNS change from Platform, needed Monday
> **Risk** — rollback untested past step 4
> **Migration** — otherwise on track, cutover Tuesday
> **Ask** — Priya approves the DNS ticket today
>
> Ask me to expand any line.

A heading that does not carry its point is a table of contents, not an
aide-memoire. "Migration — update" tells the reader nothing.

## Common mistakes

| Pressure | Wrong response | Right response |
|---|---|---|
| "Cover everything you did" | Every step, equally weighted | The verdict, then what changed |
| "More detail" | Longer narration | More facts: numbers, names, conditions |
| "Be thorough" | Log output pasted inline | A finding, with the log linked |
| "Keep it short" | A memo that decides nothing | The analysis the decision needs |
| Nothing went wrong | Risks section dropped | "No risks" |
| Nothing needed from the reader | Ends with no ask | "No action needed" |
| Low confidence | An open question | A recommendation with the confidence stated |
| The work is unfinished | A short report that reads finished | Say which part is not done |
| A judgment call | Your read stated as fact | Facts, then your read, labeled |
| Bad news | Context first, so it lands softly | The bad news first, then the context |

## Red flags, rewrite if you see

- A first sentence that is context rather than the answer
- "I started by", "I then", "After that"
- An evaluative adjective where a number exists
- A blocker or a caveat below the first third
- A question mark where a recommendation belongs
- No ask and no "no action needed"
- An ask with no name or no date on it
- A heading that labels a section instead of claiming something
- Any sentence whose subject is you rather than the work. Labeling your
  read, your confidence, or your recommendation is the exception, and
  those need first person.

## Before you output

Run this on your draft. Fix what fails, then output.

1. Does the first sentence carry the answer and its number? In a
   decision document opening on a problem the reader does not yet see,
   does the answer land by the third sentence?
2. Does every fact say why it matters to this reader?
3. Is every risk stated as a cost to the reader?
4. Is anything the reader would not expect in there with them?
5. Is the worst news in the first third?
6. Is there exactly one recommendation, not a menu?
7. Does the ask name a decision, a person, and a date — or say "no
   action needed"?
8. Is anything unverified labeled as unverified?
9. Is your read separable from the facts?
10. If you were the reader, would you sign this paper and stake your
    professional reputation on its being right? If not, take it back
    and work it over.

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
