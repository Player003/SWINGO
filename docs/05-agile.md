# 05 · Forma de trabajo (Agile)

## 1. Marco

**Scrum ligero** adaptado a un equipo pequeño (fundador de producto + desarrollador + Claude Code como asistente).

| Rol                     | Quién                                                         | Responsabilidad                                                                                                                    |
| ----------------------- | ------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| Product Owner           | Fundador de la idea (vive en Australia, conoce el nicho FIFO) | Prioriza el backlog, valida historias, consigue usuarios beta en los grupos de WhatsApp.                                           |
| Tech Lead / Dev         | Matías Roldán                                                 | Arquitectura, desarrollo, calidad, despliegues.                                                                                    |
| Asistente de desarrollo | Claude Code                                                   | Implementa historias siguiendo `CLAUDE.md`, escribe tests, propone refactors. **No decide alcance ni arquitectura sin consultar.** |

- **Sprints de 2 semanas.**
- Ceremonias mínimas: _planning_ (60 min), _review_ con demo al PO (30 min), _retro_ (20 min). Seguimiento asíncrono por chat.
- Herramienta de backlog: a decidir (GitHub Projects recomendado por estar junto al código). Mientras tanto, `docs/05-backlog.md` es la fuente de verdad.

## 2. Historias de usuario

Formato:

```
SWG-XXX · Título corto
Como <persona>, quiero <acción> para <beneficio>.

Criterios de aceptación (Gherkin):
  Dado <contexto>
  Cuando <acción>
  Entonces <resultado>

Notas técnicas: contexto(s) afectados, puertos/adaptadores nuevos, endpoints, pantallas.
Estimación: puntos (1, 2, 3, 5, 8). >8 → dividir.
```

Las historias cumplen **INVEST** (independiente, negociable, valiosa, estimable, pequeña, testeable) y se cortan en **vertical** (dominio → API → UI), no por capas.

## 3. Definition of Ready (DoR)

Una historia entra al sprint si:

- [ ] Tiene criterios de aceptación claros y verificables.
- [ ] Está estimada y es ≤ 8 puntos.
- [ ] Se conoce el contexto acotado afectado y las dependencias.
- [ ] Tiene diseño/wireframe si hay UI nueva (aunque sea un boceto).
- [ ] No tiene preguntas abiertas que bloqueen.

## 4. Definition of Done (DoD)

Una historia está terminada cuando:

- [ ] Cumple todos los criterios de aceptación.
- [ ] Respeta la arquitectura hexagonal (el check de dependencias pasa en CI).
- [ ] Tiene tests: dominio y casos de uso unitarios; integración si toca persistencia; E2E si es un flujo crítico.
- [ ] Lint, typecheck y tests en verde en CI.
- [ ] Código documentado con cabeceras TSDoc (`@author`, `@date`…) según `04-convenciones.md`.
- [ ] Textos de UI en i18n (`en-AU` y `es`).
- [ ] Eventos de analítica instrumentados si la historia lo pide.
- [ ] Funciona en iOS, Android y Web (o se documenta la excepción).
- [ ] Accesibilidad básica revisada (labels, contraste, foco).
- [ ] Migraciones de BD reversibles y revisadas.
- [ ] PR revisado y mergeado a `main`; desplegado en `dev`.
- [ ] Documentación actualizada si cambió una regla de negocio o una decisión (ADR).

## 5. Roadmap de sprints (tentativo)

| Sprint | Objetivo                | Historias principales                                                                                                                              |
| ------ | ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| **0**  | _Walking skeleton_      | Monorepo, CI/CD, Postgres local, NestJS con un contexto de ejemplo, Expo corriendo en iOS/Android/Web, auth de punta a punta, despliegue en `dev`. |
| **1**  | Identidad               | Registro/login, verificación email + teléfono, perfil, aceptación de términos.                                                                     |
| **2**  | Publicar                | Crear anuncio, fotos, condiciones, ubicación, disponibilidad, publicar/pausar.                                                                     |
| **3**  | Buscar                  | Búsqueda con filtros y fechas, lista + mapa, detalle de anuncio, favoritos.                                                                        |
| **4**  | Conectar y confiar      | Solicitudes de reserva, chat, notificaciones, reseñas, moderación básica. → **Beta cerrada R1**                                                    |
| **5**  | Marketplace             | Publicar y buscar artículos, chat con vendedor.                                                                                                    |
| **6**  | Comunidad y retención   | Eventos, búsquedas guardadas con alertas, panel admin completo.                                                                                    |
| **7**  | Diferenciación y stores | Roster de swing, mejoras UX de la beta, publicación en App Store y Google Play.                                                                    |

Al final de cada sprint: **demo con el PO** y, desde el sprint 4, feedback de usuarios beta reales.

## 6. Cómo trabaja Claude Code en este flujo

1. Recibe una historia (`SWG-XXX`) del backlog.
2. Lee los docs relevantes y el código del contexto afectado.
3. Propone un plan corto (archivos, puertos, endpoints, pantallas, tests) y **espera confirmación** si la historia toca arquitectura o modelo de datos.
4. Implementa de dentro hacia fuera: **dominio + tests → caso de uso + tests → adaptadores → controller → cliente**.
5. Ejecuta lint, typecheck y tests.
6. Resume lo hecho, marca el checklist de la DoD y propone el mensaje de commit (Conventional Commits).

Comando de ayuda: `/implementar-historia SWG-XXX` (skill que orquesta los subagentes del proyecto). Se instala con `bash docs/claude-code/instalar.sh`. Detalle en `08-claude-code.md`.
