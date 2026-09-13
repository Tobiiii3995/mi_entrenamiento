import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../modelos/alumno_profesor.dart';
import '../../modelos/entrenamiento.dart';
import '../../servicios/usuario_firestore_servicio.dart';

class ProgresoAlumnoProfesorPagina
    extends StatefulWidget {
  final AlumnoProfesor alumno;

  const ProgresoAlumnoProfesorPagina({
    super.key,
    required this.alumno,
  });

  @override
  State<ProgresoAlumnoProfesorPagina>
      createState() =>
          _ProgresoAlumnoProfesorPaginaState();
}

class _ProgresoAlumnoProfesorPaginaState
    extends State<ProgresoAlumnoProfesorPagina> {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  List<_EntrenamientoCloud> entrenamientos = [];
  List<_RutinaAsignadaCloud> rutinasAsignadas = [];
  List<_RegistroPesoCloud> historialPeso = [];

  double? pesoActual;

  bool cargando = true;
  String? error;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    if (mounted) {
      setState(() {
        cargando = true;
        error = null;
      });
    }

    try {
      final usuario =
          FirebaseAuth.instance.currentUser;

      if (usuario == null) {
        throw Exception(
          'No hay una sesión activa.',
        );
      }

      await usuario.getIdTokenResult(
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

        _firestore
            .collection(
              'entrenamientosAlumno',
            )
            .where(
              'alumnoId',
              isEqualTo: widget.alumno.id,
            )
            .get(),

        _firestore
            .collection(
              'rutinasAsignadas',
            )
            .where(
              'profesorId',
              isEqualTo: usuario.uid,
            )
            .where(
              'alumnoId',
              isEqualTo: widget.alumno.id,
            )
            .get(),

        UsuarioFirestoreServicio
            .obtenerHistorialPeso(
          widget.alumno.id,
        ),
      ]);

      final documentoUsuario =
          resultados[0]
              as DocumentSnapshot<
                  Map<String, dynamic>>;

      final entrenamientosSnapshot =
          resultados[1]
              as QuerySnapshot<
                  Map<String, dynamic>>;

      final rutinasSnapshot =
          resultados[2]
              as QuerySnapshot<
                  Map<String, dynamic>>;

      final historialPesoDatos =
          resultados[3]
              as List<Map<String, dynamic>>;

      final datosUsuario =
          documentoUsuario.data();

      final pesoDato =
          datosUsuario?['peso'];

      final entrenamientosResultado =
          <_EntrenamientoCloud>[];

      for (final documento
          in entrenamientosSnapshot.docs) {
        final entrenamiento =
            _entrenamientoDesdeFirestore(
          documento,
        );

        if (entrenamiento != null) {
          entrenamientosResultado.add(
            entrenamiento,
          );
        }
      }

      entrenamientosResultado.sort(
        (a, b) =>
            b.entrenamiento.fecha.compareTo(
          a.entrenamiento.fecha,
        ),
      );

      final rutinasResultado =
          <_RutinaAsignadaCloud>[];

      for (final documento
          in rutinasSnapshot.docs) {
        final datos =
            documento.data();

        if (datos['activa'] != true) {
          continue;
        }

        final diaDato =
            datos['dia'];

        if (diaDato is! num) {
          continue;
        }

        final snapshotRutina =
            datos['rutina'];

        String nombre =
            'Rutina';

        if (snapshotRutina is Map) {
          nombre =
              (snapshotRutina['nombre'] ??
                      'Rutina')
                  .toString();
        }

        rutinasResultado.add(
          _RutinaAsignadaCloud(
            id: documento.id,
            dia: diaDato.toInt(),
            nombre: nombre,
          ),
        );
      }

      rutinasResultado.sort(
        (a, b) =>
            a.dia.compareTo(
          b.dia,
        ),
      );

      final historialPesoResultado =
          <_RegistroPesoCloud>[];

      for (final datos
          in historialPesoDatos) {
        final pesoRegistro =
            datos['peso'];

        final fechaRegistro =
            datos['fecha'];

        if (pesoRegistro is! num ||
            fechaRegistro is! Timestamp) {
          continue;
        }

        historialPesoResultado.add(
          _RegistroPesoCloud(
            id:
                (datos['id'] ??
                        datos['documentoId'] ??
                        '')
                    .toString(),
            peso:
                pesoRegistro.toDouble(),
            fecha:
                fechaRegistro.toDate(),
          ),
        );
      }

      historialPesoResultado.sort(
        (a, b) =>
            b.fecha.compareTo(
          a.fecha,
        ),
      );

      if (!mounted) {
        return;
      }

      setState(() {
        entrenamientos =
            entrenamientosResultado;

        rutinasAsignadas =
            rutinasResultado;

        historialPeso =
            historialPesoResultado;

        pesoActual =
            pesoDato is num
                ? pesoDato.toDouble()
                : null;

        cargando = false;
      });
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }

      String mensaje =
          'No se pudo cargar el progreso del alumno.';

      if (e.code ==
          'permission-denied') {
        mensaje =
            'Ya no tenés acceso al progreso de este alumno.';
      } else if (e.code ==
          'failed-precondition') {
        mensaje =
            'Firestore necesita crear un índice para esta consulta. '
            'Abrí el enlace que aparece en la consola de depuración de Flutter y creá el índice.';
      }

      setState(() {
        cargando = false;
        error = mensaje;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      var mensaje =
          e.toString();

      mensaje =
          mensaje.replaceFirst(
        'Exception: ',
        '',
      );

      setState(() {
        cargando = false;
        error = mensaje;
      });
    }
  }

  _EntrenamientoCloud?
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

    final entrenamiento =
        Entrenamiento(
      id:
          (datos['id'] ?? documento.id)
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

    return _EntrenamientoCloud(
      entrenamiento:
          entrenamiento,
      rutinaNombre:
          (datos['rutinaNombre'] ?? '')
              .toString()
              .trim(),
    );
  }

  DateTime inicioSemana(
    DateTime fecha,
  ) {
    final limpia =
        DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
    );

    return limpia.subtract(
      Duration(
        days:
            fecha.weekday -
                DateTime.monday,
      ),
    );
  }

  bool esDeEstaSemana(
    DateTime fecha,
  ) {
    final lunes =
        inicioSemana(
      DateTime.now(),
    );

    final siguiente =
        lunes.add(
      const Duration(
        days: 7,
      ),
    );

    return !fecha.isBefore(
          lunes,
        ) &&
        fecha.isBefore(
          siguiente,
        );
  }

  _EntrenamientoCloud?
      entrenamientoSemanaParaRutina(
    _RutinaAsignadaCloud rutina,
  ) {
    final encontrados =
        entrenamientos.where(
      (item) {
        return item.entrenamiento
                .completado &&
            item.entrenamiento
                    .rutinaId ==
                rutina.id &&
            esDeEstaSemana(
              item.entrenamiento.fecha,
            );
      },
    ).toList();

    if (encontrados.isEmpty) {
      return null;
    }

    encontrados.sort(
      (a, b) =>
          b.entrenamiento.fecha
              .compareTo(
        a.entrenamiento.fecha,
      ),
    );

    return encontrados.first;
  }

  int get entrenamientosSemana {
    return entrenamientos
        .where(
          (item) =>
              item.entrenamiento
                  .completado &&
              esDeEstaSemana(
                item.entrenamiento.fecha,
              ),
        )
        .length;
  }

  int get rutinasRealizadasSemana {
    int total = 0;

    for (final rutina
        in rutinasAsignadas) {
      if (entrenamientoSemanaParaRutina(
            rutina,
          ) !=
          null) {
        total++;
      }
    }

    return total;
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

  String nombreRutina(
    _EntrenamientoCloud item,
  ) {
    if (item.rutinaNombre.isNotEmpty) {
      return item.rutinaNombre;
    }

    for (final rutina
        in rutinasAsignadas) {
      if (rutina.id ==
          item.entrenamiento.rutinaId) {
        return rutina.nombre;
      }
    }

    return 'Rutina';
  }

  int? diaRutina(
    String rutinaId,
  ) {
    for (final rutina
        in rutinasAsignadas) {
      if (rutina.id == rutinaId) {
        return rutina.dia;
      }
    }

    return null;
  }

  List<_ResumenEjercicio>
      obtenerResumenEjercicios() {
    final mapa =
        <String, _ResumenEjercicioMutable>{};

    for (final item
        in entrenamientos) {
      for (final registro
          in item.entrenamiento.ejercicios) {
        //
        // Un ejercicio que quedó sin realizar
        // en una rutina parcial no cuenta como
        // repetición del ejercicio.
        //
        if (!registro.realizadoValido) {
          continue;
        }

        final resumen =
            mapa.putIfAbsent(
          registro.ejercicioId,
          () =>
              _ResumenEjercicioMutable(
            ejercicioId:
                registro.ejercicioId,
            nombre:
                registro.nombreEjercicio,
          ),
        );

        resumen.registros.add(
          _RegistroConFecha(
            fecha:
                item.entrenamiento.fecha,
            registro:
                registro,
          ),
        );
      }
    }

    final resultado =
        <_ResumenEjercicio>[];

    for (final resumen
        in mapa.values) {
      resumen.registros.sort(
        (a, b) =>
            b.fecha.compareTo(
          a.fecha,
        ),
      );

      double? ultimoPeso;
      double? pesoMaximo;

      for (final item
          in resumen.registros) {
        final peso =
            item.registro.pesoUsado;

        if (peso == null ||
            peso <= 0) {
          continue;
        }

        ultimoPeso ??= peso;

        if (pesoMaximo == null ||
            peso > pesoMaximo) {
          pesoMaximo = peso;
        }
      }

      resultado.add(
        _ResumenEjercicio(
          ejercicioId:
              resumen.ejercicioId,
          nombre:
              resumen.nombre,
          veces:
              resumen.registros.length,
          ultimoPeso:
              ultimoPeso,
          pesoMaximo:
              pesoMaximo,
          registros:
              resumen.registros,
        ),
      );
    }

    resultado.sort(
      (a, b) =>
          a.nombre
              .toLowerCase()
              .compareTo(
                b.nombre.toLowerCase(),
              ),
    );

    return resultado;
  }

  double? get pesoInicial {
    if (historialPeso.isEmpty) {
      return null;
    }

    final ordenados = [
      ...historialPeso,
    ]..sort(
        (a, b) =>
            a.fecha.compareTo(
          b.fecha,
        ),
      );

    return ordenados.first.peso;
  }

  double? get diferenciaPeso {
    final actual =
        pesoActual;

    final inicial =
        pesoInicial;

    if (actual == null ||
        inicial == null) {
      return null;
    }

    return actual - inicial;
  }

  String textoDiferenciaPeso(
    double diferencia,
  ) {
    if (diferencia.abs() < 0.05) {
      return 'Sin cambios desde el primer registro';
    }

    if (diferencia > 0) {
      return '+${diferencia.toStringAsFixed(1)} kg desde el primer registro';
    }

    return '${diferencia.toStringAsFixed(1)} kg desde el primer registro';
  }

  void mostrarHistorialPeso() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                  historialPeso.isEmpty
                      ? 'Sin registros de peso.'
                      : '${historialPeso.length} registro${historialPeso.length == 1 ? '' : 's'}',
                  style:
                      const TextStyle(
                    color:
                        Colors.grey,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                if (historialPeso.isEmpty)
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
                  ...historialPeso.map(
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
                              Icons.monitor_weight_outlined,
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

  void mostrarEntrenamiento(
    _EntrenamientoCloud item,
  ) {
    final entrenamiento =
        item.entrenamiento;

    final dia =
        diaRutina(
      entrenamiento.rutinaId,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (sheetContext) {
        return SafeArea(
          child:
              FractionallySizedBox(
            heightFactor:
                0.9,
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
                        dia == null
                            ? nombreRutina(
                                item,
                              )
                            : 'Día $dia · ${nombreRutina(item)}',
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
                  '${fechaTexto(entrenamiento.fecha)} · ${horaTexto(entrenamiento.fecha)}',
                  style:
                      const TextStyle(
                    color:
                        Colors.grey,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                Card(
                  child:
                      Padding(
                    padding:
                        const EdgeInsets.all(
                      16,
                    ),
                    child:
                        Row(
                      children: [
                        Icon(
                          entrenamiento.esParcial
                              ? Icons
                                  .pie_chart_outline
                              : Icons
                                  .check_circle,
                          color:
                              entrenamiento.esParcial
                                  ? Colors.orange
                                  : Colors.green,
                          size:
                              30,
                        ),

                        const SizedBox(
                          width: 12,
                        ),

                        Expanded(
                          child:
                              Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                entrenamiento.esParcial
                                    ? 'Finalizada parcialmente'
                                    : 'Rutina completa',
                                style:
                                    const TextStyle(
                                  fontSize:
                                      18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                height: 3,
                              ),

                              Text(
                                '${entrenamiento.ejerciciosCompletados}/${entrenamiento.totalEjercicios} ejercicios realizados',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                ...entrenamiento.ejercicios.map(
                  (
                    ejercicio,
                  ) {
                    final realizado =
                        ejercicio.realizadoValido;

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
                            Row(
                              children: [
                                Icon(
                                  realizado
                                      ? Icons
                                          .check_circle
                                      : Icons
                                          .cancel_outlined,
                                  color:
                                      realizado
                                          ? Colors.green
                                          : Colors.grey,
                                ),

                                const SizedBox(
                                  width: 10,
                                ),

                                Expanded(
                                  child:
                                      Text(
                                    ejercicio.nombreEjercicio,
                                    style:
                                        TextStyle(
                                      fontSize:
                                          18,
                                      fontWeight:
                                          FontWeight.bold,
                                      color:
                                          realizado
                                              ? null
                                              : Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            Text(
                              '${ejercicio.series} series · ${ejercicio.repeticiones} reps',
                            ),

                            if (!realizado) ...[
                              const SizedBox(
                                height: 8,
                              ),

                              Text(
                                ejercicio.llevaPeso &&
                                        ejercicio.completado &&
                                        (ejercicio.pesoUsado ==
                                                null ||
                                            ejercicio.pesoUsado! <=
                                                0)
                                    ? 'No realizado · faltó registrar un peso válido'
                                    : 'No realizado',
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.grey,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ],

                            if (realizado &&
                                ejercicio
                                    .llevaPeso) ...[
                              const SizedBox(
                                height: 8,
                              ),

                              Text(
                                'Peso: ${ejercicio.pesoUsado!.toStringAsFixed(1)} kg',
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                            ],

                            if (ejercicio.nota
                                .trim()
                                .isNotEmpty) ...[
                              const SizedBox(
                                height: 10,
                              ),

                              Text(
                                'Nota: ${ejercicio.nota}',
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

  void mostrarHistorialEjercicio(
    _ResumenEjercicio ejercicio,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
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
                  '${ejercicio.veces} entrenamiento${ejercicio.veces == 1 ? '' : 's'} realizado${ejercicio.veces == 1 ? '' : 's'}',
                  style:
                      const TextStyle(
                    color:
                        Colors.grey,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

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

  @override
  Widget build(
    BuildContext context,
  ) {
    if (cargando) {
      return Scaffold(
        appBar:
            AppBar(
          title:
              const Text(
            'Progreso del alumno',
          ),
        ),
        body:
            const Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar:
            AppBar(
          title:
              const Text(
            'Progreso del alumno',
          ),
        ),
        body:
            Center(
          child:
              Padding(
            padding:
                const EdgeInsets.all(
              24,
            ),
            child:
                Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                const Icon(
                  Icons
                      .cloud_off_outlined,
                  size: 55,
                ),

                const SizedBox(
                  height: 14,
                ),

                Text(
                  error!,
                  textAlign:
                      TextAlign.center,
                ),

                const SizedBox(
                  height: 16,
                ),

                FilledButton(
                  onPressed:
                      cargarDatos,
                  child:
                      const Text(
                    'Reintentar',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final resumenEjercicios =
        obtenerResumenEjercicios();

    final realizadasSemana =
        rutinasRealizadasSemana;

    final totalSemana =
        rutinasAsignadas.length;

    return Scaffold(
      appBar:
          AppBar(
        title:
            const Text(
          'Progreso del alumno',
        ),
      ),
      body:
          RefreshIndicator(
        onRefresh:
            cargarDatos,
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
            Text(
              widget.alumno.nombre,
              style:
                  const TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            if (widget.alumno.correo
                .trim()
                .isNotEmpty) ...[
              const SizedBox(
                height: 4,
              ),

              Text(
                widget.alumno.correo,
                style:
                    const TextStyle(
                  color:
                      Colors.grey,
                ),
              ),
            ],

            const SizedBox(
              height: 26,
            ),

            Card(
              child:
                  Padding(
                padding:
                    const EdgeInsets.all(
                  18,
                ),
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Actividad semanal',
                      style:
                          TextStyle(
                        fontSize: 21,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      '$realizadasSemana de $totalSemana rutinas realizadas',
                    ),

                    const SizedBox(
                      height: 4,
                    ),

                    Text(
                      '$entrenamientosSemana entrenamiento${entrenamientosSemana == 1 ? '' : 's'} finalizado${entrenamientosSemana == 1 ? '' : 's'} esta semana',
                      style:
                          const TextStyle(
                        color:
                            Colors.grey,
                      ),
                    ),

                    const SizedBox(
                      height: 14,
                    ),

                    LinearProgressIndicator(
                      value:
                          totalSemana == 0
                              ? 0
                              : realizadasSemana /
                                  totalSemana,
                      minHeight: 7,
                      borderRadius:
                          BorderRadius.circular(
                        10,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
              height: 16,
            ),

            if (rutinasAsignadas.isEmpty)
              const Card(
                child:
                    Padding(
                  padding:
                      EdgeInsets.all(
                    18,
                  ),
                  child:
                      Text(
                    'El alumno no tiene rutinas activas asignadas.',
                  ),
                ),
              )
            else
              ...rutinasAsignadas.map(
                (
                  rutina,
                ) {
                  final item =
                      entrenamientoSemanaParaRutina(
                    rutina,
                  );

                  final entrenamiento =
                      item?.entrenamiento;

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child:
                        ListTile(
                      leading:
                          CircleAvatar(
                        child:
                            entrenamiento ==
                                    null
                                ? Text(
                                    '${rutina.dia}',
                                  )
                                : Icon(
                                    entrenamiento
                                            .esParcial
                                        ? Icons
                                            .pie_chart_outline
                                        : Icons
                                            .check,
                                  ),
                      ),
                      title:
                          Text(
                        'Día ${rutina.dia} · ${rutina.nombre}',
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      subtitle:
                          Text(
                        entrenamiento ==
                                null
                            ? 'Pendiente esta semana'
                            : entrenamiento
                                    .esParcial
                                ? 'Parcial ${entrenamiento.ejerciciosCompletados}/${entrenamiento.totalEjercicios} · ${fechaTexto(entrenamiento.fecha)}'
                                : 'Completa ${entrenamiento.ejerciciosCompletados}/${entrenamiento.totalEjercicios} · ${fechaTexto(entrenamiento.fecha)}',
                      ),
                      trailing:
                          item == null
                              ? const Icon(
                                  Icons
                                      .schedule,
                                )
                              : const Icon(
                                  Icons
                                      .chevron_right,
                                ),
                      onTap:
                          item == null
                              ? null
                              : () {
                                  mostrarEntrenamiento(
                                    item,
                                  );
                                },
                    ),
                  );
                },
              ),

            const SizedBox(
              height: 26,
            ),

            const Text(
              'Peso corporal',
              style:
                  TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Card(
              child:
                  Padding(
                padding:
                    const EdgeInsets.all(
                  18,
                ),
                child:
                    pesoActual ==
                            null
                        ? const Text(
                            'Sin peso actual registrado.',
                          )
                        : Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Peso actual',
                                style:
                                    TextStyle(
                                  color:
                                      Colors.grey,
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),

                              Text(
                                '${pesoActual!.toStringAsFixed(1)} kg',
                                style:
                                    const TextStyle(
                                  fontSize: 28,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              if (pesoInicial !=
                                  null) ...[
                                const SizedBox(
                                  height: 12,
                                ),

                                Text(
                                  'Peso inicial: ${pesoInicial!.toStringAsFixed(1)} kg',
                                  style:
                                      const TextStyle(
                                    fontWeight:
                                        FontWeight.w600,
                                  ),
                                ),
                              ],

                              if (diferenciaPeso !=
                                  null) ...[
                                const SizedBox(
                                  height: 5,
                                ),

                                Text(
                                  textoDiferenciaPeso(
                                    diferenciaPeso!,
                                  ),
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.grey,
                                  ),
                                ),
                              ],

                              const SizedBox(
                                height: 14,
                              ),

                              SizedBox(
                                width:
                                    double.infinity,
                                child:
                                    OutlinedButton.icon(
                                  onPressed:
                                      mostrarHistorialPeso,
                                  icon:
                                      const Icon(
                                    Icons.history,
                                  ),
                                  label:
                                      Text(
                                    historialPeso.isEmpty
                                        ? 'Ver historial'
                                        : 'Ver historial (${historialPeso.length})',
                                  ),
                                ),
                              ),
                            ],
                          ),
              ),
            ),

            const SizedBox(
              height: 26,
            ),

            const Text(
              'Ejercicios realizados',
              style:
                  TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 6,
            ),

            const Text(
              'Últimos pesos, máximos e historial.',
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
                    'Todavía no hay ejercicios realizados para mostrar.',
                  ),
                ),
              )
            else
              ...resumenEjercicios.map(
                (
                  ejercicio,
                ) {
                  String subtitulo;

                  if (ejercicio.ultimoPeso ==
                      null) {
                    subtitulo =
                        '${ejercicio.veces} entrenamiento${ejercicio.veces == 1 ? '' : 's'}';
                  } else {
                    subtitulo =
                        'Último: ${ejercicio.ultimoPeso!.toStringAsFixed(1)} kg'
                        ' · Máx: ${ejercicio.pesoMaximo!.toStringAsFixed(1)} kg';
                  }

                  return Card(
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
                          Text(
                        subtitulo,
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

            const SizedBox(
              height: 26,
            ),

            const Text(
              'Historial de entrenamientos',
              style:
                  TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            if (entrenamientos.isEmpty)
              const Card(
                child:
                    Padding(
                  padding:
                      EdgeInsets.all(
                    20,
                  ),
                  child:
                      Text(
                    'El alumno todavía no finalizó entrenamientos sincronizados.',
                  ),
                ),
              )
            else
              ...entrenamientos.map(
                (
                  item,
                ) {
                  final entrenamiento =
                      item.entrenamiento;

                  final dia =
                      diaRutina(
                    entrenamiento.rutinaId,
                  );

                  return Card(
                    margin:
                        const EdgeInsets.only(
                      bottom: 10,
                    ),
                    child:
                        ListTile(
                      leading:
                          CircleAvatar(
                        child:
                            Icon(
                          entrenamiento
                                  .esParcial
                              ? Icons
                                  .pie_chart_outline
                              : Icons
                                  .check_circle_outline,
                        ),
                      ),
                      title:
                          Text(
                        dia == null
                            ? nombreRutina(
                                item,
                              )
                            : 'Día $dia · ${nombreRutina(item)}',
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      subtitle:
                          Text(
                        entrenamiento.esParcial
                            ? '${fechaTexto(entrenamiento.fecha)} · Parcial ${entrenamiento.ejerciciosCompletados}/${entrenamiento.totalEjercicios}'
                            : '${fechaTexto(entrenamiento.fecha)} · Completa ${entrenamiento.ejerciciosCompletados}/${entrenamiento.totalEjercicios}',
                      ),
                      trailing:
                          const Icon(
                        Icons
                            .chevron_right,
                      ),
                      onTap:
                          () {
                        mostrarEntrenamiento(
                          item,
                        );
                      },
                    ),
                  );
                },
              ),
          ],
        ),
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

class _RutinaAsignadaCloud {
  final String id;
  final int dia;
  final String nombre;

  const _RutinaAsignadaCloud({
    required this.id,
    required this.dia,
    required this.nombre,
  });
}

class _EntrenamientoCloud {
  final Entrenamiento entrenamiento;
  final String rutinaNombre;

  const _EntrenamientoCloud({
    required this.entrenamiento,
    required this.rutinaNombre,
  });
}

class _ResumenEjercicio {
  final String ejercicioId;
  final String nombre;
  final int veces;
  final double? ultimoPeso;
  final double? pesoMaximo;
  final List<_RegistroConFecha> registros;

  const _ResumenEjercicio({
    required this.ejercicioId,
    required this.nombre,
    required this.veces,
    required this.ultimoPeso,
    required this.pesoMaximo,
    required this.registros,
  });
}

class _ResumenEjercicioMutable {
  final String ejercicioId;
  final String nombre;
  final List<_RegistroConFecha> registros = [];

  _ResumenEjercicioMutable({
    required this.ejercicioId,
    required this.nombre,
  });
}

class _RegistroConFecha {
  final DateTime fecha;
  final RegistroEjercicio registro;

  const _RegistroConFecha({
    required this.fecha,
    required this.registro,
  });
}
