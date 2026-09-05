#!/bin/bash

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

# Bloqueia sempre, independente da branch
DANGEROUS_PATTERNS=(
  "push --force"
  "push -f "
  "push .*--force"
  "reset --hard"
  "git clean -fd"
  "git clean -f"
  "git branch -D"
  "git checkout \."
  "git restore \."
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$COMMAND" | grep -qE "$pattern"; then
    echo "BLOCKED: '$COMMAND' bate no padrão perigoso '$pattern'. O usuário não te deu autoridade pra isso." >&2
    exit 2
  fi
done

# Push direto pra branch protegida (main/master) — o fluxo deste projeto é sempre feature branch -> MR -> validação humana.
if echo "$COMMAND" | grep -qE "git push[^|&;]*\s(origin\s+)?(main|master)(\s|$)"; then
  echo "BLOCKED: '$COMMAND' — push direto em branch protegida. Abra uma feature branch e uma merge request." >&2
  exit 2
fi

exit 0
