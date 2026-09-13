import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../modelos/entrenamiento.dart';
import '../modelos/ejercicio.dart';
import '../modelos/rutina.dart';
import '../repositorios/asignacion_rutina_repositorio.dart';
import '../servicios/base_datos_servicio.dart';
import 'detalle_entrenamiento_pagina.dart';

class ProgresoPagina extends StatefulWidget {
  const ProgresoPagina({
    super.key,
  });

  @override
  State<ProgresoPagina> createState() =>
      _ProgresoPaginaState();
}

class _ProgresoPaginaState
    extends State<ProgresoPagina> {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  late final AsignacionRutinaRepositorio
      asignacionRutinaRepositorio;

  StreamSubscription<List<Rutina>>?
      _suscripcionRutinas;

  StreamSubscription<
          QuerySnapshot<Map<String, dynamic>>>?
      _suscripcionEntrenamientos;

  StreamSubscription<
          QuerySnapshot<Map<String, dynamic>>>?
      _suscripcionPeso;

  StreamSubscription<
          DocumentSnapshot<Map<String, dynamic>>>?
      _suscripcionUsuario;

  List<Rutina> _rutinasAsignadas = [];
  List<Entrenamiento> _entrenamientos = [];
  List<_RegistroPesoCloud> _historialPeso = [];

  double? _pesoActual;

  String? _errorRutinas;
  String? _errorEntrenamientos;
  String? _errorPeso;

  @override
  void initState() {
    super.initState();

    asignacionRutinaRepositorio =
        AsignacionRutinaRepositorio(
      BaseDatosServicio.db,
    );

    _iniciarSuscripciones();
  }

  void _iniciarSuscripciones() {
    final usuario =
        FirebaseAuth.instance.currentUser;

    if (usuario == null) {
      setState(() {
        _errorEntrenamientos =
            'No hay una sesión activa.';
      });
      return;
    }

    _suscripcionRutinas =
        asignacionRutinaRepositorio
            .escucharRutinasAlumnoFirestore()
            .listen(
      (rutinas) {
        if (!mounted) {
          return;
        }

        setState(() {
          _rutinasAsignadas = [
            ...rutinas,
          ]..sort(
              (a, b) =>
                  a.dia.compareTo(
                b.dia,
              ),
            );

          _errorRutinas = null;
        });
      },
      onError: (error) {
        if (!mounted) {
          return;
        }

        setState(() {
          _errorRutinas =
              'No se pudieron sincronizar las rutinas.';
        });
      },
    );

    _suscripcionEntrenamientos =
        _firestore
            .collection(
              'entrenamientosAlumno',
            )
            .where(
              'alumnoId',
              isEqualTo: usuario.uid,
            )
            .snapshots()
            .listen(
      (snapshot) {
        final resultado =
            <Entrenamiento>[];

        for (final documento
            in snapshot.docs) {
          final entrenamiento =
              _entrenamientoDesdeFirestore(
            documento,
          );

          if (entrenamiento != null) {
            resultado.add(
              entrenamiento,
            );
          }
        }

        resultado.sort(
          (a, b) =>
              b.fecha.compareTo(
            a.fecha,
          ),
        );

        if (!mounted) {
          return;
        }

        setState(() {
          _entrenamientos =
              resultado;

          _errorEntrenamientos =
              null;
        });
      },
      onError: (error) {
        if (!mounted) {
          return;
        }

        setState(() {
          _errorEntrenamientos =
              'No se pudieron sincronizar los entrenamientos.';
        });
      },
    );

    _suscripcionPeso =
        _firestore
            .collection(
              'registrosPesoAlumno',
            )
            .where(
              'alumnoId',
              isEqualTo: usuario.uid,
            )
            .snapshots()
            .listen(
      (snapshot) {
        final resultado =
            <_RegistroPesoCloud>[];

        for (final documento
            in snapshot.docs) {
          final datos =
              documento.data();

          final pesoDato =
              datos['peso'];

          final fechaDato =
              datos['fecha'];

          if (pesoDato is! num ||
              fechaDato is! Timestamp) {
            continue;
          }

          resultado.add(
            _RegistroPesoCloud(
              id:
                  (datos['id'] ??
                          documento.id)
                      .toString(),
              peso:
                  pesoDato.toDouble(),
              fecha:
                  fechaDato.toDate(),
            ),
          );
        }

        resultado.sort(
          (a, b) =>
              b.fecha.compareTo(
            a.fecha,
          ),
        );

        if (!mounted) {
          return;
        }

        setState(() {
          _historialPeso =
              resultado;

          _errorPeso = null;
        });
      },
      onError: (error) {
        if (!mounted) {
          return;
        }

        setState(() {
          _errorPeso =
              'No se pudo sincronizar el historial de peso.';
        });
      },
    );

    _suscripcionUsuario =
        _firestore
            .collection(
              'usuarios',
            )
            .doc(
              usuario.uid,
            )
            .snapshots()
            .listen(
      (documento) {
        final datos =
            documento.data();

        final pesoDato =
            datos?['peso'];

        if (!mounted) {
          return;
        }

        setState(() {
          _pesoActual =
              pesoDato is num
                  ? pesoDato.toDouble()
                  : null;
        });
      },
      onError: (_) {
        // Si el documento de perfil no se
        // actualiza temporalmente, mantenemos
        // el último peso válido recibido.
      },
    );
  }

  @override
  void dispose() {
    _suscripcionRutinas?.cancel();
    _suscripcionEntrenamientos
        ?.cancel();
    _suscripcionPeso?.cancel();
    _suscripcionUsuario?.cancel();

    super.dispose();
  }

  Entrenamiento?
      _entrenamientoDesdeFirestore(
    QueryDocumentSnapshot<
            Map<String, dynamic>>
        documento,
  ) {
    final datos =
        documento.data();

    final fechaDato =
        datos['fecha'];

    if (fechaDato is! Timestamp) {
      return null;
    }

    final ejerciciosDato =
        datos['ejercicios'];

    final ejercicios =
        <RegistroEjercicio>[];

    if (ejerciciosDato is List) {
      final lista = [
        ...ejerciciosDato,
      ];

      lista.sort(
        (a, b) {
          if (a is! Map ||
              b is! Map) {
            return 0;
          }

          final ordenA =
              a['orden'];

          final ordenB =
              b['orden'];

          return (ordenA is num
                  ? ordenA.toInt()
                  : 0)
              .compareTo(
            ordenB is num
                ? ordenB.toInt()
                : 0,
          );
        },
      );

      for (final item
          in lista) {
        if (item is! Map) {
          continue;
        }

        final seriesDato =
            item['series'];

        final pesoDato =
            item['pesoUsado'];

        ejercicios.add(
          RegistroEjercicio(
            ejercicioId:
                (item['ejercicioId'] ?? '')
                    .toString(),
            nombreEjercicio:
                (item['nombreEjercicio'] ??
                        'Ejercicio')
                    .toString(),
            series:
                seriesDato is num
                    ? seriesDato.toInt()
                    : 0,
            repeticiones:
                (item['repeticiones'] ?? '')
                    .toString(),
            llevaPeso:
                item['llevaPeso'] == true,
            pesoUsado:
                pesoDato is num
                    ? pesoDato.toDouble()
                    : null,
            nota:
                (item['nota'] ?? '')
                    .toString(),
            completado:
                item['completado'] == true,
          ),
        );
      }
    }

    return Entrenamiento(
      id:
          (datos['id'] ??
                  documento.id)
              .toString(),
      rutinaId:
          (datos['rutinaId'] ?? '')
              .toString(),
      fecha:
          fechaDato.toDate(),
      ejercicios:
          ejercicios,
      completado:
          datos['finalizado'] == true,
    );
  }

  DateTime inicioSemana(
    DateTime fecha,
  ) {
    final fechaLimpia =
        DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
    );

    return fechaLimpia.subtract(
      Duration(
        days:
            fecha.weekday -
                DateTime.monday,
      ),
    );
  }

  Entrenamiento?
      entrenamientoDeRutinaEstaSemana(
    Rutina rutina,
  ) {
    final lunes =
        inicioSemana(
      DateTime.now(),
    );

    final lunesSiguiente =
        lunes.add(
      const Duration(
        days: 7,
      ),
    );

    final encontrados =
        _entrenamientos.where(
      (entrenamiento) {
        return entrenamiento
                .completado &&
            entrenamiento.rutinaId ==
                rutina.id &&
            !entrenamiento.fecha
                .isBefore(
              lunes,
            ) &&
            entrenamiento.fecha
                .isBefore(
              lunesSiguiente,
            );
      },
    ).toList();

    if (encontrados.isEmpty) {
      return null;
    }

    encontrados.sort(
      (a, b) =>
          b.fecha.compareTo(
        a.fecha,
      ),
    );

    return encontrados.first;
  }

  String fechaTexto(
    DateTime fecha,
  ) {
    final dia =
        fecha.day
            .toString()
            .padLeft(
              2,
              '0',
            );

    final mes =
        fecha.month
            .toString()
            .padLeft(
              2,
              '0',
            );

    return '$dia/$mes/${fecha.year}';
  }

  String horaTexto(
    DateTime fecha,
  ) {
    final hora =
        fecha.hour
            .toString()
            .padLeft(
              2,
              '0',
            );

    final minutos =
        fecha.minute
            .toString()
            .padLeft(
              2,
              '0',
            );

    return '$hora:$minutos';
  }

  List<_ResumenEjercicio>
      obtenerResumenEjercicios(
    List<Rutina> rutinas,
  ) {
    final nombres =
        <String, String>{};

    final ejerciciosActuales =
        <String, Ejercicio>{};

    //
    // Conservamos los ejercicios que están
    // actualmente en las rutinas activas.
    //
    for (final rutina
        in rutinas) {
      for (final ejercicio
          in rutina.ejercicios) {
        nombres[
                ejercicio.id] =
            ejercicio.nombre;

        ejerciciosActuales[
                ejercicio.id] =
            ejercicio;
      }
    }

    //
    // También incluimos ejercicios históricos
    // aunque la rutina ya no esté asignada.
    //
    for (final entrenamiento
        in _entrenamientos) {
      for (final registro
          in entrenamiento.ejercicios) {
        if (!registro
            .realizadoValido) {
          continue;
        }

        nombres.putIfAbsent(
          registro.ejercicioId,
          () =>
              registro
                  .nombreEjercicio,
        );
      }
    }

    final resultado =
        <_ResumenEjercicio>[];

    for (final entrada
        in nombres.entries) {
      final ejercicioId =
          entrada.key;

      final nombreActual =
          ejerciciosActuales[
                      ejercicioId]
                  ?.nombre ??
              entrada.value;

      final registros =
          <_RegistroEjercicioConFecha>[];

      for (final entrenamiento
          in _entrenamientos) {
        for (final registro
            in entrenamiento.ejercicios) {
          if (registro.ejercicioId ==
                  ejercicioId &&
              registro
                  .realizadoValido) {
            registros.add(
              _RegistroEjercicioConFecha(
                fecha:
                    entrenamiento.fecha,
                registro:
                    registro,
              ),
            );
          }
        }
      }

      registros.sort(
        (a, b) =>
            b.fecha.compareTo(
          a.fecha,
        ),
      );

      double? ultimoPeso;
      double? pesoMaximo;

      for (final item
          in registros) {
        final peso =
            item.registro
                .pesoUsado;

        if (peso == null ||
            peso <= 0) {
          continue;
        }

        ultimoPeso ??=
            peso;

        if (pesoMaximo == null ||
            peso > pesoMaximo) {
          pesoMaximo =
              peso;
        }
      }

      final llevaPeso =
          ejerciciosActuales[
                      ejercicioId]
                  ?.llevaPeso ??
              registros.any(
                (item) =>
                    item.registro
                        .llevaPeso,
              );

      resultado.add(
        _ResumenEjercicio(
          ejercicioId:
              ejercicioId,
          nombre:
              nombreActual,
          vecesRealizado:
              registros.length,
          ultimoPeso:
              ultimoPeso,
          pesoMaximo:
              pesoMaximo,
          llevaPeso:
              llevaPeso,
          registros:
              registros,
        ),
      );
    }

    resultado.sort(
      (a, b) =>
          a.nombre
              .toLowerCase()
              .compareTo(
                b.nombre
                    .toLowerCase(),
              ),
    );

    return resultado;
  }

  double? obtenerPesoInicial() {
    if (_historialPeso.isEmpty) {
      return null;
    }

    final historial = [
      ..._historialPeso,
    ];

    historial.sort(
      (a, b) =>
          a.fecha.compareTo(
        b.fecha,
      ),
    );

    return historial.first.peso;
  }

  void mostrarHistorialPeso() {
    showModalBottomSheet(
      context:
          context,
      isScrollControlled:
          true,
      builder:
          (sheetContext) {
        return SafeArea(
          child:
              FractionallySizedBox(
            heightFactor:
                0.85,
            child:
                ListView(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                40,
              ),
              children: [
                Row(
                  children: [
                    const Expanded(
                      child:
                          Text(
                        'Historial de peso',
                        style:
                            TextStyle(
                          fontSize:
                              24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed:
                          () {
                        Navigator.pop(
                          sheetContext,
                        );
                      },
                      icon:
                          const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  _historialPeso
                          .isEmpty
                      ? 'Sin registros de peso.'
                      : '${_historialPeso.length} registro${_historialPeso.length == 1 ? '' : 's'}',
                  style:
                      const TextStyle(
                    color:
                        Colors.grey,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                if (_historialPeso
                    .isEmpty)
                  const Card(
                    child:
                        Padding(
                      padding:
                          EdgeInsets.all(
                        18,
                      ),
                      child:
                          Text(
                        'Todavía no hay historial de peso corporal.',
                      ),
                    ),
                  )
                else
                  ..._historialPeso.map(
                    (
                      registro,
                    ) {
                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 10,
                        ),
                        child:
                            ListTile(
                          leading:
                              const CircleAvatar(
                            child:
                                Icon(
                              Icons
                                  .monitor_weight_outlined,
                            ),
                          ),
                          title:
                              Text(
                            '${registro.peso.toStringAsFixed(1)} kg',
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          subtitle:
                              Text(
                            '${fechaTexto(registro.fecha)} · ${horaTexto(registro.fecha)}',
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void mostrarHistorialEjercicio(
    _ResumenEjercicio ejercicio,
  ) {
    showModalBottomSheet(
      context:
          context,
      isScrollControlled:
          true,
      builder:
          (sheetContext) {
        return SafeArea(
          child:
              FractionallySizedBox(
            heightFactor:
                0.85,
            child:
                ListView(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                40,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child:
                          Text(
                        ejercicio.nombre,
                        style:
                            const TextStyle(
                          fontSize:
                              24,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed:
                          () {
                        Navigator.pop(
                          sheetContext,
                        );
                      },
                      icon:
                          const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  '${ejercicio.vecesRealizado} entrenamiento${ejercicio.vecesRealizado == 1 ? '' : 's'} realizado${ejercicio.vecesRealizado == 1 ? '' : 's'}',
                  style:
                      const TextStyle(
                    color:
                        Colors.grey,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                if (ejercicio
                    .registros
                    .isEmpty)
                  const Card(
                    child:
                        Padding(
                      padding:
                          EdgeInsets.all(
                        18,
                      ),
                      child:
                          Text(
                        'Todavía no hay registros de este ejercicio.',
                      ),
                    ),
                  )
                else
                  ...ejercicio.registros.map(
                    (
                      item,
                    ) {
                      final registro =
                          item.registro;

                      return Card(
                        margin:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child:
                            Padding(
                          padding:
                              const EdgeInsets.all(
                            16,
                          ),
                          child:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                fechaTexto(
                                  item.fecha,
                                ),
                                style:
                                    const TextStyle(
                                  fontSize:
                                      17,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                height: 8,
                              ),

                              Text(
                                '${registro.series} series · ${registro.repeticiones} reps',
                              ),

                              if (registro
                                  .llevaPeso) ...[
                                const SizedBox(
                                  height: 6,
                                ),

                                Text(
                                  'Peso: ${registro.pesoUsado!.toStringAsFixed(1)} kg',
                                ),
                              ],

                              if (registro.nota
                                  .trim()
                                  .isNotEmpty) ...[
                                const SizedBox(
                                  height: 8,
                                ),

                                Text(
                                  'Nota: ${registro.nota}',
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _construirAvisoSincronizacion() {
    final mensajes =
        <String>[];

    if (_errorRutinas != null) {
      mensajes.add(
        _errorRutinas!,
      );
    }

    if (_errorEntrenamientos !=
        null) {
      mensajes.add(
        _errorEntrenamientos!,
      );
    }

    if (_errorPeso != null) {
      mensajes.add(
        _errorPeso!,
      );
    }

    if (mensajes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      child:
          Padding(
        padding:
            const EdgeInsets.all(
          16,
        ),
        child:
            Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons
                  .cloud_off_outlined,
            ),

            const SizedBox(
              width: 12,
            ),

            Expanded(
              child:
                  Text(
                mensajes.join(
                  '\n',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final pesoActual =
        _pesoActual ??
            (_historialPeso.isNotEmpty
                ? _historialPeso.first.peso
                : null);

    final pesoInicial =
        obtenerPesoInicial();

    final diferenciaPeso =
        pesoInicial == null ||
                pesoActual == null
            ? null
            : pesoActual -
                pesoInicial;

    final rutinas = [
      ..._rutinasAsignadas,
    ];

    final resumenEjercicios =
        obtenerResumenEjercicios(
      rutinas,
    );

    final completadasSemana =
        rutinas.where(
      (rutina) =>
          entrenamientoDeRutinaEstaSemana(
            rutina,
          ) !=
          null,
    ).length;

    return SafeArea(
      child:
          ListView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding:
            const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          80,
        ),
        children: [
          const Text(
            'Progreso',
            style:
                TextStyle(
              fontSize:
                  30,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          const Text(
            'Tu evolución y entrenamientos',
            style:
                TextStyle(
              fontSize:
                  16,
              color:
                  Colors.grey,
            ),
          ),

          if (_errorRutinas != null ||
              _errorEntrenamientos !=
                  null ||
              _errorPeso != null) ...[
            const SizedBox(
              height: 16,
            ),

            _construirAvisoSincronizacion(),
          ],

          const SizedBox(
            height: 26,
          ),

          // =========================
          // PESO CORPORAL
          // =========================

          Card(
            child:
                InkWell(
              borderRadius:
                  BorderRadius.circular(
                12,
              ),
              onTap:
                  mostrarHistorialPeso,
              child:
                  Padding(
                padding:
                    const EdgeInsets.all(
                  20,
                ),
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons
                              .monitor_weight_outlined,
                          size:
                              28,
                        ),
                        SizedBox(
                          width:
                              10,
                        ),
                        Text(
                          'Peso corporal',
                          style:
                              TextStyle(
                            fontSize:
                                21,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    if (pesoActual ==
                        null)
                      const Text(
                        'Sin peso registrado.',
                        style:
                            TextStyle(
                          color:
                              Colors.grey,
                        ),
                      )
                    else ...[
                      Text(
                        '${pesoActual.toStringAsFixed(1)} kg',
                        style:
                            const TextStyle(
                          fontSize:
                              32,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      if (pesoInicial !=
                          null) ...[
                        const SizedBox(
                          height: 6,
                        ),

                        Text(
                          'Peso inicial: ${pesoInicial.toStringAsFixed(1)} kg',
                          style:
                              const TextStyle(
                            color:
                                Colors.grey,
                          ),
                        ),
                      ],

                      if (diferenciaPeso !=
                          null) ...[
                        const SizedBox(
                          height: 4,
                        ),

                        Text(
                          diferenciaPeso.abs() <
                                  0.05
                              ? 'Sin cambios desde el primer registro'
                              : diferenciaPeso >
                                      0
                                  ? '+${diferenciaPeso.toStringAsFixed(1)} kg desde el primer registro'
                                  : '${diferenciaPeso.toStringAsFixed(1)} kg desde el primer registro',
                          style:
                              const TextStyle(
                            color:
                                Colors.grey,
                          ),
                        ),
                      ],
                    ],

                    const SizedBox(
                      height: 14,
                    ),

                    Row(
                      children: [
                        Text(
                          _historialPeso
                                  .isEmpty
                              ? 'Ver historial'
                              : 'Ver historial (${_historialPeso.length})',
                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        const Icon(
                          Icons
                              .chevron_right,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 28,
          ),

          // =========================
          // ACTIVIDAD SEMANAL
          // =========================

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,
            children: [
              const Text(
                'Actividad semanal',
                style:
                    TextStyle(
                  fontSize:
                      22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              Text(
                '$completadasSemana/${rutinas.length}',
                style:
                    const TextStyle(
                  fontSize:
                      16,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          if (rutinas.isEmpty)
            const Card(
              child:
                  Padding(
                padding:
                    EdgeInsets.all(
                  20,
                ),
                child:
                    Text(
                  'No tenés rutinas asignadas.',
                ),
              ),
            )
          else
            ...rutinas.map(
              (
                rutina,
              ) {
                final entrenamiento =
                    entrenamientoDeRutinaEstaSemana(
                  rutina,
                );

                final completada =
                    entrenamiento !=
                        null;

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom:
                        10,
                  ),
                  child:
                      ListTile(
                    leading:
                        CircleAvatar(
                      child:
                          completada
                              ? Icon(
                                  entrenamiento
                                          .esParcial
                                      ? Icons
                                          .pie_chart_outline
                                      : Icons
                                          .check,
                                )
                              : Text(
                                  '${rutina.dia}',
                                ),
                    ),

                    title:
                        Text(
                      'Día ${rutina.dia}',
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    subtitle:
                        Text(
                      completada
                          ? entrenamiento
                                  .esParcial
                              ? 'Parcial ${entrenamiento.ejerciciosCompletados}/${entrenamiento.totalEjercicios} · ${fechaTexto(entrenamiento.fecha)}'
                              : 'Completado · ${fechaTexto(entrenamiento.fecha)}'
                          : 'Pendiente',
                    ),

                    trailing:
                        completada
                            ? const Icon(
                                Icons
                                    .chevron_right,
                              )
                            : const Icon(
                                Icons
                                    .schedule,
                              ),

                    onTap:
                        completada
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            DetalleEntrenamientoPagina(
                                      entrenamiento:
                                          entrenamiento,
                                      rutina:
                                          rutina,
                                    ),
                                  ),
                                );
                              }
                            : null,
                  ),
                );
              },
            ),

          const SizedBox(
            height: 28,
          ),

          // =========================
          // MIS EJERCICIOS
          // =========================

          const Text(
            'Mis ejercicios',
            style:
                TextStyle(
              fontSize:
                  22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          const Text(
            'Tu historial y mejores pesos',
            style:
                TextStyle(
              color:
                  Colors.grey,
            ),
          ),

          const SizedBox(
            height: 12,
          ),

          if (resumenEjercicios.isEmpty)
            const Card(
              child:
                  Padding(
                padding:
                    EdgeInsets.all(
                  20,
                ),
                child:
                    Text(
                  'Todavía no hay ejercicios para mostrar.',
                ),
              ),
            )
          else
            ...resumenEjercicios.map(
              (
                ejercicio,
              ) {
                String subtitulo;

                if (ejercicio
                        .vecesRealizado ==
                    0) {
                  subtitulo =
                      'Todavía sin registros';
                } else if (!ejercicio
                    .llevaPeso) {
                  subtitulo =
                      '${ejercicio.vecesRealizado} entrenamiento${ejercicio.vecesRealizado == 1 ? '' : 's'}';
                } else {
                  final ultimo =
                      ejercicio.ultimoPeso ==
                              null
                          ? '—'
                          : '${ejercicio.ultimoPeso!.toStringAsFixed(1)} kg';

                  final maximo =
                      ejercicio.pesoMaximo ==
                              null
                          ? '—'
                          : '${ejercicio.pesoMaximo!.toStringAsFixed(1)} kg';

                  subtitulo =
                      'Último: $ultimo  ·  Máx: $maximo';
                }

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom:
                        10,
                  ),
                  child:
                      ListTile(
                    leading:
                        const CircleAvatar(
                      child:
                          Icon(
                        Icons
                            .fitness_center,
                      ),
                    ),

                    title:
                        Text(
                      ejercicio.nombre,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    subtitle:
                        Padding(
                      padding:
                          const EdgeInsets.only(
                        top:
                            4,
                      ),
                      child:
                          Text(
                        subtitulo,
                      ),
                    ),

                    trailing:
                        const Icon(
                      Icons
                          .chevron_right,
                    ),

                    onTap:
                        () {
                      mostrarHistorialEjercicio(
                        ejercicio,
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _RegistroPesoCloud {
  final String id;
  final double peso;
  final DateTime fecha;

  const _RegistroPesoCloud({
    required this.id,
    required this.peso,
    required this.fecha,
  });
}

class _ResumenEjercicio {
  final String ejercicioId;
  final String nombre;
  final int vecesRealizado;
  final double? ultimoPeso;
  final double? pesoMaximo;
  final bool llevaPeso;
  final List<_RegistroEjercicioConFecha> registros;

  const _ResumenEjercicio({
    required this.ejercicioId,
    required this.nombre,
    required this.vecesRealizado,
    required this.ultimoPeso,
    required this.pesoMaximo,
    required this.llevaPeso,
    required this.registros,
  });
}

class _RegistroEjercicioConFecha {
  final DateTime fecha;
  final RegistroEjercicio registro;

  const _RegistroEjercicioConFecha({
    required this.fecha,
    required this.registro,
  });
}
