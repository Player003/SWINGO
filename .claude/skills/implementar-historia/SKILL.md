---
name: implementar-historia
description: Implementa de punta a punta una historia del backlog de Swingo (SWG-XXX) orquestando los subagentes especialistas, con arquitectura hexagonal, tests y Definition of Done.
argument-hint: SWG-XXX
disable-model-invocation: true
---

Vas a implementar la historia **$ARGUMENTS** de Swingo actuando como **orquestador**. Delega en los subagentes del proyecto y mantén este contexto limpio: pásales en cada delegación la historia, el plan aprobado, los archivos relevantes y qué significa "terminado".

## 1. Entender
- Lee la historia en `docs/05-backlog.md` y sus criterios de aceptación. Si no tiene criterios, redáctalos en Gherkin y **pídeme validación** antes de seguir.
- Lee las reglas de negocio relacionadas en `docs/02-mvp.md`.

## 2. Planificar
- Delega en el subagente **architect** el plan de implementación.
- Muéstrame el plan resumido. Si toca modelo de datos, arquitectura, un proveedor externo o el alcance del MVP, **espera mi confirmación**.

## 3. Implementar (de dentro hacia fuera)
1. Contrato en `packages/contracts` (si hay API nueva o modificada).
2. **domain-engineer** → dominio + tests (si el plan toca el dominio).
3. **backend-engineer** → casos de uso, puertos, adaptadores, controllers, migraciones.
4. **app-engineer** → pantallas, hooks, i18n (puede ir en paralelo al backend una vez fijado el contrato, si no comparten archivos).
5. **qa-engineer** → tests de aceptación a partir de los criterios y ejecución de la suite.

## 4. Verificar
- Ejecuta `pnpm lint && pnpm typecheck && pnpm test` y muestra la salida.
- Delega en **code-reviewer** la revisión del diff. Si la historia toca auth, datos personales, chat o subida de archivos, delega también en **security-reviewer**.
- Corrige los hallazgos BLOQUEANTE/IMPORTANTE y vuelve a verificar.

## 5. Cerrar
- Resumen de lo hecho (archivos, endpoints, migraciones, pantallas).
- Checklist de la Definition of Done (`docs/05-agile.md`) marcado.
- Mensaje de commit en Conventional Commits, p. ej. `feat(accommodation): add date range search (SWG-030)`.
