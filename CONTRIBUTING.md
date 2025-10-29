# Guía de Contribución

Gracias por tu interés en contribuir a ERP Invisible. Este documento proporciona las directrices para contribuir al proyecto de manera efectiva.

## Tabla de Contenidos

- [Código de Conducta](#código-de-conducta)
- [Cómo Contribuir](#cómo-contribuir)
- [Estructura de Branches](#estructura-de-branches)
- [Proceso de Pull Request](#proceso-de-pull-request)
- [Convenciones de Código](#convenciones-de-código)
- [Convenciones de Commits](#convenciones-de-commits)
- [Testing](#testing)

## Código de Conducta

Este proyecto se adhiere a un código de conducta que esperamos que todos los participantes respeten. Sé respetuoso, constructivo y profesional en todas las interacciones.

## Cómo Contribuir

Existen varias formas de contribuir al proyecto:

**Reportar bugs**: Si encuentras un error, abre un issue describiendo el problema, los pasos para reproducirlo y el comportamiento esperado.

**Sugerir mejoras**: Las ideas para nuevas características son bienvenidas. Abre un issue describiendo tu propuesta y por qué sería útil.

**Contribuir código**: Sigue el proceso descrito en este documento para enviar cambios de código.

**Mejorar documentación**: La documentación siempre puede mejorarse. Correcciones, aclaraciones y ejemplos adicionales son muy apreciados.

## Estructura de Branches

El proyecto utiliza GitFlow como estrategia de branching:

**main**: Rama principal que contiene el código en producción. Siempre debe estar en un estado desplegable y estable. Esta rama está protegida y solo se actualiza mediante Pull Requests desde `develop` o `hotfix/*`.

**develop**: Rama de integración donde se fusionan todas las características antes de pasar a producción. Es la rama base para crear nuevas features.

**feature/\***: Ramas para desarrollar nuevas funcionalidades. Se crean desde `develop` y se fusionan de vuelta a `develop` mediante Pull Request.

**hotfix/\***: Ramas para correcciones urgentes en producción. Se crean desde `main`, se fusionan a `main` y `develop`, y generan una nueva versión PATCH.

**release/\***: Ramas opcionales para preparar releases. Se crean desde `develop` cuando se está listo para una nueva versión.

## Proceso de Pull Request

### 1. Preparar tu entorno

```bash
# Fork el repositorio en GitHub
# Clona tu fork
git clone https://github.com/TU_USUARIO/erp-invisible.git
cd erp-invisible

# Añade el repositorio original como upstream
git remote add upstream https://github.com/carlostracs/erp-invisible.git

# Mantén tu fork actualizado
git fetch upstream
git checkout develop
git merge upstream/develop
```

### 2. Crear una rama de feature

```bash
# Asegúrate de estar en develop actualizado
git checkout develop
git pull upstream develop

# Crea tu rama de feature
git checkout -b feature/nombre-descriptivo
```

### 3. Desarrollar tu cambio

Realiza tus cambios siguiendo las convenciones de código del proyecto. Asegúrate de:

- Escribir código limpio y bien documentado
- Añadir tests para nuevas funcionalidades
- Actualizar la documentación si es necesario
- Seguir las convenciones de commits

### 4. Commit de cambios

```bash
# Añade los archivos modificados
git add .

# Commit con mensaje descriptivo siguiendo Conventional Commits
git commit -m "feat(webhook): añadir sistema de reintentos exponenciales"
```

### 5. Push y crear Pull Request

```bash
# Push a tu fork
git push origin feature/nombre-descriptivo
```

Luego, en GitHub:

- Ve a tu fork del repositorio
- Haz clic en "Compare & pull request"
- Asegúrate de que el PR apunta a `develop` (no a `main`)
- Completa la plantilla del PR con toda la información relevante
- Espera la revisión del código

### 6. Revisión y merge

El equipo revisará tu PR. Puede que se soliciten cambios. Una vez aprobado y con todos los checks pasando, se fusionará a `develop`.

## Convenciones de Código

El proyecto sigue las siguientes convenciones:

**Python**: Seguimos PEP 8 con algunas excepciones. Usamos Black para formateo automático con longitud de línea de 100 caracteres.

**Imports**: Organizados con isort en tres grupos: librerías estándar, librerías de terceros, y módulos locales.

**Type hints**: Usamos type hints en todas las funciones y métodos para mejorar la legibilidad y detectar errores.

**Docstrings**: Todas las funciones públicas deben tener docstrings siguiendo el formato Google.

**Nombres**: Usamos snake_case para funciones y variables, PascalCase para clases, y UPPER_CASE para constantes.

### Ejemplo de código bien formateado

```python
from typing import List, Optional

from fastapi import HTTPException
from pydantic import BaseModel

from mcp_odoo.client import OdooClient


class PartnerCreate(BaseModel):
    """Modelo para crear un partner en Odoo."""
    
    name: str
    email: Optional[str] = None
    phone: Optional[str] = None


async def create_partner(
    client: OdooClient,
    partner_data: PartnerCreate
) -> int:
    """
    Crea un nuevo partner en Odoo.
    
    Args:
        client: Cliente de Odoo configurado
        partner_data: Datos del partner a crear
        
    Returns:
        ID del partner creado
        
    Raises:
        HTTPException: Si hay error en la creación
    """
    try:
        partner_id = await client.create('res.partner', partner_data.dict())
        return partner_id
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```

### Herramientas de calidad de código

Antes de hacer commit, ejecuta:

```bash
# Formateo automático
black .
isort .

# Linting
flake8 .

# Type checking
mypy .
```

## Convenciones de Commits

Seguimos [Conventional Commits](https://www.conventionalcommits.org/) para mensajes de commit claros y consistentes.

### Formato

```
<tipo>(<ámbito>): <descripción>

[cuerpo opcional]

[footer opcional]
```

### Tipos de commit

- **feat**: Nueva funcionalidad
- **fix**: Corrección de bug
- **docs**: Cambios en documentación
- **style**: Cambios de formato (espacios, comas, etc.)
- **refactor**: Refactorización de código sin cambiar funcionalidad
- **perf**: Mejoras de rendimiento
- **test**: Añadir o modificar tests
- **chore**: Tareas de mantenimiento, dependencias, etc.
- **ci**: Cambios en CI/CD
- **build**: Cambios en sistema de build

### Ejemplos

```bash
feat(webhook): añadir reintentos exponenciales para webhooks fallidos

fix(auth): corregir validación de tokens expirados

docs(readme): actualizar instrucciones de instalación

refactor(client): simplificar lógica de conexión a Odoo

test(webhook): añadir tests para sistema de reintentos
```

### Breaking Changes

Si tu commit introduce cambios incompatibles, añade `BREAKING CHANGE:` en el footer:

```bash
feat(api): cambiar formato de respuesta de endpoints

BREAKING CHANGE: Los endpoints ahora devuelven objetos envueltos en { data: ... }
```

## Testing

Todos los cambios de código deben incluir tests apropiados.

### Ejecutar tests

```bash
# Todos los tests
pytest

# Con cobertura
pytest --cov=mcp_odoo --cov-report=html

# Tests específicos
pytest tests/test_webhook.py

# Tests con verbose
pytest -v
```

### Escribir tests

Los tests deben ser claros, independientes y reproducibles:

```python
import pytest
from mcp_odoo.webhook import WebhookRetry


@pytest.mark.asyncio
async def test_webhook_retry_exponential_backoff():
    """Test que el sistema de reintentos usa backoff exponencial."""
    retry = WebhookRetry(max_retries=3, base_delay=1)
    
    delays = [retry.get_delay(i) for i in range(3)]
    
    assert delays[0] == 1
    assert delays[1] == 2
    assert delays[2] == 4


@pytest.mark.asyncio
async def test_webhook_retry_max_attempts():
    """Test que se respeta el máximo de reintentos."""
    retry = WebhookRetry(max_retries=3)
    
    attempts = 0
    async for _ in retry:
        attempts += 1
    
    assert attempts == 3
```

### Cobertura mínima

Apuntamos a mantener una cobertura de código de al menos 80%. Los PRs que reduzcan significativamente la cobertura serán rechazados.

## Preguntas

Si tienes preguntas sobre cómo contribuir, no dudes en:

- Abrir un issue con la etiqueta "question"
- Contactar a los mantenedores del proyecto

¡Gracias por contribuir a ERP Invisible!
