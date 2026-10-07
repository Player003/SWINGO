---
name: nuevo-contexto
description: Crea el esqueleto de un nuevo contexto acotado hexagonal en el backend de Swingo (domain, application, infrastructure, interfaces y módulo NestJS) siguiendo el patrón del proyecto.
argument-hint: "nombre-del-contexto"
disable-model-invocation: true
---

Crea el esqueleto del contexto acotado **$ARGUMENTS** en `apps/api/src/contexts/$ARGUMENTS/`.

1. Confirma que el contexto está previsto en `docs/03-arquitectura.md` §4.3. Si no lo está, detente y propón primero un ADR (`/nuevo-adr`).
2. Usa como patrón el contexto más completo que exista (revisa sus carpetas y nombres).
3. Crea:
   ```
   domain/            # entidades, value objects, eventos, errors/
   application/
     ports/           # interfaces + tokens Symbol
     use-cases/
     dto/
   infrastructure/
     persistence/     # schema Drizzle, repositorio, mapper
     adapters/
   interfaces/
     http/            # controller
   $ARGUMENTS.module.ts
   ```
4. Incluye un agregado raíz mínimo, su puerto de repositorio, un adaptador Drizzle, un caso de uso de ejemplo y sus tests (dominio + caso de uso con fake en memoria), todo con las cabeceras TSDoc del equipo.
5. Registra el módulo en la aplicación y añade el contexto a las reglas de dependency-cruiser / eslint-plugin-boundaries.
6. Ejecuta `pnpm --filter api lint && pnpm --filter api typecheck && pnpm --filter api test` y muestra la salida.
