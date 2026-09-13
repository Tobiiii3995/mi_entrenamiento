# 🤖 Protocolo y Reglas para Agentes de IA (AGENTS.md)

Este documento establece las reglas obligatorias para cualquier Agente de Inteligencia Artificial (Antigravity, Codex, etc.) o desarrollador que trabaje sobre este repositorio.

---

## 📌 Principios Fundamentales
1. **GitHub es la única fuente de la verdad:** La rama principal es `main`.
2. **Sincronización Obligatoria:**
   - **Antes de comenzar:** Ejecutar siempre `git status` y `git pull origin main`.
   - **Al finalizar cada tarea o bloque estable:** Ejecutar `git add .`, `git commit -m "..."` con mensaje descriptivo y `git push origin main`.
3. **No romper código existente:** No eliminar funcionalidades implementadas ni refactorizar sin una necesidad explícita del usuario.
4. **Paridad de Plataformas:** La aplicación funciona tanto en **Flutter Web** (desplegado en Firebase Hosting) como en **Android Nativo** (instalado vía APK). Cualquier cambio debe mantener compatibilidad en ambas plataformas.
5. **Actualizar Bitácora:** Actualizar siempre el archivo `PROJECT_STATUS.md` al finalizar cambios importantes.

---

## 🛠️ Comandos Esenciales para el Flujo de Trabajo

### 1. Iniciar Sesión / Relevo
```bash
git status
git pull origin main
flutter pub get
```

### 2. Verificación y Calidad
```bash
flutter analyze
```

### 3. Compilación y Despliegue Web
```bash
flutter build web
npx firebase-tools deploy --only hosting
```
> URL Web oficial: `https://mi-entrenamiento-9f4a8.web.app`

### 4. Compilación e Instalación Móvil (Android por USB)
Para verificar dispositivos conectados vía ADB:
```bash
flutter devices
```
Para compilar release APK:
```bash
flutter build apk --release
```
Para instalar directamente en el dispositivo conectado vía USB:
```bash
flutter install -d <DEVICE_ID>
# o mediante ADB:
adb install -r build/app/outputs/flutter-apk/app-release.apk
```

---

## 🏗️ Arquitectura y Tecnologías
- **Framework:** Flutter (Dart 3.x)
- **Base de Datos Cloud:** Cloud Firestore (colecciones: `usuarios`, `rutinasProfesor`, `rutinasAsignadas`, `ejercicios`, `entrenamientosFinalizados`, `entrenamientosEnCurso`, `registrosPeso`)
- **Base de Datos Local / Caché:** Drift (SQLite)
- **Autenticación:** Firestore (`colección usuarios` con roles `profesor` y `alumno`)
- **Alojamiento Multimedia:** Catbox.moe / FreeImage.host API (sin requerir tarjeta de crédito, soporte hasta 200MB)
- **Web Hosting:** Firebase Hosting (`mi-entrenamiento-9f4a8`)

---

## 📋 Checklist antes de cerrar turno
- [ ] ¿El código pasa `flutter analyze` sin errores críticos?
- [ ] ¿Se probó la compatibilidad Web y Android?
- [ ] ¿Se actualizó `PROJECT_STATUS.md`?
- [ ] ¿Se hizo `git commit` y `git push origin main`?
