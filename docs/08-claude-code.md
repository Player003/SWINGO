# 08 · Cómo trabajar con Claude Code en Swingo

> Guía práctica para sacar el máximo partido a Claude Code: hábitos, piezas de configuración, arquitectura multi-agente para este proyecto y cómo crear agentes propios.
> Las plantillas listas para usar están en `docs/claude-code/` y se instalan con `bash docs/claude-code/instalar.sh` (ver §7).
>
> Verificado contra la documentación oficial a 07/10/2026. Claude Code evoluciona rápido: ante la duda, manda la doc → 🔗 [code.claude.com/docs](https://code.claude.com/docs/en/overview).

---

## 1. Las 6 ideas que más rendimiento dan

1. **El contexto es el recurso escaso.** Cada archivo leído y cada salida de comando ocupa la ventana de contexto, y la calidad baja cuando se llena. → `/clear` entre historias, subagentes para investigar, CLAUDE.md corto.
2. **Dale a Claude una forma de verificar su trabajo.** Tests, typecheck, build, capturas. Sin verificación, tú eres el bucle de corrección. En Swingo: _cada historia termina con `pnpm lint && pnpm typecheck && pnpm test` en verde_.
3. **Explorar → Planificar → Implementar → Commit.** Usa _plan mode_ (`Shift+Tab` hasta ver `⏸ plan mode on`) para historias que tocan varios archivos o el modelo de datos. Si el cambio cabe en una frase, sáltate el plan.
4. **Sé específico.** Referencia archivos con `@`, nombra la historia (`SWG-030`), señala un patrón existente a imitar ("sigue el patrón de `publish-listing.use-case.ts`").
5. **Corrige pronto.** `Esc` para frenar, `Esc Esc` o `/rewind` para volver a un checkpoint. Si has corregido dos veces lo mismo, `/clear` y reescribe el prompt con lo aprendido.
6. **Lo que debe pasar siempre, va en un hook; lo que es conocimiento ocasional, en una skill; lo que es regla general, en CLAUDE.md.**

🔗 [Best practices](https://code.claude.com/docs/en/best-practices) · [How Claude Code works](https://code.claude.com/docs/en/how-claude-code-works) · [Common workflows](https://code.claude.com/docs/en/common-workflows)

---

## 2. Mapa de piezas: qué usar para qué

| Pieza                            | Qué es                                                                              | Cuándo usarla en Swingo                                                                                                                           | Dónde vive                                                                                        |
| -------------------------------- | ----------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| **CLAUDE.md**                    | Contexto que se carga en _todas_ las sesiones                                       | Principios, reglas de arquitectura, comandos, mapa de docs. Mantenerlo corto.                                                                     | `CLAUDE.md` (raíz). Se pueden importar archivos con `@ruta`.                                      |
| **Skills**                       | Instrucciones/flujos que Claude carga **bajo demanda** (o tú con `/nombre`)         | Flujos repetibles: implementar historia, crear ADR, crear un contexto hexagonal nuevo, escribir historia. Conocimiento que no hace falta siempre. | `.claude/skills/<nombre>/SKILL.md` (los antiguos `.claude/commands/*.md` siguen funcionando)      |
| **Subagentes**                   | Asistentes especializados con **su propio contexto**, prompt, herramientas y modelo | Investigar sin ensuciar el contexto, revisar código con ojos frescos, especialistas por capa.                                                     | `.claude/agents/<nombre>.md`                                                                      |
| **Hooks**                        | Comandos que se ejecutan **siempre** en eventos del ciclo de vida                   | Formatear tras cada edición, bloquear edición de `.env` o migraciones ya aplicadas, avisar cuando Claude espera input.                            | `.claude/settings.json` → `hooks`                                                                 |
| **Permisos**                     | Qué puede hacer Claude sin preguntar / nunca                                        | Permitir `pnpm test`, `git status`; denegar leer `.env`, `git push --force`.                                                                      | `.claude/settings.json` → `permissions`                                                           |
| **MCP**                          | Conectores a herramientas externas                                                  | GitHub, Supabase, Sentry, Figma, Postgres (lectura).                                                                                              | `.mcp.json` o `claude mcp add`                                                                    |
| **Plugins**                      | Paquete de skills + agentes + hooks + MCP                                           | Más adelante, para compartir el "kit Swingo" entre repos o personas.                                                                              | Marketplace / `/plugin`                                                                           |
| **Modo no interactivo**          | `claude -p "..."` en scripts y CI                                                   | Revisiones automáticas, migraciones masivas, generación de changelog.                                                                             | Terminal / CI                                                                                     |
| **GitHub Actions**               | Claude en PRs e issues (`@claude`)                                                  | Revisión automática de PRs contra la DoD.                                                                                                         | `.github/workflows/`                                                                              |
| **Worktrees**                    | Copias aisladas del repo para sesiones paralelas                                    | Trabajar dos historias independientes a la vez.                                                                                                   | `claude --worktree swg-070` / `isolation: worktree` (añadir `.claude/worktrees/` al `.gitignore`) |
| **Agent teams** _(experimental)_ | Varias sesiones coordinadas con lista de tareas compartida y mensajes               | Investigación o revisión en paralelo con debate entre agentes.                                                                                    | `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`                                                          |
| **Agent SDK**                    | Claude Code como librería (TS/Python)                                               | Construir automatizaciones propias fuera del CLI (p. ej. un bot de triaje). No es necesario para el MVP.                                          | Código propio                                                                                     |

🔗 [Extend Claude Code (cuándo usar cada pieza)](https://code.claude.com/docs/en/features-overview) · [Memory / CLAUDE.md](https://code.claude.com/docs/en/memory) · [Skills](https://code.claude.com/docs/en/skills) · [Subagents](https://code.claude.com/docs/en/sub-agents) · [Hooks guide](https://code.claude.com/docs/en/hooks-guide) · [Permissions](https://code.claude.com/docs/en/permissions) · [MCP](https://code.claude.com/docs/en/mcp) · [Plugins](https://code.claude.com/docs/en/plugins/overview) · [Headless](https://code.claude.com/docs/en/headless) · [GitHub Actions](https://code.claude.com/docs/en/github-actions) · [Worktrees](https://code.claude.com/docs/en/worktrees) · [Agent teams](https://code.claude.com/docs/en/agent-teams) · [Agent SDK](https://code.claude.com/docs/en/agent-sdk/overview)

---

## 3. El ciclo de trabajo de una historia

```
 ┌──────────── 1 sesión limpia por historia (/clear) ────────────┐
 │                                                               │
 │  /implementar-historia SWG-030                                │
 │     │                                                         │
 │     ├─ architect (plan mode, solo lectura) → plan + archivos  │
 │     │        ▲ tú apruebas / corriges el plan                 │
 │     ├─ contrato primero: packages/contracts (Zod)             │
 │     ├─ domain-engineer → dominio + tests (TDD)                │
 │     ├─ backend-engineer → casos de uso, adaptadores, API      │
 │     ├─ app-engineer → pantallas Expo + i18n                   │
 │     ├─ qa-engineer → tests de aceptación (Gherkin → tests)    │
 │     ├─ verificación: lint + typecheck + test                  │
 │     └─ code-reviewer (contexto fresco) → hallazgos → arreglar │
 │                                                               │
 │  commit (Conventional Commits) → PR → CI → merge              │
 └───────────────────────────────────────────────────────────────┘
```

**Prompts útiles**

- Para arrancar una funcionalidad grande con requisitos difusos, que Claude te entreviste:
  > "Quiero construir [X]. Entrevístame en detalle con AskUserQuestion sobre implementación, UX, casos límite y trade-offs. Cuando terminemos, escribe la especificación en `docs/specs/[x].md`."
  > Luego, **sesión nueva** para implementar a partir de la spec.
- Para investigar sin gastar contexto:
  > "Usa subagentes para investigar cómo resolver la búsqueda por `daterange` con Drizzle y PostGIS, y resume opciones con pros y contras."
- Para una revisión independiente antes de dar algo por hecho:
  > "Usa el subagente code-reviewer para revisar el diff contra la historia SWG-030 y la DoD. Reporta solo problemas de corrección o de requisitos."

**Gestión de sesión**

| Necesidad                                 | Comando                                                            |
| ----------------------------------------- | ------------------------------------------------------------------ |
| Empezar historia nueva                    | `/clear`                                                           |
| Resumir cuando el contexto crece          | `/compact Conserva archivos modificados y comandos de test`        |
| Ver qué ocupa el contexto                 | `/context`                                                         |
| Volver atrás (código y/o conversación)    | `Esc Esc` o `/rewind`                                              |
| Nombrar y retomar una sesión              | `/rename swg-030-search` · `claude --continue` · `claude --resume` |
| Pregunta lateral sin ensuciar el contexto | `/btw ...`                                                         |
| Revisar el diff actual                    | `/code-review`                                                     |

🔗 [Sessions](https://code.claude.com/docs/en/sessions) · [Checkpointing](https://code.claude.com/docs/en/checkpointing) · [Permission modes / plan mode](https://code.claude.com/docs/en/permission-modes) · [Commands](https://code.claude.com/docs/en/commands) · [Costs](https://code.claude.com/docs/en/costs)

---

## 4. Arquitectura multi-agente para Swingo

### 4.1 Principio: los agentes siguen a la arquitectura

La arquitectura hexagonal ya separa responsabilidades (dominio, aplicación, adaptadores, cliente). Los agentes se especializan **por capa y por rol**, igual que lo haría un equipo humano. Cada uno tiene un prompt corto y enfocado, solo las herramientas que necesita y el modelo adecuado a su tarea.

```
                        ┌──────────────────────────┐
                        │  Sesión principal (tú +   │
                        │  Claude) = ORQUESTADOR    │
                        └────────────┬─────────────┘
          ┌──────────────┬───────────┼────────────┬──────────────┐
          ▼              ▼           ▼            ▼              ▼
   ┌────────────┐ ┌────────────┐ ┌──────────┐ ┌──────────┐ ┌──────────────┐
   │ architect  │ │  domain-   │ │ backend- │ │   app-   │ │ qa-engineer  │
   │ (opus,     │ │  engineer  │ │ engineer │ │ engineer │ │ (tests de    │
   │ solo lect.)│ │ (TDD puro) │ │ (NestJS, │ │ (Expo,   │ │  aceptación, │
   │            │ │            │ │ Drizzle) │ │  i18n)   │ │  E2E)        │
   └────────────┘ └────────────┘ └──────────┘ └──────────┘ └──────────────┘
                                     │
                     ┌───────────────┴───────────────┐
                     ▼                               ▼
              ┌──────────────┐                ┌──────────────────┐
              │ code-reviewer│                │ security-reviewer│
              │ (contexto    │                │ (auth, permisos, │
              │  fresco)     │                │  PII, OWASP)     │
              └──────────────┘                └──────────────────┘
```

| Agente              | Modelo   | Herramientas                                             | Responsabilidad                                                                                                                         |
| ------------------- | -------- | -------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `architect`         | `opus`   | Solo lectura (Read, Grep, Glob)                          | Plan de la historia: contextos, agregados, puertos, archivos, migraciones, riesgos. Vigila la regla de dependencias. No escribe código. |
| `domain-engineer`   | `sonnet` | Read, Edit, Write, Bash, Grep, Glob                      | Entidades, value objects, eventos y errores de dominio con TDD. TypeScript puro.                                                        |
| `backend-engineer`  | `sonnet` | Read, Edit, Write, Bash, Grep, Glob                      | Casos de uso, puertos, adaptadores Drizzle/Supabase, controllers, contratos Zod, migraciones.                                           |
| `app-engineer`      | `sonnet` | Read, Edit, Write, Bash, Grep, Glob                      | Pantallas Expo Router, hooks TanStack Query, componentes, i18n, accesibilidad.                                                          |
| `qa-engineer`       | `sonnet` | Read, Edit, Write, Bash, Grep, Glob                      | Traduce criterios Gherkin a tests de aceptación/E2E; ejecuta la suite; reporta fallos con evidencia.                                    |
| `code-reviewer`     | `opus`   | Read, Grep, Glob, Bash (solo para `git diff/log/status`) | Revisa el diff contra historia, arquitectura, convenciones y DoD. Solo reporta problemas reales.                                        |
| `security-reviewer` | `opus`   | Read, Grep, Glob, Bash (solo para `git diff/log/status`) | Autorización en casos de uso, exposición de datos de contacto, validación de input, secretos, rate limiting.                            |

Las definiciones completas están en `docs/claude-code/agents/`.

### 4.2 Patrones de orquestación (de más simple a más complejo)

| Patrón                             | Cómo                                                                                                                                     | Úsalo cuando                                                                                                 | Coste                      |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------ | -------------------------- |
| **1. Sesión única**                | Tú + Claude, sin delegar                                                                                                                 | Cambios pequeños, bugs acotados                                                                              | Bajo                       |
| **2. Investigador**                | "Usa subagentes para investigar X" (agente `Explore` integrado)                                                                          | Antes de planificar algo que no conoces                                                                      | Bajo — protege tu contexto |
| **3. Pipeline por capas**          | architect → domain → backend → app → qa → reviewer, **secuencial**                                                                       | Una historia vertical normal                                                                                 | Medio                      |
| **4. Escritor / revisor**          | Un agente implementa; otro, con contexto limpio, revisa                                                                                  | Siempre antes de cerrar una historia                                                                         | Medio                      |
| **5. Contrato primero + paralelo** | Se fija el contrato en `packages/contracts`; luego `backend-engineer` y `app-engineer` trabajan **en paralelo**, cada uno en su worktree | Historias grandes con API + UI                                                                               | Medio-alto                 |
| **6. Historias en paralelo**       | 2–3 sesiones, cada una en su **worktree** y su rama (p. ej. SWG-070 marketplace y SWG-080 eventos)                                       | Historias independientes que no tocan los mismos archivos                                                    | Alto                       |
| **7. Agent team** _(experimental)_ | Un lead + 3–5 compañeros con tareas compartidas y mensajes entre ellos                                                                   | Revisión de PR desde varios ángulos, investigación con hipótesis enfrentadas, diseño explorando alternativas | Muy alto                   |
| **8. Fan-out no interactivo**      | Bucle de `claude -p` o `/batch`                                                                                                          | Migraciones masivas (renombrar, añadir cabeceras TSDoc a todo un contexto)                                   | Variable                   |

**Reglas para que el multi-agente funcione bien**

- **Nunca dos agentes editando los mismos archivos.** El reparto por capas (y el contrato primero) lo evita de forma natural.
- **El prompt de delegación debe ser autosuficiente.** El subagente no ve tu conversación: pásale la historia, los archivos relevantes y el criterio de "terminado".
- **El que implementa no se revisa a sí mismo.** El reviewer siempre en contexto fresco.
- **Empieza simple.** Patrones 1–4 cubren el 90 % del MVP. Usa 5–7 solo cuando el paralelismo aporte de verdad: cada agente extra multiplica el consumo de tokens.
- **Pide evidencia, no afirmaciones:** la salida de los tests, el comando ejecutado, una captura.
- Los subagentes pueden lanzar otros subagentes (hasta 3 niveles por defecto). Para los especialistas de Swingo no hace falta: quita `Agent` de sus herramientas para mantener el control en el orquestador.

### 4.3 Elegir modelo y esfuerzo por agente

- **`opus`** para razonamiento difícil: arquitectura, revisión, seguridad, debugging complejo.
- **`sonnet`** para implementación del día a día: buen equilibrio coste/calidad.
- **`haiku`** para tareas mecánicas y búsquedas rápidas.
- `effort` (`low` … `max`) en el frontmatter ajusta cuánto "piensa" el agente.
- `inherit` usa el mismo modelo que la sesión principal.

🔗 [Subagents – choose a model](https://code.claude.com/docs/en/sub-agents) · [Model configuration](https://code.claude.com/docs/en/model-config) · [Costs](https://code.claude.com/docs/en/costs)

---

## 5. Cómo crear un agente (subagente)

### 5.1 Paso a paso

1. **Define una sola responsabilidad.** "Revisa diffs contra la DoD" es bueno; "ayuda con el backend" es demasiado amplio.
2. **Escribe la `description` pensando en cuándo delegar.** Claude decide delegar comparando tu petición con ella. Añadir "Use proactively…" anima a usarlo sin que lo pidas.
3. **Limita las herramientas** (`tools`) a lo imprescindible. Un revisor no necesita `Edit`.
4. **Elige el modelo** (`model`) y, si hace falta, `effort`, `maxTurns`, `isolation: worktree`, `skills` a precargar, `color`.
5. **Escribe el prompt del sistema** (el cuerpo del archivo): rol, qué leer primero, pasos, criterios de calidad, formato de salida.
6. **Guárdalo** en `.claude/agents/<nombre>.md` (proyecto, se versiona en git) o `~/.claude/agents/` (todos tus proyectos).
7. **Pruébalo**: `@"code-reviewer (agent)" revisa el diff actual` fuerza su uso. Ajusta la descripción si Claude no lo elige solo.
8. **Itera**: cuando el agente falle, corrige el prompt, no la conversación.

También puedes pedirle a Claude: _"Crea un subagente en `.claude/agents/` que revise migraciones de Drizzle buscando operaciones destructivas"_ y luego revisar lo que escribe.

### 5.2 Anatomía de un agente

```markdown
---
name: code-reviewer # obligatorio, único, sin ":"
description: Revisa el diff actual contra la historia, la arquitectura hexagonal y la DoD de Swingo. Use proactively antes de cerrar cualquier historia. # obligatorio
tools: Read, Grep, Glob, Bash
model: opus # sonnet | opus | haiku | fable | inherit | id completo
effort: high # opcional
color: purple # opcional
# otros opcionales: disallowedTools, permissionMode, maxTurns, skills,
# mcpServers, hooks, memory, background, isolation: worktree, omitClaudeMd
---

Eres el revisor de código de Swingo. [prompt del sistema…]
```

Puntos clave:

- El cuerpo es **todo** su prompt de sistema (no hereda el de Claude Code). Sí recibe el CLAUDE.md del proyecto (salvo `omitClaudeMd: true`).
- Empieza con **contexto propio y limpio**: solo ve el mensaje de delegación, no tu conversación.
- Solo su **resultado final** vuelve a la sesión principal → mantiene limpio tu contexto.
- `tools` es una lista de herramientas, no de comandos: para limitar _qué_ comandos de Bash puede ejecutar, usa reglas `permissions.deny` en `.claude/settings.json` (aplican también a subagentes) y dilo en el prompt.
- `isolation: worktree` le da una copia aislada del repo (se limpia sola si no cambia nada).
- `skills: [nombre]` precarga skills en su contexto (p. ej. las convenciones de testing).

🔗 [Create custom subagents – referencia completa del frontmatter](https://code.claude.com/docs/en/sub-agents)

### 5.3 Cómo crear una skill (flujo reutilizable)

```markdown
---
name: nuevo-adr
description: Crea un Architecture Decision Record en docs/adr con el formato del proyecto
argument-hint: 'título de la decisión'
disable-model-invocation: true # solo se ejecuta cuando tú escribes /nuevo-adr
---

Crea un ADR para: $ARGUMENTS

1. Mira el último número en docs/adr/ y usa el siguiente.
2. Sigue el formato de docs/adr/0001-*.md (Estado, Fecha, Autor, Contexto, Decisión, Alternativas, Consecuencias).
3. Si sustituye a otro ADR, márcalo como "Sustituido por ADR-XXXX".
```

- `$ARGUMENTS` (todo), `$0`, `$1`… (posicionales).
- `context: fork` + `agent: <nombre>` ejecuta la skill dentro de un subagente.
- `allowed-tools` pre-aprueba herramientas durante esa invocación.
- Una skill puede tener archivos de apoyo (plantillas, scripts) en su carpeta.

🔗 [Skills](https://code.claude.com/docs/en/skills)

### 5.4 Cómo crear un hook

Ejemplo: formatear con Prettier cada archivo que Claude edita (`.claude/settings.json`):

```json
{
  "hooks": {
    "PostToolUse": [
      {
        "matcher": "Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "jq -r '.tool_input.file_path' | xargs npx prettier --write --ignore-unknown"
          }
        ]
      }
    ]
  }
}
```

- Un hook `PreToolUse` que termina con **exit 2** bloquea la acción y le explica el motivo a Claude (ver `docs/claude-code/hooks/protect-files.sh`).
- `/hooks` muestra los hooks configurados.
- Para agent teams existen eventos específicos (`TaskCompleted`, `TeammateIdle`) para imponer puertas de calidad.

🔗 [Hooks guide](https://code.claude.com/docs/en/hooks-guide) · [Hooks reference](https://code.claude.com/docs/en/hooks)

---

## 6. Automatización (cuando el MVP esté en marcha)

| Automatización                    | Cómo                                                                                                                                                                              |
| --------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Revisión de cada PR               | Claude Code GitHub Action con un prompt que use la DoD (`05-agile.md`) como checklist. 🔗 [GitHub Actions](https://code.claude.com/docs/en/github-actions)                        |
| Comprobación previa en local      | `claude -p "Revisa el diff staged contra CLAUDE.md. Responde OK o lista de problemas" --output-format json` en un script. 🔗 [Headless](https://code.claude.com/docs/en/headless) |
| Tareas recurrentes                | Tareas programadas / routines (p. ej. informe semanal de deuda técnica). 🔗 [Routines](https://code.claude.com/docs/en/routines)                                                  |
| Migraciones masivas               | `/batch <instrucción>` (reparte el trabajo entre subagentes en worktrees) o bucle de `claude -p`.                                                                                 |
| Automatizaciones propias (fase 2) | Agent SDK en TypeScript, p. ej. un agente que haga triaje de reportes de moderación o de issues. 🔗 [Agent SDK](https://code.claude.com/docs/en/agent-sdk/overview)               |

---

## 7. Configuración propuesta para el repo

Plantillas en `docs/claude-code/` (no se pudieron escribir directamente en `.claude/` desde la sesión remota):

```
docs/claude-code/
├── instalar.sh                      # copia todo a .claude/
├── settings.json                    # permisos + hooks del proyecto
├── hooks/protect-files.sh           # bloquea .env, lockfile y migraciones ya aplicadas
├── hooks/format.sh                  # Prettier tras cada edición (no bloquea)
├── agents/
│   ├── architect.md
│   ├── domain-engineer.md
│   ├── backend-engineer.md
│   ├── app-engineer.md
│   ├── qa-engineer.md
│   ├── code-reviewer.md
│   └── security-reviewer.md
└── skills/
    ├── implementar-historia/SKILL.md
    ├── nueva-historia/SKILL.md
    ├── nuevo-adr/SKILL.md
    └── nuevo-contexto/SKILL.md
```

**Instalación** (desde la raíz del repo, en tu terminal):

```bash
bash docs/claude-code/instalar.sh
```

Después, en Claude Code: `/hooks` para ver los hooks, `/permissions` para ver permisos y `@"architect (agent)"` para probar un agente.

> Los hooks de formato necesitan `jq` (`brew install jq`) y que exista Prettier en el monorepo (SWG-001). Antes de eso fallan sin bloquear nada.

### Higiene del CLAUDE.md

- Ejecuta `/context` de vez en cuando para ver cuánto ocupa.
- Por cada línea pregúntate: _"¿Si la quito, Claude se equivocará?"_ Si no, fuera (o a una skill).
- Si Claude ignora una regla importante, probablemente el archivo es demasiado largo. Marca con **IMPORTANTE** solo lo crítico.

---

## 8. Anti-patrones a evitar

| Anti-patrón                                   | Solución                                                    |
| --------------------------------------------- | ----------------------------------------------------------- |
| Sesión "cajón de sastre" con tareas mezcladas | `/clear` entre historias                                    |
| Corregir lo mismo una y otra vez              | Tras 2 correcciones: `/clear` + mejor prompt                |
| CLAUDE.md gigante                             | Podar; mover lo ocasional a skills                          |
| Confiar sin verificar                         | Tests/typecheck obligatorios; pedir evidencia               |
| "Investiga X" sin límites                     | Acotar o delegar en un subagente                            |
| Muchos agentes para una tarea secuencial      | Pipeline simple; paralelizar solo trabajo independiente     |
| Reviewer que exige cambios cosméticos         | Pedirle solo problemas de corrección o requisitos           |
| Dejar que Claude decida reglas de negocio     | Si no está en los docs, debe preguntar (regla en CLAUDE.md) |
