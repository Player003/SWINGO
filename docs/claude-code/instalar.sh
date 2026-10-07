#!/usr/bin/env bash
# Instala la configuración de Claude Code de Swingo en .claude/
# Uso (desde la raíz del repo):  bash docs/claude-code/instalar.sh
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC="$ROOT/docs/claude-code"
DEST="$ROOT/.claude"

mkdir -p "$DEST/agents" "$DEST/skills" "$DEST/hooks"

cp "$SRC"/agents/*.md "$DEST/agents/"
cp -R "$SRC"/skills/. "$DEST/skills/"
cp "$SRC"/hooks/*.sh "$DEST/hooks/"
chmod +x "$DEST"/hooks/*.sh

if [ -f "$DEST/settings.json" ]; then
  cp "$SRC/settings.json" "$DEST/settings.swingo.json"
  echo "⚠️  Ya existía .claude/settings.json: la propuesta se copió en .claude/settings.swingo.json para que la fusiones a mano."
else
  cp "$SRC/settings.json" "$DEST/settings.json"
fi

# Entradas recomendadas en .gitignore
touch "$ROOT/.gitignore"
for entry in ".claude/settings.local.json" ".claude/worktrees/"; do
  grep -qxF "$entry" "$ROOT/.gitignore" || echo "$entry" >> "$ROOT/.gitignore"
done

command -v jq >/dev/null 2>&1 || echo "⚠️  Falta jq (los hooks lo necesitan): brew install jq"

echo "✅ Configuración instalada en .claude/"
echo "   Agentes: $(ls "$DEST/agents" | tr '\n' ' ')"
echo "   Skills:  $(ls "$DEST/skills" | tr '\n' ' ')"
echo "   Abre Claude Code y prueba: /implementar-historia SWG-001"
