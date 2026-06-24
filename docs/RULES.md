# Reglas del proyecto

## Versionado

- Cada `push` a `main` debe tener un tag de versión semántica (`vX.Y.Z`)
- El tag debe coincidir con el commit al que pertenece
- El número de versión debe incrementarse respecto al tag anterior

### Formato

```
v<major>.<minor>.<patch>
```

### Criterios de incremento

| Componente | Cuándo incrementar |
|---|---|
| `major` | Cambios incompatibles, refactors grandes, breaking changes |
| `minor` | Nuevas funcionalidades, nuevas UIs, nuevos módulos |
| `patch` | Bugfixes, mejoras menores, documentación, config |

### Ejemplo

```bash
git add -A
git commit -m "descripción del cambio"
git tag v1.1.0
git push origin main --tags
```

## Commits

- Mensajes claros y descriptivos en español
- Un commit por cambio lógico completo

## Archivo VERSION

- Existe un archivo `VERSION` en la raíz del proyecto
- Su contenido debe coincidir exactamente con el último tag (`vX.Y.Z`)
- Debe incrementarse en cada commit al mismo tiempo que se crea el tag
- El formato es una línea: `vX.Y.Z` (sin salto de línea extra)

## Directorio tools/

- Todos los scripts utilitarios (`.sh`) se alojan en `tools/`
- No debe haber scripts `.sh` sueltos en la raíz del proyecto
- `tools/install.sh` → instalación multiplataforma
- `tools/run.sh` → menú interactivo

## Estilo y calidad del código

- Escribir código como un profesional senior: limpio, legible y mantenible
- Seguir las convenciones del lenguaje y del proyecto (imports, naming, estructura)
- No dejar código comentado sin propósito — si no se usa, se elimina
- Mantener consistencia: si el proyecto usa un patrón, seguirlo en todo el códigobase
- Los nombres de variables, funciones y archivos deben ser autoexplicativos
- Cada archivo debe tener una única responsabilidad bien definida

## Prohibido

- Pushear `.env` con API keys (ya están en `.gitignore`)
- Pushear sin tag
- Pushear código que no compila/ejecuta

---

> Esta sección está preparada para futuras reglas. Agregar nuevas secciones arriba según sea necesario.
>
> **Próximas reglas propuestas:**
> - Tests
> - Linting/formatting
> - Code review
> - Branch strategy
