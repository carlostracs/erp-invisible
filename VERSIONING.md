# Guía de Versionado y Releases

Este documento describe el proceso de versionado y creación de releases para ERP Invisible.

## Versionado Semántico (SemVer)

El proyecto sigue [Semantic Versioning 2.0.0](https://semver.org/lang/es/). El formato de versión es `MAJOR.MINOR.PATCH`, donde:

**MAJOR** (vX.0.0): Se incrementa cuando se realizan cambios incompatibles con versiones anteriores (breaking changes). Esto incluye cambios en la API que requieren modificaciones en el código del cliente, eliminación de funcionalidades, o cambios estructurales significativos.

**MINOR** (v1.X.0): Se incrementa cuando se añaden nuevas funcionalidades de manera compatible con versiones anteriores. Incluye nuevos endpoints, nuevas características, o mejoras significativas que no rompen la compatibilidad.

**PATCH** (v1.0.X): Se incrementa para correcciones de bugs compatibles con versiones anteriores. Incluye fixes de seguridad, correcciones de errores, y pequeñas mejoras de rendimiento.

## Ejemplos de Cambios por Tipo

### MAJOR (Breaking Changes)

```
v1.0.0 → v2.0.0
```

Ejemplos de cambios que requieren incremento MAJOR:

- Cambiar el formato de respuesta de endpoints existentes
- Eliminar endpoints o funcionalidades
- Modificar la estructura de configuración de manera incompatible
- Cambiar requisitos mínimos de versión de dependencias críticas
- Reestructurar la base de datos de manera incompatible

### MINOR (New Features)

```
v1.0.0 → v1.1.0
```

Ejemplos de cambios que requieren incremento MINOR:

- Añadir nuevos endpoints a la API
- Implementar nuevas funcionalidades (webhooks, integraciones)
- Añadir nuevos parámetros opcionales a endpoints existentes
- Mejorar el rendimiento de manera significativa
- Añadir soporte para nuevas versiones de Odoo

### PATCH (Bug Fixes)

```
v1.0.0 → v1.0.1
```

Ejemplos de cambios que requieren incremento PATCH:

- Corregir bugs en funcionalidades existentes
- Fixes de seguridad
- Correcciones en la documentación
- Pequeñas mejoras de rendimiento
- Actualización de dependencias por seguridad

## Proceso de Release

### 1. Preparación

Antes de crear una release, asegúrate de que:

- Todos los tests pasan correctamente
- La documentación está actualizada
- El CHANGELOG.md refleja todos los cambios
- El código en `develop` está estable y probado

### 2. Crear Release desde Develop

```bash
# Asegurarse de estar en develop actualizado
git checkout develop
git pull origin develop

# Crear rama de release (opcional, para preparación)
git checkout -b release/v1.1.0

# Actualizar CHANGELOG.md con la fecha de release
# Actualizar versión en archivos relevantes si aplica

# Commit de preparación
git commit -am "chore(release): preparar v1.1.0"

# Merge a main
git checkout main
git pull origin main
git merge release/v1.1.0

# Crear tag
git tag -a v1.1.0 -m "Release v1.1.0

Nuevas características:
- Soporte para webhooks con reintentos
- Integración con conciliación bancaria
- Mejoras en el sistema de logging

Correcciones:
- Fix timeout en conexiones Odoo
- Corrección en validación de tokens"

# Push de main y tag
git push origin main
git push origin v1.1.0

# Merge de vuelta a develop
git checkout develop
git merge main
git push origin develop

# Eliminar rama de release (si se creó)
git branch -d release/v1.1.0
```

### 3. GitHub Actions Automático

Al hacer push del tag, GitHub Actions automáticamente:

- Ejecuta todos los tests
- Construye la imagen Docker
- Publica la imagen en GitHub Container Registry
- Crea la GitHub Release con changelog automático
- (Opcional) Despliega a producción

### 4. Verificar Release

Después del push del tag:

1. Verifica que el workflow de release se ejecutó correctamente en GitHub Actions
2. Comprueba que la imagen Docker se publicó en GHCR
3. Revisa la GitHub Release generada automáticamente
4. Prueba la nueva versión en staging antes de producción

## Hotfixes (Correcciones Urgentes)

Para correcciones urgentes en producción:

```bash
# Crear hotfix desde la última release tag
git checkout -b hotfix/critical-bug v1.1.0

# Realizar la corrección
# ... hacer cambios ...

git commit -m "fix(critical): corregir vulnerabilidad de seguridad"

# Merge a main
git checkout main
git merge hotfix/critical-bug

# Crear tag PATCH
git tag -a v1.1.1 -m "Hotfix v1.1.1: corregir vulnerabilidad de seguridad"
git push origin main
git push origin v1.1.1

# Merge también a develop
git checkout develop
git merge hotfix/critical-bug
git push origin develop

# Eliminar rama de hotfix
git branch -d hotfix/critical-bug
```

## Rollback a Versión Anterior

Si una release tiene problemas en producción:

### Opción A: Rollback de Despliegue (Recomendado)

```bash
# Re-desplegar la versión anterior sin tocar Git
docker pull ghcr.io/carlostracs/erp-invisible:v1.0.0
docker-compose up -d

# O con kubectl
kubectl set image deployment/erp-invisible \
  erp-invisible=ghcr.io/carlostracs/erp-invisible:v1.0.0
```

### Opción B: Revert de Commits

```bash
# Revertir el merge problemático
git checkout main
git log --oneline --graph  # Identificar el hash del merge

git revert -m 1 <hash_del_merge>
git push origin main

# Crear tag de patch con el revert
git tag -a v1.1.1 -m "revert: revertir cambios problemáticos de v1.1.0"
git push origin v1.1.1
```

### Opción C: Hotfix Correctivo

Si el problema es menor, crear un hotfix que corrija el issue sin revertir toda la release.

## Pre-releases y Release Candidates

Para versiones beta o release candidates:

```bash
# Tag con sufijo
git tag -a v1.2.0-rc.1 -m "Release Candidate 1 para v1.2.0"
git push origin v1.2.0-rc.1

# Beta releases
git tag -a v1.2.0-beta.1 -m "Beta 1 para v1.2.0"
git push origin v1.2.0-beta.1
```

En GitHub, marca estas releases como "Pre-release" para distinguirlas de releases estables.

## Checklist de Release

Antes de crear una release, verifica:

- [ ] Todos los tests pasan en CI
- [ ] La documentación está actualizada
- [ ] CHANGELOG.md incluye todos los cambios
- [ ] No hay issues críticos abiertos
- [ ] El código ha sido revisado (code review)
- [ ] Se ha probado en staging
- [ ] Las migraciones de BD están documentadas (si aplica)
- [ ] Los breaking changes están claramente documentados
- [ ] Se ha actualizado la versión en archivos relevantes

## Despliegue de Releases

### Staging (automático desde develop)

Cada push a `develop` despliega automáticamente a staging con tag `staging-<sha>`.

### Producción (desde tags)

Las releases etiquetadas se despliegan automáticamente a producción (cuando esté configurado).

Para despliegue manual:

```bash
# Descargar imagen de la release
docker pull ghcr.io/carlostracs/erp-invisible:v1.1.0

# Desplegar
docker-compose up -d

# O con kubectl
kubectl set image deployment/erp-invisible \
  erp-invisible=ghcr.io/carlostracs/erp-invisible:v1.1.0
```

## Comunicación de Releases

Para cada release:

1. Actualiza el CHANGELOG.md con detalles completos
2. Crea la GitHub Release con notas de release
3. Notifica al equipo sobre cambios importantes
4. Si hay breaking changes, documenta la guía de migración
5. Actualiza la documentación de usuario si es necesario

## Referencias

- [Semantic Versioning](https://semver.org/lang/es/)
- [Keep a Changelog](https://keepachangelog.com/es-ES/1.0.0/)
- [Conventional Commits](https://www.conventionalcommits.org/)
