# Multi-stage build para optimizar tamaño de imagen
FROM python:3.11-slim as builder

# Variables de entorno para Python
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Directorio de trabajo
WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copiar requirements y instalar dependencias
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Etapa final
FROM python:3.11-slim

# Variables de entorno
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH=/root/.local/bin:$PATH

# Crear usuario no-root
RUN useradd -m -u 1000 mcp && \
    mkdir -p /app/logs && \
    chown -R mcp:mcp /app

# Directorio de trabajo
WORKDIR /app

# Copiar dependencias desde builder
COPY --from=builder --chown=mcp:mcp /root/.local /home/mcp/.local

# Copiar código de la aplicación
COPY --chown=mcp:mcp . .

# Cambiar a usuario no-root
USER mcp

# Exponer puerto
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/health')" || exit 1

# Comando de inicio
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
