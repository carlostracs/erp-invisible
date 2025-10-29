# Git Cheatsheet - ERP Invisible

Comandos Git útiles para el flujo de trabajo del proyecto.

## Configuración Inicial

```bash
# Clonar el repositorio
git clone https://github.com/carlostracs/erp-invisible.git
cd erp-invisible

# Configurar usuario (si no está configurado globalmente)
git config user.name "Tu Nombre"
git config user.email "tu@email.com"

# Ver configuración
git config --list
```

## Trabajo con Branches

### Crear Feature Branch

```bash
# Actualizar develop
git checkout develop
git pull origin develop

# Crear nueva feature
git checkout -b feature/nombre-descriptivo

# Ejemplo: feature para webhooks
git checkout -b feature/webhook-retry
```

### Crear Hotfix Branch

```bash
# Crear desde última release o desde main
git checkout -b hotfix/descripcion-bug v1.0.0
# o
git checkout -b hotfix/descripcion-bug main
```

### Listar y Cambiar Branches

```bash
# Listar branches locales
git branch

# Listar branches remotas
git branch -r

# Listar todas las branches
git branch -a

# Cambiar de branch
git checkout develop
git checkout main

# Crear y cambiar en un comando
git checkout -b nueva-branch
```

### Eliminar Branches

```bash
# Eliminar branch local (después de merge)
git branch -d feature/nombre-feature

# Forzar eliminación (si no está mergeada)
git branch -D feature/nombre-feature

# Eliminar branch remota
git push origin --delete feature/nombre-feature
```

## Commits

### Hacer Commits

```bash
# Ver estado de archivos
git status

# Añadir archivos específicos
git add archivo.py
git add carpeta/

# Añadir todos los cambios
git add .

# Commit con mensaje
git commit -m "feat(webhook): añadir sistema de reintentos"

# Commit con mensaje multi-línea
git commit -m "feat(webhook): añadir sistema de reintentos

- Implementar backoff exponencial
- Añadir configuración de max_retries
- Logging de intentos fallidos"

# Añadir y commit en un comando (solo archivos ya trackeados)
git commit -am "fix(auth): corregir validación de tokens"
```

### Modificar Commits

```bash
# Modificar el último commit (antes de push)
git commit --amend -m "Nuevo mensaje"

# Añadir cambios al último commit
git add archivo-olvidado.py
git commit --amend --no-edit

# Ver historial de commits
git log
git log --oneline
git log --oneline --graph --all
```

## Sincronización con Remoto

### Pull y Push

```bash
# Actualizar branch actual
git pull

# Actualizar branch específica
git pull origin develop

# Push de branch
git push

# Push de nueva branch
git push -u origin feature/nueva-feature

# Push forzado (¡CUIDADO! Solo en branches personales)
git push --force-with-lease
```

### Fetch

```bash
# Descargar cambios sin merge
git fetch origin

# Ver diferencias con remoto
git fetch origin
git diff origin/develop

# Actualizar referencias de branches remotas
git remote update origin --prune
```

## Tags y Releases

### Crear Tags

```bash
# Tag anotado (recomendado para releases)
git tag -a v1.0.0 -m "Release v1.0.0: Primera versión estable"

# Tag ligero
git tag v1.0.0

# Listar tags
git tag
git tag -l "v1.*"

# Ver información de un tag
git show v1.0.0

# Push de tag específico
git push origin v1.0.0

# Push de todos los tags
git push origin --tags
```

### Eliminar Tags

```bash
# Eliminar tag local
git tag -d v1.0.0

# Eliminar tag remoto
git push origin --delete v1.0.0
```

### Checkout de Tags

```bash
# Ver código de una versión específica
git checkout v1.0.0

# Crear branch desde un tag
git checkout -b hotfix/fix-critico v1.0.0
```

## Merge y Rebase

### Merge

```bash
# Merge de feature a develop
git checkout develop
git pull origin develop
git merge feature/mi-feature

# Merge con mensaje personalizado
git merge feature/mi-feature -m "Merge feature: sistema de webhooks"

# Abortar merge en caso de conflictos
git merge --abort
```

### Resolver Conflictos

```bash
# Ver archivos con conflictos
git status

# Después de resolver manualmente los conflictos
git add archivo-resuelto.py
git commit -m "Resolver conflictos de merge"

# Usar herramienta de merge
git mergetool
```

### Rebase

```bash
# Rebase de feature sobre develop actualizado
git checkout feature/mi-feature
git rebase develop

# Continuar rebase después de resolver conflictos
git add archivo-resuelto.py
git rebase --continue

# Abortar rebase
git rebase --abort

# Rebase interactivo (para limpiar historial)
git rebase -i HEAD~3
```

## Revert y Reset

### Revert (Recomendado para branches compartidas)

```bash
# Revertir un commit específico
git revert <hash-del-commit>

# Revertir un merge commit
git revert -m 1 <hash-del-merge>

# Revertir múltiples commits
git revert <hash-antiguo>..<hash-reciente>
```

### Reset (Solo para branches locales)

```bash
# Reset suave (mantiene cambios en staging)
git reset --soft HEAD~1

# Reset mixto (mantiene cambios sin staging)
git reset HEAD~1

# Reset duro (ELIMINA cambios)
git reset --hard HEAD~1

# Volver a un commit específico
git reset --hard <hash-del-commit>

# Deshacer reset (si no has hecho más cambios)
git reflog
git reset --hard HEAD@{1}
```

## Cherry-pick

```bash
# Aplicar un commit específico a la branch actual
git cherry-pick <hash-del-commit>

# Cherry-pick sin commit automático
git cherry-pick -n <hash-del-commit>

# Cherry-pick de múltiples commits
git cherry-pick <hash1> <hash2> <hash3>

# Abortar cherry-pick
git cherry-pick --abort
```

## Stash (Guardar Cambios Temporalmente)

```bash
# Guardar cambios actuales
git stash

# Guardar con mensaje descriptivo
git stash save "WIP: implementando webhook retry"

# Listar stashes
git stash list

# Aplicar último stash
git stash pop

# Aplicar stash específico
git stash apply stash@{0}

# Ver contenido de stash
git stash show -p stash@{0}

# Eliminar stash
git stash drop stash@{0}

# Limpiar todos los stashes
git stash clear
```

## Inspección y Comparación

### Diff

```bash
# Ver cambios no staged
git diff

# Ver cambios staged
git diff --staged

# Comparar branches
git diff develop..feature/mi-feature

# Comparar con remoto
git diff origin/develop

# Ver cambios en archivo específico
git diff archivo.py
```

### Log

```bash
# Log básico
git log

# Log compacto
git log --oneline

# Log con gráfico
git log --oneline --graph --all

# Log de un archivo específico
git log -- archivo.py

# Log con búsqueda
git log --grep="webhook"

# Log de autor específico
git log --author="Carlos"

# Log entre fechas
git log --since="2025-01-01" --until="2025-01-31"

# Ver cambios de un commit
git show <hash-del-commit>
```

### Blame (Ver quién modificó cada línea)

```bash
# Ver autoría de líneas
git blame archivo.py

# Con rango de líneas
git blame -L 10,20 archivo.py
```

## Limpieza

```bash
# Eliminar archivos no trackeados
git clean -n  # Preview
git clean -f  # Ejecutar

# Eliminar archivos y directorios no trackeados
git clean -fd

# Eliminar branches mergeadas
git branch --merged | grep -v "\*" | xargs -n 1 git branch -d

# Optimizar repositorio
git gc
git prune
```

## Configuración Útil

```bash
# Alias útiles
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.lg "log --oneline --graph --all"

# Configurar editor
git config --global core.editor "vim"

# Configurar colores
git config --global color.ui auto

# Configurar pull con rebase por defecto
git config --global pull.rebase true

# Guardar credenciales (cuidado en máquinas compartidas)
git config --global credential.helper cache
```

## Flujo de Trabajo Completo

### Desarrollar Nueva Feature

```bash
# 1. Actualizar develop
git checkout develop
git pull origin develop

# 2. Crear branch de feature
git checkout -b feature/nueva-funcionalidad

# 3. Desarrollar y hacer commits
git add .
git commit -m "feat(modulo): descripción del cambio"

# 4. Push de la branch
git push -u origin feature/nueva-funcionalidad

# 5. Crear Pull Request en GitHub hacia develop

# 6. Después del merge, actualizar local y limpiar
git checkout develop
git pull origin develop
git branch -d feature/nueva-funcionalidad
```

### Crear Release

```bash
# 1. Asegurar que develop está listo
git checkout develop
git pull origin develop

# 2. Merge a main
git checkout main
git pull origin main
git merge develop

# 3. Crear tag
git tag -a v1.1.0 -m "Release v1.1.0: descripción"

# 4. Push
git push origin main
git push origin v1.1.0

# 5. Merge de vuelta a develop
git checkout develop
git merge main
git push origin develop
```

### Hotfix Urgente

```bash
# 1. Crear hotfix desde última release
git checkout -b hotfix/bug-critico v1.0.0

# 2. Corregir y commit
git commit -am "fix(critical): descripción del fix"

# 3. Merge a main
git checkout main
git merge hotfix/bug-critico

# 4. Tag de patch
git tag -a v1.0.1 -m "Hotfix v1.0.1: descripción"
git push origin main
git push origin v1.0.1

# 5. Merge a develop
git checkout develop
git merge hotfix/bug-critico
git push origin develop

# 6. Limpiar
git branch -d hotfix/bug-critico
```

## Troubleshooting

### Deshacer cambios locales

```bash
# Descartar cambios en archivo específico
git checkout -- archivo.py

# Descartar todos los cambios no staged
git checkout .

# Descartar cambios staged
git reset HEAD archivo.py
```

### Recuperar commits perdidos

```bash
# Ver historial de referencias
git reflog

# Recuperar commit
git checkout <hash-del-commit>
git checkout -b recuperar-cambios
```

### Sincronizar fork

```bash
# Añadir upstream (una vez)
git remote add upstream https://github.com/carlostracs/erp-invisible.git

# Actualizar desde upstream
git fetch upstream
git checkout develop
git merge upstream/develop
git push origin develop
```

## Referencias Rápidas

### Conventional Commits

```
feat(scope): descripción corta
fix(scope): descripción corta
docs(scope): descripción corta
style(scope): descripción corta
refactor(scope): descripción corta
test(scope): descripción corta
chore(scope): descripción corta
```

### Estados de Git

- **Working Directory**: Cambios no staged
- **Staging Area**: Cambios staged (con `git add`)
- **Repository**: Cambios committed
- **Remote**: Cambios pushed al servidor

### Comandos de Emergencia

```bash
# "¡Ayuda! Rompí todo"
git reflog  # Ver historial completo
git reset --hard HEAD@{1}  # Volver al estado anterior

# "Necesito deshacer el último push"
git revert HEAD
git push origin develop

# "Hice commit en la branch equivocada"
git log  # Copiar hash del commit
git checkout branch-correcta
git cherry-pick <hash>
git checkout branch-incorrecta
git reset --hard HEAD~1
```
