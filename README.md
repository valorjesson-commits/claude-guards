# claude-guards

PreToolUse hooks for Claude Code that refuse a tool call at the point of the mistake and tell the model what to do instead.

- **refuse-detached-bash** (Bash): refuses `nohup`, `setsid` and `disown` in a foreground call. A job detached that way sends Claude Code no completion notice, so the session never learns it ended. `run_in_background: true` calls pass; the refusal message shows how to run a job that must outlive Claude Code.
- **require-subagent-model** (Agent): refuses a subagent launch without an explicit `model`, so each one runs on a deliberately chosen model instead of the default. Forks are exempt: they always inherit the parent model.

Needs `sh` and `jq`.

## Subagent model policy

`require-subagent-model` enforces explicit model choice on Agent calls (except forks). Use this compatibility guide:

| Work type | Recommended model family |
|---|---|
| Search, read, mechanical edits | haiku |
| Normal coding and review | sonnet |
| Hard reasoning only | opus/fable |

## Install

```
/plugin install guards --marketplace sasa-tomic/claude-guards
```

## Update

```
/plugin marketplace update claude-guards
```

Then `/plugin`, Installed tab, guards, Update now, then `/reload-plugins`.

## Remove

```
/plugin uninstall guards
/plugin marketplace remove claude-guards
/reload-plugins
```

## Test

```
sh hooks/refuse-detached-bash.test.sh
sh hooks/require-subagent-model.test.sh
```

Each prints `ok`, or a `FAIL` line per wrong case and exits 1.
