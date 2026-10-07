# 01 · Visión de producto

## 1. Qué es Swingo

**Swingo** es una plataforma digital (web + iOS + Android) que centraliza **alojamiento, marketplace y comunidad** para trabajadores **FIFO** (_Fly-In, Fly-Out_) y trabajadores "golondrina": personas que vuelan a una mina u obra durante su _swing_ (p. ej. 2 semanas) y luego vuelven a la ciudad durante sus días libres.

Mercado inicial: **Australia** (Perth / Western Australia, Brisbane, etc.). Visión: **global**, cualquier país con trabajo rotativo (minería, oil & gas, construcción remota, offshore, temporadas agrícolas).

> **Frase guía:** Swingo transforma información dispersa en grupos de WhatsApp en una plataforma organizada, accesible y confiable.

## 2. El insight

En Australia, la mayoría de backpackers y trabajadores FIFO viven en casas compartidas. Quien se va a la mina 1–2 semanas **pone su habitación a disposición** de otro trabajador que justo vuelve a la ciudad:

- El que vuelve **tiene dónde quedarse** durante sus días libres.
- El que se va **no paga la renta en vano**: alguien la cubre mientras está en el sitio.

Es un _win-win_ que ya ocurre de forma espontánea y **gratuita**, pero hoy solo funciona por **grupos cerrados de WhatsApp**.

## 3. Problema

| Problema                         | Detalle                                                                                   |
| -------------------------------- | ----------------------------------------------------------------------------------------- |
| Acceso limitado                  | Muchos grupos, cerrados y separados; no todos llegan a ellos.                             |
| Información efímera              | Mensajes temporales (24 h): una habitación publicada ayer "desaparece" aunque siga libre. |
| Sin organización                 | No se puede filtrar por zona, fechas, precio, nº de personas, pareja, solo mujeres, etc.  |
| Sin referencias                  | No hay valoraciones ni reputación de habitaciones, anfitriones o huéspedes.               |
| Poca anticipación                | Difícil planificar y comparar antes de los días libres.                                   |
| Lo mismo pasa con la compraventa | Botas, ropa de trabajo, autos para ir a trabajar… todo pasa por WhatsApp y se pierde.     |

## 4. Solución

Una plataforma con la experiencia de búsqueda de **Booking.com** (alojamiento), **Facebook Marketplace** (segunda mano) y el espíritu comunitario de **Couchsurfing**, pero:

- **Exclusiva para el nicho FIFO / trabajo rotativo.**
- **Sin comisiones y sin pagos dentro de la plataforma.** Swingo solo conecta a quien busca con quien ofrece.
- **Usuarios verificados**, para que reseñas y reservas sean reales.

### Pilares

1. **Alojamiento** — publicar una habitación por un rango de fechas (normalmente tu propio swing) y buscar con filtros + calendario.
2. **Marketplace** — compraventa de segunda mano del nicho (indumentaria, botas, EPP, vehículos, herramientas) con filtros tipo Facebook Marketplace y punto de encuentro.
3. **Comunidad** — eventos, y más adelante **guías** de carrera FIFO ("cómo pasar a camionero de mina: certificaciones, tiempos, empresas, salarios").
4. **Confianza** — verificación de identidad, reseñas solo tras estancias reales, moderación.

## 5. Principios de producto (no negociables)

1. **Gratis para el usuario.** Nunca comisión fija ni porcentual. Si aparece un intermediario que cobra, "la idea se cae".
2. **Swingo no es parte del acuerdo** ni gestiona pagos (ver `06-legal.md`).
3. **El tráfico es el activo.** Todo lo que aumente visitas recurrentes y retención es prioritario.
4. **Confianza antes que volumen.** Mejor menos anuncios pero reales y verificados.
5. **Mobile-first**: el usuario está en el aeropuerto, en el campamento minero o en el bus.
6. **Global desde el diseño, local en el lanzamiento**: i18n, multi-moneda, zonas horarias y direcciones genéricas desde el día 1, aunque se lance solo en Australia.

## 6. Usuarios (personas)

| Persona                                                              | Necesidad principal                                                                                                                |
| -------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- |
| **Anfitrión FIFO** — inquilino en casa compartida que se va de swing | Publicar su habitación por las fechas exactas en que estará en la mina y cubrir su renta. Elegir a quién deja entrar (reputación). |
| **Huésped FIFO** — vuelve a la ciudad sus días libres                | Encontrar con anticipación una habitación por fechas, zona, precio y condiciones (pareja, solo mujeres…).                          |
| **Propietario / inquilino principal**                                | Publicar habitaciones de forma recurrente.                                                                                         |
| **Vendedor / comprador**                                             | Vender o comprar botas, ropa de trabajo, autos, herramientas.                                                                      |
| **Organizador de comunidad**                                         | Publicar eventos (asados, partidos, meetups, salidas).                                                                             |
| **Administrador / moderador** (Swingo)                               | Moderar contenido, gestionar reportes, banear usuarios.                                                                            |
| **Partner / anunciante** (fase posterior)                            | Llegar al nicho con promociones y códigos de descuento (cursos de forklift, ropa de trabajo, surf…).                               |

## 7. Modelo de negocio

- **Ingresos por publicidad y partners**, nunca por comisiones a usuarios.
- Formatos previstos (post-MVP):
  - Espacios patrocinados en listados y en la home.
  - **Ofertas de partners con código de descuento exclusivo** para usuarios de Swingo (certificaciones forklift, RIIMPO, cursos, workwear, clases de surf…). Medibles: el partner ve cuántos canjes vienen de Swingo.
  - Guías patrocinadas ("Cómo conseguir tu licencia HR — con descuento en X").
- **Implicación técnica:** desde el MVP se mide el tráfico (analítica de producto) y la arquitectura prevé un contexto `promotions/partners` aunque no se implemente aún.

## 8. Riesgo principal y estrategia de retención

**Riesgo:** después del primer contacto, anfitrión y huésped intercambian teléfonos y la siguiente vez lo resuelven por WhatsApp, sin pasar por Swingo.

**Respuesta:**

1. **Marketplace** y **eventos** dan motivos para volver aunque no busques habitación.
2. **Reputación portable solo dentro de Swingo**: reseñas e insignias de verificación que el usuario quiere acumular.
3. **Funciones de valor que WhatsApp no da**: calendario de disponibilidad, alertas de búsqueda guardada ("avísame cuando haya habitación en Victoria Park del 10 al 17"), roster de swing, favoritos.
4. **Guías / contenido útil** (fase 2): tráfico orgánico por SEO y motivo de visita recurrente.
5. **Ofertas de partners**: descuentos que solo existen dentro de la app.

## 9. Diferenciadores FIFO (ideas a validar)

- **Roster de swing** en el perfil (p. ej. 2:1, 8:6, 14:7): el anfitrión genera disponibilidad automáticamente a partir de su roster; el huésped busca "por mis días libres".
- Filtros pensados para el nicho: **cerca del aeropuerto**, **parking para ute**, **habitación oscura / silenciosa para dormir de día** (turnos de noche), **ropa de cama incluida**, **gastos incluidos**.
- Preferencias de convivencia: solo mujeres / solo hombres / indiferente, se admiten parejas, nº de personas, mascotas, fumar.

## 10. Métricas de éxito (North Star y apoyo)

- **North Star:** nº de **contactos efectivos** por semana (solicitudes de reserva aceptadas + conversaciones de marketplace iniciadas).
- Usuarios activos semanales (WAU) y retención a 30 días.
- Anuncios de habitación activos por ciudad / suburbio.
- % de solicitudes de reserva respondidas en < 24 h.
- Nº de reseñas tras estancia.
- (Post-MVP) clics y canjes en ofertas de partners.

## 11. ¿Herramienta no-code de IA o desarrollo propio? (respuesta al audio 3)

**Decisión:** desarrollo propio, bien hecho, con **Claude Code como asistente de desarrollo**, sobre una arquitectura que permita crecer.

- Las herramientas "genera tu app con IA" sirven para **prototipos visuales** y validar ideas en días. Para un producto con usuarios verificados, reseñas, mensajería, búsqueda geográfica, moderación, apps nativas y escala global, se quedan cortas en control, calidad, seguridad, coste a escala y propiedad del código.
- Se puede usar un prototipo rápido (Figma / Claude) para **validar la UX con usuarios reales** antes o durante el Sprint 1.
- **Costes de mantenimiento:** sí los hay, aunque al inicio pueden ser bajos. Componentes:
  - Hosting de API y base de datos (hay _free tiers_ suficientes para la beta).
  - Almacenamiento de fotos.
  - Envío de emails / SMS de verificación (el SMS es el coste variable más relevante).
  - Mapas / geocodificación.
  - Cuentas de desarrollador: Apple Developer Program (cuota anual) y Google Play (pago único).
  - Dominio.
  - Tiempo de desarrollo y moderación (el coste real más alto).
- Al **no procesar pagos**, se evitan costes de pasarela, PCI y gran parte de la complejidad legal.
