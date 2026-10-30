#!/bin/sh
# PreToolUse(Agent): refuse a subagent launch that leaves the model at its default. The orchestrator must pick the
# cheapest model that does the job with quality (haiku: search/read/mechanical edits; sonnet: normal coding/review;
# opus/fable: only hard reasoning). Forks always inherit the parent model, so they are exempt.
in=$(cat)
type=$(printf '%s' "$in" | jq -r '.tool_input.subagent_type // "" | ascii_downcase')
model=$(printf '%s' "$in" | jq -r '.tool_input.model // ""')
trimmed_model=$(printf '%s' "$model" | sed 's/^[[:space:]]*//; s/[[:space:]]*$//')
[ "$type" = "fork" ] && exit 0
[ -n "$trimmed_model" ] && exit 0
echo "Agent call refused: set an explicit 'model' (cheapest that does the job with quality: haiku for search/read/mechanical work, sonnet for coding/review, opus/fable only for hard reasoning)." >&2
exit 2
