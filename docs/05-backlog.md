# 05 · Backlog inicial

> Fuente de verdad del backlog hasta migrarlo a una herramienta (GitHub Projects recomendado). Estimaciones orientativas en puntos; se re-estiman en cada planning.
> Prioridad: **M** Must · **S** Should · **C** Could.

---

## E0 · Plataforma (Sprint 0)

| ID | Historia | Pts | Prio |
|---|---|---|---|
| SWG-001 | Como dev, quiero el monorepo (pnpm + Turborepo) con `apps/api`, `apps/app`, `apps/admin` y `packages/*` configurados (TS strict, ESLint, Prettier), para empezar con una base limpia. | 3 | M |
| SWG-002 | Como dev, quiero Postgres + PostGIS en docker-compose y migraciones Drizzle, para desarrollar en local. | 2 | M |
| SWG-003 | Como dev, quiero el *shared kernel* del backend (Entity, AggregateRoot, ValueObject, DomainError, Result, Clock, Id, Money, DateRange, GeoPoint, EventBus) con tests, para que todos los contextos lo reutilicen. | 5 | M |
| SWG-004 | Como dev, quiero CI en GitHub Actions (lint, typecheck, test, build, check de dependencias hexagonales), para no romper `main`. | 3 | M |
| SWG-005 | Como dev, quiero la app Expo arrancando en iOS, Android y Web con Expo Router, NativeWind, i18n (`en-AU`, `es`) y las 5 pestañas vacías, para validar el cliente universal. | 3 | M |
| SWG-006 | Como dev, quiero `packages/contracts` → OpenAPI → `packages/api-client`, para compartir tipos entre API y clientes. | 3 | M |
| SWG-007 | Como dev, quiero despliegue automático de la API a `dev` y builds EAS internos, para enseñar avances al PO. | 3 | M |
| SWG-008 | Como dev, quiero Sentry, logs estructurados y PostHog conectados detrás de puertos, para observar errores y tráfico. | 2 | M |

## E1 · Identidad y perfiles

| ID | Historia | Pts | Prio |
|---|---|---|---|
| SWG-010 | Como visitante, quiero registrarme con email/contraseña, Google o Apple, para tener cuenta en Swingo. | 5 | M |
| SWG-011 | Como usuario, quiero verificar mi email y mi teléfono (OTP por SMS), para poder publicar y solicitar reservas. | 5 | M |
| SWG-012 | Como usuario, quiero completar mi perfil (nombre visible, foto, bio, ocupación, idiomas), para generar confianza. | 3 | M |
| SWG-013 | Como usuario, quiero ver el perfil público de otro usuario con sus insignias de verificación y reseñas, para decidir si confío. | 3 | M |
| SWG-014 | Como anfitrión, quiero aceptar los términos de publicación (versión vigente para mi país), para poder publicar. | 2 | M |
| SWG-015 | Como usuario, quiero exportar mis datos y borrar mi cuenta, para ejercer mis derechos de privacidad. | 3 | M |
| SWG-016 | Como usuario FIFO, quiero definir mi roster de swing (patrón y fecha de inicio), para que la app conozca mis días libres. | 5 | C |

**Criterios de aceptación — SWG-011**
```
Dado un usuario registrado sin teléfono verificado
Cuando intenta publicar un anuncio o enviar una solicitud de reserva
Entonces la app le pide verificar su teléfono antes de continuar

Dado un usuario que introduce su teléfono en formato internacional
Cuando recibe el código OTP y lo introduce correctamente antes de que caduque
Entonces su perfil muestra la insignia "Teléfono verificado"

Dado un usuario que falla el código 5 veces
Entonces se bloquea el reintento durante 15 minutos
```

## E2 · Publicación de habitaciones

| ID | Historia | Pts | Prio |
|---|---|---|---|
| SWG-020 | Como anfitrión, quiero crear un anuncio en borrador con tipo, título, descripción, precio (moneda y unidad) y nº máximo de personas. | 5 | M |
| SWG-021 | Como anfitrión, quiero subir y ordenar hasta 12 fotos, para mostrar la habitación. | 5 | M |
| SWG-022 | Como anfitrión, quiero marcar condiciones y comodidades (parejas, preferencia de género, mascotas, parking, baño privado, cerca del aeropuerto, apta para dormir de día…), para que me encuentren los huéspedes adecuados. | 3 | M |
| SWG-023 | Como anfitrión, quiero indicar la dirección con autocompletado y que solo se muestre una ubicación aproximada, para proteger mi privacidad. | 5 | M |
| SWG-024 | Como anfitrión, quiero añadir uno o varios rangos de disponibilidad en un calendario, para ofrecer la habitación durante mi swing. | 5 | M |
| SWG-025 | Como anfitrión, quiero publicar, pausar y reactivar mi anuncio, para controlar cuándo es visible. | 3 | M |
| SWG-026 | Como anfitrión, quiero ver mis anuncios y su estado en "Mis anuncios". | 2 | M |
| SWG-027 | Como anfitrión con roster, quiero generar la disponibilidad automáticamente a partir de mi roster, para no cargar fechas a mano. | 5 | C |

**Criterios de aceptación — SWG-025 (publicar)**
```
Dado un anuncio en borrador sin fotos
Cuando el anfitrión pulsa "Publicar"
Entonces ve el error "Añade al menos una foto" y el anuncio sigue en DRAFT

Dado un anuncio completo y un anfitrión con email y teléfono verificados
Y que NO ha aceptado la versión vigente de los términos de publicación
Cuando pulsa "Publicar"
Entonces se le muestran los términos y la declaración de autorización del propietario
Y solo tras aceptarlos el anuncio pasa a PUBLISHED

Dado un anuncio publicado cuyo último rango de disponibilidad terminó ayer
Cuando corre el job diario de expiración
Entonces el anuncio pasa a EXPIRED y deja de aparecer en búsquedas
```

## E3 · Búsqueda de alojamiento

| ID | Historia | Pts | Prio |
|---|---|---|---|
| SWG-030 | Como huésped, quiero buscar por ciudad/suburbio y rango de fechas y nº de personas, para ver habitaciones disponibles en mis días libres. | 8 | M |
| SWG-031 | Como huésped, quiero filtrar por precio, tipo, parejas, preferencia de género y comodidades, para encontrar exactamente lo que necesito. | 5 | M |
| SWG-032 | Como huésped, quiero ver los resultados en lista y en mapa, y ordenarlos (precio, más recientes, valoración, distancia), para comparar. | 5 | M |
| SWG-033 | Como huésped, quiero ver el detalle de un anuncio (galería, condiciones, calendario, mapa aproximado, perfil y reseñas del anfitrión). | 5 | M |
| SWG-034 | Como usuario, quiero compartir un anuncio por WhatsApp con vista previa (Open Graph), para que otros lo vean aunque no tengan la app. | 2 | S |
| SWG-035 | Como huésped, quiero guardar anuncios en favoritos. | 2 | S |
| SWG-036 | Como huésped, quiero guardar una búsqueda y recibir una alerta cuando aparezca un anuncio que encaje. | 5 | S |
| SWG-037 | Como huésped con roster, quiero buscar "en mis próximos días libres" con un toque. | 3 | C |

**Criterios de aceptación — SWG-030**
```
Dado un anuncio publicado en Victoria Park disponible del 10/11 al 24/11 para 2 personas
Cuando un huésped busca "Victoria Park", del 12/11 al 19/11, 1 persona
Entonces el anuncio aparece en los resultados

Cuando busca del 20/11 al 27/11
Entonces el anuncio NO aparece (el rango no está cubierto completamente)

Dado que existe una solicitud ACEPTADA para ese anuncio del 12/11 al 15/11
Cuando otro huésped busca del 13/11 al 14/11
Entonces el anuncio NO aparece
```

## E4 · Solicitudes de reserva y mensajería

| ID | Historia | Pts | Prio |
|---|---|---|---|
| SWG-040 | Como huésped verificado, quiero enviar una solicitud de reserva con fechas, nº de personas y un mensaje. | 5 | M |
| SWG-041 | Como anfitrión, quiero aceptar o rechazar solicitudes; al aceptar, ambos vemos los datos de contacto y la dirección exacta. | 5 | M |
| SWG-042 | Como usuario, quiero cancelar una solicitud (pendiente o aceptada) indicando motivo. | 3 | M |
| SWG-043 | Como sistema, quiero expirar solicitudes pendientes a las 72 h y completar las aceptadas al pasar el check-out. | 3 | M |
| SWG-044 | Como usuario, quiero chatear 1-a-1 en tiempo real ligado a un anuncio, solicitud o artículo. | 8 | M |
| SWG-045 | Como usuario, quiero recibir notificaciones push y email de solicitudes, respuestas y mensajes, y configurar mis preferencias. | 5 | M |
| SWG-046 | Como usuario, quiero ver un aviso antiestafa si un mensaje pide pagos por adelantado o datos sensibles. | 3 | S |

## E5 · Valoraciones y referencias

| ID | Historia | Pts | Prio |
|---|---|---|---|
| SWG-050 | Como huésped, tras una estancia completada, quiero valorar al anfitrión y la habitación (1–5 + dimensiones + comentario). | 5 | M |
| SWG-051 | Como anfitrión, tras una estancia completada, quiero valorar al huésped. | 2 | M |
| SWG-052 | Como sistema, quiero publicar las reseñas cuando ambos hayan reseñado o a los 14 días (reseña ciega). | 3 | M |
| SWG-053 | Como usuario, quiero ver la puntuación media y nº de reseñas en perfiles y anuncios. | 2 | M |

## E6 · Administración y moderación

| ID | Historia | Pts | Prio |
|---|---|---|---|
| SWG-060 | Como usuario, quiero reportar un anuncio, artículo, evento, reseña, mensaje o perfil con un motivo. | 3 | M |
| SWG-061 | Como moderador, quiero una cola de reportes en el panel admin y poder ocultar contenido o suspender/banear usuarios. | 8 | M |
| SWG-062 | Como admin, quiero un log de auditoría de todas las acciones de moderación. | 2 | M |
| SWG-063 | Como admin, quiero un dashboard con métricas básicas (usuarios, anuncios activos por ciudad, solicitudes, contactos efectivos). | 3 | S |
| SWG-064 | Como admin, quiero gestionar versiones de términos por país e idioma. | 3 | S |
| SWG-065 | Como usuario, quiero bloquear a otro usuario para que no pueda contactarme ni ver mis anuncios (requisito de App Store 1.2 y Google Play para contenido generado por usuarios). | 3 | M |

## E7 · Marketplace

| ID | Historia | Pts | Prio |
|---|---|---|---|
| SWG-070 | Como vendedor, quiero publicar un artículo con categoría, atributos (p. ej. talla), estado, precio, fotos y zona de encuentro. | 5 | S |
| SWG-071 | Como comprador, quiero buscar artículos por ciudad, categoría, atributos (talla), precio y estado en una grilla tipo Marketplace. | 5 | S |
| SWG-072 | Como comprador, quiero contactar al vendedor por chat desde el artículo. | 2 | S |
| SWG-073 | Como vendedor, quiero marcar un artículo como reservado/vendido y renovarlo. | 2 | S |

## E8 · Eventos y comunidad

| ID | Historia | Pts | Prio |
|---|---|---|---|
| SWG-080 | Como usuario, quiero publicar un evento comunitario (fecha, lugar, descripción, foto, cupo). | 3 | S |
| SWG-081 | Como usuario, quiero ver eventos próximos en mi ciudad y marcar "voy". | 3 | S |

## E11 · Analítica

| ID | Historia | Pts | Prio |
|---|---|---|---|
| SWG-110 | Como PO, quiero medir eventos clave (registro, verificación, anuncio publicado, búsqueda, detalle visto, solicitud enviada/aceptada, mensaje enviado, artículo publicado), para conocer el tráfico y la North Star. | 3 | M |

---

## Fase 2 (ideas, sin refinar)

- **Guías FIFO** ("islas de información"): artículos de carrera (p. ej. cómo pasar a operador de camión: certificaciones, tiempos, mineras, salarios, contactos), con SEO.
- **Partners y ofertas**: perfiles de empresa, ofertas con **código de descuento exclusivo Swingo** (cursos forklift, workwear, surf…), seguimiento de clics/canjes.
- **Espacios publicitarios** en home, búsqueda y guías.
- **Verificación de identidad** (documento + selfie) con insignia "ID verificado".
- **Expansión** a otros países / sectores (oil & gas, offshore, construcción remota).
- Traducción automática de anuncios y mensajes.
