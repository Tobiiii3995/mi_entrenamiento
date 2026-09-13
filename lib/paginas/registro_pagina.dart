import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../servicios/usuario_firestore_servicio.dart';

class RegistroPagina extends StatefulWidget {
  const RegistroPagina({
    super.key,
  });

  @override
  State<RegistroPagina> createState() =>
      _RegistroPaginaState();
}

class _RegistroPaginaState
    extends State<RegistroPagina> {
  final nombreController =
      TextEditingController();

  final correoController =
      TextEditingController();

  final contrasenaController =
      TextEditingController();

  final repetirContrasenaController =
      TextEditingController();

  bool cargando = false;
  bool ocultarContrasena = true;
  bool ocultarRepetir = true;

  static final RegExp _nombreValido =
      RegExp(
    r'^[A-Za-zÁÉÍÓÚÜÑáéíóúüñ ]+$',
  );

  @override
  void dispose() {
    nombreController.dispose();
    correoController.dispose();
    contrasenaController.dispose();
    repetirContrasenaController.dispose();

    super.dispose();
  }

  String normalizarNombre(
    String texto,
  ) {
    return texto
        .trim()
        .replaceAll(
          RegExp(r' +'),
          ' ',
        );
  }

  Future<void> crearCuenta() async {
    if (cargando) {
      return;
    }

    final nombre =
        normalizarNombre(
      nombreController.text,
    );

    final correo =
        correoController.text
            .trim()
            .toLowerCase();

    final contrasena =
        contrasenaController.text;

    final repetir =
        repetirContrasenaController.text;

    if (nombre.length < 2 ||
        nombre.length > 60) {
      mostrarMensaje(
        'Ingresá un nombre válido de entre 2 y 60 caracteres.',
      );
      return;
    }

    if (!_nombreValido.hasMatch(
      nombre,
    )) {
      mostrarMensaje(
        'El nombre solo puede contener letras y espacios.',
      );
      return;
    }

    if (correo.isEmpty) {
      mostrarMensaje(
        'Ingresá tu correo electrónico.',
      );
      return;
    }

    if (!correo.contains('@') ||
        !correo.contains('.')) {
      mostrarMensaje(
        'Ingresá un correo electrónico válido.',
      );
      return;
    }

    if (contrasena.length < 8) {
      mostrarMensaje(
        'La contraseña debe tener al menos 8 caracteres.',
      );
      return;
    }

    if (contrasena != repetir) {
      mostrarMensaje(
        'Las contraseñas no coinciden.',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    setState(() {
      cargando = true;
    });

    User? usuarioCreado;

    try {
      await FirebaseAuth.instance
          .setLanguageCode('es');

      final credencial =
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );

      usuarioCreado =
          credencial.user;

      if (usuarioCreado == null) {
        throw Exception(
          'No se pudo obtener el usuario creado.',
        );
      }

      // Guardamos el nombre en Authentication
      // cuanto antes.
      await usuarioCreado
          .updateDisplayName(
        nombre,
      );

      // Crea o completa el documento inicial
      // de Firestore. Este método es idempotente:
      // funciona aunque el documento haya sido
      // creado unos milisegundos antes por el gate.
      await UsuarioFirestoreServicio
          .crearPerfilInicial(
        nombre: nombre,
      );

      await usuarioCreado
          .sendEmailVerification();

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      String mensaje =
          'No se pudo crear la cuenta.';

      switch (e.code) {
        case 'email-already-in-use':
          mensaje =
              'Ya existe una cuenta con ese correo.';
          break;

        case 'invalid-email':
          mensaje =
              'El correo ingresado no es válido.';
          break;

        case 'weak-password':
          mensaje =
              'La contraseña es demasiado débil.';
          break;

        case 'operation-not-allowed':
          mensaje =
              'El registro con correo y contraseña no está habilitado.';
          break;

        case 'too-many-requests':
          mensaje =
              'Se hicieron demasiados intentos. Probá nuevamente más tarde.';
          break;

        case 'network-request-failed':
          mensaje =
              'No se pudo conectar a internet.';
          break;

        default:
          mensaje =
              'No se pudo crear la cuenta (${e.code}).';
      }

      mostrarMensaje(
        mensaje,
      );
    } on FirebaseException catch (e) {
      // Si llegamos acá después de crear Auth,
      // no decimos que "la cuenta no existe":
      // la cuenta ya fue creada.
      if (usuarioCreado != null) {
        mostrarMensaje(
          'La cuenta fue creada, pero no se pudo terminar de configurar '
          'el perfil (${e.code}).',
        );
      } else {
        mostrarMensaje(
          'Ocurrió un error de Firebase (${e.code}).',
        );
      }
    } catch (e) {
      if (usuarioCreado != null) {
        mostrarMensaje(
          'La cuenta fue creada, pero ocurrió un problema al terminar la configuración.',
        );
      } else {
        mostrarMensaje(
          'Ocurrió un error al crear la cuenta.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
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
        content: Text(
          mensaje,
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
          'Crear cuenta',
        ),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(
              24,
            ),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 420,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .stretch,
                children: [
                  Text(
                    'Empezá tu cuenta',
                    textAlign:
                        TextAlign.center,
                    style: Theme.of(
                      context,
                    )
                        .textTheme
                        .headlineMedium,
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    'Primero verificaremos tu correo y después completaremos tus datos.',
                    textAlign:
                        TextAlign.center,
                    style: Theme.of(
                      context,
                    )
                        .textTheme
                        .bodyLarge,
                  ),

                  const SizedBox(
                    height: 32,
                  ),

                  TextField(
                    controller:
                        nombreController,
                    textCapitalization:
                        TextCapitalization
                            .words,
                    textInputAction:
                        TextInputAction
                            .next,
                    maxLength: 60,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .allow(
                        RegExp(
                          r'[A-Za-zÁÉÍÓÚÜÑáéíóúüñ ]',
                        ),
                      ),
                    ],
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Nombre y apellido',
                      helperText:
                          'Solo letras y espacios',
                      prefixIcon:
                          Icon(
                        Icons
                            .person_outline,
                      ),
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  TextField(
                    controller:
                        correoController,
                    keyboardType:
                        TextInputType
                            .emailAddress,
                    textInputAction:
                        TextInputAction
                            .next,
                    autocorrect: false,
                    enableSuggestions:
                        false,
                    autofillHints:
                        const [
                      AutofillHints.email,
                    ],
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Correo',
                      prefixIcon:
                          Icon(
                        Icons
                            .email_outlined,
                      ),
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  TextField(
                    controller:
                        contrasenaController,
                    obscureText:
                        ocultarContrasena,
                    textInputAction:
                        TextInputAction
                            .next,
                    autofillHints:
                        const [
                      AutofillHints
                          .newPassword,
                    ],
                    decoration:
                        InputDecoration(
                      labelText:
                          'Contraseña',
                      helperText:
                          'Mínimo 8 caracteres',
                      prefixIcon:
                          const Icon(
                        Icons
                            .lock_outline,
                      ),
                      border:
                          const OutlineInputBorder(),
                      suffixIcon:
                          IconButton(
                        onPressed: () {
                          setState(() {
                            ocultarContrasena =
                                !ocultarContrasena;
                          });
                        },
                        icon: Icon(
                          ocultarContrasena
                              ? Icons
                                  .visibility_outlined
                              : Icons
                                  .visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  TextField(
                    controller:
                        repetirContrasenaController,
                    obscureText:
                        ocultarRepetir,
                    textInputAction:
                        TextInputAction
                            .done,
                    onSubmitted: (_) {
                      crearCuenta();
                    },
                    decoration:
                        InputDecoration(
                      labelText:
                          'Repetir contraseña',
                      prefixIcon:
                          const Icon(
                        Icons
                            .lock_outline,
                      ),
                      border:
                          const OutlineInputBorder(),
                      suffixIcon:
                          IconButton(
                        onPressed: () {
                          setState(() {
                            ocultarRepetir =
                                !ocultarRepetir;
                          });
                        },
                        icon: Icon(
                          ocultarRepetir
                              ? Icons
                                  .visibility_outlined
                              : Icons
                                  .visibility_off_outlined,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  FilledButton(
                    onPressed:
                        cargando
                            ? null
                            : crearCuenta,
                    child: Padding(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 14,
                      ),
                      child: cargando
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth:
                                    2,
                              ),
                            )
                          : const Text(
                              'Crear cuenta',
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}