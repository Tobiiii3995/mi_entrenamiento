import 'package:flutter/material.dart';

import '../modelos/entrenamiento.dart';
import '../modelos/rutina.dart';
import '../repositorios/asignacion_rutina_repositorio.dart';
import '../servicios/base_datos_servicio.dart';
import '../servicios/datos_app.dart';
import '../servicios/validacion_diaria_servicio.dart';
import 'detalle_entrenamiento_pagina.dart';
import 'detalle_rutina_pagina.dart';

class RutinasPagina extends StatefulWidget {
  const RutinasPagina({
    super.key,
  });

  @override
  State<RutinasPagina> createState() =>
      _RutinasPaginaState();
}

class _RutinasPaginaState
    extends State<RutinasPagina>
    with WidgetsBindingObserver {
  late final AsignacionRutinaRepositorio
      asignacionRepositorio;

  bool validandoAcceso = true;
  bool accesoRutinasHabilitado = false;
  bool necesitaInternet = false;
  String? mensajeValidacion;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(
      this,
    );

    asignacionRepositorio =
        AsignacionRutinaRepositorio(
      BaseDatosServicio.db,
    );

    comprobarAccesoDiario();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(
      this,
    );

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state ==
        AppLifecycleState.resumed) {
      comprobarAccesoDiario(
        mostrarCarga:
            false,
      );
    }
  }

  Future<bool> comprobarAccesoDiario({
    bool mostrarCarga = true,
  }) async {
    if (mostrarCarga &&
        mounted) {
      setState(() {
        validandoAcceso =
            true;
      });
    }

    final resultado =
        await ValidacionDiariaServicio
            .comprobarParaEntrenar();

    if (!mounted) {
      return false;
    }

    setState(() {
      validandoAcceso =
          false;

      accesoRutinasHabilitado =
          resultado.valida &&
              resultado
                  .habilitadoParaEntrenar;

      necesitaInternet =
          resultado.necesitaInternet;

      mensajeValidacion =
          resultado.mensaje;
    });

    return accesoRutinasHabilitado;
  }

  Future<bool> validarAccesoOnline() async {
    if (mounted) {
      setState(() {
        validandoAcceso =
            true;
      });
    }

    final resultado =
        await ValidacionDiariaServicio
            .validarOnlineAhora();

    if (!mounted) {
      return false;
    }

    final habilitado =
        resultado.valida &&
            resultado
                .habilitadoParaEntrenar;

    setState(() {
      validandoAcceso =
          false;

      accesoRutinasHabilitado =
          habilitado;

      necesitaInternet =
          resultado.necesitaInternet;

      mensajeValidacion =
          resultado.mensaje;
    });

    return habilitado;
  }

  Future<bool>
      asegurarAccesoAntesDeAbrir() async {
    final resultado =
        await ValidacionDiariaServicio
            .comprobarParaEntrenar();

    if (!mounted) {
      return false;
    }

    final habilitado =
        resultado.valida &&
            resultado
                .habilitadoParaEntrenar;

    if (!habilitado) {
      setState(() {
        validandoAcceso =
            false;

        accesoRutinasHabilitado =
            false;

        necesitaInternet =
            resultado.necesitaInternet;

        mensajeValidacion =
            resultado.mensaje;
      });

      return false;
    }

    if (!accesoRutinasHabilitado) {
      setState(() {
        accesoRutinasHabilitado =
            true;

        necesitaInternet =
            false;

        mensajeValidacion =
            null;
      });
    }

    return true;
  }

  Widget construirBloqueoValidacion() {
    final mensaje =
        mensajeValidacion ??
            (necesitaInternet
                ? 'Conectate a internet para validar tu cuenta y actualizar tus rutinas de hoy.'
                : 'Tus rutinas no están habilitadas en este momento.');

    return SafeArea(
      child:
          Center(
        child:
            SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            28,
          ),
          child:
              Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Icon(
                necesitaInternet
                    ? Icons
                        .wifi_off_outlined
                    : Icons
                        .person_off_outlined,
                size:
                    64,
              ),

              const SizedBox(
                height:
                    18,
              ),

              Text(
                necesitaInternet
                    ? 'Conexión necesaria'
                    : 'Rutinas no disponibles',
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  fontSize:
                      23,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height:
                    10,
              ),

              Text(
                mensaje,
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  fontSize:
                      16,
                  color:
                      Colors.grey,
                ),
              ),

              if (necesitaInternet) ...[
                const SizedBox(
                  height:
                      20,
                ),

                FilledButton.icon(
                  onPressed:
                      validandoAcceso
                          ? null
                          : () {
                              validarAccesoOnline();
                            },
                  icon:
                      const Icon(
                    Icons
                        .sync,
                  ),
                  label:
                      const Text(
                    'Reintentar conexión',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  DateTime inicioSemana(
    DateTime fecha,
  ) {
    final fechaLimpia = DateTime(
      fecha.year,
      fecha.month,
      fecha.day,
    );

    return fechaLimpia.subtract(
      Duration(
        days:
            fecha.weekday - DateTime.monday,
      ),
    );
  }

  bool mismaFecha(
    DateTime a,
    DateTime b,
  ) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }

  Entrenamiento?
      obtenerEntrenamientoSemana(
    Rutina rutina,
  ) {
    final ahora = DateTime.now();

    final lunes = inicioSemana(
      ahora,
    );

    final lunesSiguiente = lunes.add(
      const Duration(
        days: 7,
      ),
    );

    final realizados = DatosApp
        .entrenamientosRealizados
        .where(
      (entrenamiento) {
        return entrenamiento.completado &&
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

    if (realizados.isEmpty) {
      return null;
    }

    realizados.sort(
      (a, b) =>
          b.fecha.compareTo(
        a.fecha,
      ),
    );

    return realizados.first;
  }

  Entrenamiento?
      obtenerEntrenamientoFinalizadoHoy() {
    final ahora = DateTime.now();

    final realizadosHoy = DatosApp
        .entrenamientosRealizados
        .where(
      (entrenamiento) {
        return entrenamiento.completado &&
            mismaFecha(
              entrenamiento.fecha,
              ahora,
            );
      },
    ).toList();

    if (realizadosHoy.isEmpty) {
      return null;
    }

    realizadosHoy.sort(
      (a, b) =>
          b.fecha.compareTo(
        a.fecha,
      ),
    );

    return realizadosHoy.first;
  }

  bool get yaFinalizoRutinaHoy =>
      obtenerEntrenamientoFinalizadoHoy() !=
      null;

  int? obtenerSiguienteDiaPendiente(
    List<Rutina> rutinas,
  ) {
    final ordenadas = [
      ...rutinas,
    ];

    ordenadas.sort(
      (a, b) =>
          a.dia.compareTo(
        b.dia,
      ),
    );

    for (final rutina in ordenadas) {
      final finalizada =
          obtenerEntrenamientoSemana(
                rutina,
              ) !=
              null;

      if (!finalizada) {
        return rutina.dia;
      }
    }

    return null;
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

  Future<void> abrirRutina(
    Rutina rutina,
    List<Rutina> rutinas,
  ) async {
    final acceso =
        await asegurarAccesoAntesDeAbrir();

    if (!mounted ||
        !acceso) {
      return;
    }

    final entrenamientoSemana =
        obtenerEntrenamientoSemana(
      rutina,
    );

    //
    // Si esta rutina ya fue finalizada esta
    // semana, abrimos solamente su detalle.
    //
    if (entrenamientoSemana != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) =>
                  DetalleEntrenamientoPagina(
            entrenamiento:
                entrenamientoSemana,
            rutina:
                rutina,
          ),
        ),
      );

      if (mounted) {
        setState(() {});
      }

      return;
    }

    final siguienteDia =
        obtenerSiguienteDiaPendiente(
      rutinas,
    );

    //
    // Primero respetamos el orden Día 1,
    // Día 2, Día 3...
    //
    if (siguienteDia !=
        rutina.dia) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text(
            siguienteDia == null
                ? 'Ya finalizaste todas las rutinas de esta semana.'
                : 'Primero corresponde completar el Día $siguienteDia.',
          ),
        ),
      );

      return;
    }

    //
    // REGLA DEFINITIVA:
    // máximo una rutina FINALIZADA por día.
    //
    // Una rutina parcial también se considera
    // finalizada y bloquea comenzar la siguiente
    // hasta el próximo día calendario.
    //
    if (yaFinalizoRutinaHoy) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text(
            'Ya finalizaste una rutina hoy. '
            'El próximo día de entrenamiento se habilita mañana.',
          ),
        ),
      );

      return;
    }

    await abrirRutinaParaEntrenar(
      rutina,
    );
  }

  Future<void>
      abrirRutinaParaEntrenar(
    Rutina rutina,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                DetalleRutinaPagina(
          rutina:
              rutina,
        ),
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (validandoAcceso) {
      return const SafeArea(
        child:
            Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    if (!accesoRutinasHabilitado) {
      return construirBloqueoValidacion();
    }

    return SafeArea(
      child:
          StreamBuilder<
              List<Rutina>>(
        stream:
            asignacionRepositorio
                .escucharRutinasAlumnoFirestore(),
        builder:
            (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child:
                  Padding(
                padding:
                    EdgeInsets.all(
                  30,
                ),
                child:
                    Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 50,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      'No se pudieron cargar tus rutinas.',
                      textAlign:
                          TextAlign.center,
                      style:
                          TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final rutinas = [
            ...(snapshot.data ??
                const <Rutina>[]),
          ];

          rutinas.sort(
            (a, b) =>
                a.dia.compareTo(
              b.dia,
            ),
          );

          final siguienteDia =
              obtenerSiguienteDiaPendiente(
            rutinas,
          );

          final entrenamientoHoy =
              obtenerEntrenamientoFinalizadoHoy();

          return Padding(
            padding:
                const EdgeInsets.all(
              20,
            ),
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rutinas',
                  style:
                      TextStyle(
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                const Text(
                  'Entrenamiento semanal flexible',
                  style:
                      TextStyle(
                    fontSize: 16,
                    color:
                        Colors.grey,
                  ),
                ),

                if (entrenamientoHoy !=
                    null) ...[
                  const SizedBox(
                    height: 18,
                  ),

                  Card(
                    child:
                        Padding(
                      padding:
                          const EdgeInsets.all(
                        14,
                      ),
                      child:
                          Row(
                        children: [
                          const Icon(
                            Icons
                                .event_available_outlined,
                          ),

                          const SizedBox(
                            width: 12,
                          ),

                          const Expanded(
                            child:
                                Text(
                              'Entrenamiento de hoy finalizado. '
                              'El siguiente día se habilita mañana.',
                              style:
                                  TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(
                  height: 24,
                ),

                if (rutinas.isEmpty)
                  const Expanded(
                    child:
                        Center(
                      child:
                          Padding(
                        padding:
                            EdgeInsets.all(
                          30,
                        ),
                        child:
                            Column(
                          mainAxisSize:
                              MainAxisSize.min,
                          children: [
                            Icon(
                              Icons
                                  .assignment_outlined,
                              size: 60,
                            ),
                            SizedBox(
                              height: 14,
                            ),
                            Text(
                              'Todavía no tenés rutinas asignadas.',
                              textAlign:
                                  TextAlign.center,
                              style:
                                  TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Cuando tu profesor te asigne una rutina aparecerá acá.',
                              textAlign:
                                  TextAlign.center,
                              style:
                                  TextStyle(
                                color:
                                    Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child:
                        ListView.builder(
                      itemCount:
                          rutinas.length,
                      itemBuilder:
                          (
                        context,
                        index,
                      ) {
                        final rutina =
                            rutinas[index];

                        final entrenamientoSemana =
                            obtenerEntrenamientoSemana(
                          rutina,
                        );

                        final finalizada =
                            entrenamientoSemana !=
                                null;

                        final disponiblePorOrden =
                            !finalizada &&
                                siguienteDia ==
                                    rutina.dia;

                        final bloqueadaPorHoy =
                            disponiblePorOrden &&
                                yaFinalizoRutinaHoy;

                        final bloqueadaPorOrden =
                            !finalizada &&
                                !disponiblePorOrden;

                        final disponible =
                            disponiblePorOrden &&
                                !bloqueadaPorHoy;

                        String subtitulo;

                        if (finalizada) {
                          if (entrenamientoSemana
                              .esParcial) {
                            subtitulo =
                                '${rutina.nombre}\n'
                                'Parcial ${entrenamientoSemana.ejerciciosCompletados}/${entrenamientoSemana.totalEjercicios} · '
                                '${fechaTexto(entrenamientoSemana.fecha)}';
                          } else {
                            subtitulo =
                                '${rutina.nombre}\n'
                                'Completa · ${fechaTexto(entrenamientoSemana.fecha)}';
                          }
                        } else if (bloqueadaPorHoy) {
                          subtitulo =
                              '${rutina.nombre}\nDisponible mañana';
                        } else if (disponible) {
                          subtitulo =
                              '${rutina.nombre}\nSiguiente entrenamiento';
                        } else {
                          subtitulo =
                              '${rutina.nombre}\nPendiente';
                        }

                        return Card(
                          margin:
                              const EdgeInsets.only(
                            bottom: 14,
                          ),
                          child:
                              ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading:
                                CircleAvatar(
                              radius: 26,
                              child:
                                  finalizada
                                      ? Icon(
                                          entrenamientoSemana
                                                  .esParcial
                                              ? Icons
                                                  .pie_chart_outline
                                              : Icons.check,
                                        )
                                      : bloqueadaPorHoy ||
                                              bloqueadaPorOrden
                                          ? const Icon(
                                              Icons
                                                  .lock_outline,
                                            )
                                          : Text(
                                              '${rutina.dia}',
                                              style:
                                                  const TextStyle(
                                                fontWeight:
                                                    FontWeight.bold,
                                              ),
                                            ),
                            ),
                            title:
                                Text(
                              'Día ${rutina.dia}',
                              style:
                                  const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                            subtitle:
                                Padding(
                              padding:
                                  const EdgeInsets.only(
                                top: 4,
                              ),
                              child:
                                  Text(
                                subtitulo,
                              ),
                            ),
                            isThreeLine:
                                true,
                            trailing:
                                Icon(
                              finalizada
                                  ? Icons
                                      .chevron_right
                                  : disponible
                                      ? Icons
                                          .play_arrow
                                      : Icons
                                          .lock_outline,
                            ),
                            onTap:
                                () {
                              abrirRutina(
                                rutina,
                                rutinas,
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
