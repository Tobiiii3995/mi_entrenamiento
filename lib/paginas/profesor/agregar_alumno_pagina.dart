import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../servicios/vinculacion_firestore_servicio.dart';
import '../../widgets/avatar_usuario.dart';

class AgregarAlumnoPagina extends StatefulWidget {
  const AgregarAlumnoPagina({
    super.key,
  });

  @override
  State<AgregarAlumnoPagina> createState() =>
      _AgregarAlumnoPaginaState();
}

class _AgregarAlumnoPaginaState
    extends State<AgregarAlumnoPagina> {
  final codigoController = TextEditingController();

  bool buscando = false;

  @override
  void dispose() {
    codigoController.dispose();
    super.dispose();
  }

  void mostrarMensaje(
    String mensaje,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }

  Future<void> procesarVinculacion() async {
    if (buscando) {
      return;
    }

    final codigo = codigoController.text.trim().toUpperCase();

    if (codigo.length != 8) {
      mostrarMensaje(
        'Ingresá un código válido de 8 caracteres.',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      buscando = true;
    });

    try {
      // 1. Buscar los datos del alumno (Foto, Nombre, Correo) antes de vincular
      final alumnoInfo = await VinculacionFirestoreServicio.buscarAlumnoPorCodigo(codigo);

      if (!mounted) return;

      final nombreAlumno = alumnoInfo['nombre'] as String? ?? 'Alumno';
      final correoAlumno = alumnoInfo['correo'] as String? ?? '';
      final fotoUrlAlumno = alumnoInfo['fotoUrl'] as String? ?? '';

      // 2. Mostrar diálogo de confirmación con foto y nombre
      final confirmar = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Confirmar vinculación',
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AvatarUsuario(
                  fotoUrl: fotoUrlAlumno,
                  nombre: nombreAlumno,
                  radio: 38,
                ),
                const SizedBox(height: 14),
                Text(
                  nombreAlumno,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (correoAlumno.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    correoAlumno,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Text(
                  '¿Deseas enviar la solicitud de vinculación a $nombreAlumno?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Confirmar y enviar'),
              ),
            ],
          );
        },
      );

      if (confirmar != true || !mounted) {
        return;
      }

      // 3. Enviar la solicitud
      await VinculacionFirestoreServicio.enviarSolicitudPorCodigo(codigo);

      if (!mounted) return;

      codigoController.clear();

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text(
              'Solicitud enviada',
            ),
            content: Text(
              'La solicitud fue enviada correctamente a $nombreAlumno.\n\n'
              'El alumno deberá aceptarla desde su perfil para que comiencen a estar vinculados.',
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Navigator.pop(context); // Regresar a la lista de alumnos
                },
                child: const Text(
                  'Entendido',
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      var mensaje = e.toString();
      mensaje = mensaje.replaceFirst('Exception: ', '');
      mostrarMensaje(mensaje);
    } finally {
      if (mounted) {
        setState(() {
          buscando = false;
        });
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vincular alumno',
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            80,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Agregar alumno',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Pedile al alumno su código de vinculación de 8 caracteres. '
                'Lo encontrará en su perfil.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: codigoController,
                enabled: !buscando,
                maxLength: 8,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[a-zA-Z0-9]'),
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: 'Código del alumno',
                  hintText: 'Ej: K7P4X9M2',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.key_outlined,
                  ),
                ),
                onSubmitted: (_) {
                  procesarVinculacion();
                },
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: buscando ? null : procesarVinculacion,
                  icon: buscando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.person_search_outlined,
                        ),
                  label: Text(
                    buscando
                        ? 'Buscando alumno...'
                        : 'Buscar y vincular alumno',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Antes de enviar, podrás verificar la foto y nombre del alumno para confirmar que el código sea correcto.',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}