# 02 · Alcance del MVP

## 1. Objetivo del MVP

Validar que los trabajadores FIFO de **una ciudad piloto (Perth, WA — a confirmar)** prefieren Swingo a los grupos de WhatsApp para **encontrar y ofrecer habitaciones durante su swing**, y que vuelven a la app por el marketplace y la comunidad.

**Hipótesis a validar**

1. Los anfitriones publican sus habitaciones si hacerlo lleva < 3 minutos desde el móvil.
2. Los huéspedes encuentran opciones relevantes filtrando por zona + fechas + condiciones.
3. La verificación y las reseñas aumentan la confianza y las solicitudes aceptadas.
4. El marketplace genera visitas recurrentes entre búsquedas de alojamiento.

## 2. Plataformas del MVP

- **App móvil iOS + Android** y **web responsive** desde una sola base de código cliente (ver `03-arquitectura.md` y ADR-0002).
- **Panel de administración** web (rutas protegidas por rol).

## 3. Qué incluye (MoSCoW)

Las 8 funcionalidades del brief, priorizadas. Marketplace y Eventos entran al MVP en su **versión mínima**.

| #   | Épica                                    | Prioridad      | Versión MVP                                                                                                                |
| --- | ---------------------------------------- | -------------- | -------------------------------------------------------------------------------------------------------------------------- |
| E1  | **Identidad y perfiles**                 | Must           | Registro email / Google / Apple, verificación de email y teléfono (OTP), perfil público, aceptación de términos.           |
| E2  | **Publicación de habitaciones**          | Must           | Crear/editar anuncio con fotos, precio, características, normas, ubicación aproximada y **rangos de disponibilidad**.      |
| E3  | **Búsqueda de alojamiento**              | Must           | Filtros tipo Booking (ciudad/suburbio o mapa, fechas, personas, precio, condiciones), calendario, listado + mapa, detalle. |
| E4  | **Solicitudes de reserva y mensajería**  | Must           | Solicitud de reserva (sin pago), aceptar/rechazar, chat 1-a-1, notificaciones.                                             |
| E5  | **Valoraciones y referencias**           | Must           | Reseñas mutuas solo tras una estancia aceptada y finalizada.                                                               |
| E6  | **Panel de administración y moderación** | Must           | Reportes de usuarios, ocultar contenido, suspender cuentas, métricas básicas.                                              |
| E7  | **Marketplace de segunda mano**          | Should         | Publicar artículo (categoría, talla, estado, precio, fotos, zona de encuentro), buscar con filtros, contactar por chat.    |
| E8  | **Eventos y comunidad**                  | Should         | Publicar evento (fecha, lugar, descripción), listado por ciudad, "me apunto".                                              |
| E9  | **Favoritos y alertas**                  | Should         | Guardar anuncios; búsqueda guardada con alerta push/email.                                                                 |
| E10 | **Roster de swing**                      | Could          | Definir roster en el perfil y generar disponibilidad automáticamente.                                                      |
| E11 | **Analítica de producto**                | Must (técnica) | Eventos clave instrumentados para medir tráfico y la North Star.                                                           |

### Fuera del MVP (Won't, por ahora)

- **Pagos, depósitos, comisiones** — fuera por principio de producto, no solo por alcance.
- Contratos firmados dentro de la app.
- Verificación de documento de identidad (ID/pasaporte) — se deja el **puerto** preparado (insignia "ID verificado" en fase 2).
- Publicidad, partners y códigos de descuento (fase 2; se modela el contexto, no se implementa).
- Guías / blog de carrera FIFO (fase 2).
- Multi-país operativo (el modelo lo soporta; el lanzamiento es en un país).
- Traducción automática de anuncios.

## 4. Reglas de negocio clave

### Alojamiento

- Un **anuncio** (`Listing`) describe una habitación o espacio; tiene uno o varios **rangos de disponibilidad** (`AvailabilityWindow`: desde–hasta, fechas locales sin hora).
- Tipos: habitación privada, habitación compartida, casa/apartamento completo, sofá/cama.
- Precio: importe + moneda ISO 4217 + unidad (`per_night` | `per_week` | `total_stay`). **Informativo**: Swingo no cobra.
- **Ubicación pública aproximada** (suburbio + punto difuminado ~300–500 m). La dirección exacta y el teléfono solo se comparten tras aceptar una solicitud.
- El anuncio no puede publicarse sin: ≥ 1 foto, precio, al menos un rango de disponibilidad futuro, aceptación vigente de los términos de publicación y **declaración de autorización del propietario**.
- Un anuncio cuyo último rango de disponibilidad ya pasó pasa automáticamente a `EXPIRED` (no se borra: conserva reseñas).

### Condiciones del anuncio (filtrables)

- Nº máximo de personas · se admiten parejas · preferencia de género (indiferente / solo mujeres / solo hombres) · mascotas · fumar.
- Baño privado · parking (incl. ute) · aire acondicionado · wifi · lavandería · ropa de cama incluida · gastos incluidos · amueblado.
- Específicos FIFO: cerca del aeropuerto · apta para dormir de día (oscura/silenciosa) · estancia mínima / máxima.

### Solicitudes de reserva

- Máquina de estados: `PENDING → ACCEPTED | DECLINED | CANCELLED | EXPIRED`; `ACCEPTED → COMPLETED` (automático al pasar el check-out) o `CANCELLED`.
- Solo usuarios con **email y teléfono verificados** pueden enviar solicitudes o publicar.
- No se puede solicitar fuera de un rango de disponibilidad ni solapando otra solicitud **aceptada**.
- Una solicitud `PENDING` expira a las 72 h sin respuesta (configurable).
- Al aceptar: se revelan datos de contacto y dirección exacta, y las fechas quedan bloqueadas en el calendario.
- El anfitrión no puede solicitar su propio anuncio.

### Reseñas

- Solo se puede reseñar si existe una solicitud `COMPLETED` entre ambos usuarios ("reseñas verdaderas").
- Reseña **mutua y ciega**: anfitrión ↔ huésped. Se publican cuando ambos han reseñado o a los 14 días.
- Puntuación 1–5 + comentario; dimensiones para alojamiento: limpieza, exactitud del anuncio, comunicación, ubicación.
- Una reseña por estancia y dirección. Editable 48 h. Reportable.

### Marketplace

- Categorías iniciales: Indumentaria de trabajo, Calzado de seguridad, EPP, Herramientas, Vehículos, Camping/campamento, Electrónica, Hogar, Otros.
- Atributos según categoría (p. ej. talla para calzado/ropa, km y año para vehículos).
- Precio informativo + "negociable", estado (nuevo / como nuevo / usado), **zona de encuentro**.
- Estado del artículo: `ACTIVE → RESERVED → SOLD` o `REMOVED`. Caduca a los 30 días si no se renueva.

### Eventos

- Título, descripción, fecha/hora con zona horaria, lugar (o "online"), ciudad, foto, cupo opcional.
- Usuarios pueden marcar "voy". Se ocultan tras su fecha.

### Moderación

- Cualquier usuario puede **reportar** anuncio, artículo, evento, reseña, mensaje o perfil.
- Moderador: ver cola de reportes, ocultar contenido, advertir, suspender/banear usuario; todo queda en log de auditoría.
- Lista de palabras/patrones bloqueados configurable (p. ej. pedir pagos por adelantado fuera de la app → aviso antiestafa).

## 5. Flujos críticos (happy paths)

1. **Anfitrión publica su habitación**: registro → verifica email y teléfono → acepta términos de publicación → crea anuncio (fotos, precio, condiciones, ubicación) → añade rango "del 10/11 al 24/11" → publica.
2. **Huésped encuentra y solicita**: busca "Perth · Victoria Park · 12/11–19/11 · 1 persona · solo mujeres" → compara en lista/mapa → abre detalle (fotos, condiciones, reseñas del anfitrión) → envía solicitud con mensaje.
3. **Anfitrión responde**: recibe push → revisa perfil y reseñas del huésped → acepta → ambos ven contacto y dirección → chat.
4. **Tras la estancia**: la solicitud pasa a `COMPLETED` → ambos reciben invitación a reseñar.
5. **Marketplace**: publicar "Botas Steel Blue talla 7, $60, punto de encuentro Northbridge" → otro usuario filtra "Calzado · talla 7 · Perth" → chatea con el vendedor.

## 6. Requisitos no funcionales del MVP

| Área           | Requisito                                                                                                      |
| -------------- | -------------------------------------------------------------------------------------------------------------- |
| Rendimiento    | Búsqueda < 500 ms p95 con 10k anuncios. App usable en 3G (imágenes optimizadas, paginación).                   |
| Disponibilidad | 99,5 % mensual en beta.                                                                                        |
| Seguridad      | OWASP ASVS nivel 1, rate limiting en auth y mensajería, contraseñas gestionadas por el proveedor de identidad. |
| Privacidad     | Cumplimiento con la _Privacy Act 1988_ (AU) y preparado para GDPR (exportar y borrar cuenta).                  |
| Accesibilidad  | WCAG 2.1 AA en web; tamaños de fuente dinámicos en móvil.                                                      |
| i18n           | `en-AU` (por defecto) y `es` desde el día 1. Fechas/monedas formateadas por locale.                            |
| Observabilidad | Logs estructurados, trazas de errores (Sentry o similar), métricas de API.                                     |

## 7. Plan de releases

| Release                              | Contenido                                                                                   | Objetivo                                                                         |
| ------------------------------------ | ------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- |
| **R0 – Walking skeleton** (Sprint 0) | Monorepo, CI/CD, auth, despliegue de API + app vacía en los 3 targets.                      | Poder desplegar en un día.                                                       |
| **R1 – Alojamiento** (Sprints 1–4)   | E1, E2, E3, E4, E5, E6 básico, E11.                                                         | **Beta cerrada** en ciudad piloto con usuarios reales de los grupos de WhatsApp. |
| **R2 – Comunidad** (Sprints 5–6)     | E7 Marketplace, E8 Eventos, E9 Favoritos y alertas.                                         | Retención: motivos para volver.                                                  |
| **R3 – Diferenciación** (Sprint 7+)  | E10 Roster de swing, mejoras de búsqueda, publicación en stores.                            | Lanzamiento público.                                                             |
| **Fase 2**                           | Guías FIFO, partners y códigos de descuento, publicidad, verificación de ID, nuevos países. | Monetización y escala.                                                           |

Detalle de historias en `05-backlog.md`.
