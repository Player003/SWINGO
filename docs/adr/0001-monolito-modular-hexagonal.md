# ADR-0001 · Monolito modular con arquitectura hexagonal

- **Estado:** Aceptado
- **Fecha:** 07/10/2026
- **Autor:** Matías Roldán

## Contexto

Swingo empieza con un equipo mínimo y un MVP con 8 funcionalidades, pero aspira a escala global y a añadir módulos (partners, guías, nuevos países). Hay que equilibrar velocidad inicial con capacidad de evolución, y poder cambiar de proveedores externos (auth, storage, búsqueda) sin reescribir la lógica de negocio.

## Decisión

- Un **único backend desplegable** (monolito modular) dividido en **contextos acotados** (`identity`, `accommodation`, `booking`, `reviews`, `messaging`, `marketplace`, `community`, `moderation`, `notifications`, `engagement`).
- Cada contexto sigue **arquitectura hexagonal**: `domain` (puro) ← `application` (casos de uso + puertos) ← `infrastructure` / `interfaces` (adaptadores).
- Los contextos se comunican por **puertos** (consultas) y **eventos de dominio** (reacciones), nunca importando el dominio de otro.
- La regla de dependencias se valida en CI.

## Alternativas consideradas

- **Microservicios desde el inicio:** demasiado coste operativo para un MVP.
- **Monolito MVC por capas técnicas:** más rápido al principio, pero acopla negocio a framework y ORM, y dificulta extraer módulos después.

## Consecuencias

- ✅ Dominio testeable sin infraestructura; proveedores intercambiables.
- ✅ Un contexto puede extraerse a un servicio cuando la carga lo justifique (el outbox ya desacopla eventos).
- ⚠️ Más archivos y ceremonia (puertos, mappers). Se acepta como coste de calidad.
