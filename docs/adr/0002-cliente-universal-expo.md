# ADR-0002 · Cliente universal con Expo (iOS, Android, Web)

- **Estado:** Propuesto (confirmar en Sprint 0)
- **Fecha:** 07/10/2026
- **Autor:** Matías Roldán

## Contexto

El producto debe ser multiplataforma (iOS, Android, Web), mobile-first, y lo desarrolla un equipo muy pequeño. La web pública debe permitir compartir anuncios por WhatsApp con vista previa y tener SEO razonable.

## Decisión

- **Expo (React Native) + Expo Router** como cliente único para iOS, Android y Web.
- **NativeWind** para estilos y `packages/ui-tokens` para el design system.
- **Next.js** solo para el **panel de administración** (`apps/admin`), que es web y de tablas densas.
- Si en el futuro el SEO de la web pública (guías, anuncios) lo exige, se añade una app `apps/web` en Next.js que reutiliza `packages/contracts`, `api-client` e `i18n` (nuevo ADR).

## Alternativas consideradas

- **Flutter:** buen multiplataforma, pero otro lenguaje (Dart) distinto al backend y web más débil en SEO.
- **Next.js + React Native por separado:** mejor SEO, pero duplica UI con un equipo de una persona.
- **Nativo (Swift/Kotlin):** máxima calidad nativa, coste inasumible.

## Consecuencias

- ✅ Una base de código de UI; TypeScript de punta a punta.
- ✅ Builds y publicación en stores con EAS.
- ⚠️ La web de Expo es menos flexible que Next.js para SEO avanzado; mitigado con renderizado estático de rutas públicas y la opción de `apps/web`.
