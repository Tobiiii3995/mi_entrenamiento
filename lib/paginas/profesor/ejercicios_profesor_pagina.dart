import 'package:flutter/material.dart';

import '../../modelos/ejercicio_catalogo.dart';
import '../../repositorios/ejercicio_repositorio.dart';
import '../../servicios/base_datos_servicio.dart';
import 'editar_ejercicio_pagina.dart';

class EjerciciosProfesorPagina extends StatefulWidget {
  final String profesorId;

  const EjerciciosProfesorPagina({
    super.key,
    required this.profesorId,
  });

  @override
  State<EjerciciosProfesorPagina> createState() =>
      _EjerciciosProfesorPaginaState();
}

class _EjerciciosProfesorPaginaState
    extends State<EjerciciosProfesorPagina> {
  late final EjercicioRepositorio ejercicioRepositorio;

  final TextEditingController buscarController =
      TextEditingController();

  List<EjercicioCatalogo> ejercicios = [];

  bool cargando = true;

  @override
  void initState() {
    super.initState();

    ejercicioRepositorio = EjercicioRepositorio(
      BaseDatosServicio.db,
    );

    cargarEjercicios();
  }

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  Future<void> cargarEjercicios() async {
    if (mounted) {
      setState(() {
        cargando = true;
      });
    }

    final resultado =
        await ejercicioRepositorio.obtenerEjerciciosDelProfesor(
      widget.profesorId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      ejercicios = resultado;
      cargando = false;
    });
  }

  List<EjercicioCatalogo> get ejerciciosFiltrados {
    final busqueda =
        buscarController.text.trim().toLowerCase();

    if (busqueda.isEmpty) {
      return ejercicios;
    }

    return ejercicios.where(
      (ejercicio) {
        return ejercicio.nombre.toLowerCase().contains(
                  busqueda,
                ) ||
            ejercicio.grupoMuscular
                .toLowerCase()
                .contains(
                  busqueda,
                );
      },
    ).toList();
  }

  Future<void> crearEjercicio() async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditarEjercicioPagina(
          profesorId: widget.profesorId,
        ),
      ),
    );

    if (resultado == true) {
      await cargarEjercicios();
    }
  }

  Future<void> editarEjercicio(
    EjercicioCatalogo ejercicio,
  ) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditarEjercicioPagina(
          profesorId: widget.profesorId,
          ejercicio: ejercicio,
        ),
      ),
    );

    if (resultado == true) {
      await cargarEjercicios();
    }
  }

  Future<void> confirmarArchivar(
    EjercicioCatalogo ejercicio,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Archivar ejercicio',
          ),
          content: Text(
            '¿Querés archivar "${ejercicio.nombre}"?\n\n'
            'No se borrarán los entrenamientos históricos '
            'donde este ejercicio ya fue utilizado.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  context,
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
                  context,
                  true,
                );
              },
              child: const Text(
                'Archivar',
              ),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    await ejercicioRepositorio.archivarEjercicio(
      ejercicio.id,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${ejercicio.nombre} fue archivado.',
        ),
      ),
    );

    await cargarEjercicios();
  }

  void mostrarOpciones(
    EjercicioCatalogo ejercicio,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.edit_outlined,
                ),
                title: const Text(
                  'Editar ejercicio',
                ),
                onTap: () {
                  Navigator.pop(context);

                  editarEjercicio(
                    ejercicio,
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.archive_outlined,
                ),
                title: const Text(
                  'Archivar ejercicio',
                ),
                onTap: () {
                  Navigator.pop(context);

                  confirmarArchivar(
                    ejercicio,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtrados = ejerciciosFiltrados;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ejercicios',
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: crearEjercicio,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Nuevo ejercicio',
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                12,
              ),
              child: TextField(
                controller: buscarController,
                onChanged: (_) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  labelText: 'Buscar ejercicio',
                  hintText:
                      'Nombre o grupo muscular',
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  suffixIcon:
                      buscarController.text.isEmpty
                          ? null
                          : IconButton(
                              onPressed: () {
                                buscarController.clear();

                                setState(() {});
                              },
                              icon: const Icon(
                                Icons.close,
                              ),
                            ),
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: cargando
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : filtrados.isEmpty
                      ? _EstadoVacio(
                          tieneEjercicios:
                              ejercicios.isNotEmpty,
                          onCrear: crearEjercicio,
                        )
                      : RefreshIndicator(
                          onRefresh: cargarEjercicios,
                          child: ListView.builder(
                            padding:
                                const EdgeInsets.fromLTRB(
                              20,
                              4,
                              20,
                              100,
                            ),
                            itemCount: filtrados.length,
                            itemBuilder:
                                (context, index) {
                              final ejercicio =
                                  filtrados[index];

                              return Card(
                                margin:
                                    const EdgeInsets.only(
                                  bottom: 12,
                                ),
                                child: ListTile(
                                  contentPadding:
                                      const EdgeInsets.all(
                                    14,
                                  ),
                                  leading: CircleAvatar(
                                    child: Icon(
                                      ejercicio.llevaPeso
                                          ? Icons
                                              .fitness_center
                                          : Icons
                                              .directions_run,
                                    ),
                                  ),
                                  title: Text(
                                    ejercicio.nombre,
                                    style:
                                        const TextStyle(
                                      fontSize: 18,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                  subtitle: Padding(
                                    padding:
                                        const EdgeInsets.only(
                                      top: 6,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        if (ejercicio
                                            .grupoMuscular
                                            .trim()
                                            .isNotEmpty)
                                          Text(
                                            ejercicio
                                                .grupoMuscular,
                                          ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          ejercicio.llevaPeso
                                              ? 'Registra peso'
                                              : 'Sin registro de peso',
                                          style:
                                              const TextStyle(
                                            color:
                                                Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      mostrarOpciones(
                                        ejercicio,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.more_vert,
                                    ),
                                  ),
                                  onTap: () {
                                    editarEjercicio(
                                      ejercicio,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EstadoVacio extends StatelessWidget {
  final bool tieneEjercicios;
  final VoidCallback onCrear;

  const _EstadoVacio({
    required this.tieneEjercicios,
    required this.onCrear,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(
          30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.fitness_center,
              size: 60,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              tieneEjercicios
                  ? 'No encontramos ejercicios con esa búsqueda.'
                  : 'Todavía no creaste ejercicios.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!tieneEjercicios) ...[
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Creá tu biblioteca de ejercicios para después '
                'usarlos al armar rutinas.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FilledButton.icon(
                onPressed: onCrear,
                icon: const Icon(
                  Icons.add,
                ),
                label: const Text(
                  'Crear primer ejercicio',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}