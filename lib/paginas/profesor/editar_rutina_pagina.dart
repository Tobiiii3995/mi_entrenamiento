import 'package:flutter/material.dart';

import '../../modelos/ejercicio_catalogo.dart';
import '../../modelos/rutina_editor.dart';
import '../../repositorios/ejercicio_repositorio.dart';
import '../../repositorios/rutina_profesor_repositorio.dart';
import '../../servicios/base_datos_servicio.dart';
import 'editar_ejercicio_pagina.dart';

class EditarRutinaPagina extends StatefulWidget {
  final String profesorId;
  final RutinaEditor? rutina;

  const EditarRutinaPagina({
    super.key,
    required this.profesorId,
    this.rutina,
  });

  bool get esEdicion => rutina != null;

  @override
  State<EditarRutinaPagina> createState() =>
      _EditarRutinaPaginaState();
}

class _EditarRutinaPaginaState extends State<EditarRutinaPagina> {
  late final RutinaProfesorRepositorio rutinaRepositorio;
  late final EjercicioRepositorio ejercicioRepositorio;

  late final TextEditingController nombreController;
  late final TextEditingController descripcionController;

  final List<EjercicioRutinaEditor> ejerciciosSeleccionados = [];

  bool cargandoBiblioteca = true;
  bool guardando = false;

  List<EjercicioCatalogo> biblioteca = [];

  @override
  void initState() {
    super.initState();

    rutinaRepositorio = RutinaProfesorRepositorio(
      BaseDatosServicio.db,
    );

    ejercicioRepositorio = EjercicioRepositorio(
      BaseDatosServicio.db,
    );

    nombreController = TextEditingController(
      text: widget.rutina?.nombre ?? '',
    );

    descripcionController = TextEditingController(
      text: widget.rutina?.descripcion ?? '',
    );

    if (widget.rutina != null) {
      ejerciciosSeleccionados.addAll(
        widget.rutina!.ejercicios.map(
          (item) {
            return EjercicioRutinaEditor(
              idRelacion: item.idRelacion,
              ejercicio: item.ejercicio,
              orden: item.orden,
              series: item.series,
              repeticiones: item.repeticiones,
              descansoSegundos: item.descansoSegundos,
              observaciones: item.observaciones,
            );
          },
        ),
      );
    }

    cargarBiblioteca();
  }

  @override
  void dispose() {
    nombreController.dispose();
    descripcionController.dispose();

    super.dispose();
  }

  Future<void> cargarBiblioteca() async {
    final resultado =
        await ejercicioRepositorio.obtenerEjerciciosDelProfesor(
      widget.profesorId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      biblioteca = resultado;
      cargandoBiblioteca = false;
    });
  }

  bool ejercicioYaAgregado(
    String ejercicioId,
  ) {
    return ejerciciosSeleccionados.any(
      (item) => item.ejercicio.id == ejercicioId,
    );
  }

  Future<void> crearNuevoEjercicioDesdeRutina([BuildContext? modalContext]) async {
    final creado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditarEjercicioPagina(
          profesorId: widget.profesorId,
        ),
      ),
    );

    if (creado == true) {
      await cargarBiblioteca();
      if (modalContext != null && modalContext.mounted) {
        Navigator.pop(modalContext);
      }
      if (biblioteca.isNotEmpty) {
        final nuevo = biblioteca.last;
        if (!ejercicioYaAgregado(nuevo.id)) {
          agregarEjercicio(nuevo);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('¡"${nuevo.nombre}" añadido a la rutina!'),
              ),
            );
          }
        }
      }
    }
  }

  Future<void> mostrarSelectorEjercicios() async {
    if (cargandoBiblioteca) {
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return SafeArea(
          child: FractionallySizedBox(
            heightFactor: 0.85,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    16,
                    20,
                    12,
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Agregar ejercicio',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      FilledButton.tonalIcon(
                        onPressed: () => crearNuevoEjercicioDesdeRutina(bottomSheetContext),
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Nuevo'),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                if (biblioteca.isEmpty)
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.fitness_center,
                              size: 52,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Todavía no tenés ejercicios en tu biblioteca.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Podés crear uno ahora mismo sin salir de la rutina.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 20),
                            FilledButton.icon(
                              onPressed: () => crearNuevoEjercicioDesdeRutina(bottomSheetContext),
                              icon: const Icon(Icons.add),
                              label: const Text('Crear ejercicio'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: biblioteca.length,
                      itemBuilder: (context, index) {
                        final ejercicio = biblioteca[index];

                        final agregado = ejercicioYaAgregado(
                          ejercicio.id,
                        );

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(
                                ejercicio.llevaPeso
                                    ? Icons.fitness_center
                                    : Icons.directions_run,
                              ),
                            ),
                            title: Text(
                              ejercicio.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: ejercicio.grupoMuscular.trim().isEmpty
                                ? null
                                : Text(
                                    ejercicio.grupoMuscular,
                                  ),
                            trailing: agregado
                                ? const Icon(
                                    Icons.check_circle,
                                  )
                                : const Icon(
                                    Icons.add_circle_outline,
                                  ),
                            enabled: !agregado,
                            onTap: agregado
                                ? null
                                : () {
                                    agregarEjercicio(
                                      ejercicio,
                                    );

                                    Navigator.pop(bottomSheetContext);
                                  },
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void agregarEjercicio(
    EjercicioCatalogo ejercicio,
  ) {
    final ahora = DateTime.now();

    setState(() {
      ejerciciosSeleccionados.add(
        EjercicioRutinaEditor(
          idRelacion:
              'rel_${ahora.microsecondsSinceEpoch}_${ejercicio.id}',
          ejercicio: ejercicio,
          orden: ejerciciosSeleccionados.length,
          series: 3,
          repeticiones: '10',
          descansoSegundos: 60,
          observaciones: '',
        ),
      );
    });
  }

  void eliminarEjercicio(
    int index,
  ) {
    setState(() {
      ejerciciosSeleccionados.removeAt(
        index,
      );

      actualizarOrden();
    });
  }

  void moverArriba(
    int index,
  ) {
    if (index <= 0) {
      return;
    }

    setState(() {
      final item = ejerciciosSeleccionados.removeAt(
        index,
      );

      ejerciciosSeleccionados.insert(
        index - 1,
        item,
      );

      actualizarOrden();
    });
  }

  void moverAbajo(
    int index,
  ) {
    if (index >= ejerciciosSeleccionados.length - 1) {
      return;
    }

    setState(() {
      final item = ejerciciosSeleccionados.removeAt(
        index,
      );

      ejerciciosSeleccionados.insert(
        index + 1,
        item,
      );

      actualizarOrden();
    });
  }

  void actualizarOrden() {
    for (int i = 0;
        i < ejerciciosSeleccionados.length;
        i++) {
      ejerciciosSeleccionados[i].orden = i;
    }
  }

  Future<void> editarConfiguracionEjercicio(
    int index,
  ) async {
    final item = ejerciciosSeleccionados[index];

    String seriesTexto = item.series.toString();
    String repeticionesTexto = item.repeticiones;
    String descansoTexto = item.descansoSegundos.toString();
    String observacionesTexto = item.observaciones;

    final resultado = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            item.ejercicio.nombre,
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: seriesTexto,
                  keyboardType: TextInputType.number,
                  onChanged: (valor) {
                    seriesTexto = valor;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Series',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 14),

                TextFormField(
                  initialValue: repeticionesTexto,
                  onChanged: (valor) {
                    repeticionesTexto = valor;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Repeticiones',
                    hintText: 'Ej: 12-10-8 o 10 por serie',
                    helperText:
                        'Podés indicar repeticiones fijas (ej: 12) o por serie (ej: 12-10-8)',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 14),

                TextFormField(
                  initialValue: descansoTexto,
                  keyboardType: TextInputType.number,
                  onChanged: (valor) {
                    descansoTexto = valor;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Descanso',
                    suffixText: 'seg',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 14),

                TextFormField(
                  initialValue: observacionesTexto,
                  maxLines: 3,
                  onChanged: (valor) {
                    observacionesTexto = valor;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Observaciones',
                    hintText: 'Ej: controlar bajada',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                FocusScope.of(dialogContext).unfocus();

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
                final series = int.tryParse(
                  seriesTexto.trim(),
                );

                final descanso = int.tryParse(
                  descansoTexto.trim(),
                );

                final repeticiones =
                    repeticionesTexto.trim();

                if (series == null ||
                    series <= 0 ||
                    descanso == null ||
                    descanso < 0 ||
                    repeticiones.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Revisá series, repeticiones y descanso.',
                      ),
                    ),
                  );

                  return;
                }

                item.series = series;
                item.repeticiones = repeticiones;
                item.descansoSegundos = descanso;
                item.observaciones =
                    observacionesTexto.trim();

                FocusScope.of(dialogContext).unfocus();

                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text(
                'Guardar',
              ),
            ),
          ],
        );
      },
    );

    if (resultado == true && mounted) {
      setState(() {});
    }
  }

  Future<void> guardarRutina() async {
    if (guardando) {
      return;
    }

    final nombre = nombreController.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ingresá un nombre para la rutina.',
          ),
        ),
      );

      return;
    }

    if (ejerciciosSeleccionados.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La rutina debe tener al menos un ejercicio.',
          ),
        ),
      );

      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      guardando = true;
    });

    try {
      final ahora = DateTime.now();

      final rutina = RutinaEditor(
        id: widget.rutina?.id ??
            'rut_${ahora.microsecondsSinceEpoch}',
        creadorId:
            widget.rutina?.creadorId ?? widget.profesorId,
        nombre: nombre,
        descripcion: descripcionController.text.trim(),
        ejercicios: ejerciciosSeleccionados,
      );

      await rutinaRepositorio.guardarRutina(
        rutina,
      );

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        true,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        guardando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo guardar la rutina: $error',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.esEdicion
              ? 'Editar rutina'
              : 'Nueva rutina',
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            100,
          ),
          children: [
            TextField(
              controller: nombreController,
              enabled: !guardando,
              textCapitalization:
                  TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nombre de la rutina',
                hintText: 'Ej: Tren inferior A',
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.assignment_outlined,
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: descripcionController,
              enabled: !guardando,
              maxLines: 3,
              textCapitalization:
                  TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Objetivo o indicaciones generales',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 28),

            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Ejercicios',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: guardando
                      ? null
                      : mostrarSelectorEjercicios,
                  icon: const Icon(
                    Icons.add,
                  ),
                  label: const Text(
                    'Agregar',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            const Text(
              'Configurá series, repeticiones y descanso para cada ejercicio.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 14),

            if (ejerciciosSeleccionados.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 44,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Todavía no agregaste ejercicios.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...ejerciciosSeleccionados.asMap().entries.map(
                (entrada) {
                  final index = entrada.key;
                  final item = entrada.value;

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(
                        14,
                      ),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                child: Text(
                                  '${index + 1}',
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  item.ejercicio.nombre,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),

                              PopupMenuButton<String>(
                                onSelected: (opcion) {
                                  if (opcion == 'editar') {
                                    editarConfiguracionEjercicio(
                                      index,
                                    );
                                  } else if (opcion ==
                                      'arriba') {
                                    moverArriba(
                                      index,
                                    );
                                  } else if (opcion ==
                                      'abajo') {
                                    moverAbajo(
                                      index,
                                    );
                                  } else if (opcion ==
                                      'eliminar') {
                                    eliminarEjercicio(
                                      index,
                                    );
                                  }
                                },
                                itemBuilder: (context) {
                                  return [
                                    const PopupMenuItem(
                                      value: 'editar',
                                      child: Text(
                                        'Editar configuración',
                                      ),
                                    ),
                                    if (index > 0)
                                      const PopupMenuItem(
                                        value: 'arriba',
                                        child: Text(
                                          'Mover arriba',
                                        ),
                                      ),
                                    if (index <
                                        ejerciciosSeleccionados
                                                .length -
                                            1)
                                      const PopupMenuItem(
                                        value: 'abajo',
                                        child: Text(
                                          'Mover abajo',
                                        ),
                                      ),
                                    const PopupMenuItem(
                                      value: 'eliminar',
                                      child: Text(
                                        'Quitar de la rutina',
                                      ),
                                    ),
                                  ];
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 14),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Chip(
                                label: Text(
                                  '${item.series} series',
                                ),
                              ),
                              Chip(
                                label: Text(
                                  '${item.repeticiones} reps',
                                ),
                              ),
                              Chip(
                                label: Text(
                                  '${item.descansoSegundos} seg',
                                ),
                              ),
                            ],
                          ),

                          if (item.observaciones
                              .trim()
                              .isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Text(
                              item.observaciones,
                              style: const TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],

                          const SizedBox(height: 8),

                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: guardando
                                  ? null
                                  : () {
                                      editarConfiguracionEjercicio(
                                        index,
                                      );
                                    },
                              icon: const Icon(
                                Icons.tune,
                              ),
                              label: const Text(
                                'Configurar ejercicio',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed:
                    guardando ? null : guardarRutina,
                icon: guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.save,
                      ),
                label: Text(
                  guardando
                      ? 'Guardando...'
                      : 'Guardar rutina',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}