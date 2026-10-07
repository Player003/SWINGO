# ADR-0003 · Backend NestJS + PostgreSQL/PostGIS, Supabase como proveedor inicial

- **Estado:** Propuesto (confirmar en Sprint 0)
- **Fecha:** 07/10/2026
- **Autor:** Matías Roldán

## Contexto

Necesitamos: autenticación con verificación de email y teléfono (OTP), login social (Google, Apple), base de datos con búsquedas geográficas y por rangos de fechas, almacenamiento de fotos, y coste bajo durante la beta, sin quedar atados a un proveedor.

## Decisión

- **NestJS** (Node.js LTS, TypeScript) para la API. NestJS solo en `interfaces/` e `infrastructure/` y en los `*.module.ts`; el dominio no lo conoce.
- **PostgreSQL + PostGIS** como base de datos; **Drizzle ORM** en los adaptadores de persistencia.
- **Supabase** como proveedor inicial de: Postgres gestionado, **Auth** (email, OTP SMS, Google, Apple) y **Storage** (fotos). La API valida los JWT de Supabase y mantiene su propia tabla de usuarios del dominio.
- Cada servicio externo detrás de un puerto: `AuthProviderPort`, `MediaStoragePort`, `EmailSenderPort`, `PushSenderPort`, `GeocodingPort`, `AnalyticsPort`, `ListingSearchPort`.

## Alternativas consideradas

- **Firebase:** NoSQL dificulta búsquedas por rangos de fechas + geografía + filtros combinados.
- **Clerk / Auth0 para auth:** excelentes, pero añaden otro proveedor y coste por usuario activo.
- **AWS desde el día 1 (RDS, Cognito, S3):** más control, más configuración; es el destino natural si se escala.
- **Supabase como backend completo (sin API propia, lógica en RLS/Edge Functions):** más rápido, pero mete reglas de negocio en la base de datos y rompe la arquitectura hexagonal.

## Consecuencias

- ✅ MVP barato y rápido; migración posible a otro proveedor cambiando adaptadores.
- ✅ PostGIS + `daterange` + índices GiST resuelven la búsqueda del MVP sin motor externo.
- ⚠️ Hay que sincronizar el usuario del proveedor de auth con el `User` del dominio (webhook o alta perezosa en el primer request).
