# Fuentes originales del proyecto

Material aportado por el fundador de la idea (residente en Australia, trabajador del entorno FIFO/backpacker). Se conserva tal cual como referencia; la interpretación está en `01-vision-producto.md` y `02-mvp.md`.

Las transcripciones de audio se generaron automáticamente (Whisper) y se corrigieron solo errores evidentes (p. ej. "FIFA" → "FIFO", "adquilar" → "alquilar"). Fecha de los audios: 24/09/2026.

---

## Texto 1 — Brief de desarrollo

**SWINGO — Brief de desarrollo de la aplicación**

**1. Idea principal**
Crear una plataforma digital para trabajadores FIFO en Australia que centralice alojamiento, marketplace y comunidad en un solo lugar.
La experiencia de búsqueda de alojamiento/uniformes/vehículos/eventos estará inspirada en sitios web como Booking.com, Facebook Marketplace, Couchsurfing.

**2. Problema principal que resuelve**
Actualmente, una de las alternativas utilizadas por los trabajadores FIFO para encontrar habitaciones y compartir información son los grupos cerrados de WhatsApp. Estos grupos presentan varias limitaciones:

- **Acceso limitado:** no todos los trabajadores pueden acceder a los grupos ni encontrar a las personas que ofrecen alojamiento.
- **Información efímera:** los mensajes pueden desaparecer en 24 horas cuando se utilizan mensajes temporales, y la información queda enterrada entre conversaciones.
- **Falta de organización:** no hay filtros para buscar por fechas, ubicación, precio o disponibilidad.
- **Falta de referencias:** no existe un sistema estructurado de comentarios, valoraciones o referencias sobre las habitaciones y sus anfitriones.
- **Poca anticipación:** resulta difícil encontrar y comparar opciones de alojamiento con suficiente tiempo antes de los días libres.

**3. Solución: Swingo**
Una plataforma donde toda la información esté centralizada, organizada y disponible con anticipación, permitiendo a los trabajadores encontrar exactamente lo que necesitan mediante filtros y sin comisiones.

El usuario podrá:
- Buscar habitaciones por ubicación, fechas, características, precio y disponibilidad.
- Consultar fotografías, descripciones, condiciones y referencias de otros usuarios.
- Publicar habitaciones disponibles durante sus swings.
- Guardar opciones y contactar directamente con los anfitriones.
- Encontrar productos de segunda mano y eventos comunitarios en el [texto incompleto en el original].

Swingo transforma información dispersa en una plataforma organizada, accesible y confiable.

**4. Funcionalidades esenciales del MVP**
- Registro y perfiles de usuarios.
- Buscador de alojamiento con filtros y calendario.
- Publicación de habitaciones con fotos, precios y disponibilidad.
- Valoraciones y referencias.
- Mensajería y solicitudes de reserva.
- Marketplace de segunda mano.
- Eventos y comunidad.
- Panel de administración y moderación.

**Objetivo:** que Swingo sea el lugar donde cualquier trabajador FIFO pueda encontrar, comparar y organizar con anticipación su alojamiento, acceder a oportunidades y conectar con otros trabajadores, sin depender de grupos cerrados de WhatsApp.

---

## Texto 2 — Responsabilidad legal

- El usuario que publica la habitación es responsable de contar con la autorización del propietario y cumplir la legislación y su contrato de alquiler.
- El anfitrión y el huésped acuerdan directamente las condiciones de la estancia y firman su propio acuerdo.
- Swingo actúa únicamente como plataforma de conexión, no es parte del acuerdo ni gestiona los pagos.
- Antes de publicar, el usuario debe aceptar estas condiciones y asumir la responsabilidad de su oferta.

---

## Texto 3 — Nota sobre la interfaz

> Nunca hice un brief para un programador pero si me decís qué más le falta con gusto lo detallo más. Básicamente está la idea general y el problema que resuelve. En cuanto a la interfaz sería el mismo modelo de búsqueda de habitaciones que Booking por ejemplo para no complicarse, y marketplace igual al de Facebook con los filtros de búsqueda. Y pienso que debería haber una autenticación de usuario para que las reseñas y las reservas sean verdaderas.

---

## Audio 1 (3:52) — El problema y el modelo de negocio

> Desde que estoy aquí en Australia noto algo. La gente que hace FIFO —la gente que vuela en avión a la mina por una semana o dos y luego vuelve—… Generalmente acá todos los backpackers alquilan casa compartida. Y lo interesante es que la gente que se va una semana o dos a la mina siempre pone su habitación disponible para que otra persona que también está haciendo FIFO y justo esté en la ciudad ocupe la habitación. Entonces es un *win-win*: la persona que vuelve a la ciudad tiene dónde quedarse y la persona que se va a la mina no paga la renta al pedo, alguien se la está pagando por él.
>
> ¿Cuál es el tema? Que hace 3 años el único método que veo para que la gente se ponga en contacto es a través de grupos de WhatsApp cerrados. Es medio confuso porque hay muchos grupos separados. Muchos grupos ponen que cada 24 horas se borra todo el historial. Si alguien puso ayer que tiene una habitación disponible, por más que siga libre no te enteraste, porque el mensaje ya está borrado. Y es bastante desorganizado tener que buscar en un chat grupal la zona que te interesa, el precio, que diga pareja, que sea para una persona, que sea solo para mujeres…
>
> Lo que estaba pensando es desarrollar una aplicación exclusivamente para gente que haga la modalidad FIFO, donde la gente que tiene una habitación o una casa la suba de forma ordenada y segmentada: esta habitación está disponible desde esta fecha hasta esta fecha, sale este precio, tiene estas características, se admite este tipo de personas, no se permiten estas cosas. Exactamente lo mismo que Booking. ¿La diferencia? Que esto no está pasando en Booking. Y además sería **sin comisión**.
>
> Lo que más me interesa es que haya **mucho tráfico** de gente intentando alquilar y gente que quiera alquilar su habitación. Porque si tengo mucho tráfico, después algunas **empresas pueden publicitar sus productos o servicios** en la aplicación, y de ahí serían las ganancias. Pero quiero que sea **totalmente gratuito** para la gente. ¿Por qué? Porque ya se está dando de forma gratuita, sin comisión. Si hubiera un intermediario que te coge una comisión fija o porcentual, la idea se cae.
>
> Quiero una aplicación mucho más organizada donde puedas poner por filtro: ¿en qué ciudad de Australia estás? ¿En qué barrio de esa ciudad te interesa la casa? ¿Para cuántas personas, por cuántos días? Y ver las disponibilidades para poder contactarte con el dueño de esa habitación.

## Audio 2 (2:51) — Retención, marketplace, publicidad y guías

> Esta aplicación tiene una pequeña contra: una vez que la persona contacta al dueño de una habitación, luego quedan en contacto por teléfono. La siguiente vez seguramente lo harán por WhatsApp y no por la aplicación. Entonces, **para seguir generando tráfico**, dentro de la aplicación habría una especie de **marketplace**, donde yo no intervengo con la plata. No hay plataforma de pago, simplemente es un lugar donde la gente se entera de cosas. En los grupos de WhatsApp siempre las personas FIFO venden **botas de trabajo, indumentaria de trabajo, autos para ir a trabajar**; todo lo relacionado a minería pasa por WhatsApp, y los mensajes se borran.
>
> En la aplicación podrías segmentar: busco indumentaria → botas → talla 7, y que te salgan las personas que ofrecen botas talla 7, con los distintos precios y **dónde puedes reunirte** con esa persona. Sin comisión, sin ser intermediario.
>
> Y si tiene tráfico, que otras **empresas** estén interesadas en publicitar productos o servicios que le sirvan a este mercado: cosas para backpackers, indumentaria más barata, clases de surf, capacitaciones, **certificaciones** (p. ej. forklift). Por ejemplo, si entras desde la página tienes un **descuento** con ellos; así garantizas que la gente vaya a la página.
>
> También que en la plataforma encuentres **información útil y bien resumida**: si quiero seguir en FIFO pero en un nuevo puesto (p. ej. manejar camiones), pequeños **artículos / "islas de información"**: el paso a paso, esta certificación, este tiempo, aplicar a estas mineras, estas son tus opciones, acá tenés contacto, acá tenés código de descuento, estos son los tiempos, estos son los salarios.

## Audio 3 (0:50) — Duda sobre herramientas de IA y costes

> Había escuchado que hay aplicaciones o páginas con inteligencia artificial que te permiten desarrollar una aplicación gratis o pagando poco, pero no sé cuál es el resultado. ¿Esto que quiero hacer es algo que la IA puede hacer, por lo menos como prototipo, o hay que desarrollarla de cero, bien hecha? ¿Va a tener costes de mantenimiento? De nuevo, **no quiero que haya transacciones dentro de la plataforma**: simplemente se busca y se pone información para poner en contacto a gente que busca y gente que ofrece.
