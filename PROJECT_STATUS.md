# 📊 Estado Actual del Proyecto (PROJECT_STATUS.md)

**Proyecto:** Mi Entrenamiento (App de Gestión de Rutinas y Seguimiento de Alumnos)  
**Repositorio GitHub:** [https://github.com/Tobiiii3995/mi_entrenamiento.git](https://github.com/Tobiiii3995/mi_entrenamiento.git) (Rama: `main`)  
**Despliegue Web:** [https://mi-entrenamiento-9f4a8.web.app](https://mi-entrenamiento-9f4a8.web.app)  
**Firebase Project ID:** `mi-entrenamiento-9f4a8`  

---

## 🟢 Funcionalidades Implementadas y Terminadas

### 1. Perfiles y Autenticación
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
- Finalización de entrenamiento con sincronización automática a Firestore y guardado de historial.

### 4. Demostraciones Multimedia (GIF / Videos / Enlaces)
- **Subida Gratuita Local:** Botón *"Subir GIF / Video local"* disponible tanto en Web como en Android.
  - Sube automáticamente a servidores de medios gratuitos (**Catbox.moe** con fallback a **FreeImage.host**) sin requerir tarjeta de crédito ni plan de pago en Firebase.
  - Genera automáticamente el enlace directo y lo inserta en el ejercicio.
  - Acepta archivos `.gif`, `.mp4`, `.mov`, `.webp`, `.png`, `.jpg` de hasta **200 MB**.
- **Visualizador Ampliado y Pantalla Completa:**
  - Modal interactivo *"Ver demostración"*.
  - Botón **"Maximizar"** con vista en pantalla completa y soporte de **Zoom interactivo** (pellizco táctil en celular / scroll y doble clic en PC).
  - Soporte para videos de YouTube y enlaces externos con botón seguro de apertura en nueva pestaña (`_blank`).

### 5. Multiplataforma y Despliegue
- **Web (PWA):** Compilado y desplegado en Firebase Hosting.
- **Android (.APK):** Compilación lista para instalación directa por USB (`build/app/outputs/flutter-apk/app-release.apk`).

---

## 🟡 Estado de la Última Sesión
- **Motor de Subida:** Implementado con procesamiento ultra rápido como Data URI (< 800 KB) inmune a CORS y conexión, más fallback en la nube para archivos pesados.
- **Visualizador:** Implementado con pantalla completa interactiva, zoom táctil/PC y soporte para Data URIs e imágenes en memoria.
- **Repositorio y Despliegue:** 100% sincronizado en GitHub (`main`) y desplegado en Firebase Hosting.

---

## 🎯 Próximos Pasos Sugeridos
1. Probar en la Web (`https://mi-entrenamiento-9f4a8.web.app`) la creación de un ejercicio subiendo un archivo GIF o video local y verificar la vista previa en pantalla completa.
2. Probar la realización de una rutina desde la cuenta de Alumno y confirmar la visualización de la demostración.
3. Si se desea instalar en el celular por USB, ejecutar `flutter install -d <DEVICE_ID>` o `adb install -r build/app/outputs/flutter-apk/app-release.apk` asegurándose de aceptar el permiso en la pantalla del dispositivo.
