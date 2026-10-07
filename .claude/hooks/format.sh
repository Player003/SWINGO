#!/usr/bin/env bash
# Hook PostToolUse (Edit|Write) de Swingo.
# Formatea con Prettier el archivo que Claude acaba de editar.
# No bloquea nunca: si Prettier aún no está instalado (antes de SWG-001), no hace nada.
# Requiere jq.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] && exit 0
[ -f "$FILE_PATH" ] || exit 0

cd "$CLAUDE_PROJECT_DIR" 2>/dev/null || exit 0
if [ -x node_modules/.bin/prettier ]; then
  node_modules/.bin/prettier --write --ignore-unknown "$FILE_PATH" >/dev/null 2>&1
fi

exit 0
