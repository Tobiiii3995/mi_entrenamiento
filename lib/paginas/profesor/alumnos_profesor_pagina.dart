import 'package:flutter/material.dart';

import '../../modelos/alumno_profesor.dart';
import '../../repositorios/alumno_repositorio.dart';
import '../../servicios/base_datos_servicio.dart';
import '../../widgets/avatar_usuario.dart';
import 'agregar_alumno_pagina.dart';
import 'detalle_alumno_profesor_pagina.dart';

class AlumnosProfesorPagina extends StatefulWidget {
  final String profesorId;

  const AlumnosProfesorPagina({
    super.key,
    required this.profesorId,
  });

  @override
  State<AlumnosProfesorPagina> createState() =>
      _AlumnosProfesorPaginaState();
}

class _AlumnosProfesorPaginaState
    extends State<AlumnosProfesorPagina> {
  late final AlumnoRepositorio alumnoRepositorio;

  @override
  void initState() {
    super.initState();

    alumnoRepositorio = AlumnoRepositorio(
      BaseDatosServicio.db,
    );
  }

  Future<void> abrirVincularAlumno() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AgregarAlumnoPagina(),
      ),
    );
  }

  Future<void> abrirAlumno(
    AlumnoProfesor alumno,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleAlumnoProfesorPagina(
          profesorId: widget.profesorId,
          alumno: alumno,
        ),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alumnos',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: 'Vincular alumno',
            onPressed: abrirVincularAlumno,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: abrirVincularAlumno,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Vincular alumno'),
      ),
      body: SafeArea(
        top: false,
        child: StreamBuilder<List<AlumnoProfesor>>(
          stream: alumnoRepositorio.escucharAlumnosVinculados(
            widget.profesorId,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 44,
                      ),
                      SizedBox(height: 14),
                      Text(
                        'No se pudieron cargar los alumnos.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final alumnos = snapshot.data ?? const [];

            if (alumnos.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 60,
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        'Todavía no tenés alumnos vinculados.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Pedile al alumno su código de vinculación desde su perfil para agregarlo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: abrirVincularAlumno,
                        icon: const Icon(Icons.person_add_alt_1),
                        label: const Text('Vincular nuevo alumno'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    18,
                    20,
                    6,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          alumnos.length == 1
                              ? '1 alumno vinculado'
                              : '${alumnos.length} alumnos vinculados',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      10,
                      20,
                      100,
                    ),
                    itemCount: alumnos.length,
                    itemBuilder: (context, index) {
                      final alumno = alumnos[index];

                      return Card(
                        margin: const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(
                            14,
                          ),
                          leading: AvatarUsuario(
                            fotoUrl: alumno.fotoUrl,
                            nombre: alumno.nombre,
                            radio: 22,
                          ),
                          title: Text(
                            alumno.nombre,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (alumno.correo.trim().isNotEmpty) ...[
                                const SizedBox(height: 3),
                                Text(alumno.correo),
                              ],
                              const SizedBox(height: 4),
                              const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.link,
                                    size: 15,
                                  ),
                                  SizedBox(width: 4),
                                  Text('Vinculado'),
                                ],
                              ),
                            ],
                          ),
                          trailing: const Icon(
                            Icons.chevron_right,
                          ),
                          onTap: () {
                            abrirAlumno(alumno);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}