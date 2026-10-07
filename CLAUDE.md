# SWINGO — Contexto para Claude Code

## Qué es

Plataforma **multiplataforma (iOS, Android, Web)** para trabajadores **FIFO** (*Fly-In, Fly-Out*) y "golondrina" que centraliza **alojamiento** (estilo Booking), **marketplace de segunda mano** (estilo Facebook Marketplace) y **comunidad** (eventos; luego guías). Reemplaza a los grupos cerrados de WhatsApp donde hoy se ofrecen habitaciones mientras el inquilino está en la mina durante su *swing*.

- Lanzamiento: **Australia** (ciudad piloto: Perth, a confirmar). Visión: **global**.
- Equipo: **Martin Melleretzky** (fundador de producto / PO, en Australia) + **Matías Roldán** (CTO) + Claude Code.

## Principios de producto

1. **Sin pagos ni comisiones en el MVP — decisión revisable.** Hoy Swingo solo conecta: no cobra, no retiene ni procesa pagos, y los precios son informativos. El modelo de negocio **puede cambiar al escalar** (comisiones, pagos entre usuarios, anuncios destacados, suscripciones), así que el diseño no debe impedirlo: dinero siempre como `Money`, máquinas de estado extensibles y un futuro contexto `payments` detrás de puertos. No implementar nada de pagos sin un ADR nuevo. (ADR-0004)
2. **Swingo no es parte del acuerdo** entre anfitrión y huésped. El anfitrión acepta términos y declara autorización del propietario **antes de publicar**. (`docs/06-legal.md`)
3. **Usuarios verificados** (email + teléfono) para publicar y solicitar; **reseñas solo tras estancias reales** (solicitud `COMPLETED`).
4. **El tráfico es el activo** (el negocio futuro es publicidad/partners): instrumentar analítica en los flujos clave.
5. **Global desde el diseño**: nada de textos hardcodeados (i18n `en-AU` + `es`), dinero como `Money` (entero + ISO 4217), instantes en UTC, estancias como fechas locales, direcciones genéricas con `country_code`.
6. **Mobile-first.**

## Arquitectura (resumen)

- **Monorepo TypeScript** (pnpm + Turborepo): `apps/api` (NestJS), `apps/app` (Expo: iOS/Android/Web), `apps/admin` (Next.js), `packages/{contracts,api-client,i18n,ui-tokens,config}`.
- **Backend: monolito modular + arquitectura hexagonal** por contexto acotado en `apps/api/src/contexts/<context>/{domain,application,infrastructure,interfaces}`.
  - Contextos: `identity`, `accommodation`, `booking`, `reviews`, `messaging`, `marketplace`, `community`, `moderation`, `notifications`, `engagement` (futuros: `promotions`, `payments`).
- **PostgreSQL + PostGIS**, Drizzle (solo en adaptadores). Supabase como proveedor inicial de Auth/DB/Storage, siempre detrás de puertos.
- Detalle completo: `docs/03-arquitectura.md` y `docs/adr/`.

### Reglas de dependencia (obligatorias)

- `domain/` es **TypeScript puro**: no importa NestJS, Drizzle, Zod, Supabase ni nada de `infrastructure/` o `interfaces/`. Nada de `new Date()` / `Date.now()`: usar el puerto `Clock`.
- `application/` depende solo de `domain/` y de **sus propios puertos** (interfaces). Un caso de uso = una clase con `execute()`.
- `infrastructure/` implementa puertos; `interfaces/` (controllers, gateways, jobs) valida input con Zod y llama a casos de uso.
- **Nunca** importar `domain/` o repositorios de otro contexto: usar un puerto propio + adaptador, o eventos de dominio.
- Las reglas de negocio viven en entidades/value objects, no en controllers ni en casos de uso.
- Todo servicio externo (auth, storage, email, push, mapas, analítica, búsqueda) va detrás de un puerto.

## Convenciones

@docs/04-convenciones.md

Lo esencial:
- Código, nombres, commits y endpoints en **inglés**; documentación TSDoc y `docs/` en **español**.
- **Cabecera TSDoc en cada clase y método público** con `@author Matías Roldán`, `@date dd/MM/yyyy`, `@param`, `@returns`, `@throws`, `@where` (ver plantilla en convenciones). Al modificar: añadir `@modified`.
- TS `strict`, sin `any`, exports nombrados, archivos `kebab-case` con sufijo de rol (`.entity.ts`, `.use-case.ts`, `.port.ts`, `.repository.ts`, `.controller.ts`, `.spec.ts`).
- Tests: dominio y casos de uso unitarios (fakes en memoria de los puertos), repositorios con integración, flujos críticos E2E.
- Conventional Commits; ramas `feat/SWG-123-descripcion`.

## Cómo trabajar en este repo

1. Antes de implementar una historia, lee su entrada en `docs/05-backlog.md` y las reglas de negocio en `docs/02-mvp.md`. Para historias completas usa `/implementar-historia SWG-XXX` y los subagentes de `.claude/agents/` (architect, domain-engineer, backend-engineer, app-engineer, qa-engineer, code-reviewer, security-reviewer).
2. Si la tarea toca **modelo de datos, arquitectura, un nuevo proveedor externo o el alcance del MVP**, propón un plan breve y **espera confirmación** antes de escribir código. Si cambia una decisión, propone un ADR nuevo en `docs/adr/`.
3. Implementa de dentro hacia fuera: **dominio + tests → caso de uso + tests → adaptadores → controller/contrato → cliente**.
4. Corta en vertical (una historia funcionando de punta a punta), no por capas.
5. Ejecuta lint, typecheck y tests antes de dar algo por terminado y repasa la Definition of Done (`docs/05-agile.md`).
6. No añadas dependencias nuevas sin mencionarlo y justificarlo.
7. No inventes reglas de negocio: si algo no está en los docs, pregunta.

## Comandos

> Se completan en el Sprint 0 (SWG-001). Objetivo:

```bash
pnpm install
pnpm dev               # api + app en paralelo (turbo)
pnpm --filter api dev
pnpm --filter app start  # Expo (i: iOS, a: Android, w: Web)
pnpm lint && pnpm typecheck && pnpm test
pnpm --filter api db:migrate
docker compose -f infra/docker-compose.yml up -d   # Postgres + PostGIS
```

## Mapa de documentación

| Archivo | Cuándo leerlo |
|---|---|
| `docs/01-vision-producto.md` | Entender el porqué, usuarios, modelo de negocio, principios. |
| `docs/02-mvp.md` | **Reglas de negocio**, alcance, flujos críticos, requisitos no funcionales. |
| `docs/03-arquitectura.md` | Estructura, contextos, modelo de datos, API, escala. |
| `docs/04-convenciones.md` | Clean Code, documentación, testing, git. |
| `docs/05-agile.md` | Roles, DoR/DoD, roadmap de sprints, flujo con Claude Code. |
| `docs/05-backlog.md` | Historias con IDs `SWG-XXX` y criterios de aceptación. |
| `docs/06-legal.md` | Responsabilidad legal y su reflejo en el sistema. |
| `docs/07-ruta-implementacion.md` | Checklist de implementación por fases con enlaces a documentación oficial. |
| `docs/08-claude-code.md` | Cómo trabajar con Claude Code: subagentes, skills, hooks, multi-agente. |
| `docs/adr/` | Decisiones de arquitectura. |
| `docs/fuentes/brief-original.md` | Brief, textos y transcripciones originales del fundador. |
| `docs/claude-code/` | Plantillas de agentes, skills, hooks y settings (instalar con `bash docs/claude-code/instalar.sh`). |

## Glosario

- **FIFO** — *Fly-In, Fly-Out*: trabajador que vuela al sitio (mina, planta) por un periodo y vuelve a la ciudad en sus días libres.
- **Swing** — periodo de trabajo en el sitio. **Roster** — patrón de swing, p. ej. `2:1` (2 semanas dentro, 1 fuera), `8:6` (días).
- **Golondrina** — trabajador temporal/rotativo que se desplaza según el trabajo.
- **Anfitrión (host)** — quien ofrece la habitación (a menudo inquilino que se va de swing). **Huésped (guest)** — quien la ocupa.
- **Solicitud de reserva (BookingRequest)** — petición sin pago que el anfitrión acepta o rechaza.
- **Ute** — camioneta pick-up (relevante para filtro de parking).
- **Backpacker** — viajero con visa working holiday; gran parte del público objetivo.
