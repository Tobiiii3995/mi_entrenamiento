import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../servicios/vinculacion_firestore_servicio.dart';

class AgregarAlumnoPagina
    extends StatefulWidget {
  const AgregarAlumnoPagina({
    super.key,
  });

  @override
  State<AgregarAlumnoPagina>
      createState() =>
          _AgregarAlumnoPaginaState();
}

class _AgregarAlumnoPaginaState
    extends State<AgregarAlumnoPagina> {
  final codigoController =
      TextEditingController();

  bool enviando = false;

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

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }

  Future<void> enviarSolicitud() async {
    if (enviando) {
      return;
    }

    final codigo =
        codigoController.text
            .trim()
            .toUpperCase();

    if (codigo.length != 8) {
      mostrarMensaje(
        'Ingresá un código válido de 8 caracteres.',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      enviando = true;
    });

    try {
      await VinculacionFirestoreServicio
          .enviarSolicitudPorCodigo(
        codigo,
      );

      if (!mounted) {
        return;
      }

      codigoController.clear();

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text(
              'Solicitud enviada',
            ),
            content: const Text(
              'La solicitud fue enviada correctamente.\n\n'
              'El alumno deberá aceptarla antes de quedar vinculado contigo.',
            ),
            actions: [
              FilledButton(
                onPressed: () {
                  Navigator.pop(
                    dialogContext,
                  );
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
      var mensaje =
          e.toString();

      mensaje = mensaje.replaceFirst(
        'Exception: ',
        '',
      );

      mostrarMensaje(mensaje);
    } finally {
      if (mounted) {
        setState(() {
          enviando = false;
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
          padding:
              const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            80,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Agregar alumno',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const Text(
                'Pedile al alumno su código de vinculación. '
                'Lo encontrará en su perfil.',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              TextField(
                controller:
                    codigoController,
                enabled: !enviando,
                maxLength: 8,
                textCapitalization:
                    TextCapitalization
                        .characters,
                inputFormatters: [
                  FilteringTextInputFormatter
                      .allow(
                    RegExp(
                      r'[a-zA-Z0-9]',
                    ),
                  ),
                ],
                decoration:
                    const InputDecoration(
                  labelText:
                      'Código del alumno',
                  hintText:
                      'Ej: K7P4X9M2',
                  border:
                      OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.key_outlined,
                  ),
                ),
                onSubmitted: (_) {
                  enviarSolicitud();
                },
              ),

              const SizedBox(
                height: 12,
              ),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed:
                      enviando
                          ? null
                          : enviarSolicitud,
                  icon: enviando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons
                              .person_add_alt_1,
                        ),
                  label: Text(
                    enviando
                        ? 'Enviando...'
                        : 'Enviar solicitud',
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              const Card(
                child: Padding(
                  padding:
                      EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons
                            .shield_outlined,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          'El alumno no se agrega automáticamente. '
                          'Primero deberá aceptar tu solicitud.',
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