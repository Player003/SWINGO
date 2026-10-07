# ADR-0004 · Sin pagos ni comisiones en el MVP (decisión revisable)

- **Estado:** Aceptado para el MVP · **revisable** según evolucione el negocio
- **Fecha:** 07/10/2026 (revisado 07/10/2026)
- **Autor:** Matías Roldán

## Contexto

El intercambio de habitaciones entre trabajadores FIFO ya ocurre de forma gratuita. El fundador considera que cobrar una comisión (fija o porcentual) al inicio haría caer la propuesta de valor. Además, el marco legal actual define a Swingo como plataforma de conexión que no es parte del acuerdo ni gestiona pagos.

Al mismo tiempo, el modelo de negocio **puede cambiar** al escalar (nuevos países, nuevos segmentos, más volumen) y la arquitectura no debe cerrar esa puerta.

## Decisión

**Para el MVP:**

- No existe ningún flujo de pago, depósito, retención ni comisión en Swingo.
- Los precios de anuncios y artículos son **informativos**.
- La "reserva" es una **solicitud de reserva** que habilita el contacto; el acuerdo y el pago se hacen fuera de Swingo.
- La monetización inicial será por **publicidad y partners** (fase 2).

**Preparación para escalar (sin implementar nada de pagos):**

- El dinero se modela siempre con el value object `Money` (importe entero en unidades menores + ISO 4217), nunca con `number` suelto.
- `BookingRequest` y `MarketplaceItem` tienen máquinas de estados **extensibles**: se podrán añadir estados como `AWAITING_PAYMENT` o `PAID` sin romper los existentes.
- Se reserva un contexto acotado futuro **`payments`** (pasarela detrás de `PaymentGatewayPort`, p. ej. Stripe Connect para pagos entre usuarios). Los demás contextos solo reaccionarían a sus eventos (`PaymentSucceeded`, `PaymentRefunded`…), sin depender de él.
- La configuración comercial (comisión %, tarifas, planes) se pensará **por país** y como dato configurable, no hardcodeada.
- Modelos de ingreso compatibles a evaluar: publicidad y partners, anuncios destacados, suscripción premium para anfitriones o empresas, comisión por reserva o por venta, depósitos de garantía.

## Alternativas consideradas

- **Pagos desde el MVP:** más complejidad (PCI, KYC de anfitriones, disputas, reembolsos) antes de validar el producto.
- **Prohibir los pagos para siempre:** limita las opciones de negocio al escalar.

## Consecuencias

- ✅ MVP sin pasarelas, PCI, conciliaciones ni disputas de pago: menos complejidad y riesgo legal.
- ✅ El diseño permite incorporar pagos o comisiones sin reescribir el dominio.
- ⚠️ Riesgo de desintermediación (los usuarios siguen por WhatsApp): se mitiga con marketplace, comunidad, reputación, alertas y ofertas.
- ⚠️ Riesgo de estafas fuera de la app: avisos antiestafa en mensajería y moderación.
- ⚠️ Si se activan pagos, cambia el rol legal de Swingo (deja de ser "solo conexión"): habrá que revisar `06-legal.md`, términos por país, obligaciones fiscales y de prevención de fraude.
- Activar pagos o comisiones requiere un **ADR nuevo** que sustituya a este y la validación del fundador.
