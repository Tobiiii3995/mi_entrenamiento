import 'package:flutter/material.dart';

import '../../modelos/ejercicio_catalogo.dart';
import '../../repositorios/ejercicio_repositorio.dart';
import '../../servicios/base_datos_servicio.dart';

class EditarEjercicioPagina
    extends StatefulWidget {
  final String profesorId;
  final EjercicioCatalogo? ejercicio;

  const EditarEjercicioPagina({
    super.key,
    required this.profesorId,
    this.ejercicio,
  });

  bool get esEdicion =>
      ejercicio != null;

  @override
  State<EditarEjercicioPagina>
      createState() =>
          _EditarEjercicioPaginaState();
}

class _EditarEjercicioPaginaState
    extends State<EditarEjercicioPagina> {
  late final EjercicioRepositorio
      ejercicioRepositorio;

  late final TextEditingController
      nombreController;

  late final TextEditingController
      grupoController;

  late final TextEditingController
      descripcionController;

  late final TextEditingController
      instruccionesController;

  late final TextEditingController
      urlMediaController;

  bool llevaPeso = true;
  bool guardando = false;

  @override
  void initState() {
    super.initState();

    ejercicioRepositorio =
        EjercicioRepositorio(
      BaseDatosServicio.db,
    );

    final ejercicio =
        widget.ejercicio;

    nombreController =
        TextEditingController(
      text: ejercicio?.nombre ?? '',
    );

    grupoController =
        TextEditingController(
      text:
          ejercicio?.grupoMuscular ?? '',
    );

    descripcionController =
        TextEditingController(
      text:
          ejercicio?.descripcion ?? '',
    );

    instruccionesController =
        TextEditingController(
      text:
          ejercicio?.instrucciones ?? '',
    );

    urlMediaController =
        TextEditingController(
      text:
          ejercicio?.urlMedia ?? '',
    );

    llevaPeso =
        ejercicio?.llevaPeso ?? true;
  }

  @override
  void dispose() {
    nombreController.dispose();
    grupoController.dispose();
    descripcionController.dispose();
    instruccionesController.dispose();
    urlMediaController.dispose();

    super.dispose();
  }

  Future<void> guardar() async {
    if (guardando) {
      return;
    }

    final nombre =
        nombreController.text.trim();

    if (nombre.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Ingresá el nombre del ejercicio.',
          ),
        ),
      );

      return;
    }

    setState(() {
      guardando = true;
    });

    try {
      final ejercicio =
          EjercicioCatalogo(
        id: widget.ejercicio?.id ??
            'ej_${DateTime.now().microsecondsSinceEpoch}',
        creadorId:
            widget.ejercicio
                    ?.creadorId ??
                widget.profesorId,
        nombre:
            nombre,
        descripcion:
            descripcionController.text,
        llevaPeso:
            llevaPeso,
        grupoMuscular:
            grupoController.text,
        instrucciones:
            instruccionesController.text,
        urlMedia:
            urlMediaController.text.trim(),
      );

      await ejercicioRepositorio
          .guardarEjercicio(
        ejercicio,
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

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo guardar el ejercicio: $error',
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.esEdicion
              ? 'Editar ejercicio'
              : 'Nuevo ejercicio',
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
            TextField(
              controller:
                  nombreController,
              enabled:
                  !guardando,
              textCapitalization:
                  TextCapitalization
                      .sentences,
              decoration:
                  const InputDecoration(
                labelText:
                    'Nombre del ejercicio',
                hintText:
                    'Ej: Hip Thrust',
                border:
                    OutlineInputBorder(),
                prefixIcon:
                    Icon(
                  Icons.fitness_center,
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  grupoController,
              enabled:
                  !guardando,
              textCapitalization:
                  TextCapitalization
                      .sentences,
              decoration:
                  const InputDecoration(
                labelText:
                    'Grupo muscular',
                hintText:
                    'Ej: Glúteos',
                border:
                    OutlineInputBorder(),
                prefixIcon:
                    Icon(
                  Icons.accessibility_new,
                ),
              ),
            ),

            const SizedBox(height: 16),

            Card(
              child: SwitchListTile(
                title: const Text(
                  'Registrar peso',
                  style: TextStyle(
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  llevaPeso
                      ? 'El alumno podrá ingresar los kg utilizados.'
                      : 'El ejercicio se registrará sin peso.',
                ),
                value:
                    llevaPeso,
                onChanged: guardando
                    ? null
                    : (valor) {
                        setState(() {
                          llevaPeso =
                              valor;
                        });
                      },
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  descripcionController,
              enabled:
                  !guardando,
              maxLines: 3,
              textCapitalization:
                  TextCapitalization
                      .sentences,
              decoration:
                  const InputDecoration(
                labelText:
                    'Descripción',
                hintText:
                    'Descripción general del ejercicio',
                alignLabelWithHint:
                    true,
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  instruccionesController,
              enabled:
                  !guardando,
              maxLines: 5,
              textCapitalization:
                  TextCapitalization
                      .sentences,
              decoration:
                  const InputDecoration(
                labelText:
                    'Instrucciones',
                hintText:
                    'Ej: apoyar la espalda alta en el banco...',
                alignLabelWithHint:
                    true,
                border:
                    OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  urlMediaController,
              enabled:
                  !guardando,
              keyboardType:
                  TextInputType.url,
              decoration:
                  const InputDecoration(
                labelText:
                    'Enlace de demostración (GIF / Video)',
                hintText:
                    'Ej: https://media.giphy.com/.../ejercicio.gif',
                helperText:
                    'Pegá una URL de GIF o demostración para tus alumnos',
                border:
                    OutlineInputBorder(),
                prefixIcon:
                    Icon(
                  Icons.play_circle_outline,
                ),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width:
                  double.infinity,
              child:
                  FilledButton.icon(
                onPressed:
                    guardando
                        ? null
                        : guardar,
                icon: guardando
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child:
                            CircularProgressIndicator(
                          strokeWidth:
                              2,
                        ),
                      )
                    : const Icon(
                        Icons.save,
                      ),
                label: Text(
                  guardando
                      ? 'Guardando...'
                      : 'Guardar ejercicio',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}