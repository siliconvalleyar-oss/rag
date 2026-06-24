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

## Prohibido

- Pushear `.env` con API keys (ya están en `.gitignore`)
- Pushear sin tag
- Pushear código que no compila/ejecuta
