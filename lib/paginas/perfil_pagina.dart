import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../servicios/datos_app.dart';
import '../servicios/sesion_local_servicio.dart';
import '../servicios/vinculacion_firestore_servicio.dart';
import '../widgets/avatar_usuario.dart';
import '../widgets/perfil_dato.dart';
import 'cuenta_seguridad_pagina.dart';
import 'editar_perfil_pagina.dart';

class PerfilPagina extends StatefulWidget {
  const PerfilPagina({
    super.key,
  });

  @override
  State<PerfilPagina> createState() =>
      _PerfilPaginaState();
}

class _PerfilPaginaState
    extends State<PerfilPagina> {
  bool volviendoUsuario = false;
  bool cerrandoSesion = false;

  bool cargandoCodigo = false;

  String? codigoVinculacion;
  String? errorCodigo;

  String? solicitudProcesandoId;

  bool desvinculandoProfesor = false;

  bool intentandoGenerarCodigoAutomaticamente =
      false;

  @override
  void initState() {
    super.initState();

    if (DatosApp.usuarioActual.rol ==
        'alumno') {
      prepararVinculacionAlumno();
    }
  }

  Future<void>
      prepararVinculacionAlumno() async {
    try {
      await VinculacionFirestoreServicio
          .asegurarVinculoLegacyAlumno();

      final usuario =
          FirebaseAuth.instance.currentUser;

      if (usuario == null) {
        return;
      }

      final tieneProfesor =
          await VinculacionFirestoreServicio
              .tieneProfesorActivo(
        usuario.uid,
      );

      if (!tieneProfesor) {
        await cargarCodigoVinculacion();
      }
    } catch (_) {
      // Los widgets individuales
      // mostrarán el estado correspondiente.
    }
  }

  Future<void>
      generarCodigoSiHaceFalta() async {
    if (intentandoGenerarCodigoAutomaticamente) {
      return;
    }

    if (codigoVinculacion != null &&
        codigoVinculacion!.trim().isNotEmpty) {
      return;
    }

    if (cargandoCodigo) {
      return;
    }

    intentandoGenerarCodigoAutomaticamente =
        true;

    try {
      await cargarCodigoVinculacion();
    } finally {
      intentandoGenerarCodigoAutomaticamente =
          false;
    }
  }

  Future<void>
      cargarCodigoVinculacion() async {
    if (cargandoCodigo) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      cargandoCodigo = true;
      errorCodigo = null;
    });

    try {
      final codigo =
          await VinculacionFirestoreServicio
              .obtenerOCrearCodigoAlumno();

      if (!mounted) {
        return;
      }

      setState(() {
        codigoVinculacion =
            codigo;
        errorCodigo =
            null;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      final texto =
          e.toString();

      if (texto.contains(
        'Ya tenés un profesor vinculado',
      )) {
        setState(() {
          errorCodigo =
              null;
          codigoVinculacion =
              null;
        });

        return;
      }

      setState(() {
        errorCodigo =
            'No se pudo obtener el código.';
      });
    } finally {
      if (mounted) {
        setState(() {
          cargandoCodigo =
              false;
        });
      }
    }
  }

  Future<void> copiarCodigo() async {
    final codigo =
        codigoVinculacion;

    if (codigo == null ||
        codigo.trim().isEmpty) {
      return;
    }

    await Clipboard.setData(
      ClipboardData(
        text: codigo,
      ),
    );

    if (!mounted) {
      return;
    }

    mostrarMensaje(
      'Código copiado.',
    );
  }

  void mostrarMensaje(
    String mensaje,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
        ),
      ),
    );
  }

  Future<void> aceptarSolicitud(
    SolicitudVinculacion solicitud,
  ) async {
    if (solicitudProcesandoId != null) {
      return;
    }

    final confirmar =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Aceptar profesor',
          ),
          content: Text(
            '¿Querés vincularte con '
            '${solicitud.profesorNombre} '
            'como tu profesor/a?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancelar',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Aceptar',
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    setState(() {
      solicitudProcesandoId =
          solicitud.id;
    });

    try {
      await VinculacionFirestoreServicio
          .aceptarSolicitud(
        solicitud,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        codigoVinculacion =
            null;
        errorCodigo =
            null;
      });

      mostrarMensaje(
        'Profesor vinculado correctamente.',
      );
    } catch (e) {
      var mensaje =
          e.toString();

      mensaje =
          mensaje.replaceFirst(
        'Exception: ',
        '',
      );

      mostrarMensaje(
        mensaje,
      );
    } finally {
      if (mounted) {
        setState(() {
          solicitudProcesandoId =
              null;
        });
      }
    }
  }

  Future<void> rechazarSolicitud(
    SolicitudVinculacion solicitud,
  ) async {
    if (solicitudProcesandoId != null) {
      return;
    }

    final confirmar =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Rechazar solicitud',
          ),
          content: Text(
            '¿Querés rechazar la solicitud de '
            '${solicitud.profesorNombre}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancelar',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Rechazar',
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    setState(() {
      solicitudProcesandoId =
          solicitud.id;
    });

    try {
      await VinculacionFirestoreServicio
          .rechazarSolicitud(
        solicitud,
      );

      mostrarMensaje(
        'Solicitud rechazada.',
      );
    } catch (e) {
      var mensaje =
          e.toString();

      mensaje =
          mensaje.replaceFirst(
        'Exception: ',
        '',
      );

      mostrarMensaje(
        mensaje,
      );
    } finally {
      if (mounted) {
        setState(() {
          solicitudProcesandoId =
              null;
        });
      }
    }
  }

  Future<void> desvincularProfesor(
    VinculoProfesor vinculo,
  ) async {
    if (desvinculandoProfesor) {
      return;
    }

    final confirmar =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Desvincular profesor',
          ),
          content: Text(
            '¿Querés dejar de estar vinculado/a con '
            '${vinculo.profesorNombre}?\n\n'
            'Después podrás vincularte con otro profesor.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancelar',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Desvincular',
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    setState(() {
      desvinculandoProfesor =
          true;
    });

    try {
      final nuevoCodigo =
          await VinculacionFirestoreServicio
              .desvincularProfesor(
        vinculo,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        codigoVinculacion =
            nuevoCodigo;
        errorCodigo =
            null;
      });

      mostrarMensaje(
        'Te desvinculaste del profesor. '
        'Ya podés vincularte con otro.',
      );
    } catch (e) {
      var mensaje =
          e.toString();

      mensaje =
          mensaje.replaceFirst(
        'Exception: ',
        '',
      );

      mostrarMensaje(
        mensaje,
      );
    } finally {
      if (mounted) {
        setState(() {
          desvinculandoProfesor =
              false;
        });
      }
    }
  }

  Future<void>
      volverAlProfesor() async {
    if (volviendoUsuario) {
      return;
    }

    setState(() {
      volviendoUsuario =
          true;
    });

    final correcto =
        await SesionLocalServicio
            .volverAlUsuarioAnterior();

    if (!mounted) {
      return;
    }

    if (!correcto) {
      setState(() {
        volviendoUsuario =
            false;
      });

      mostrarMensaje(
        'No se pudo volver al usuario anterior.',
      );

      return;
    }

    setState(() {
      volviendoUsuario =
          false;
    });

    mostrarMensaje(
      'Volviste al usuario de prueba principal.',
    );
  }

  Future<void> cerrarSesion() async {
    if (cerrandoSesion) {
      return;
    }

    final confirmar =
        await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Cerrar sesión',
          ),
          content: const Text(
            '¿Querés cerrar tu sesión actual?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text(
                'Cancelar',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Cerrar sesión',
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    setState(() {
      cerrandoSesion =
          true;
    });

    try {
      await FirebaseAuth.instance
          .signOut();
    } on FirebaseAuthException {
      mostrarMensaje(
        'No se pudo cerrar la sesión.',
      );
    } catch (_) {
      mostrarMensaje(
        'Ocurrió un error al cerrar la sesión.',
      );
    } finally {
      if (mounted) {
        setState(() {
          cerrandoSesion =
              false;
        });
      }
    }
  }

  Widget construirProfesorActual(
    VinculoProfesor vinculo,
  ) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CircleAvatar(
                  child: Icon(
                    Icons.fitness_center,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Text(
                    'Mi profesor',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 16,
            ),

            Text(
              vinculo.profesorNombre,
              style:
                  const TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 4,
            ),

            const Text(
              'Profesor/a vinculado',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(
              height: 18,
            ),

            SizedBox(
              width: double.infinity,
              child:
                  OutlinedButton.icon(
                onPressed:
                    desvinculandoProfesor
                        ? null
                        : () {
                            desvincularProfesor(
                              vinculo,
                            );
                          },
                icon:
                    desvinculandoProfesor
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2,
                            ),
                          )
                        : const Icon(
                            Icons.link_off_outlined,
                          ),
                label: Text(
                  desvinculandoProfesor
                      ? 'Desvinculando...'
                      : 'Desvincular profesor',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget construirSolicitudes() {
    return StreamBuilder<
        List<SolicitudVinculacion>>(
      stream:
          VinculacionFirestoreServicio
              .escucharSolicitudesPendientes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Card(
            child: ListTile(
              leading: const Icon(
                Icons.error_outline,
              ),
              title: const Text(
                'Solicitudes',
              ),
              subtitle: const Text(
                'No se pudieron cargar las solicitudes.',
              ),
            ),
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding:
                  EdgeInsets.all(
                18,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: Text(
                      'Buscando solicitudes...',
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final solicitudes =
            snapshot.data ??
                const [];

        if (solicitudes.isEmpty) {
          return const SizedBox
              .shrink();
        }

        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Solicitudes',
              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            ...solicitudes.map(
              (solicitud) {
                final procesando =
                    solicitudProcesandoId ==
                        solicitud.id;

                return Padding(
                  padding:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: Card(
                    child: Padding(
                      padding:
                          const EdgeInsets.all(
                        16,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                child: Icon(
                                  Icons.person_add_alt_1,
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    const Text(
                                      'Solicitud de vinculación',
                                      style:
                                          TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize:
                                            17,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      '${solicitud.profesorNombre} '
                                      'quiere ser tu profesor/a.',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(
                            height: 16,
                          ),

                          Row(
                            children: [
                              Expanded(
                                child:
                                    OutlinedButton(
                                  onPressed:
                                      procesando
                                          ? null
                                          : () {
                                              rechazarSolicitud(
                                                solicitud,
                                              );
                                            },
                                  child:
                                      const Text(
                                    'Rechazar',
                                  ),
                                ),
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child:
                                    FilledButton(
                                  onPressed:
                                      procesando
                                          ? null
                                          : () {
                                              aceptarSolicitud(
                                                solicitud,
                                              );
                                            },
                                  child:
                                      procesando
                                          ? const SizedBox(
                                              width:
                                                  20,
                                              height:
                                                  20,
                                              child:
                                                  CircularProgressIndicator(
                                                strokeWidth:
                                                    2,
                                              ),
                                            )
                                          : const Text(
                                              'Aceptar',
                                            ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget construirCodigoVinculacion() {
    if (cargandoCodigo) {
      return const Card(
        child: Padding(
          padding:
              EdgeInsets.all(
            18,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
              SizedBox(
                width: 14,
              ),
              Expanded(
                child: Text(
                  'Generando código de vinculación...',
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (errorCodigo != null) {
      return Card(
        child: ListTile(
          leading: const Icon(
            Icons.error_outline,
          ),
          title: const Text(
            'Código de vinculación',
          ),
          subtitle: Text(
            errorCodigo!,
          ),
          trailing: IconButton(
            onPressed:
                cargarCodigoVinculacion,
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.link_outlined,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    'Código de vinculación',
                    style:
                        TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            const Text(
              'Compartí este código únicamente con el profesor '
              'que quieras vincular a tu cuenta.',
            ),

            const SizedBox(
              height: 16,
            ),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 16,
                    ),
                    decoration:
                        BoxDecoration(
                      border: Border.all(
                        color:
                            Theme.of(
                          context,
                        )
                                .colorScheme
                                .outlineVariant,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: Text(
                      codigoVinculacion ??
                          '--------',
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                        letterSpacing: 3,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  width: 10,
                ),

                IconButton.filledTonal(
                  tooltip:
                      'Copiar código',
                  onPressed:
                      codigoVinculacion ==
                              null
                          ? null
                          : copiarCodigo,
                  icon: const Icon(
                    Icons.copy_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget construirBloqueVinculacionAlumno() {
    return StreamBuilder<
        VinculoProfesor?>(
      stream:
          VinculacionFirestoreServicio
              .escucharVinculoActivo(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Card(
            child: ListTile(
              leading: Icon(
                Icons.error_outline,
              ),
              title: Text(
                'Vinculación',
              ),
              subtitle: Text(
                'No se pudo consultar el profesor vinculado.',
              ),
            ),
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding:
                  EdgeInsets.all(
                18,
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                  SizedBox(
                    width: 14,
                  ),
                  Expanded(
                    child: Text(
                      'Comprobando vinculación...',
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final vinculo =
            snapshot.data;

        if (vinculo != null) {
          return construirProfesorActual(
            vinculo,
          );
        }

        //
        // IMPORTANTE:
        //
        // Si el profesor eliminó el vínculo desde su cuenta,
        // este StreamBuilder recibe null automáticamente.
        //
        // En ese momento generamos el código nuevo.
        //
        if (codigoVinculacion == null &&
            !cargandoCodigo &&
            !intentandoGenerarCodigoAutomaticamente) {
          WidgetsBinding.instance
              .addPostFrameCallback(
            (_) {
              if (!mounted) {
                return;
              }

              generarCodigoSiHaceFalta();
            },
          );
        }

        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            construirSolicitudes(),

            const SizedBox(
              height: 8,
            ),

            construirCodigoVinculacion(),
          ],
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final usuario =
        DatosApp.usuarioActual;

    final usuarioFirebase =
        FirebaseAuth
            .instance.currentUser;

    return SafeArea(
      child: SingleChildScrollView(
        padding:
            const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          80,
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Perfil',
              style: TextStyle(
                fontSize: 30,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            Center(
              child: Column(
                children: [
                  AvatarUsuario(
                    fotoUrl: usuario.fotoUrl,
                    nombre: usuario.nombre,
                    radio: 50,
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Text(
                    usuario.nombre,
                    style:
                        const TextStyle(
                      fontSize: 22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 4,
                  ),

                  Text(
                    usuario.rol ==
                            'profesor'
                        ? 'Profesor/a'
                        : 'Alumno',
                    style:
                        const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),

                  if (usuarioFirebase
                          ?.email !=
                      null) ...[
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      usuarioFirebase!
                          .email!,
                      style:
                          const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            PerfilDato(
              icono:
                  Icons.cake_outlined,
              titulo:
                  'Edad',
              valor:
                  '${usuario.edad} años',
            ),

            PerfilDato(
              icono:
                  Icons.height,
              titulo:
                  'Altura',
              valor:
                  '${usuario.altura.toStringAsFixed(2)} m',
            ),

            PerfilDato(
              icono:
                  Icons.monitor_weight_outlined,
              titulo:
                  'Peso actual',
              valor:
                  '${usuario.peso.toStringAsFixed(1)} kg',
            ),

            PerfilDato(
              icono:
                  Icons.flag_outlined,
              titulo:
                  'Objetivo',
              valor:
                  usuario.objetivo,
            ),

            if (usuario.rol ==
                'alumno') ...[
              const SizedBox(
                height: 24,
              ),

              construirBloqueVinculacionAlumno(),
            ],

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width:
                  double.infinity,
              child:
                  FilledButton.icon(
                onPressed: () async {
                  final huboCambios =
                      await Navigator
                          .push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const EditarPerfilPagina(),
                    ),
                  );

                  if (huboCambios ==
                      true) {
                    setState(() {});
                  }
                },
                icon: const Icon(
                  Icons.edit_outlined,
                ),
                label: const Text(
                  'Editar perfil',
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.security_outlined,
                ),
                title: const Text(
                  'Cuenta y seguridad',
                ),
                subtitle: const Text(
                  'Correo, contraseña e inicio de sesión',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CuentaSeguridadPagina(),
                    ),
                  );
                },
              ),
            ),

            if (SesionLocalServicio
                .puedeVolver) ...[
              const SizedBox(
                height: 12,
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.switch_account_outlined,
                  ),
                  title: const Text(
                    'Volver al profesor',
                  ),
                  subtitle: const Text(
                    'Salir del alumno de prueba',
                  ),
                  trailing:
                      volviendoUsuario
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(
                              Icons.chevron_right,
                            ),
                  onTap:
                      volviendoUsuario
                          ? null
                          : volverAlProfesor,
                ),
              ),
            ],

            const SizedBox(
              height: 12,
            ),

            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                ),
                title: const Text(
                  'Cerrar sesión',
                ),
                subtitle: Text(
                  usuarioFirebase
                          ?.email ??
                      'Salir de la cuenta actual',
                ),
                trailing:
                    cerrandoSesion
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.chevron_right,
                          ),
                onTap:
                    cerrandoSesion
                        ? null
                        : cerrarSesion,
              ),
            ),
          ],
        ),
      ),
    );
  }
}