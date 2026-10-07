---
name: nueva-historia
description: Redacta una nueva historia de usuario para el backlog de Swingo con formato INVEST, criterios de aceptación en Gherkin, notas técnicas y estimación.
argument-hint: "descripción breve de la funcionalidad"
disable-model-invocation: true
---

Redacta una historia de usuario para: **$ARGUMENTS**

1. Lee `docs/05-backlog.md` para ver el último ID (`SWG-XXX`) y la épica adecuada; usa el siguiente ID libre dentro de la épica.
2. Lee `docs/01-vision-producto.md` (personas) y `docs/02-mvp.md` (reglas de negocio) para no contradecirlas.
3. Si te falta información importante (persona, regla de negocio, caso límite), hazme hasta 3 preguntas concretas antes de redactar.
4. Formato:

```
SWG-XXX · Título corto
Como <persona>, quiero <acción> para <beneficio>.

Criterios de aceptación:
  Dado … Cuando … Entonces …   (incluye al menos un caso límite y un caso de error)

Notas técnicas: contexto(s), puertos/adaptadores, endpoints, pantallas, analítica.
Estimación: 1 | 2 | 3 | 5 | 8 (si es > 8, propón cómo dividirla)
Prioridad: Must | Should | Could
```

5. Muéstramela y, cuando la apruebe, añádela a la tabla de su épica en `docs/05-backlog.md` (y sus criterios debajo si son extensos).
