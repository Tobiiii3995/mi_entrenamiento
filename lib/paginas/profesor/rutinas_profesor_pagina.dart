import 'package:flutter/material.dart';

import '../../modelos/rutina_editor.dart';
import '../../repositorios/rutina_profesor_repositorio.dart';
import '../../servicios/base_datos_servicio.dart';
import 'editar_rutina_pagina.dart';

class RutinasProfesorPagina extends StatefulWidget {
  final String profesorId;

  const RutinasProfesorPagina({
    super.key,
    required this.profesorId,
  });

  @override
  State<RutinasProfesorPagina> createState() =>
      _RutinasProfesorPaginaState();
}

class _RutinasProfesorPaginaState
    extends State<RutinasProfesorPagina> {
  late final RutinaProfesorRepositorio rutinaRepositorio;

  final TextEditingController buscarController =
      TextEditingController();

  List<RutinaEditor> rutinas = [];

  bool cargando = true;

  @override
  void initState() {
    super.initState();

    rutinaRepositorio = RutinaProfesorRepositorio(
      BaseDatosServicio.db,
    );

    cargarRutinas();
  }

  @override
  void dispose() {
    buscarController.dispose();
    super.dispose();
  }

  Future<void> cargarRutinas() async {
    if (mounted) {
      setState(() {
        cargando = true;
      });
    }

    final resultado =
        await rutinaRepositorio.obtenerRutinasDelProfesor(
      widget.profesorId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      rutinas = resultado;
      cargando = false;
    });
  }

  List<RutinaEditor> get rutinasFiltradas {
    final busqueda =
        buscarController.text.trim().toLowerCase();

    if (busqueda.isEmpty) {
      return rutinas;
    }

    return rutinas.where(
      (rutina) {
        return rutina.nombre.toLowerCase().contains(
                  busqueda,
                ) ||
            rutina.descripcion.toLowerCase().contains(
                  busqueda,
                ) ||
            rutina.ejercicios.any(
              (item) => item.ejercicio.nombre
                  .toLowerCase()
                  .contains(
                    busqueda,
                  ),
            );
      },
    ).toList();
  }

  Future<void> crearRutina() async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditarRutinaPagina(
          profesorId: widget.profesorId,
        ),
      ),
    );

    if (resultado == true) {
      await cargarRutinas();
    }
  }

  Future<void> editarRutina(
    RutinaEditor rutina,
  ) async {
    final resultado = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditarRutinaPagina(
          profesorId: widget.profesorId,
          rutina: rutina,
        ),
      ),
    );

    if (resultado == true) {
      await cargarRutinas();
    }
  }

  Future<void> confirmarArchivar(
    RutinaEditor rutina,
  ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Archivar rutina',
          ),
          content: Text(
            '¿Querés archivar "${rutina.nombre}"?\n\n'
            'La rutina dejará de aparecer en tu biblioteca, '
            'pero los entrenamientos históricos ya realizados '
            'no se borrarán.',
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

    await rutinaRepositorio.archivarRutina(
      rutina.id,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${rutina.nombre} fue archivada.',
        ),
      ),
    );

    await cargarRutinas();
  }

  void mostrarOpciones(
    RutinaEditor rutina,
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
                  'Editar rutina',
                ),
                onTap: () {
                  Navigator.pop(context);

                  editarRutina(
                    rutina,
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.archive_outlined,
                ),
                title: const Text(
                  'Archivar rutina',
                ),
                onTap: () {
                  Navigator.pop(context);

                  confirmarArchivar(
                    rutina,
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
    final filtradas = rutinasFiltradas;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rutinas',
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: crearRutina,
        icon: const Icon(
          Icons.add,
        ),
        label: const Text(
          'Nueva rutina',
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
                  labelText: 'Buscar rutina',
                  hintText:
                      'Nombre, descripción o ejercicio',
                  prefixIcon: const Icon(
                    Icons.search,
                  ),
                  suffixIcon: buscarController.text.isEmpty
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
                  : filtradas.isEmpty
                      ? _EstadoVacio(
                          tieneRutinas:
                              rutinas.isNotEmpty,
                          onCrear: crearRutina,
                        )
                      : RefreshIndicator(
                          onRefresh: cargarRutinas,
                          child: ListView.builder(
                            padding:
                                const EdgeInsets.fromLTRB(
                              20,
                              4,
                              20,
                              100,
                            ),
                            itemCount: filtradas.length,
                            itemBuilder: (
                              context,
                              index,
                            ) {
                              final rutina =
                                  filtradas[index];

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
                                    child: Text(
                                      rutina.ejercicios.length
                                          .toString(),
                                    ),
                                  ),
                                  title: Text(
                                    rutina.nombre,
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
                                        Text(
                                          '${rutina.ejercicios.length} ejercicio${rutina.ejercicios.length == 1 ? '' : 's'}',
                                        ),
                                        if (rutina.descripcion
                                            .trim()
                                            .isNotEmpty) ...[
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            rutina.descripcion,
                                            maxLines: 2,
                                            overflow:
                                                TextOverflow
                                                    .ellipsis,
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      mostrarOpciones(
                                        rutina,
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.more_vert,
                                    ),
                                  ),
                                  onTap: () {
                                    editarRutina(
                                      rutina,
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
  final bool tieneRutinas;
  final VoidCallback onCrear;

  const _EstadoVacio({
    required this.tieneRutinas,
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
              Icons.assignment_outlined,
              size: 60,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              tieneRutinas
                  ? 'No encontramos rutinas con esa búsqueda.'
                  : 'Todavía no creaste rutinas.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!tieneRutinas) ...[
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Creá una rutina y agregale ejercicios de tu biblioteca.',
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
                  'Crear primera rutina',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}