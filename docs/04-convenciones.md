# 04 · Convenciones de código (Clean Code)

Estas reglas aplican a todo el código del monorepo. Claude Code debe seguirlas sin que se le recuerden.

## 1. Idioma

| Qué                                                                | Idioma                                                                                 |
| ------------------------------------------------------------------ | -------------------------------------------------------------------------------------- |
| Código: nombres de clases, funciones, variables, tablas, endpoints | **Inglés**                                                                             |
| Commits, nombres de ramas, PRs                                     | **Inglés** (Conventional Commits)                                                      |
| Comentarios de documentación (TSDoc)                               | **Español** (equipo hispanohablante)                                                   |
| Documentación de producto (`docs/`)                                | **Español**                                                                            |
| Textos de UI                                                       | **Nunca hardcodeados**: siempre claves i18n (`en-AU` por defecto, `es` segundo idioma) |

## 2. Principios

- **SOLID**, especialmente _Single Responsibility_ y _Dependency Inversion_ (es la base de la arquitectura hexagonal).
- **Nombres que revelan intención.** `findAvailableRoomsForSwing()` mejor que `getData()`. Sin abreviaturas crípticas.
- **Funciones pequeñas**, un nivel de abstracción por función. Si necesita un comentario para explicar _qué_ hace, extraer una función con ese nombre.
- **Sin efectos secundarios ocultos.** Los casos de uso declaran sus dependencias por constructor.
- **Inmutabilidad por defecto** en el dominio (`readonly`, value objects).
- **Errores explícitos:** el dominio lanza/devuelve errores tipados (`DomainError` y subclases, o `Result<T, E>`), nunca `throw new Error('algo')` genérico ni `null` ambiguo.
- **Sin `any`.** TypeScript en modo `strict`. `unknown` + validación cuando el dato viene de fuera.
- **Validación en el borde:** todo input externo (HTTP, formularios, webhooks) se valida con esquemas Zod de `packages/contracts` antes de llegar a un caso de uso.
- **Boy Scout Rule:** dejar el código un poco mejor de lo que estaba, pero sin refactors fuera del alcance de la historia.

## 3. Documentación del código (estilo del equipo)

Toda clase y todo método público lleva cabecera TSDoc con autor y fecha, siguiendo el estilo que Matías usa en Salesforce adaptado a TypeScript.

**Cabecera de clase / módulo:**

```ts
/**
 * Caso de uso que crea una solicitud de reserva sobre un anuncio de habitación
 * @author Matías Roldán
 * @date 07/10/2026
 */
export class CreateBookingRequestUseCase { ... }
```

**Cada método:**

```ts
/**
 * MÉTODO PRINCIPAL que valida disponibilidad del anuncio para las fechas
 * solicitadas y registra la solicitud en estado PENDING
 *
 * @author Matías Roldán
 * @date 07/10/2026
 * @param command (datos de la solicitud: listingId, guestId, checkIn, checkOut)
 * @returns BookingRequest (la solicitud creada)
 * @throws ListingNotAvailableError (si las fechas se solapan con otra reserva aceptada)
 * @where BookingRequestController.create (POST /v1/booking-requests)
 */
async execute(command: CreateBookingRequestCommand): Promise<BookingRequest> { ... }
```

Reglas:

- Formato de fecha `dd/MM/yyyy`. Usar la fecha real del día en que se escribe el código.
- `@author`: quien escribe o pide el cambio. Por defecto `Matías Roldán`.
- `@where`: desde dónde se invoca (controller, otro caso de uso, job, pantalla).
- Al **modificar** un método existente, no reescribir la cabecera: añadir una línea `@modified dd/MM/yyyy Nombre - motivo`.
- Componentes React: misma cabecera en el componente; props documentadas en el tipo.

## 4. Estructura y nombres de archivos

- `kebab-case` para archivos: `create-booking-request.use-case.ts`, `listing.repository.port.ts`, `prisma-listing.repository.ts`.
- Sufijos por rol: `.entity.ts`, `.value-object.ts`, `.use-case.ts`, `.port.ts`, `.adapter.ts` / `.repository.ts`, `.controller.ts`, `.mapper.ts`, `.dto.ts`, `.spec.ts`.
- Componentes React en `PascalCase.tsx`.
- Un concepto por archivo. Exports nombrados (no `default`), salvo donde el framework lo exija (páginas de Next.js / Expo Router).

## 5. Testing

| Capa                                                     | Tipo de test                                                                | Obligatorio                       |
| -------------------------------------------------------- | --------------------------------------------------------------------------- | --------------------------------- |
| Dominio (entidades, value objects, servicios de dominio) | Unitario puro, sin mocks de infraestructura                                 | **Sí**, cobertura objetivo ≥ 90 % |
| Aplicación (casos de uso)                                | Unitario con _fakes_ en memoria de los puertos                              | **Sí**, ≥ 80 %                    |
| Adaptadores de infraestructura                           | Integración (Postgres real en Docker / Testcontainers)                      | Sí para repositorios              |
| API                                                      | E2E de endpoints críticos (auth, publicar, solicitar reserva, reseñar)      | Sí                                |
| UI                                                       | Tests de componentes + flujos críticos E2E (Playwright web / Maestro móvil) | Flujos críticos                   |

- Patrón **Arrange / Act / Assert**, un comportamiento por test, nombre descriptivo: `it('rejects a booking request when dates overlap an accepted one')`.
- TDD recomendado en el dominio: escribir el test primero.
- Nada de tests que dependan del orden o de la hora real: inyectar un `Clock` (puerto).

## 6. Git y flujo de trabajo

- Rama principal `main` siempre desplegable. Ramas cortas: `feat/SWG-123-search-filters`, `fix/SWG-130-calendar-timezone`.
- **Conventional Commits**: `feat(accommodation): add date range filter to search`.
- PR pequeños (idealmente < 400 líneas), con referencia a la historia y checklist de la Definition of Done.
- CI obligatorio: lint + typecheck + tests + build antes de merge.

## 7. Herramientas

- ESLint (config compartida en `packages/config`), Prettier, `typescript --strict`.
- Regla de lint que **impide importar infraestructura desde dominio** (p. ej. `eslint-plugin-boundaries` o `dependency-cruiser`).
- Husky + lint-staged para pre-commit.

## 8. Seguridad y privacidad por defecto

- Nunca loguear datos personales (email, teléfono, documentos) ni tokens.
- Secretos solo en variables de entorno; `.env.example` sin valores reales.
- Autorización en el caso de uso (quién puede hacer qué), no solo en el controller.
- Datos de contacto del anfitrión (teléfono, dirección exacta) visibles **solo** tras aceptar una solicitud de reserva.
