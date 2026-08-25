---
description: Set up the parts of this plugin that installing cannot do, mainly the output style.
allowed-tools: Bash, Read, Edit, Write
---

<!-- writing-style:disable — this file quotes banned words on purpose -->

Installing the plugin gives the user its skills and commands. It does not
turn on the output style, and it does not know their organization's
conventions. Do those two things now.

Work through the steps in order. Report what you changed at the end. Ask
before any step that edits a file the user owns. This command is safe to run
again: every step checks its current state first.

## Step 1: Report what is already active

```bash
ls "$HOME/.claude/output-styles/" 2>/dev/null
python3 -c "import json;print(json.load(open('$HOME/.claude/settings.json')).get('outputStyle','<none>'))" 2>/dev/null
```

Tell the user which output style is selected now, if any.

## Step 2: Explain the choice, then ask

Say this in your own words, briefly:

- The three skills fire on a task, so they govern commit messages, documents,
  and product copy. They cannot change how Claude talks in ordinary replies,
  because a reply has no task trigger.
- The output style covers replies. It loads on every turn.
- Only one output style is active at a time. Turning this one on replaces
  whatever they run now.
- It costs about 400 tokens on every turn.

Then ask whether to turn it on. If they decline, skip to step 4.

If step 1 showed a different output style already selected, name it and
confirm they want to replace it before going further.

## Step 3: Install and select the style

```bash
mkdir -p "$HOME/.claude/output-styles"
cp "${CLAUDE_PLUGIN_ROOT}/output-styles/writing-style.md" "$HOME/.claude/output-styles/"
```

Back up settings, then set the key. Show the user the diff:

```bash
cp "$HOME/.claude/settings.json" "$HOME/.claude/settings.json.bak"
python3 - <<'PY'
import json, collections, os
p = os.path.expanduser('~/.claude/settings.json')
d = json.load(open(p), object_pairs_hook=collections.OrderedDict)
d['outputStyle'] = 'writing-style'
json.dump(d, open(p, 'w'), indent=2); open(p, 'a').write('\n')
PY
diff "$HOME/.claude/settings.json.bak" "$HOME/.claude/settings.json" || true
```

Confirm the file is still valid JSON before moving on.

## Step 4: Offer to record their conventions

The plugin ships knowing nothing about their organization. Ask whether they
have any of these, and offer to append a section to their `CLAUDE.md`:

- A commit subject convention, for example `fix(scope): lowercase`
- A ticket prefix on pull request titles, for example `[ENG-1234]`
- A house copy guide that wins over the product-copy skill
- Product names that must never be reworded

If they give you any, append a `## Writing conventions` section listing them.
Ask which `CLAUDE.md` to edit when more than one applies. Skip this step
without comment if they have none.

## Step 5: Report

Tell them, in plain sentences:

- Which files you changed, by path
- That the output style applies after they restart Claude Code, not now
- That `/skills:check-writing` reviews a file or a draft and reports findings
  without editing
- How to undo it: delete `~/.claude/output-styles/writing-style.md` and remove
  the `outputStyle` key, or pick a different style under `/config`

Do not restate the rules the skills teach. They can read the skills.
