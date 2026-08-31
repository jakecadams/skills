# skills

Agent skills for Claude Code, by [Jake Adams](https://github.com/jakecadams).

Everything ships as one plugin, so you install once. New skills arrive
with `claude plugin update`.

## The writing set

A house style for agent-produced writing.

Coding agents now draft most commit messages and a growing share of pull
request text, documentation, and product copy. The output varies: subjects
past 72 characters, bodies that narrate the diff, help articles that open
with an apology, error messages that name no cause. This plugin sets one
standard across all of it.

It works in two places. Engineers install it as a Claude Code plugin.
Everyone else uploads the same skills to Claude on the web or desktop, with
no terminal and no repository involved.

## What is in it

| Skill | Loads when you write | Based on |
|---|---|---|
| `commit-messages` | Commit messages, pull request titles and descriptions | Tim Pope, Chris Beams |
| `clear-writing` | Docs, READMEs, help articles, release notes, announcements, memos, email | ASD-STE100, Google developer documentation style guide |
| `product-copy` | Error messages, empty states, notifications, buttons | ASD-STE100, Google developer documentation style guide |

Each skill is standalone. It triggers on its own surface, so the commit
rules never load when you are writing a help article.

There is also `/jakecadams-skills:check-writing`, which reviews a file, a
pasted draft, or your most recent draft and reports what it would change.
It never edits.

A `PreToolUse` hook injects the commit and pull request rules when a session
is about to run `git commit` or `gh pr create`. It blocks nothing, and
installing the plugin enables it. It exists because the commit-messages skill
fires when you ask for a commit message, not when a session reaches
`git commit` after doing something else, which is where rushed messages come
from.

`/jakecadams-skills:setup` turns on the output style, retires any hook of
your own that now duplicates the plugin's, and records your conventions.
Run it once after installing.

An output style, `output-styles/writing-style.md`, covers the agent's replies
to you, which the skills alone do not reach.

## The tmux handoff skill

`/tmux-handoff <name>` moves the current Claude Code session into a new
named tmux session, so the session survives a closed terminal. Omit the
name and the skill derives one from the current work.

The skill confirms the session ID by writing a nonce into the transcript
and finding it again. It then creates a detached tmux session that waits
for the current process to exit and resumes the same session under the
same name. The wait prevents two live processes from interleaving writes
into one transcript. The skill copies the attach command to your
clipboard; exit the old session, then paste to attach.

This skill is Claude Code only, and it assumes macOS and tmux.

## Install for Claude Code

```
/plugin marketplace add jakecadams/skills
/plugin install jakecadams-skills@jakecadams
```

Then run `/jakecadams-skills:setup` to turn on the output style and record
your conventions.

To try it from a local clone instead:

```
/plugin marketplace add /path/to/skills
/plugin install jakecadams-skills@jakecadams
```

## Install for the Claude desktop or web app

Build the archive, then upload it as one plugin:

```
./scripts/package.sh
```

1. Open Settings, then Plugins, under Customize.
2. Choose Add, then Upload local plugin.
3. Select the whole-plugin archive that `package.sh` printed.

One upload installs the three writing skills and the check command. The
setup command and the tmux handoff skill are Claude Code only: the
desktop and web apps have no output styles and no terminal.

The uploader rejects an archive that contains another archive, so never
zip the folder while `build/` is inside it. `scripts/package.sh` excludes
`build/` for this reason. If you zip the folder by hand in Finder, delete
`build/` first.

To install a single skill instead of the whole plugin, use Settings, then
Skills, and upload one archive from `build/skills/`. Someone who writes
help articles and never touches a repository needs only
`clear-writing.zip` and `product-copy.zip`.

## Applying the style to replies as well as documents

The three skills fire on a task: a commit, a document, an error message. They
do not fire on an ordinary reply, so they cannot change how the agent talks to
you. That needs an output style, which loads unconditionally and injects into
the system prompt.

`output-styles/writing-style.md` carries the conversational rules: lead with
the answer, prose by default, no bolded label on every paragraph, no closing
summary, no filler. It ends by handing structure back to the artifact: a pull
request keeps the repository template, a document keeps its headings, and only
the word and voice rules carry across.

Run the setup command and it does all of this for you:

```
/jakecadams-skills:setup
```

It reports which style is active now, explains the trade-off, asks before it
changes anything, backs up your settings, and offers to record your
organization's conventions in `CLAUDE.md`. It is safe to run again.

To do it by hand instead:

```
mkdir -p ~/.claude/output-styles
cp output-styles/writing-style.md ~/.claude/output-styles/
```

Then set it in `~/.claude/settings.json`:

```json
{ "outputStyle": "writing-style" }
```

Or pick it under `/config`, then Output Style. Restart to apply.

Two limits worth knowing. Claude Code has output styles and the desktop and
web apps do not, so this half of the standard reaches engineers only. And one
output style is active at a time, so this one replaces any other you run.

## Checking that it works

```
./scripts/test-skills.sh
```

Each case in `tests/cases/` carries the pressure that breaks unguided writing:
"cover everything you did", "make it friendly", "be apologetic", "more detail
than usual". The script sends each through a fresh headless session and checks
the result: subject length, the blank second line, body wrap, whether an error
opens with a fact, and the word and pattern rules.

Run one case by name:

```
./scripts/test-skills.sh error-message
```

Print mode does not apply output styles, so this covers the skills and the
check command. Test the output style in an interactive session.

## Setting your own conventions

The plugin ships knowing nothing about your organization. It has no
config file. Your conventions go where your team already keeps them:
`CLAUDE.md` or `AGENTS.md` in Claude Code, or your project's custom
instructions elsewhere. Every skill ends by saying those win.

Add a section like this to your `CLAUDE.md`:

```markdown
## Writing conventions

- Commit subjects use a conventional prefix: `fix(scope): lowercase`.
- Pull request titles start with the ticket ID: `[ENG-1234]`.
- Product copy follows `docs/COPY.md` where it disagrees with the
  product-copy skill.
- Never rename these features in prose: Saved View, Sprint Board.
```

## What this deliberately does not do

It does not install git hooks, and it does not reject a commit. An earlier
version did both. Git hooks force every teammate to opt into a standard they
never agreed to, and they cost a `direnv` re-approval across the team, so
they came out.

The `PreToolUse` hook is a different mechanism and keeps none of that cost. It
runs inside your own Claude Code session, changes no git configuration, and
reaches no one else. It adds context and never rejects anything.

The replacement is inside the skills: each one ends with a self-check the
agent runs on its own draft before it hands the text over. If you want a
harder check, run `/jakecadams-skills:check-writing` on your own writing.
If you want to know how often the rules get broken, run it for two weeks
and keep a tally. That is the same signal a hook would give you, without
forcing it on anyone else.

## The plain-word list

`skills/writing/clear-writing/references/plain-words.txt` is the single
source for banned words and their replacements. The checker reads it and
the `clear-writing` skill cites it.

Grow it by pull request. Spot a weasel word in review, add a line:

```
phrase|replacement
```

Use `delete` as the replacement when the word adds nothing.

## Sources

- Tim Pope, [A Note About Git Commit Messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
- Chris Beams, [How to Write a Git Commit Message](https://cbea.ms/git-commit/)
- [ASD-STE100 Simplified Technical English](https://www.asd-ste100.org/)
- [Google developer documentation style guide](https://developers.google.com/style)

The skills take the ASD-STE100 structure rules and its plain-word
principle. They do not take the 900-word controlled dictionary; full
conformance needs that dictionary and its checker, and the structure rules
carry most of the value outside aerospace.

## Layout

```
.claude-plugin/plugin.json     lists every skill by path
skills/<domain>/<skill>/       SKILL.md and any reference files
commands/                      slash commands
output-styles/                 styles that govern replies
scripts/                       the prose checker, packaging, tests
tests/cases/                   pressure prompts
```

Skills sit under a domain folder, so a future set lands in `skills/<domain>/`
and reaches everyone on their next `claude plugin update`. Nested paths are
not auto-discovered, so add each new skill to the `skills` array in
`.claude-plugin/plugin.json`.

## License

MIT. See `LICENSE`.
