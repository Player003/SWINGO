---
name: nuevo-adr
description: Crea un Architecture Decision Record (ADR) en docs/adr con el formato del proyecto Swingo.
argument-hint: 'título de la decisión'
disable-model-invocation: true
---

Crea un ADR para la decisión: **$ARGUMENTS**

1. Mira el último número en `docs/adr/` y usa el siguiente (`000N-titulo-en-kebab-case.md`).
2. Sigue el formato de los ADR existentes:
   - `# ADR-000N · Título`
   - Estado (Propuesto / Aceptado / Sustituido por ADR-XXXX), Fecha (`dd/MM/yyyy`, hoy), Autor (Matías Roldán)
   - Contexto · Decisión · Alternativas consideradas · Consecuencias (✅ / ⚠️)
3. Si sustituye a un ADR anterior, actualiza el estado del antiguo a "Sustituido por ADR-000N" sin borrar su contenido.
4. Si la decisión cambia el stack, la estructura o un principio, actualiza también `CLAUDE.md` y `docs/03-arquitectura.md` para que sean coherentes, y dime qué cambiaste.
5. Deja el estado en **Propuesto** salvo que te diga que está aceptado.
