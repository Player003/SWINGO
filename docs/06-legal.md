# 06 · Marco legal y responsabilidad

> Texto aportado por el fundador. Es la base de los Términos de Publicación que el usuario debe aceptar **antes** de publicar una habitación. Debe revisarlo un abogado en cada país donde se lance.

## Texto base (es)

**Responsabilidad legal**

- El usuario que publica la habitación es responsable de contar con la autorización del propietario y cumplir la legislación y su contrato de alquiler.
- El anfitrión y el huésped acuerdan directamente las condiciones de la estancia y firman su propio acuerdo.
- Swingo actúa únicamente como plataforma de conexión, no es parte del acuerdo ni gestiona los pagos.
- Antes de publicar, el usuario debe aceptar estas condiciones y asumir la responsabilidad de su oferta.

## Implicaciones para el producto y el código

| Regla | Cómo se refleja en el sistema |
|---|---|
| Swingo **no gestiona pagos** | No existe módulo de pagos en el MVP. El precio es informativo. Ningún flujo cobra, retiene ni transfiere dinero. |
| Swingo **no es parte del acuerdo** | La "reserva" es una **solicitud de reserva** (BookingRequest) que el anfitrión acepta o rechaza. Al aceptarse, se habilita el contacto y queda registro, pero no hay contrato gestionado por Swingo. |
| El anfitrión declara tener **autorización del propietario** | Checkbox obligatorio + aceptación de términos en el flujo de publicación. |
| Aceptación **previa** a publicar | Entidad `TermsAcceptance` (userId, termsType, termsVersion, acceptedAt, ip/userAgent, locale). Un `Listing` no puede pasar a `PUBLISHED` sin aceptación vigente de la versión actual. |
| Versionado de términos | Si cambia la versión, se pide re-aceptación antes de la siguiente publicación/edición. |
| Multi-país | Los términos se versionan **por país y por idioma** (`termsType + countryCode + locale + version`). |

## Pendiente de validar (no bloquea el desarrollo)

- Revisión legal en Australia (Consumer Law, privacidad: *Privacy Act 1988* / APPs) antes del lanzamiento.
- Política de privacidad y tratamiento de documentos de identidad si se usa verificación de ID.
- Política de contenidos prohibidos para Marketplace y Eventos.
- Requisitos de subarriendo (*sublet*) por estado australiano: el texto traslada la responsabilidad al anfitrión, pero conviene mostrar un aviso informativo.
