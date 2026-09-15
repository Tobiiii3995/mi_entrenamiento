# PROJECT STATUS

## Estado general

Proyecto desarrollado mediante colaboración entre **Google Antigravity** y **OpenAI Codex**.

GitHub representa el estado oficial del proyecto:
- **Repositorio:** [https://github.com/Tobiiii3995/mi_entrenamiento.git](https://github.com/Tobiiii3995/mi_entrenamiento.git) (Rama: `main`)
- **Despliegue Web:** [https://mi-entrenamiento-9f4a8.web.app](https://mi-entrenamiento-9f4a8.web.app)
- **Firebase Project ID:** `mi-entrenamiento-9f4a8`

---

## TERMINADO

### 1. Autenticación y Perfiles
- Roles diferenciados: **Profesor** y **Alumno**.
- Sistema de vinculación por código entre Alumno y Profesor.
- Gestión de perfil de usuario y cambio de rol.

### 2. Gestión de Rutinas y Ejercicios (Profesor)
- Creación, edición y eliminación de ejercicios en catálogo.
- Configuración avanzada por ejercicio: series y repeticiones personalizadas por serie (ej: Serie 1 = 12 reps, Serie 2 = 10 reps).
- Asignación de rutinas por día para cada alumno vinculado.
- Seguimiento en vivo del progreso de los alumnos y rutinas finalizadas.

### 3. Rutinas y Entrenamiento en Vivo (Alumno)
- Vista de rutinas asignadas por día de la semana.
- Modo entrenamiento activo: cronómetro, marcado de series completadas, registro de pesos utilizados (kg).
- Finalización de entrenamiento con sincronización automática a Firestore y guardado de historial local y remoto.

### 4. Demostraciones Multimedia (GIF / Videos / Enlaces)
- Soporte para subida local y procesamiento automático.
- Codificación instantánea como Data URI (< 800 KB) para GIFs cortos e imágenes (0ms, 100% inmune a CORS).
- Visualizador ampliado con modal interactivo, botón Maximizar a pantalla completa y soporte de Zoom táctil / PC (`InteractiveViewer`).
- Soporte para enlaces externos y videos de YouTube.

### 5. Multiplataforma y Despliegue
- Flutter Web configurado y desplegado en Firebase Hosting (`mi-entrenamiento-9f4a8.web.app`).
- Configuración para compilación Android APK.

---

## EN DESARROLLO

- Robustez en el servicio de subida de archivos multimedia grandes (> 800 KB): manejo resiliente ante respuestas no JSON (XML/HTML de error de Cloudflare o APIs externas) con proveedores de respaldo y mensajes claros al usuario.

---

## ERRORES CONOCIDOS

1. **Error al procesar respuestas XML/HTML al subir archivos multimedia grandes (> 800 KB):**
   - **Comportamiento esperado:** Al subir un archivo de demostración pesado (> 800 KB), el servicio debe subirlo a la API externa y parsear la URL resultante sin caer en FormatException si la API responde con HTML/XML de error.
   - **Comportamiento actual:** Si el proveedor externo (ImgBB o FreeImage) responde con una página HTML de bloqueo/Cloudflare o XML de error en lugar de JSON, `jsonDecode` lanza excepción no controlada.
   - **Archivos relacionados:** `lib/servicios/almacenamiento_servicio.dart`.
   - **Pruebas ya realizadas:** Para archivos <= 800 KB, el guardado directo en Data URI base64 funciona al 100%. Falta blindar la subida externa para archivos pesados o videos MP4.

---

## PRÓXIMOS PASOS

1. Implementar parsing seguro y fallback robusto en `AlmacenamientoServicio` para que capture y maneje respuestas no JSON adecuadamente.
2. Validar el flujo completo de entrenamiento: creación de rutina por profesor con demostración -> asignación -> realización por alumno.
3. Asegurar entorno local de desarrollo (Flutter SDK en PATH) para compilar y desplegar con `flutter build web` y `npx firebase-tools deploy`.

---

## ÚLTIMO HANDOFF

**Agente:** Antigravity  
**Fecha:** 2026-09-15  
**Último commit:** `e5a0a8c`

### Trabajo realizado
- Sincronización del repositorio con `git pull` y verificación de remotos.
- Actualización de `AGENTS.md` y `PROJECT_STATUS.md` al nuevo estándar de colaboración bidireccional entre Antigravity y OpenAI Codex.
- Documentación del estado del motor de almacenamiento y visualizador multimedia.

### Archivos modificados
- `AGENTS.md`
- `PROJECT_STATUS.md`

### Pruebas realizadas
- Verificación del árbol de trabajo de Git (`git status`, `git log`, `git pull origin main`).
- Inspección del servicio de almacenamiento multimedia y widgets de demostración.

### Pendiente
- Blindaje de `AlmacenamientoServicio` ante respuestas XML/HTML en subidas externas.
- Ejecutar despliegue y validación una vez que el SDK de Flutter esté disponible en la consola local si se desean builds locales.
