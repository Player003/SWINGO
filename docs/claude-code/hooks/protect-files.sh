#!/usr/bin/env bash
# Hook PreToolUse (Edit|Write) de Swingo.
# Bloquea cambios en archivos sensibles y en migraciones ya existentes.
# Exit 2 = bloquear y explicar el motivo a Claude por stderr.
# Requiere jq.

INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')
[ -z "$FILE_PATH" ] && exit 0

block() {
  echo "Bloqueado por protect-files.sh: $1" >&2
  exit 2
}

case "$FILE_PATH" in
  *.env.example) ;;  # la plantilla sin secretos sí se puede editar
  */.env|*/.env.*|.env|.env.*)
    block "$FILE_PATH contiene secretos. Edítalo tú manualmente; Claude solo puede tocar .env.example." ;;
  *pnpm-lock.yaml)
    block "No edites pnpm-lock.yaml a mano: usa pnpm add/remove/install." ;;
  */.git/*)
    block "No se modifica el directorio .git." ;;
esac

# Las migraciones ya creadas no se editan: se crea una nueva.
if [[ "$FILE_PATH" == */migrations/*.sql && -f "$FILE_PATH" ]]; then
  block "$FILE_PATH es una migración existente. Crea una migración nueva en lugar de modificarla."
fi

exit 0
