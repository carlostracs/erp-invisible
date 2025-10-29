# GitHub Actions Workflows

Esta carpeta contiene los templates de workflows de GitHub Actions para el proyecto.

## ⚠️ Instalación Manual Requerida

Debido a restricciones de permisos de GitHub CLI, estos workflows deben ser añadidos manualmente al repositorio.

## Instrucciones de Instalación

### Opción 1: Mediante la interfaz web de GitHub

1. Ve a tu repositorio en GitHub: https://github.com/carlostracs/erp-invisible
2. Navega a la pestaña "Actions"
3. Haz clic en "set up a workflow yourself" o "New workflow"
4. Copia y pega el contenido de cada archivo `.yml` de esta carpeta
5. Guarda cada workflow con su nombre correspondiente en `.github/workflows/`

### Opción 2: Mediante Git local (Recomendado)

```bash
# Asegúrate de estar en la rama develop
git checkout develop
git pull origin develop

# Copia los workflows a la ubicación correcta
mkdir -p .github/workflows
cp workflows-templates/*.yml .github/workflows/

# Commit y push
git add .github/workflows/
git commit -m "ci: añadir workflows de GitHub Actions"
git push origin develop
```

**Nota**: Si el push falla por permisos, deberás crear los archivos directamente en GitHub:

1. Ve a https://github.com/carlostracs/erp-invisible/tree/develop
2. Navega a `.github/workflows/` (créala si no existe)
3. Haz clic en "Add file" > "Create new file"
4. Nombra el archivo (ej: `ci.yml`)
5. Copia el contenido del template correspondiente
6. Haz commit directamente en GitHub

## Workflows Incluidos

### 1. `ci.yml` - Continuous Integration

**Trigger**: Pull Requests y push a `develop`

**Funciones**:
- Ejecuta tests con pytest en Python 3.11 y 3.12
- Linting con flake8
- Formateo con black
- Ordenamiento de imports con isort
- Type checking con mypy
- Cobertura de código
- Build de imagen Docker

**Uso**: Este workflow se ejecuta automáticamente en cada PR para asegurar calidad del código.

### 2. `release.yml` - Release & Deploy

**Trigger**: Push de tags con formato `v*` (ej: `v1.0.0`)

**Funciones**:
- Build de imagen Docker
- Publicación en GitHub Container Registry (ghcr.io)
- Generación automática de release notes
- Actualización de GitHub Release
- (Opcional) Deploy automático a producción

**Uso**: 
```bash
# Crear y push un tag
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

El workflow creará automáticamente:
- Imagen Docker: `ghcr.io/carlostracs/erp-invisible:v1.0.0`
- GitHub Release con changelog

### 3. `staging.yml` - Deploy to Staging

**Trigger**: Push a rama `develop`

**Funciones**:
- Build de imagen Docker para staging
- Publicación con tags `staging` y `staging-<sha>`
- Deploy automático a entorno de staging
- Comentario en commit con información de deploy

**Uso**: Cada push a `develop` despliega automáticamente a staging.

## Configuración Adicional

### Secrets Necesarios

Los workflows usan `GITHUB_TOKEN` que está disponible automáticamente. Si necesitas configurar deploy a producción/staging, añade estos secrets en GitHub:

1. Ve a Settings > Secrets and variables > Actions
2. Añade los secrets necesarios según tu infraestructura:
   - `DEPLOY_SSH_KEY`: Clave SSH para deploy
   - `KUBE_CONFIG`: Configuración de Kubernetes
   - `DEPLOY_TOKEN`: Token para servicios de deploy

### Environments

Para configurar environments (staging, production):

1. Ve a Settings > Environments
2. Crea los environments: `staging` y `production`
3. Configura protection rules para `production`:
   - Required reviewers
   - Wait timer
   - Deployment branches

### Permisos del Repositorio

Asegúrate de que GitHub Actions tiene los permisos necesarios:

1. Ve a Settings > Actions > General
2. En "Workflow permissions", selecciona:
   - ✅ Read and write permissions
   - ✅ Allow GitHub Actions to create and approve pull requests

## Personalización

### Modificar versiones de Python

En `ci.yml`, edita la matriz de versiones:

```yaml
strategy:
  matrix:
    python-version: ['3.11', '3.12', '3.13']  # Añade más versiones
```

### Configurar Deploy Automático

En `release.yml`, descomenta y configura la sección `deploy-production`:

```yaml
deploy-production:
  name: Deploy to Production
  runs-on: ubuntu-latest
  needs: build-and-publish
  environment:
    name: production
    url: https://erp-invisible.tudominio.com
  
  steps:
    - name: Deploy to production
      run: |
        # Tu lógica de deploy aquí
        kubectl set image deployment/erp-invisible erp-invisible=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:${{ github.ref_name }}
```

### Modificar Triggers

Puedes modificar cuándo se ejecutan los workflows:

```yaml
on:
  push:
    branches: [ main, develop, feature/* ]  # Añade más branches
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 0 * * 0'  # Ejecutar semanalmente
```

## Verificación

Después de instalar los workflows:

1. Crea un PR de prueba
2. Verifica que el workflow `ci.yml` se ejecuta
3. Revisa los logs en la pestaña "Actions"
4. Asegúrate de que todos los checks pasan

## Troubleshooting

### Error: "refusing to allow a GitHub App to create or update workflow"

**Solución**: Crea los workflows manualmente en la interfaz web de GitHub o ajusta los permisos del token.

### Workflow no se ejecuta

**Verificar**:
1. Los workflows están en `.github/workflows/`
2. La sintaxis YAML es correcta (usa un validador)
3. Los triggers están configurados correctamente
4. GitHub Actions está habilitado en el repositorio

### Error en build de Docker

**Verificar**:
1. El Dockerfile existe y es válido
2. Los permisos de packages están configurados
3. El token tiene permisos de escritura en packages

## Recursos

- [Documentación de GitHub Actions](https://docs.github.com/en/actions)
- [Workflow Syntax](https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions)
- [GitHub Container Registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
