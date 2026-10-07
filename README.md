# Swingo

Plataforma para trabajadores **FIFO** (_Fly-In, Fly-Out_): alojamiento entre swings, marketplace de segunda mano y comunidad. Sin comisiones. iOS · Android · Web.

- Contexto para Claude Code: [`CLAUDE.md`](./CLAUDE.md)
- Visión de producto: [`docs/01-vision-producto.md`](./docs/01-vision-producto.md)
- Alcance del MVP: [`docs/02-mvp.md`](./docs/02-mvp.md)
- Arquitectura: [`docs/03-arquitectura.md`](./docs/03-arquitectura.md)
- Backlog: [`docs/05-backlog.md`](./docs/05-backlog.md)
- Ruta de implementación: [`docs/07-ruta-implementacion.md`](./docs/07-ruta-implementacion.md)
- Trabajo con Claude Code: [`docs/08-claude-code.md`](./docs/08-claude-code.md)

> Estado: Sprint 0 en curso. Scaffold del monorepo completado con SWG-001.

## Quick start

Requisitos: **Node 22 LTS** (ver `.nvmrc`) y **pnpm 10**. Con `nvm` instalado: `nvm use`.

```bash
pnpm install          # install all workspace dependencies
pnpm dev              # run api + app in parallel (turbo)
pnpm lint             # lint all packages
pnpm typecheck        # type-check all packages
pnpm test             # run all tests
pnpm format:check     # verify formatting
```
