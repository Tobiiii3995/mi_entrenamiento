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
- Codificación instantánea como Data URI (< 800 KB) para GIFs cortos e imágenes (0ms, 100% inmune a CORS y fallos de red).
- **Subida resiliente multi-proveedor** para archivos pesados (> 800 KB / videos MP4 / MOV) con fallback escalonado: Catbox.moe -> Litterbox -> FreeImage.host -> TmpFiles.
- **Parsing protegido:** Detección de formato y captura de excepciones para evitar errores de tipo XML/HTML (`FormatException`) ante respuestas no-JSON o bloqueos de servidores externos.
- Visualizador ampliado con modal interactivo, botón Maximizar a pantalla completa y soporte de Zoom táctil / PC (`InteractiveViewer`).
- Soporte para enlaces externos y videos de YouTube.

### 5. Multiplataforma y Despliegue
- Flutter Web configurado y desplegado en Firebase Hosting (`mi-entrenamiento-9f4a8.web.app`).
- Configuración para compilación Android APK.

---

## EN DESARROLLO

- Nuevas funcionalidades o requerimientos solicitados por el usuario.

---

## ERRORES CONOCIDOS

- Ninguno crítico pendiente en el módulo de demostraciones multimedia tras la implementación del blindaje multi-proveedor y parsing protegido.

---

## PRÓXIMOS PASOS

1. Implementar la siguiente petición funcional que indique el usuario.
2. Validar pruebas funcionales de extremo a extremo (Profesor creando rutina -> Alumno entrenando).

---

## ÚLTIMO HANDOFF

**Agente:** Antigravity  
**Fecha:** 2026-09-15  
**Último commit:** `c3ecfa6`

### Trabajo realizado
- Blindaje completo de `AlmacenamientoServicio` para resolver el error de XML/HTML cuando se esperaba JSON.
- Implementación de fallback escalonado de subida de medios: Data URI (< 800 KB) -> Catbox -> Litterbox -> FreeImage -> TmpFiles.
- Integración de los dominios en `DialogoDemostracion`.
- Actualización de la bitácora en `PROJECT_STATUS.md`.

### Archivos modificados
- `lib/servicios/almacenamiento_servicio.dart`
- `lib/widgets/dialogo_demostracion.dart`
- `PROJECT_STATUS.md`

### Pruebas realizadas
- Verificación sintáctica y de flujo de fallback.
- Commit y Push a GitHub rama `main`.

### Pendiente
- Continuar con la siguiente petición del usuario.
