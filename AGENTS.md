# AGENTS.md — Protocolo e Instrucciones para Agentes IA

Este proyecto es desarrollado conjuntamente utilizando distintos agentes de IA, principalmente **Google Antigravity** y **OpenAI Codex**.

GitHub es la **FUENTE OFICIAL** del estado del proyecto (rama `main`).

---

## 📌 REGLA PRINCIPAL

Antes de realizar cualquier modificación:

1. Ejecutar `git pull origin main`.
2. Revisar el estado actual del repositorio (`git status`).
3. Revisar los últimos commits (`git log`).
4. Leer `PROJECT_STATUS.md`.
5. Analizar el código existente antes de modificarlo.

**NO asumir que el último trabajo fue realizado por este mismo agente.** Otro agente puede haber trabajado anteriormente.

---

## ⚙️ REGLAS DE DESARROLLO

- **NO eliminar funcionalidades existentes** sin autorización.
- **NO rehacer código que ya funciona** sin una razón técnica clara.
- **NO cambiar la arquitectura del proyecto** innecesariamente.
- **NO sobrescribir cambios** realizados por otro agente.
- **Mantener compatibilidad** con el código existente y paridad de plataformas (**Flutter Web** y **Android Nativo**).
- **Investigar el origen de un error** antes de aplicar soluciones.
- **Realizar cambios pequeños y verificables** cuando sea posible.
- Después de cambios importantes, ejecutar las pruebas/build correspondientes (`flutter analyze`, `flutter build web`, etc.).
- Corregir errores introducidos antes de finalizar la sesión.

---

## 🐙 GIT Y FLUJO DE TRABAJO

### Antes de trabajar:
```bash
git pull origin main
```

### Al finalizar cada etapa o bloque estable:
1. Revisar cambios (`git status`, `git diff`).
2. Probar el proyecto (`flutter analyze` / `flutter build`).
3. Actualizar `PROJECT_STATUS.md` completando la sección de **ÚLTIMO HANDOFF**.
4. Crear un commit descriptivo:
   ```bash
   git add .
   git commit -m "tipo: descripción clara del cambio"
   git push origin main
   ```

Los commits deben explicar claramente qué se modificó (ej: `feat: ...`, `fix: ...`, `docs: ...`, `refactor: ...`).

---

## 🔄 TRABAJO ENTRE ANTIGRAVITY Y CODEX

Flujo esperado:

```
Antigravity
    ↓ trabaja
commit + push
    ↓
Codex
    ↓ git pull + analiza
continúa el trabajo
    ↓
commit + push
    ↓
Antigravity
    ↓ git pull + analiza
continúa el trabajo
```

Cada agente debe asumir que el agente anterior pudo modificar cualquier parte del proyecto. Por lo tanto, **SIEMPRE revisar Git y `PROJECT_STATUS.md` antes de continuar**.

---

## 🚫 PROHIBICIONES

- **NO** trabajar simultáneamente sobre la misma rama desde dos agentes.
- **NO** hacer `git push --force` salvo autorización explícita.
- **NO** borrar archivos o funcionalidades simplemente porque parezcan innecesarios.
- **NO** resetear el repositorio para solucionar conflictos sin revisar primero los cambios existentes.
- **NO** reemplazar implementaciones completas cuando el problema puede solucionarse con un cambio localizado.

---

## 🏗️ ARQUITECTURA Y TECNOLOGÍAS DEL PROYECTO

- **Framework:** Flutter (Dart 3.x)
- **Base de Datos Cloud:** Cloud Firestore (colecciones: `usuarios`, `rutinasProfesor`, `rutinasAsignadas`, `ejercicios`, `entrenamientosFinalizados`, `entrenamientosEnCurso`, `registrosPeso`)
- **Base de Datos Local / Caché:** Drift (SQLite)
- **Autenticación:** Firestore (`colección usuarios` con roles `profesor` y `alumno` + códigos de vinculación)
- **Alojamiento Multimedia:** Data URIs en base64 (< 800 KB) con fallback gratuito para medios grandes (ImgBB / FreeImage.host)
- **Web Hosting:** Firebase Hosting (`https://mi-entrenamiento-9f4a8.web.app`)

---

## 🤝 HANDOFF ENTRE AGENTES

Antes de finalizar una sesión, **actualizar obligatoriamente `PROJECT_STATUS.md`** indicando:
- Qué se terminó.
- Qué quedó funcionando.
- Qué está en desarrollo.
- Errores conocidos.
- Próximos pasos.
- Archivos importantes modificados.
- Pruebas realizadas.
- Último agente que trabajó.
- Commit correspondiente.

El siguiente agente debe leer ese archivo antes de iniciar su trabajo.
