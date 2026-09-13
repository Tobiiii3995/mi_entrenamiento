import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../modelos/rutina.dart';
import '../modelos/entrenamiento.dart';
import '../modelos/estado_entrenamiento.dart';
import '../repositorios/entrenamiento_en_curso_repositorio.dart';
import '../repositorios/entrenamiento_repositorio.dart';
import '../servicios/base_datos_servicio.dart';
import '../servicios/datos_app.dart';
import '../widgets/dato_ejercicio.dart';
import '../widgets/dialogo_demostracion.dart';

class DetalleRutinaPagina extends StatefulWidget {
  final Rutina rutina;

  const DetalleRutinaPagina({
    super.key,
    required this.rutina,
  });

  @override
  State<DetalleRutinaPagina> createState() =>
      _DetalleRutinaPaginaState();
}

class _DetalleRutinaPaginaState
    extends State<DetalleRutinaPagina> {
  late final EntrenamientoEnCursoRepositorio
      entrenamientoEnCursoRepositorio;

  late final EntrenamientoRepositorio
      entrenamientoRepositorio;

  EntrenamientoEnCurso? entrenamientoEnCurso;

  final Map<String, double> pesosAnteriores = {};

  List<TextEditingController> pesoControllers = [];
  List<TextEditingController> notaControllers = [];

  bool cargando = true;
  bool finalizando = false;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _suscripcionRutina;

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
      _suscripcionVinculo;

  bool _cerrandoPorRetiro = false;
  bool _rutinaDisponible = true;

  @override
  void initState() {
    super.initState();

    entrenamientoEnCursoRepositorio =
        EntrenamientoEnCursoRepositorio(
      BaseDatosServicio.db,
    );

    entrenamientoRepositorio =
        EntrenamientoRepositorio(
      BaseDatosServicio.db,
    );

    cargarEntrenamiento();
    _escucharDisponibilidadRutina();
  }

  void _escucharDisponibilidadRutina() {
    final alumnoId =
        DatosApp.usuarioActual.id;

    _suscripcionRutina =
        FirebaseFirestore.instance
            .collection(
              'rutinasAsignadas',
            )
            .doc(
              widget.rutina.id,
            )
            .snapshots(
              includeMetadataChanges:
                  true,
            )
            .listen(
      (documento) {
        if (documento
            .metadata
            .isFromCache) {
          return;
        }

        final datos =
            documento.data();

        final sigueActiva =
            documento.exists &&
                datos != null &&
                datos['activa'] ==
                    true &&
                (datos['alumnoId'] ??
                        '')
                    .toString() ==
                    alumnoId;

        if (!sigueActiva) {
          _cerrarPorRetiro(
            'Esta rutina ya no está disponible.',
          );
        }
      },
      onError: (_) {},
    );

    _suscripcionVinculo =
        FirebaseFirestore.instance
            .collection(
              'vinculosActivos',
            )
            .doc(
              alumnoId,
            )
            .snapshots(
              includeMetadataChanges:
                  true,
            )
            .listen(
      (documento) {
        if (documento
            .metadata
            .isFromCache) {
          return;
        }

        final datos =
            documento.data();

        final sigueVinculado =
            documento.exists &&
                datos != null &&
                datos['estado'] ==
                    'activa' &&
                (datos['alumnoId'] ??
                        '')
                    .toString() ==
                    alumnoId;

        if (!sigueVinculado) {
          _cerrarPorRetiro(
            'Tu vínculo con el profesor ya no está activo.',
          );
        }
      },
      onError: (_) {},
    );
  }

  void _cerrarPorRetiro(
    String mensaje,
  ) {
    if (_cerrandoPorRetiro ||
        !_rutinaDisponible) {
      return;
    }

    _cerrandoPorRetiro =
        true;
    _rutinaDisponible =
        false;

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

    Navigator.of(context).pop();
  }

  Future<void> cargarEntrenamiento() async {
    final alumnoId =
        DatosApp.usuarioActual.id;

    final ultimosPesos =
        await entrenamientoRepositorio
            .obtenerUltimosPesosEjercicios(
      alumnoId,
    );

    pesosAnteriores
      ..clear()
      ..addAll(ultimosPesos);

    final entrenamiento =
        await entrenamientoEnCursoRepositorio
            .obtenerOCrear(
      alumnoId: alumnoId,
      rutina: widget.rutina,
    );

    pesoControllers =
        entrenamiento.ejercicios.map(
      (estado) {
        return TextEditingController(
          text: estado.peso,
        );
      },
    ).toList();

    notaControllers =
        entrenamiento.ejercicios.map(
      (estado) {
        return TextEditingController(
          text: estado.nota,
        );
      },
    ).toList();

    DatosApp.establecerEntrenamientoEnCurso(
      entrenamiento,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      entrenamientoEnCurso = entrenamiento;
      cargando = false;
    });
  }

  @override
  void dispose() {
    _suscripcionRutina
        ?.cancel();

    _suscripcionVinculo
        ?.cancel();

    for (final controller in pesoControllers) {
      controller.dispose();
    }

    for (final controller in notaControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  void sincronizarCamposConEstado() {
    final entrenamiento = entrenamientoEnCurso;

    if (entrenamiento == null) {
      return;
    }

    for (int i = 0;
        i < entrenamiento.ejercicios.length;
        i++) {
      if (i < pesoControllers.length) {
        entrenamiento.ejercicios[i].peso =
            pesoControllers[i].text;
      }

      if (i < notaControllers.length) {
        entrenamiento.ejercicios[i].nota =
            notaControllers[i].text;
      }
    }
  }

  String? primerPesoFaltanteEnCompletados() {
    final entrenamiento = entrenamientoEnCurso;

    if (entrenamiento == null) {
      return null;
    }

    sincronizarCamposConEstado();

    for (int i = 0;
        i < widget.rutina.ejercicios.length;
        i++) {
      final ejercicio =
          widget.rutina.ejercicios[i];

      final estado =
          entrenamiento.ejercicios[i];

      if (!estado.completado ||
          !ejercicio.llevaPeso) {
        continue;
      }

      final pesoTexto =
          i < pesoControllers.length
              ? pesoControllers[i].text
              : estado.peso;

      final peso = double.tryParse(
        pesoTexto
            .replaceAll(',', '.')
            .trim(),
      );

      if (peso == null || peso <= 0) {
        return ejercicio.nombre;
      }
    }

    return null;
  }

  List<String> ejerciciosPendientes() {
    final entrenamiento = entrenamientoEnCurso;

    if (entrenamiento == null) {
      return const [];
    }

    final pendientes = <String>[];

    for (int i = 0;
        i < widget.rutina.ejercicios.length;
        i++) {
      if (!entrenamiento.ejercicios[i].completado) {
        pendientes.add(
          widget.rutina.ejercicios[i].nombre,
        );
      }
    }

    return pendientes;
  }

  Future<void> guardarEstadoEjercicio(
    int index,
  ) async {
    final entrenamiento =
        entrenamientoEnCurso;

    if (entrenamiento == null ||
        !_rutinaDisponible) {
      return;
    }

    final estado =
        entrenamiento.ejercicios[index];

    await entrenamientoEnCursoRepositorio
        .actualizarEjercicio(
      entrenamiento: entrenamiento,
      orden: index,
      estado: estado,
    );
  }

  Future<void> cambiarCompletado(
    int index,
  ) async {
    final entrenamiento =
        entrenamientoEnCurso;

    if (entrenamiento == null ||
        !_rutinaDisponible) {
      return;
    }

    setState(() {
      entrenamiento
              .ejercicios[index]
              .completado =
          !entrenamiento
              .ejercicios[index]
              .completado;
    });

    await guardarEstadoEjercicio(index);
  }

  Future<void> intentarFinalizarRutina() async {
    if (finalizando ||
        !_rutinaDisponible) {
      return;
    }

    sincronizarCamposConEstado();

    // Si el alumno marcó un ejercicio como realizado y ese
    // ejercicio exige peso, el peso es obligatorio para cerrar.
    final pesoFaltante =
        primerPesoFaltanteEnCompletados();

    if (pesoFaltante != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Marcaste $pesoFaltante como completado, pero falta ingresar un peso válido.',
          ),
        ),
      );

      return;
    }

    final pendientes =
        ejerciciosPendientes();

    final completados = entrenamientoEnCurso!
        .ejercicios
        .where((estado) => estado.completado)
        .length;

    if (completados == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Para finalizar la rutina debés completar al menos un ejercicio.',
          ),
        ),
      );
      return;
    }

    String mensaje;

    if (pendientes.isEmpty) {
      mensaje =
          '¿Confirmás que terminaste esta rutina? '
          'Al finalizar quedará guardada en tu progreso.';
    } else {
      final nombres = pendientes.join(', ');

      mensaje =
          'Quedaron ${pendientes.length} ejercicio${pendientes.length == 1 ? '' : 's'} sin realizar:\n\n'
          '$nombres\n\n'
          'Si finalizás igualmente, la rutina quedará registrada como parcial y también sumará en tu progreso.';
    }

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            pendientes.isEmpty
                ? 'Finalizar rutina'
                : 'Finalizar rutina parcial',
          ),
          content: Text(
            mensaje,
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
                'Volver',
              ),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: Text(
                pendientes.isEmpty
                    ? 'Sí, finalizar'
                    : 'Finalizar igualmente',
              ),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await finalizarRutina();
    }
  }

  Future<void> finalizarRutina() async {
    if (finalizando ||
        !_rutinaDisponible) {
      return;
    }

    final entrenamientoCurso =
        entrenamientoEnCurso;

    if (entrenamientoCurso == null) {
      return;
    }

    sincronizarCamposConEstado();

    // Segunda validación por seguridad antes de guardar.
    final pesoFaltante =
        primerPesoFaltanteEnCompletados();

    if (pesoFaltante != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Falta ingresar un peso válido en $pesoFaltante.',
          ),
        ),
      );
      return;
    }

    setState(() {
      finalizando = true;
    });

    try {
      final registros =
          <RegistroEjercicio>[];

      for (int i = 0;
          i < widget.rutina.ejercicios.length;
          i++) {
        final ejercicio =
            widget.rutina.ejercicios[i];

        final estado =
            entrenamientoCurso.ejercicios[i];

        double? pesoUsado;

        if (estado.completado &&
            ejercicio.llevaPeso) {
          pesoUsado = double.tryParse(
            estado.peso
                .replaceAll(',', '.')
                .trim(),
          );
        }

        registros.add(
          RegistroEjercicio(
            ejercicioId:
                ejercicio.id,
            nombreEjercicio:
                ejercicio.nombre,
            series:
                ejercicio.series,
            repeticiones:
                ejercicio.repeticiones,
            llevaPeso:
                ejercicio.llevaPeso,
            pesoUsado:
                estado.completado
                    ? pesoUsado
                    : null,
            nota:
                estado.nota.trim(),
            completado:
                estado.completado,
          ),
        );
      }

      final ahora = DateTime.now();

      final entrenamientoFinalizado =
          Entrenamiento(
        id: ahora.microsecondsSinceEpoch
            .toString(),
        rutinaId:
            widget.rutina.id,
        fecha:
            ahora,
        ejercicios:
            registros,
        // true = sesión cerrada. Los ejercicios internos
        // determinan si fue completa o parcial.
        completado:
            true,
      );

      await entrenamientoRepositorio
          .guardarEntrenamientoFinalizado(
        entrenamiento:
            entrenamientoFinalizado,
        alumnoId:
            DatosApp.usuarioActual.id,
        entrenamientoEnCursoId:
            entrenamientoCurso.id,
        rutinaNombre:
            widget.rutina.nombre,
      );

      DatosApp.entrenamientosRealizados.add(
        entrenamientoFinalizado,
      );

      DatosApp.eliminarEntrenamientoEnCurso(
        widget.rutina.id,
      );

      if (!mounted) {
        return;
      }

      final mensaje =
          entrenamientoFinalizado.esParcial
              ? 'Rutina parcial guardada: ${entrenamientoFinalizado.ejerciciosCompletados}/${entrenamientoFinalizado.totalEjercicios} ejercicios. También suma en tu progreso.'
              : 'Rutina finalizada y guardada.';

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            mensaje,
          ),
        ),
      );

      Navigator.pop(context);
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        finalizando = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo finalizar la rutina: $error',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cargando ||
        entrenamientoEnCurso == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Día ${widget.rutina.dia}',
          ),
        ),
        body: const Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    final entrenamiento =
        entrenamientoEnCurso!;

    final completados =
        entrenamiento.ejercicios
            .where(
              (estado) =>
                  estado.completado,
            )
            .length;


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Día ${widget.rutina.dia}',
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding:
              const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            80,
          ),
          children: [
            Text(
              widget.rutina.nombre,
              style: const TextStyle(
                fontSize: 26,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              '$completados de '
              '${widget.rutina.ejercicios.length} '
              'ejercicios completados',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 12),

            LinearProgressIndicator(
              value: widget.rutina
                      .ejercicios.isEmpty
                  ? 0
                  : completados /
                      widget.rutina
                          .ejercicios.length,
              minHeight: 7,
              borderRadius:
                  BorderRadius.circular(10),
            ),

            const SizedBox(height: 24),

            ...widget.rutina.ejercicios
                .asMap()
                .entries
                .map(
              (entrada) {
                final index =
                    entrada.key;

                final ejercicio =
                    entrada.value;

                final estado =
                    entrenamiento
                        .ejercicios[index];

                final pesoAnterior =
                    pesosAnteriores[
                        ejercicio.id];

                return Card(
                  margin:
                      const EdgeInsets.only(
                    bottom: 16,
                  ),
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
                            Expanded(
                              child: Text(
                                ejercicio.nombre,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                  decoration:
                                      estado
                                              .completado
                                          ? TextDecoration
                                              .lineThrough
                                          : TextDecoration
                                              .none,
                                ),
                              ),
                            ),

                            IconButton(
                              onPressed:
                                  finalizando
                                      ? null
                                      : () {
                                          cambiarCompletado(
                                            index,
                                          );
                                        },
                              icon: Icon(
                                estado.completado
                                    ? Icons
                                        .check_circle
                                    : Icons
                                        .radio_button_unchecked,
                                size: 32,
                                color: estado
                                        .completado
                                    ? Colors.green
                                    : null,
                              ),
                            ),
                          ],
                        ),

                        if (ejercicio.urlMedia != null &&
                            ejercicio.urlMedia!.trim().isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (_) => DialogoDemostracion(
                                    nombreEjercicio: ejercicio.nombre,
                                    urlMedia: ejercicio.urlMedia!,
                                  ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              icon: const Icon(
                                Icons.play_circle_outline,
                                size: 18,
                              ),
                              label: const Text(
                                'Ver ejemplo',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(
                          height: 14,
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            DatoEjercicio(
                              titulo:
                                  'Series',
                              valor:
                                  ejercicio
                                      .series
                                      .toString(),
                            ),
                            DatoEjercicio(
                              titulo:
                                  'Reps',
                              valor:
                                  ejercicio
                                      .repeticiones,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 12,
                        ),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .spaceBetween,
                          children: [
                            DatoEjercicio(
                              titulo:
                                  'Descanso',
                              valor:
                                  '${ejercicio.descansoSegundos} seg',
                            ),

                            if (ejercicio
                                .llevaPeso)
                              DatoEjercicio(
                                titulo:
                                    'Peso anterior',
                                valor:
                                    pesoAnterior ==
                                            null
                                        ? 'Sin registro'
                                        : '${pesoAnterior.toStringAsFixed(1)} kg',
                              ),
                          ],
                        ),

                        if (ejercicio
                            .llevaPeso) ...[
                          const SizedBox(
                            height: 18,
                          ),

                          TextField(
                            controller:
                                pesoControllers[
                                    index],
                            enabled:
                                !finalizando,
                            keyboardType:
                                const TextInputType
                                    .numberWithOptions(
                              decimal: true,
                            ),
                            onChanged:
                                (valor) {
                              estado.peso =
                                  valor;

                              guardarEstadoEjercicio(
                                index,
                              );
                            },
                            decoration:
                                const InputDecoration(
                              labelText:
                                  'Peso de hoy',
                              suffixText:
                                  'kg',
                              border:
                                  OutlineInputBorder(),
                              prefixIcon:
                                  Icon(
                                Icons
                                    .fitness_center,
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(
                          height: 14,
                        ),

                        TextField(
                          controller:
                              notaControllers[
                                  index],
                          enabled:
                              !finalizando,
                          maxLines: 2,
                          onChanged:
                              (valor) {
                            estado.nota =
                                valor;

                            guardarEstadoEjercicio(
                              index,
                            );
                          },
                          decoration:
                              const InputDecoration(
                            labelText:
                                'Notas',
                            hintText:
                                'Ej: me costó la última serie',
                            border:
                                OutlineInputBorder(),
                            prefixIcon:
                                Icon(
                              Icons
                                  .note_alt_outlined,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 14,
                        ),

                        SizedBox(
                          width:
                              double.infinity,
                          child:
                              OutlinedButton
                                  .icon(
                            onPressed:
                                finalizando
                                    ? null
                                    : () {
                                        cambiarCompletado(
                                          index,
                                        );
                                      },
                            icon: Icon(
                              estado.completado
                                  ? Icons
                                      .check_circle
                                  : Icons
                                      .check_circle_outline,
                            ),
                            label: Text(
                              estado.completado
                                  ? 'Ejercicio completado'
                                  : 'Marcar como completado',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(
              height: 10,
            ),

            Card(
              child: Padding(
                padding:
                    const EdgeInsets.all(
                  20,
                ),
                child: Column(
                  children: [
                    Icon(
                      completados ==
                              widget.rutina.ejercicios.length
                          ? Icons.emoji_events
                          : Icons.flag_outlined,
                      size: 48,
                    ),

                    const SizedBox(
                      height: 10,
                    ),

                    Text(
                      completados ==
                              widget.rutina.ejercicios.length
                          ? '¡Todos los ejercicios están completados!'
                          : 'Podés finalizar aunque queden ejercicios pendientes.',
                      textAlign:
                          TextAlign.center,
                      style:
                          const TextStyle(
                        fontSize: 21,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      completados ==
                              widget.rutina.ejercicios.length
                          ? 'Revisá los pesos antes de finalizar.'
                          : 'Si confirmás, se guardará como parcial y también contará en tu progreso.',
                      textAlign:
                          TextAlign.center,
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    SizedBox(
                      width:
                          double.infinity,
                      child:
                          FilledButton.icon(
                        onPressed:
                            finalizando
                                ? null
                                : intentarFinalizarRutina,
                        icon:
                            finalizando
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(
                                    Icons.flag,
                                  ),
                        label: Text(
                          finalizando
                              ? 'Guardando...'
                              : 'Finalizar rutina',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}