import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

import 'paginas/completar_perfil_pagina.dart';
import 'paginas/login_pagina.dart';
import 'paginas/perfil_pagina.dart';
import 'paginas/progreso_pagina.dart';
import 'paginas/rutinas_pagina.dart';
import 'paginas/verificar_correo_pagina.dart';
import 'paginas/profesor/panel_profesor_pagina.dart';

import 'servicios/inicializacion_app_servicio.dart';
import 'servicios/entrenamientos_pendientes_servicio.dart';
import 'servicios/usuario_firestore_servicio.dart';
import 'servicios/validacion_diaria_servicio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const MiEntrenamientoApp(),
  );
}

class MiEntrenamientoApp extends StatelessWidget {
  const MiEntrenamientoApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
  debugShowCheckedModeBanner: false,
  title: 'Mi Entrenamiento',

  locale: const Locale('es', 'UY'),

  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],

  supportedLocales: const [
    Locale('es', 'UY'),
    Locale('es'),
  ],

  theme: ThemeData(
    useMaterial3: true,
    colorSchemeSeed: Colors.blueGrey,
  ),

  home: const PuertaAutenticacion(),
);
  }
}

class PuertaAutenticacion extends StatefulWidget {
  const PuertaAutenticacion({
    super.key,
  });

  @override
  State<PuertaAutenticacion> createState() =>
      _PuertaAutenticacionState();
}

class _PuertaAutenticacionState
    extends State<PuertaAutenticacion> {
  String? uidPreparado;

  Future<Map<String, dynamic>>? preparacionUsuario;

  Future<Map<String, dynamic>> prepararUsuario(
    User usuario,
  ) async {
    final datos =
        await UsuarioFirestoreServicio
            .asegurarYObtenerUsuarioActual();

    final rol =
        (datos['rol'] ?? 'alumno')
            .toString()
            .trim()
            .toLowerCase();

    final activo =
        datos['activo'] == true;

    if (!activo) {
      throw Exception(
        'La cuenta está desactivada.',
      );
    }

    final perfilCompleto =
        datos['perfilCompleto'] == true;

    // Solo cargamos datos locales si:
    // 1. el correo ya está verificado
    // 2. el perfil ya está completo
    if (usuario.emailVerified &&
        perfilCompleto) {
      final correo =
          (datos['correo'] ??
                  usuario.email ??
                  '')
              .toString();

      final nombre =
          (datos['nombre'] ?? '')
              .toString()
              .trim();

      await InicializacionAppServicio
          .cargarDatosLocales(
        usuarioId: usuario.uid,
        correo: correo,
        rol: rol,
        nombre: nombre,
        datosFirestore: datos,
      );

      if (rol == 'alumno') {
        await EntrenamientosPendientesServicio
            .finalizarPendientesDeDiasAnteriores(
          alumnoId: usuario.uid,
        );
      }
    }

    return datos;
  }

  void recargarUsuario(
    User usuario,
  ) {
    setState(() {
      preparacionUsuario =
          prepararUsuario(
        usuario,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream:
          FirebaseAuth.instance.userChanges(),
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text(
                'Ocurrió un error al iniciar la aplicación.',
              ),
            ),
          );
        }

        final usuario =
            snapshot.data;

        if (usuario == null) {
          uidPreparado = null;
          preparacionUsuario =
              null;

          return const LoginPagina();
        }

        if (uidPreparado !=
                usuario.uid ||
            preparacionUsuario ==
                null) {
          uidPreparado =
              usuario.uid;

          preparacionUsuario =
              prepararUsuario(
            usuario,
          );
        }

        return FutureBuilder<
            Map<String, dynamic>>(
          future:
              preparacionUsuario,
          builder: (
            context,
            snapshotPreparacion,
          ) {
            if (snapshotPreparacion
                    .connectionState !=
                ConnectionState.done) {
              return const Scaffold(
                body: Center(
                  child:
                      CircularProgressIndicator(),
                ),
              );
            }

            if (snapshotPreparacion
                .hasError) {
              return Scaffold(
                body: Center(
                  child: Padding(
                    padding:
                        const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.cloud_off_outlined,
                          size: 56,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          '${snapshotPreparacion.error}',
                          textAlign:
                              TextAlign.center,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        FilledButton(
                          onPressed: () {
                            recargarUsuario(
                              usuario,
                            );
                          },
                          child:
                              const Text(
                            'Reintentar',
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextButton(
                          onPressed:
                              () async {
                            await ValidacionDiariaServicio
                                .limpiarValidacion();

                            await FirebaseAuth
                                .instance
                                .signOut();
                          },
                          child:
                              const Text(
                            'Cerrar sesión',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final datos =
                snapshotPreparacion
                    .data!;

            // =========================
            // 1. CORREO SIN VERIFICAR
            // =========================

            if (!usuario.emailVerified) {
              return VerificarCorreoPagina(
                onVerificado: () async {
                  final actual =
                      FirebaseAuth
                          .instance
                          .currentUser;

                  if (actual == null) {
                    return;
                  }

                  await actual.reload();

                  final actualizado =
                      FirebaseAuth
                          .instance
                          .currentUser;

                  if (actualizado != null) {
                    recargarUsuario(
                      actualizado,
                    );
                  }
                },
              );
            }

            // =========================
            // 2. PERFIL INCOMPLETO
            // =========================

            final perfilCompleto =
                datos[
                        'perfilCompleto'] ==
                    true;

            if (!perfilCompleto) {
              return CompletarPerfilPagina(
                onCompletado: () {
                  final actual =
                      FirebaseAuth
                          .instance
                          .currentUser;

                  if (actual != null) {
                    recargarUsuario(
                      actual,
                    );
                  }
                },
              );
            }

            // =========================
            // 3. APP NORMAL
            // =========================

            final rol =
                (datos['rol'] ??
                        'alumno')
                    .toString()
                    .trim()
                    .toLowerCase();

            return PantallaPrincipal(
              rol: rol,
            );
          },
        );
      },
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  final String rol;

  const PantallaPrincipal({
    super.key,
    required this.rol,
  });

  @override
  State<PantallaPrincipal> createState() =>
      _PantallaPrincipalState();
}

class _PantallaPrincipalState
    extends State<PantallaPrincipal> {
  int paginaActual = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final mensaje =
            EntrenamientosPendientesServicio
                .consumirMensaje();

        if (!mounted || mensaje == null) {
          return;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              mensaje,
            ),
          ),
        );
      },
    );
  }

  bool get esProfesor =>
      widget.rol == 'profesor';

  List<Widget> get paginas {
    final lista = <Widget>[
      const PerfilPagina(),
      const RutinasPagina(),
      const ProgresoPagina(),
    ];

    if (esProfesor) {
      lista.add(
        const PanelProfesorPagina(),
      );
    }

    return lista;
  }

  List<NavigationDestination>
      get destinos {
    final lista =
        <NavigationDestination>[
      const NavigationDestination(
        icon: Icon(
          Icons.person_outline,
        ),
        selectedIcon: Icon(
          Icons.person,
        ),
        label: 'Perfil',
      ),
      const NavigationDestination(
        icon: Icon(
          Icons.fitness_center_outlined,
        ),
        selectedIcon: Icon(
          Icons.fitness_center,
        ),
        label: 'Rutinas',
      ),
      const NavigationDestination(
        icon: Icon(
          Icons.show_chart,
        ),
        selectedIcon: Icon(
          Icons.trending_up,
        ),
        label: 'Progreso',
      ),
    ];

    if (esProfesor) {
      lista.add(
        const NavigationDestination(
          icon: Icon(
            Icons
                .admin_panel_settings_outlined,
          ),
          selectedIcon: Icon(
            Icons.admin_panel_settings,
          ),
          label: 'Profesor',
        ),
      );
    }

    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: paginaActual,
        children: paginas,
      ),
      bottomNavigationBar:
          NavigationBar(
        selectedIndex:
            paginaActual,
        onDestinationSelected:
            (index) {
          setState(() {
            paginaActual =
                index;
          });
        },
        destinations:
            destinos,
      ),
    );
  }
}