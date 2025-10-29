# ERP Invisible

MCP (Model Context Protocol) Server para Odoo - Sistema de integración inteligente para automatización de procesos empresariales.

## 🎯 Descripción

ERP Invisible es un servidor MCP que permite la integración y automatización de procesos en Odoo mediante el protocolo Model Context Protocol, facilitando la comunicación entre sistemas de IA y el ERP.

## 🚀 Características

- Integración completa con Odoo via XML-RPC
- Soporte para operaciones CRUD en modelos de Odoo
- Gestión de conciliaciones bancarias
- Webhooks para eventos en tiempo real
- Sistema de reintentos exponenciales
- Health checks y monitoreo

## 📋 Requisitos

- Python 3.11+
- Odoo 16.0+ o 17.0+
- Docker (opcional, recomendado para producción)

## 🛠️ Instalación

### Desarrollo local

```bash
# Clonar el repositorio
git clone https://github.com/carlostracs/erp-invisible.git
cd erp-invisible

# Crear entorno virtual
python3 -m venv venv
source venv/bin/activate  # En Windows: venv\Scripts\activate

# Instalar dependencias
pip install -r requirements.txt

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales de Odoo
```

### Producción con Docker

```bash
# Construir imagen
docker build -t erp-invisible:v1.0.0 .

# Ejecutar contenedor
docker run -d \
  --name erp-invisible \
  -p 8000:8000 \
  --env-file .env \
  erp-invisible:v1.0.0
```

## 📖 Uso

```python
# Ejemplo de uso del MCP
from mcp_odoo import OdooMCPServer

server = OdooMCPServer(
    url="https://tu-odoo.com",
    db="tu_base_datos",
    username="admin",
    password="tu_password"
)

# Operaciones con modelos
partners = server.search_read('res.partner', [('is_company', '=', True)])
```

## 🌿 Workflow de desarrollo

Este proyecto sigue un flujo de trabajo basado en GitFlow con versionado semántico (SemVer).

### Estructura de branches

- **main**: Rama principal, siempre estable y desplegable
- **develop**: Rama de integración para nuevas características
- **feature/\***: Ramas para nuevas funcionalidades
- **hotfix/\***: Ramas para correcciones urgentes en producción

### Proceso de contribución

1. Crear una rama desde `develop`:
   ```bash
   git checkout develop
   git pull
   git checkout -b feature/nombre-feature
   ```

2. Realizar cambios con commits descriptivos:
   ```bash
   git commit -m "feat(webhook): añadir reintentos exponenciales"
   ```

3. Abrir Pull Request hacia `develop`

4. Tras revisión y merge a `develop`, se integra a `main` para release

### Versionado

Seguimos [SemVer](https://semver.org/):
- **MAJOR**: Cambios incompatibles con versiones anteriores
- **MINOR**: Nuevas funcionalidades compatibles
- **PATCH**: Correcciones de bugs compatibles

## 🔖 Releases

Las releases se crean desde `main` con tags:

```bash
git checkout main
git pull
git tag -a v1.0.0 -m "Release inicial con soporte básico de Odoo"
git push origin v1.0.0
```

Cada tag genera automáticamente:
- GitHub Release con changelog
- Imagen Docker en GHCR
- Despliegue automático (según configuración)

## 🧪 Testing

```bash
# Ejecutar tests
pytest

# Con cobertura
pytest --cov=mcp_odoo --cov-report=html

# Linting
flake8 .
black --check .
```

## 📦 Despliegue

### Rollback a versión anterior

```bash
# Desplegar versión específica
docker pull ghcr.io/carlostracs/erp-invisible:v1.0.0
docker run -d ghcr.io/carlostracs/erp-invisible:v1.0.0
```

### Revertir cambios problemáticos

```bash
git checkout main
git log --oneline --graph
git revert -m 1 <hash_del_merge>
git push origin main
```

## 🤝 Contribución

1. Fork el proyecto
2. Crea tu rama de feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'feat: Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

## 📝 Convenciones de commits

Usamos [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` Nueva funcionalidad
- `fix:` Corrección de bug
- `docs:` Cambios en documentación
- `style:` Formato, sin cambios de código
- `refactor:` Refactorización de código
- `test:` Añadir o modificar tests
- `chore:` Tareas de mantenimiento

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👥 Autores

- **Carlos Tracs** - [@carlostracs](https://github.com/carlostracs)

## 🔗 Enlaces útiles

- [Documentación de Odoo](https://www.odoo.com/documentation)
- [Model Context Protocol](https://modelcontextprotocol.io/)
- [Guía de contribución](CONTRIBUTING.md)
- [Changelog](CHANGELOG.md)
