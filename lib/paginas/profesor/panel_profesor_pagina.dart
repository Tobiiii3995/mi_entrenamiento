import 'package:flutter/material.dart';

import '../../servicios/datos_app.dart';
import 'agregar_alumno_pagina.dart';
import 'alumnos_profesor_pagina.dart';
import 'ejercicios_profesor_pagina.dart';
import 'rutinas_profesor_pagina.dart';

class PanelProfesorPagina
    extends StatelessWidget {
  const PanelProfesorPagina({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    final profesorId =
        DatosApp.usuarioActual.id;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Panel Profesor',
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
            const Text(
              'Gestión',
              style: TextStyle(
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            const Text(
              'Administrá ejercicios, rutinas y alumnos.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),

            const SizedBox(
              height: 24,
            ),

            Card(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.all(
                  16,
                ),
                leading:
                    const CircleAvatar(
                  child: Icon(
                    Icons.fitness_center,
                  ),
                ),
                title: const Text(
                  'Ejercicios',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Crear, editar y archivar ejercicios',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          EjerciciosProfesorPagina(
                        profesorId:
                            profesorId,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Card(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.all(
                  16,
                ),
                leading:
                    const CircleAvatar(
                  child: Icon(
                    Icons
                        .assignment_outlined,
                  ),
                ),
                title: const Text(
                  'Rutinas',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Crear, editar y archivar rutinas',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RutinasProfesorPagina(
                        profesorId:
                            profesorId,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Card(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.all(
                  16,
                ),
                leading:
                    const CircleAvatar(
                  child: Icon(
                    Icons
                        .person_add_alt_1,
                  ),
                ),
                title: const Text(
                  'Vincular alumno',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Enviar solicitud usando el código del alumno',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const AgregarAlumnoPagina(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Card(
              child: ListTile(
                contentPadding:
                    const EdgeInsets.all(
                  16,
                ),
                leading:
                    const CircleAvatar(
                  child: Icon(
                    Icons.people_outline,
                  ),
                ),
                title: const Text(
                  'Alumnos',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Gestionar alumnos y asignar rutinas',
                ),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AlumnosProfesorPagina(
                        profesorId:
                            profesorId,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}