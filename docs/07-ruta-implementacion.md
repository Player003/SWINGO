# 07 · Ruta de implementación (checklist)

> Guía paso a paso de cero a lanzamiento. Cada bloque enlaza a la documentación interna (📄) y a la documentación oficial (🔗) que conviene leer **antes** de empezar ese paso. Marca las casillas a medida que avances.
>
> Orden pensado para un equipo pequeño + Claude Code. Para cómo trabajar cada paso con Claude Code, ver `08-claude-code.md`.

---

## Fase A · Preparación (antes del Sprint 0)

### A1. Producto y validación
- [ ] Confirmar ciudad piloto (Perth u otra) y lista de 20–30 usuarios beta de los grupos de WhatsApp.
- [ ] Entrevistar a 5 anfitriones y 5 huéspedes FIFO: validar filtros, campos del anuncio y el flujo de solicitud.
- [ ] Wireframes de baja fidelidad de los 5 flujos críticos (📄 `02-mvp.md` §5). Figma o bocetos en papel.
- [ ] Definir nombre de dominio, identidad visual mínima (logo, 2 colores, tipografía).
- [ ] Revisar y priorizar el backlog con Martin (📄 `05-backlog.md`).

### A2. Cuentas y servicios
- [ ] Organización en GitHub + repositorio `swingo` (privado). 🔗 [GitHub Docs](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-new-repository)
- [ ] Dominio + email del proyecto.
- [ ] Proyecto Supabase (`dev`; luego `staging` y `prod`) en una región cercana a los usuarios (Sídney para Australia). 🔗 [Supabase Docs](https://supabase.com/docs)
- [ ] Cuenta Expo / EAS. 🔗 [EAS](https://docs.expo.dev/eas/)
- [ ] Apple Developer Program y Google Play Console (se tardan días en aprobarse: empezar pronto). 🔗 [Apple Developer Program](https://developer.apple.com/programs/) · 🔗 [Google Play Console](https://support.google.com/googleplay/android-developer/answer/6112435)
- [ ] Cuentas Mapbox, Resend, Sentry, PostHog (todas con free tier). 🔗 [Mapbox](https://docs.mapbox.com/) · [Resend](https://resend.com/docs) · [Sentry](https://docs.sentry.io/) · [PostHog](https://posthog.com/docs)
- [ ] Gestor de secretos compartido (1Password / Bitwarden) — nunca secretos en el repo.

### A3. Entorno local
- [ ] Node.js LTS, pnpm, Docker Desktop, Xcode (iOS), Android Studio (Android), `jq`, `gh` CLI.
- [ ] Claude Code instalado y configuración del repo aplicada (📄 `08-claude-code.md` §7). 🔗 [Claude Code – Setup](https://code.claude.com/docs/en/setup)

📚 **Lecturas base de la fase:**
- 🔗 [Hexagonal Architecture – Alistair Cockburn](https://alistair.cockburn.us/hexagonal-architecture/)
- 🔗 [DDD Reference – Eric Evans](https://www.domainlanguage.com/ddd/reference/)
- 🔗 [The Scrum Guide](https://scrumguides.org/)
- 🔗 [Architecture Decision Records](https://adr.github.io/)

---

## Fase B · Sprint 0 — Walking skeleton (📄 E0: SWG-001…008)

**Objetivo:** un "hola mundo" de punta a punta (app → API → BD) desplegado, con CI y reglas de arquitectura activas.

### B1. Monorepo (SWG-001)
- [ ] `pnpm` workspaces + Turborepo con `apps/{api,app,admin}` y `packages/{contracts,api-client,i18n,ui-tokens,config}`.
- [ ] `tsconfig` base estricto, ESLint + Prettier compartidos, Husky + lint-staged.
- 🔗 [pnpm workspaces](https://pnpm.io/workspaces) · [Turborepo docs](https://turborepo.dev/docs) · [Expo – Monorepos](https://docs.expo.dev/guides/monorepos/) · [TypeScript – strict](https://www.typescriptlang.org/tsconfig/#strict)

### B2. Base de datos (SWG-002)
- [ ] `infra/docker-compose.yml` con Postgres + PostGIS.
- [ ] Drizzle configurado en `apps/api`, primera migración (extensiones `postgis`, `btree_gist`).
- 🔗 [Drizzle ORM](https://orm.drizzle.team/docs/overview) · [Drizzle – PostGIS point](https://orm.drizzle.team/docs/guides/postgis-geometry-point) · [Drizzle Kit migrations](https://orm.drizzle.team/docs/kit-overview) · [PostGIS docs](https://postgis.net/documentation/) · [PostgreSQL – Range types y exclusion constraints](https://www.postgresql.org/docs/current/rangetypes.html)

### B3. Shared kernel y primer contexto (SWG-003)
- [ ] `shared/domain`: `Entity`, `AggregateRoot`, `ValueObject`, `DomainEvent`, `DomainError`, `Result`, `Id` (uuid v7), `Clock`, `Money`, `DateRange`, `GeoPoint`.
- [ ] `shared/application`: `UseCase`, `EventBusPort`, `UnitOfWorkPort`.
- [ ] Contexto `identity` mínimo con un caso de uso y test, para fijar el patrón que copiarán los demás.
- [ ] Regla de dependencias en CI (dependency-cruiser o eslint-plugin-boundaries).
- 🔗 [NestJS – Modules](https://docs.nestjs.com/modules) · [NestJS – Custom providers (puertos → adaptadores)](https://docs.nestjs.com/fundamentals/custom-providers) · [dependency-cruiser](https://github.com/sverweij/dependency-cruiser) · [eslint-plugin-boundaries](https://github.com/javierbrea/eslint-plugin-boundaries) · [Vitest](https://vitest.dev/)

### B4. Contratos y cliente tipado (SWG-006)
- [ ] Esquemas Zod en `packages/contracts`, OpenAPI generado, cliente en `packages/api-client`.
- [ ] Errores en formato Problem Details.
- 🔗 [Zod](https://zod.dev/) · [zod-to-openapi](https://github.com/asteasolutions/zod-to-openapi) · [nestjs-zod](https://github.com/BenLorantfy/nestjs-zod) · [openapi-typescript / openapi-fetch](https://openapi-ts.dev/) · [RFC 9457 Problem Details](https://www.rfc-editor.org/rfc/rfc9457)

### B5. App universal (SWG-005)
- [ ] Expo + Expo Router con las 5 pestañas, NativeWind, TanStack Query, i18n (`en-AU`, `es`).
- [ ] Corre en iOS, Android y Web.
- 🔗 [Expo docs](https://docs.expo.dev/) · [Expo Router](https://docs.expo.dev/router/introduction/) · [NativeWind](https://www.nativewind.dev/) · [TanStack Query](https://tanstack.com/query/latest) · [expo-localization](https://docs.expo.dev/versions/latest/sdk/localization/) · [i18next / react-i18next](https://react.i18next.com/)

### B6. CI/CD y observabilidad (SWG-004, 007, 008)
- [ ] GitHub Actions: install → lint → typecheck → test → build (con caché de Turborepo).
- [ ] Despliegue automático de la API a `dev` (Railway / Fly.io / Render) con Dockerfile.
- [ ] Builds internos con EAS (development build + preview).
- [ ] Sentry (API + app), logs con pino, PostHog detrás de `AnalyticsPort`.
- 🔗 [GitHub Actions](https://docs.github.com/en/actions) · [EAS Build](https://docs.expo.dev/build/introduction/) · [EAS Update](https://docs.expo.dev/eas-update/introduction/) · [Sentry – NestJS](https://docs.sentry.io/platforms/javascript/guides/nestjs/) · [Sentry – React Native](https://docs.sentry.io/platforms/react-native/) · [PostHog – React Native](https://posthog.com/docs/libraries/react-native)
- [ ] (Opcional) Claude Code revisando PRs en GitHub. 🔗 [Claude Code GitHub Actions](https://code.claude.com/docs/en/github-actions)

✅ **Salida del Sprint 0:** demo a Martin con la app instalada en su móvil, login funcionando y un endpoint real.

---

## Fase C · Sprint 1 — Identidad (📄 E1: SWG-010…016)

- [ ] Registro/login email, Google y Apple (si ofreces login social de terceros, Apple exige una opción equivalente que proteja la privacidad, como Sign in with Apple).
- [ ] Alta perezosa del `User` de dominio a partir del JWT del proveedor (ADR-0003).
- [ ] Verificación de email y teléfono (OTP SMS) + insignias.
- [ ] Perfil público y edición de perfil (avatar en Storage).
- [ ] Aceptación de términos versionados por país/idioma (📄 `06-legal.md`).
- [ ] Exportar datos y borrar cuenta (exigido por Apple y Google).
- 🔗 [Supabase Auth](https://supabase.com/docs/guides/auth) · [Supabase – Phone login](https://supabase.com/docs/guides/auth/phone-login) · [Supabase – Expo tutorial](https://supabase.com/docs/guides/getting-started/tutorials/with-expo-react-native) · [Supabase – JWTs](https://supabase.com/docs/guides/auth/jwts) · [NestJS – Guards](https://docs.nestjs.com/guards) · [Apple – Guideline 4.8 Login Services](https://developer.apple.com/app-store/review/guidelines/#4.8) · [Google Play – Account deletion](https://support.google.com/googleplay/android-developer/answer/13327111)

---

## Fase D · Sprint 2 — Publicar habitaciones (📄 E2: SWG-020…027)

- [ ] Agregado `Listing` con su máquina de estados y reglas de publicación (tests de dominio primero).
- [ ] Subida de fotos con URL firmada + compresión en cliente.
- [ ] Autocompletado de dirección + ubicación pública difuminada.
- [ ] Calendario de disponibilidad (`daterange` + `EXCLUDE` para evitar solapes).
- [ ] Job diario de expiración de anuncios.
- 🔗 [Supabase Storage](https://supabase.com/docs/guides/storage) · [Supabase – Signed upload URLs](https://supabase.com/docs/reference/javascript/storage-from-createsigneduploadurl) · [expo-image-picker](https://docs.expo.dev/versions/latest/sdk/imagepicker/) · [expo-image-manipulator](https://docs.expo.dev/versions/latest/sdk/imagemanipulator/) · [Mapbox Geocoding / Search](https://docs.mapbox.com/api/search/) · [NestJS – Task scheduling](https://docs.nestjs.com/techniques/task-scheduling)

---

## Fase E · Sprint 3 — Buscar (📄 E3: SWG-030…037)

- [ ] `SearchListingsUseCase` + adaptador PostGIS detrás de `ListingSearchPort` (filtros, rango de fechas cubierto, radio/área, orden, paginación por cursor).
- [ ] Índices: GiST en ubicación y en `daterange`, B-tree en filtros frecuentes. Medir con `EXPLAIN ANALYZE`.
- [ ] UI tipo Booking: barra destino + fechas + personas → lista/mapa → detalle.
- [ ] Rutas web públicas con meta tags / Open Graph para compartir por WhatsApp.
- [ ] Favoritos y búsquedas guardadas con alerta.
- 🔗 [PostGIS – ST_DWithin](https://postgis.net/docs/ST_DWithin.html) · [PostgreSQL – Índices GiST](https://www.postgresql.org/docs/current/gist.html) · [PostgreSQL – EXPLAIN](https://www.postgresql.org/docs/current/using-explain.html) · [Expo – Maps](https://docs.expo.dev/versions/latest/sdk/map-view/) · [Expo Router – Static rendering](https://docs.expo.dev/router/reference/static-rendering/) · [TanStack Query – Infinite queries](https://tanstack.com/query/latest/docs/framework/react/guides/infinite-queries)

---

## Fase F · Sprint 4 — Conectar y confiar → Beta cerrada (📄 E4, E5, E6)

- [ ] `BookingRequest` con máquina de estados, expiración a 72 h y completado automático (eventos de dominio → outbox).
- [ ] Chat 1-a-1 en tiempo real (WebSocket) con persistencia y aviso antiestafa.
- [ ] Push (Expo Notifications) + email (Resend) + preferencias.
- [ ] Reseñas mutuas ciegas tras estancia `COMPLETED`.
- [ ] Reportar contenido, **bloquear usuarios** y cola de moderación en `apps/admin`.
- [ ] Analítica de la North Star instrumentada (SWG-110).
- [ ] **Beta cerrada** con usuarios reales (TestFlight + Google Play internal testing).
- 🔗 [NestJS – Gateways (WebSockets)](https://docs.nestjs.com/websockets/gateways) · [Socket.IO](https://socket.io/docs/v4/) · [Transactional outbox](https://microservices.io/patterns/data/transactional-outbox.html) · [Expo – Push notifications](https://docs.expo.dev/push-notifications/overview/) · [Next.js](https://nextjs.org/docs) · [shadcn/ui](https://ui.shadcn.com/docs) · [TestFlight](https://developer.apple.com/testflight/) · [Google Play – Testing tracks](https://support.google.com/googleplay/android-developer/answer/9845334)

⚠️ Las stores exigen en apps con contenido generado por usuarios: **reportar contenido, bloquear usuarios, filtrar contenido y un contacto publicado**. 🔗 [App Store Review Guidelines 1.2](https://developer.apple.com/app-store/review/guidelines/#1.2) · [Google Play – UGC policy](https://support.google.com/googleplay/android-developer/answer/9876937)

---

## Fase G · Sprints 5–6 — Marketplace, comunidad y retención (📄 E7, E8, E9)

- [ ] Marketplace: categorías con atributos validados por esquema (talla, km, año…), grilla con filtros, chat con vendedor, estados reservado/vendido.
- [ ] Eventos: creación, listado por ciudad, "voy", zonas horarias.
- [ ] Alertas de búsquedas guardadas.
- [ ] Panel admin completo + dashboard de métricas.
- 🔗 [PostgreSQL – JSONB](https://www.postgresql.org/docs/current/datatype-json.html) · [Zod – discriminated unions](https://zod.dev/api#discriminated-unions)

---

## Fase H · Sprint 7 — Diferenciación y publicación en stores

- [ ] Roster de swing y "buscar en mis días libres" (SWG-016, 027, 037).
- [ ] Ajustes de UX según el feedback de la beta.
- [ ] Rendimiento: budget de bundle, imágenes optimizadas, p95 de búsqueda < 500 ms.
- [ ] Accesibilidad (WCAG 2.1 AA en web; lectores de pantalla en móvil).
- [ ] Ficha de las stores: capturas, descripción en `en-AU` y `es`, **privacy labels / Data safety**.
- [ ] Publicación con EAS Submit.
- 🔗 [EAS Submit](https://docs.expo.dev/submit/introduction/) · [App Store – Privacy details](https://developer.apple.com/app-store/app-privacy-details/) · [Google Play – Data safety](https://support.google.com/googleplay/android-developer/answer/10787469) · [WCAG 2.1](https://www.w3.org/TR/WCAG21/) · [React Native – Accessibility](https://reactnative.dev/docs/accessibility) · [React Native – Performance](https://reactnative.dev/docs/performance)

---

## Fase I · Pre-lanzamiento (transversal, cerrar antes de abrir al público)

### Legal y privacidad
- [ ] Revisión legal de términos y privacidad en Australia (📄 `06-legal.md`). 🔗 [OAIC – Australian Privacy Principles](https://www.oaic.gov.au/privacy/australian-privacy-principles) · [ACCC – Consumer law for businesses](https://www.accc.gov.au/business)
- [ ] Política de privacidad y términos publicados en web y enlazados en las stores.
- [ ] Preparado para GDPR si se abre a Europa. 🔗 [GDPR – texto oficial](https://eur-lex.europa.eu/eli/reg/2016/679/oj)

### Seguridad
- [ ] Checklist OWASP ASVS nivel 1 y Mobile Top 10. 🔗 [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/) · [OWASP Mobile Top 10](https://owasp.org/www-project-mobile-top-10/)
- [ ] Rate limiting en auth, mensajería y creación de contenido. 🔗 [NestJS – Rate limiting](https://docs.nestjs.com/security/rate-limiting)
- [ ] Revisión de seguridad con el subagente `security-reviewer` (📄 `08-claude-code.md`).
- [ ] Backups automáticos de BD y prueba de restauración.

### Operación
- [ ] Alertas de errores (Sentry) y de caída (uptime).
- [ ] Runbook: cómo desplegar, revertir, restaurar BD, banear usuario.
- [ ] Plan de moderación: quién revisa reportes y en cuánto tiempo.

---

## Fase J · Después del lanzamiento (Fase 2)

- [ ] Guías FIFO con SEO (evaluar `apps/web` en Next.js → nuevo ADR).
- [ ] Contexto `promotions`: partners, ofertas, códigos de descuento, medición de canjes.
- [ ] Verificación de identidad (puerto ya previsto).
- [ ] Revisar ADR-0004 (pagos/comisiones) según datos de uso.
- [ ] Expansión a otro país: términos, moneda, categorías, textos.
- [ ] Extraer búsqueda a un motor dedicado si PostGIS no escala. 🔗 [Meilisearch](https://www.meilisearch.com/docs) · [Typesense](https://typesense.org/docs/)
- [ ] (Opcional) Funciones con IA dentro del producto (asistente para redactar anuncios, apoyo a moderación) detrás de un puerto. 🔗 [Claude API](https://platform.claude.com/docs/en/home)

---

## Referencias transversales

| Tema | Enlace |
|---|---|
| Testing de NestJS | 🔗 [docs.nestjs.com/fundamentals/testing](https://docs.nestjs.com/fundamentals/testing) |
| Testcontainers (Postgres real en tests) | 🔗 [node.testcontainers.org](https://node.testcontainers.org/) |
| E2E web | 🔗 [Playwright](https://playwright.dev/docs/intro) |
| E2E móvil | 🔗 [Maestro](https://docs.maestro.dev/) |
| React Native Testing Library | 🔗 [callstack.github.io/react-native-testing-library](https://callstack.github.io/react-native-testing-library/) |
| Conventional Commits | 🔗 [conventionalcommits.org](https://www.conventionalcommits.org/) |
| Clean Code / refactoring | 🔗 [refactoring.guru](https://refactoring.guru/) |
| Claude Code (buenas prácticas) | 🔗 [code.claude.com/docs/en/best-practices](https://code.claude.com/docs/en/best-practices) |
