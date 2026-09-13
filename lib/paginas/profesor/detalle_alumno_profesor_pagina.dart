import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../modelos/alumno_profesor.dart';
import '../../modelos/rutina_editor.dart';
import '../../repositorios/asignacion_rutina_repositorio.dart';
import '../../repositorios/rutina_profesor_repositorio.dart';
import '../../servicios/base_datos_servicio.dart';
import '../../servicios/vinculacion_firestore_servicio.dart';
import 'progreso_alumno_profesor_pagina.dart';

class DetalleAlumnoProfesorPagina
    extends StatefulWidget {
  final String profesorId;
  final AlumnoProfesor alumno;

  const DetalleAlumnoProfesorPagina({
    super.key,
    required this.profesorId,
    required this.alumno,
  });

  @override
  State<DetalleAlumnoProfesorPagina>
      createState() =>
          _DetalleAlumnoProfesorPaginaState();
}

class _DetalleAlumnoProfesorPaginaState
    extends State<DetalleAlumnoProfesorPagina> {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  late final AsignacionRutinaRepositorio
      asignacionRepositorio;

  late final RutinaProfesorRepositorio
      rutinaRepositorio;

  List<RutinaEditor> rutinasProfesor = [];

  bool cargando = true;
  bool asignando = false;
  bool desvinculando = false;

  String nombre = '';
  String correo = '';
  String objetivo = '';

  int? edad;
  double? altura;
  double? peso;

  @override
  void initState() {
    super.initState();

    asignacionRepositorio =
        AsignacionRutinaRepositorio(
      BaseDatosServicio.db,
    );

    rutinaRepositorio =
        RutinaProfesorRepositorio(
      BaseDatosServicio.db,
    );

    cargarDatos();
  }

  Future<void> cargarDatos() async {
    if (!mounted) {
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      final usuarioActual =
          FirebaseAuth.instance.currentUser;

      if (usuarioActual == null) {
        throw Exception(
          'No hay una sesión activa.',
        );
      }

      if (usuarioActual.uid !=
          widget.profesorId) {
        throw Exception(
          'No tenés permiso para ver este alumno.',
        );
      }

      await usuarioActual
          .getIdTokenResult(
        true,
      );

      final resultados =
          await Future.wait([
        _firestore
            .collection(
              'usuarios',
            )
            .doc(
              widget.alumno.id,
            )
            .get(),

        rutinaRepositorio
            .obtenerRutinasDelProfesor(
          widget.profesorId,
        ),
      ]);

      final documento =
          resultados[0]
              as DocumentSnapshot<
                  Map<String, dynamic>>;

      final rutinas =
          resultados[1]
              as List<RutinaEditor>;

      final datos =
          documento.data();

      if (datos == null) {
        throw Exception(
          'No se encontró el perfil del alumno.',
        );
      }

      final edadDato =
          datos['edad'];

      final alturaDato =
          datos['altura'];

      final pesoDato =
          datos['peso'];

      if (!mounted) {
        return;
      }

      setState(() {
        nombre =
            (datos['nombre'] ??
                    widget.alumno.nombre)
                .toString()
                .trim();

        correo =
            (datos['correo'] ??
                    widget.alumno.correo)
                .toString()
                .trim();

        objetivo =
            (datos['objetivo'] ?? '')
                .toString()
                .trim();

        if (edadDato is num) {
          edad =
              edadDato.toInt();
        } else {
          edad =
              null;
        }

        if (alturaDato is num) {
          altura =
              alturaDato.toDouble();
        } else {
          altura =
              null;
        }

        if (pesoDato is num) {
          peso =
              pesoDato.toDouble();
        } else {
          peso =
              null;
        }

        rutinasProfesor =
            rutinas;

        cargando =
            false;
      });
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        cargando =
            false;
      });

      final mensaje =
          e.code ==
                  'permission-denied'
              ? 'Ya no tenés acceso a este alumno.'
              : 'No se pudo cargar la información del alumno.';

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text(
            mensaje,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        cargando =
            false;
      });

      var mensaje =
          e.toString();

      mensaje =
          mensaje.replaceFirst(
        'Exception: ',
        '',
      );

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text(
            mensaje,
          ),
        ),
      );
    }
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
        content:
            Text(
          mensaje,
        ),
      ),
    );
  }

  Future<void>
      mostrarSelectorRutina(
    List<AsignacionRutinaFirestore>
        asignaciones,
  ) async {
    if (asignando) {
      return;
    }

    if (asignaciones.length >= 7) {
      mostrarMensaje(
        'Este alumno ya tiene 7 rutinas asignadas.',
      );

      return;
    }

    if (rutinasProfesor.isEmpty) {
      mostrarMensaje(
        'Primero debés crear una rutina.',
      );

      return;
    }

    final idsAsignadas =
        asignaciones
            .map(
              (item) =>
                  item.rutinaOrigenId,
            )
            .toSet();

    final disponibles =
        rutinasProfesor
            .where(
              (rutina) =>
                  !idsAsignadas.contains(
                rutina.id,
              ),
            )
            .toList();

    if (disponibles.isEmpty) {
      mostrarMensaje(
        'No quedan rutinas disponibles para asignar.',
      );

      return;
    }

    final rutinaElegida =
        await showModalBottomSheet<
            RutinaEditor>(
      context:
          context,
      builder:
          (sheetContext) {
        return SafeArea(
          child: ListView(
            shrinkWrap:
                true,
            padding:
                const EdgeInsets.all(
              16,
            ),
            children: [
              const Text(
                'Asignar rutina',
                style:
                    TextStyle(
                  fontSize:
                      22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height:
                    12,
              ),

              ...disponibles.map(
                (rutina) {
                  return Card(
                    child:
                        ListTile(
                      leading:
                          CircleAvatar(
                        child:
                            Text(
                          rutina
                              .ejercicios
                              .length
                              .toString(),
                        ),
                      ),
                      title:
                          Text(
                        rutina.nombre,
                      ),
                      subtitle:
                          Text(
                        '${rutina.ejercicios.length} ejercicios',
                      ),
                      trailing:
                          const Icon(
                        Icons
                            .add_circle_outline,
                      ),
                      onTap:
                          () {
                        Navigator.pop(
                          sheetContext,
                          rutina,
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    if (rutinaElegida == null) {
      return;
    }

    setState(() {
      asignando =
          true;
    });

    try {
      await asignacionRepositorio
          .asignarRutinaFirestore(
        profesorId:
            widget.profesorId,
        alumnoId:
            widget.alumno.id,
        rutina:
            rutinaElegida,
      );

      mostrarMensaje(
        'Rutina asignada correctamente.',
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
          asignando =
              false;
        });
      }
    }
  }

  Future<void> quitarAsignacion(
    AsignacionRutinaFirestore asignacion,
  ) async {
    final confirmar =
        await showDialog<bool>(
      context:
          context,
      builder:
          (dialogContext) {
        return AlertDialog(
          title:
              const Text(
            'Quitar rutina',
          ),
          content:
              Text(
            '¿Querés quitar "${asignacion.nombreRutina}" del alumno?\n\n'
            'Los entrenamientos ya realizados no se borrarán.',
          ),
          actions: [
            TextButton(
              onPressed:
                  () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child:
                  const Text(
                'Cancelar',
              ),
            ),
            FilledButton(
              onPressed:
                  () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child:
                  const Text(
                'Quitar',
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    try {
      await asignacionRepositorio
          .quitarAsignacionFirestore(
        profesorId:
            widget.profesorId,
        alumnoId:
            widget.alumno.id,
        asignacionId:
            asignacion.id,
      );

      mostrarMensaje(
        'Rutina quitada.',
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
    }
  }

  Future<void> moverAsignacion(
    AsignacionRutinaFirestore asignacion,
    bool subir,
  ) async {
    try {
      await asignacionRepositorio
          .moverAsignacionFirestore(
        profesorId:
            widget.profesorId,
        alumnoId:
            widget.alumno.id,
        asignacionId:
            asignacion.id,
        subir:
            subir,
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
    }
  }

  Future<void> desvincularAlumno() async {
    if (desvinculando) {
      return;
    }

    final nombreMostrar =
        nombre.isEmpty
            ? widget.alumno.nombre
            : nombre;

    final confirmar =
        await showDialog<bool>(
      context:
          context,
      builder:
          (dialogContext) {
        return AlertDialog(
          title:
              const Text(
            'Desvincular alumno',
          ),
          content:
              Text(
            '¿Querés desvincular a $nombreMostrar?\n\n'
            'El alumno dejará de aparecer en tu lista y ya no tendrás acceso a sus datos.\n\n'
            'El alumno quedará libre para vincularse con otro profesor.',
          ),
          actions: [
            TextButton(
              onPressed:
                  () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child:
                  const Text(
                'Cancelar',
              ),
            ),
            FilledButton(
              onPressed:
                  () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child:
                  const Text(
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
      desvinculando =
          true;
    });

    try {
      await VinculacionFirestoreServicio
          .desvincularAlumnoComoProfesor(
        alumnoId:
            widget.alumno.id,
      );

      if (!mounted) {
        return;
      }

      mostrarMensaje(
        'Alumno desvinculado correctamente.',
      );

      Navigator.pop(
        context,
        true,
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
          desvinculando =
              false;
        });
      }
    }
  }

  Future<void> abrirProgreso() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            ProgresoAlumnoProfesorPagina(
          alumno: widget.alumno,
        ),
      ),
    );
  }

  Widget construirDato({
    required IconData icono,
    required String titulo,
    required String valor,
  }) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical:
            8,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            icono,
            size:
                21,
          ),

          const SizedBox(
            width:
                12,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style:
                      const TextStyle(
                    fontSize:
                        13,
                    color:
                        Colors.grey,
                  ),
                ),

                const SizedBox(
                  height:
                      2,
                ),

                Text(
                  valor,
                  style:
                      const TextStyle(
                    fontSize:
                        16,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget construirAsignaciones() {
    return StreamBuilder<
        List<AsignacionRutinaFirestore>>(
      stream:
          asignacionRepositorio
              .escucharAsignacionesProfesor(
        profesorId:
            widget.profesorId,
        alumnoId:
            widget.alumno.id,
      ),
      builder:
          (context, snapshot) {
        if (snapshot.hasError) {
          return const Card(
            child:
                ListTile(
              leading:
                  Icon(
                Icons.error_outline,
              ),
              title:
                  Text(
                'Rutinas',
              ),
              subtitle:
                  Text(
                'No se pudieron cargar las rutinas asignadas.',
              ),
            ),
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child:
                Padding(
              padding:
                  EdgeInsets.all(
                20,
              ),
              child:
                  CircularProgressIndicator(),
            ),
          );
        }

        final asignaciones =
            snapshot.data ??
                const [];

        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child:
                      Text(
                    'Rutinas semanales',
                    style:
                        TextStyle(
                      fontSize:
                          22,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                FilledButton.icon(
                  onPressed:
                      asignando
                          ? null
                          : () {
                              mostrarSelectorRutina(
                                asignaciones,
                              );
                            },
                  icon:
                      asignando
                          ? const SizedBox(
                              width:
                                  17,
                              height:
                                  17,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,
                              ),
                            )
                          : const Icon(
                              Icons.add,
                            ),
                  label:
                      const Text(
                    'Asignar',
                  ),
                ),
              ],
            ),

            const SizedBox(
              height:
                  8,
            ),

            const Text(
              'Orden flexible. El alumno realiza Día 1, Día 2, etc., según vaya entrenando.',
              style:
                  TextStyle(
                color:
                    Colors.grey,
              ),
            ),

            const SizedBox(
              height:
                  16,
            ),

            if (asignaciones.isEmpty)
              const Card(
                child:
                    Padding(
                  padding:
                      EdgeInsets.all(
                    22,
                  ),
                  child:
                      Center(
                    child:
                        Text(
                      'Este alumno todavía no tiene rutinas asignadas.',
                      textAlign:
                          TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              ...asignaciones
                  .asMap()
                  .entries
                  .map(
                (entrada) {
                  final index =
                      entrada.key;

                  final asignacion =
                      entrada.value;

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom:
                          12,
                    ),
                    child:
                        ListTile(
                      leading:
                          CircleAvatar(
                        child:
                            Text(
                          '${asignacion.dia}',
                        ),
                      ),
                      title:
                          Text(
                        'Día ${asignacion.dia}',
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      subtitle:
                          Text(
                        asignacion.nombreRutina,
                      ),
                      trailing:
                          PopupMenuButton<
                              String>(
                        onSelected:
                            (opcion) {
                          if (opcion ==
                              'arriba') {
                            moverAsignacion(
                              asignacion,
                              true,
                            );
                          }

                          if (opcion ==
                              'abajo') {
                            moverAsignacion(
                              asignacion,
                              false,
                            );
                          }

                          if (opcion ==
                              'quitar') {
                            quitarAsignacion(
                              asignacion,
                            );
                          }
                        },
                        itemBuilder:
                            (context) {
                          return [
                            if (index >
                                0)
                              const PopupMenuItem(
                                value:
                                    'arriba',
                                child:
                                    Text(
                                  'Mover arriba',
                                ),
                              ),

                            if (index <
                                asignaciones.length -
                                    1)
                              const PopupMenuItem(
                                value:
                                    'abajo',
                                child:
                                    Text(
                                  'Mover abajo',
                                ),
                              ),

                            const PopupMenuDivider(),

                            const PopupMenuItem(
                              value:
                                  'quitar',
                              child:
                                  Text(
                                'Quitar asignación',
                              ),
                            ),
                          ];
                        },
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

  @override
  Widget build(
    BuildContext context,
  ) {
    final nombreMostrar =
        nombre.isEmpty
            ? widget.alumno.nombre
            : nombre;

    return Scaffold(
      appBar:
          AppBar(
        title:
            Text(
          nombreMostrar,
        ),
      ),
      body:
          SafeArea(
        top:
            false,
        child:
            cargando
                ? const Center(
                    child:
                        CircularProgressIndicator(),
                  )
                : ListView(
                    padding:
                        const EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      100,
                    ),
                    children: [
                      Card(
                        child:
                            Padding(
                          padding:
                              const EdgeInsets.all(
                            18,
                          ),
                          child:
                              Column(
                            children: [
                              const CircleAvatar(
                                radius:
                                    40,
                                child:
                                    Icon(
                                  Icons.person_outline,
                                  size:
                                      42,
                                ),
                              ),

                              const SizedBox(
                                height:
                                    12,
                              ),

                              Text(
                                nombreMostrar,
                                textAlign:
                                    TextAlign.center,
                                style:
                                    const TextStyle(
                                  fontSize:
                                      22,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              if (correo.isNotEmpty) ...[
                                const SizedBox(
                                  height:
                                      5,
                                ),
                                Text(
                                  correo,
                                  textAlign:
                                      TextAlign.center,
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.grey,
                                  ),
                                ),
                              ],

                              const SizedBox(
                                height:
                                    10,
                              ),

                              const Chip(
                                avatar:
                                    Icon(
                                  Icons.link,
                                  size:
                                      17,
                                ),
                                label:
                                    Text(
                                  'Alumno vinculado',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height:
                            20,
                      ),

                      const Text(
                        'Información',
                        style:
                            TextStyle(
                          fontSize:
                              22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height:
                            10,
                      ),

                      Card(
                        child:
                            Padding(
                          padding:
                              const EdgeInsets.all(
                            16,
                          ),
                          child:
                              Column(
                            children: [
                              construirDato(
                                icono:
                                    Icons.cake_outlined,
                                titulo:
                                    'Edad',
                                valor:
                                    edad == null
                                        ? 'Sin información'
                                        : '$edad años',
                              ),

                              construirDato(
                                icono:
                                    Icons.height,
                                titulo:
                                    'Altura',
                                valor:
                                    altura == null
                                        ? 'Sin información'
                                        : '${altura!.toStringAsFixed(2)} m',
                              ),

                              construirDato(
                                icono:
                                    Icons.monitor_weight_outlined,
                                titulo:
                                    'Peso actual',
                                valor:
                                    peso == null
                                        ? 'Sin información'
                                        : '${peso!.toStringAsFixed(1)} kg',
                              ),

                              construirDato(
                                icono:
                                    Icons.flag_outlined,
                                titulo:
                                    'Objetivo',
                                valor:
                                    objetivo.isEmpty
                                        ? 'Sin información'
                                        : objetivo,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(
                        height:
                            24,
                      ),

                      const Text(
                        'Progreso',
                        style:
                            TextStyle(
                          fontSize:
                              22,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height:
                            10,
                      ),

                      Card(
                        child:
                            ListTile(
                          leading:
                              const CircleAvatar(
                            child:
                                Icon(
                              Icons.trending_up,
                            ),
                          ),
                          title:
                              const Text(
                            'Ver progreso del alumno',
                            style:
                                TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          subtitle:
                              const Text(
                            'Actividad semanal, rutinas completas o parciales, pesos, notas e historial.',
                          ),
                          trailing:
                              const Icon(
                            Icons.chevron_right,
                          ),
                          onTap:
                              abrirProgreso,
                        ),
                      ),

                      const SizedBox(
                        height:
                            24,
                      ),

                      construirAsignaciones(),

                      const SizedBox(
                        height:
                            28,
                      ),

                      const Divider(),

                      const SizedBox(
                        height:
                            14,
                      ),

                      const Text(
                        'Vinculación',
                        style:
                            TextStyle(
                          fontSize:
                              20,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                        height:
                            8,
                      ),

                      const Text(
                        'Si desvinculás al alumno, dejarás de tener acceso a su información. '
                        'El alumno quedará disponible para vincularse con otro profesor.',
                        style:
                            TextStyle(
                          color:
                              Colors.grey,
                        ),
                      ),

                      const SizedBox(
                        height:
                            16,
                      ),

                      SizedBox(
                        width:
                            double.infinity,
                        child:
                            OutlinedButton.icon(
                          onPressed:
                              desvinculando
                                  ? null
                                  : desvincularAlumno,
                          icon:
                              desvinculando
                                  ? const SizedBox(
                                      width:
                                          18,
                                      height:
                                          18,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth:
                                            2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.link_off,
                                    ),
                          label:
                              Text(
                            desvinculando
                                ? 'Desvinculando...'
                                : 'Desvincular alumno',
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}