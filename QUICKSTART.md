# Guía de Inicio Rápido - ERP Invisible

Esta guía te ayudará a configurar el repositorio y empezar a trabajar en el proyecto rápidamente.

## 📋 Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:

- **Git** (versión 2.0 o superior)
- **Python** 3.11 o superior
- **Docker** (opcional, recomendado para producción)
- **Cuenta de GitHub** con acceso al repositorio

## 🚀 Configuración Inicial

### 1. Clonar el Repositorio

```bash
# Clonar el repositorio
git clone https://github.com/carlostracs/erp-invisible.git
cd erp-invisible

# Verificar que estás en develop
git checkout develop
git pull origin develop
```

### 2. Configurar Git

```bash
# Configurar tu identidad (si no lo has hecho globalmente)
git config user.name "Tu Nombre"
git config user.email "tu@email.com"

# Configurar aliases útiles (opcional)
git config alias.co checkout
git config alias.br branch
git config alias.st status
git config alias.lg "log --oneline --graph --all"
```

### 3. Configurar Entorno Python

```bash
# Crear entorno virtual
python3 -m venv venv

# Activar entorno virtual
# En Linux/Mac:
source venv/bin/activate
# En Windows:
venv\Scripts\activate

# Actualizar pip
pip install --upgrade pip

# Instalar dependencias
pip install -r requirements.txt
```

### 4. Configurar Variables de Entorno

```bash
# Copiar archivo de ejemplo
cp .env.example .env

# Editar .env con tus credenciales
nano .env  # o usa tu editor preferido
```

Configura al menos estas variables:

```env
ODOO_URL=https://tu-odoo.com
ODOO_DB=tu_base_datos
ODOO_USERNAME=admin
ODOO_PASSWORD=tu_password
```

### 5. Instalar GitHub Actions Workflows

Los workflows están en `workflows-templates/`. Para instalarlos:

```bash
# Copiar workflows a la ubicación correcta
mkdir -p .github/workflows
cp workflows-templates/*.yml .github/workflows/

# Commit (hazlo directamente en GitHub si tienes problemas de permisos)
git add .github/workflows/
git commit -m "ci: añadir workflows de GitHub Actions"
```

Si el push falla, crea los archivos directamente en GitHub siguiendo las instrucciones en `workflows-templates/README.md`.

## 🔧 Desarrollo

### Crear una Nueva Feature

```bash
# Asegurarte de estar en develop actualizado
git checkout develop
git pull origin develop

# Crear rama de feature
git checkout -b feature/nombre-descriptivo

# Ejemplo: feature para webhooks
git checkout -b feature/webhook-retry
```

### Hacer Cambios y Commits

```bash
# Ver estado de archivos
git status

# Añadir archivos modificados
git add .

# Commit con mensaje siguiendo Conventional Commits
git commit -m "feat(webhook): añadir sistema de reintentos exponenciales"

# Push de la rama
git push -u origin feature/webhook-retry
```

### Crear Pull Request

1. Ve a https://github.com/carlostracs/erp-invisible
2. Haz clic en "Compare & pull request"
3. Asegúrate de que el PR apunta a `develop`
4. Completa la plantilla del PR
5. Espera la revisión y aprobación

### Ejecutar Tests Localmente

```bash
# Activar entorno virtual
source venv/bin/activate

# Ejecutar todos los tests
pytest

# Con cobertura
pytest --cov=mcp_odoo --cov-report=html

# Tests específicos
pytest tests/test_webhook.py -v
```

### Linting y Formateo

```bash
# Formatear código automáticamente
black .
isort .

# Verificar linting
flake8 .

# Type checking
mypy . --ignore-missing-imports
```

## 🐳 Docker

### Build Local

```bash
# Construir imagen
docker build -t erp-invisible:dev .

# Ejecutar contenedor
docker run -d \
  --name erp-invisible \
  -p 8000:8000 \
  --env-file .env \
  erp-invisible:dev
```

### Docker Compose

```bash
# Iniciar servicios
docker-compose up -d

# Ver logs
docker-compose logs -f

# Detener servicios
docker-compose down
```

## 📦 Estructura del Proyecto

```
erp-invisible/
├── .github/                    # Configuración de GitHub
│   ├── workflows/             # GitHub Actions workflows
│   ├── ISSUE_TEMPLATE/        # Plantillas de issues
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── CODEOWNERS
│   └── dependabot.yml
├── workflows-templates/        # Templates de workflows
├── tests/                      # Tests unitarios e integración
├── mcp_odoo/                   # Código fuente principal
├── docs/                       # Documentación adicional
├── .env.example               # Ejemplo de variables de entorno
├── .gitignore
├── Dockerfile
├── docker-compose.yml
├── requirements.txt
├── README.md
├── CONTRIBUTING.md
├── CHANGELOG.md
├── VERSIONING.md
├── GIT_CHEATSHEET.md
└── QUICKSTART.md              # Este archivo
```

## 🌿 Flujo de Trabajo Git

### Branches Principales

- **main**: Código en producción, siempre estable
- **develop**: Integración de features, próxima release

### Branches de Trabajo

- **feature/\***: Nuevas funcionalidades
- **hotfix/\***: Correcciones urgentes en producción
- **release/\***: Preparación de releases (opcional)

### Flujo Completo

```
develop → feature/nueva-funcionalidad → PR → develop → main → tag → release
```

## 📝 Convenciones

### Commits

Seguimos [Conventional Commits](https://www.conventionalcommits.org/):

```
feat(scope): añadir nueva funcionalidad
fix(scope): corregir bug
docs(scope): actualizar documentación
style(scope): formateo de código
refactor(scope): refactorización
test(scope): añadir tests
chore(scope): tareas de mantenimiento
```

### Branches

```
feature/descripcion-corta
hotfix/descripcion-bug
release/v1.1.0
```

## 🔖 Crear Release

```bash
# Asegurarse de que develop está listo
git checkout develop
git pull origin develop

# Merge a main
git checkout main
git pull origin main
git merge develop

# Crear tag
git tag -a v1.0.0 -m "Release v1.0.0: descripción"

# Push
git push origin main
git push origin v1.0.0

# Merge de vuelta a develop
git checkout develop
git merge main
git push origin develop
```

El tag disparará automáticamente:
- Build de Docker image
- Publicación en GHCR
- Creación de GitHub Release

## 🆘 Solución de Problemas

### Error: "refusing to allow a GitHub App to create or update workflow"

**Solución**: Crea los workflows manualmente en la interfaz web de GitHub.

### Tests fallan localmente

**Verificar**:
1. Entorno virtual activado
2. Dependencias instaladas: `pip install -r requirements.txt`
3. Variables de entorno configuradas en `.env`

### Docker build falla

**Verificar**:
1. Docker está corriendo: `docker ps`
2. Dockerfile es válido
3. Suficiente espacio en disco

### No puedo hacer push

**Verificar**:
1. Estás en la branch correcta (no en `main`)
2. Tienes permisos en el repositorio
3. Branch protection rules (main requiere PR)

## 📚 Recursos Adicionales

- **README.md**: Descripción general del proyecto
- **CONTRIBUTING.md**: Guía detallada de contribución
- **VERSIONING.md**: Guía de versionado y releases
- **GIT_CHEATSHEET.md**: Comandos Git útiles
- **workflows-templates/README.md**: Instrucciones de workflows

## 🤝 Obtener Ayuda

Si tienes problemas:

1. Revisa la documentación en este repositorio
2. Busca en issues existentes: https://github.com/carlostracs/erp-invisible/issues
3. Abre un nuevo issue con la etiqueta "question"
4. Contacta al equipo

## ✅ Checklist de Configuración

Marca cuando completes cada paso:

- [ ] Repositorio clonado
- [ ] Git configurado (nombre y email)
- [ ] Entorno virtual de Python creado y activado
- [ ] Dependencias instaladas
- [ ] Archivo `.env` configurado
- [ ] Workflows instalados (opcional al inicio)
- [ ] Tests ejecutados exitosamente
- [ ] Docker funcionando (opcional)
- [ ] Primera feature branch creada
- [ ] Primer commit realizado

¡Listo! Ya estás preparado para contribuir al proyecto. 🎉

---

**Próximos pasos**: Lee `CONTRIBUTING.md` para entender el flujo completo de contribución y las mejores prácticas del proyecto.
