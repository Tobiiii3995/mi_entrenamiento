import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'registro_pagina.dart';

class LoginPagina extends StatefulWidget {
  const LoginPagina({
    super.key,
  });

  @override
  State<LoginPagina> createState() =>
      _LoginPaginaState();
}

class _LoginPaginaState
    extends State<LoginPagina> {
  final TextEditingController correoController =
      TextEditingController();

  final TextEditingController contrasenaController =
      TextEditingController();

  bool cargando = false;
  bool recuperando = false;
  bool ocultarContrasena = true;

  @override
  void dispose() {
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  Future<void> iniciarSesion() async {
    final correo =
        correoController.text.trim();

    final contrasena =
        contrasenaController.text;

    if (correo.isEmpty ||
        contrasena.isEmpty) {
      mostrarMensaje(
        'Ingresá tu correo y contraseña.',
      );
      return;
    }

    setState(() {
      cargando = true;
    });

    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: correo,
        password: contrasena,
      );
    } on FirebaseAuthException catch (e) {
      String mensaje =
          'No se pudo iniciar sesión.';

      switch (e.code) {
        case 'invalid-email':
          mensaje =
              'El correo ingresado no es válido.';
          break;

        case 'user-disabled':
          mensaje =
              'Esta cuenta está deshabilitada.';
          break;

        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          mensaje =
              'Correo o contraseña incorrectos.';
          break;

        case 'too-many-requests':
          mensaje =
              'Demasiados intentos. Intentá nuevamente más tarde.';
          break;

        case 'network-request-failed':
          mensaje =
              'No se pudo conectar a internet.';
          break;
      }

      mostrarMensaje(mensaje);
    } catch (_) {
      mostrarMensaje(
        'Ocurrió un error inesperado.',
      );
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  Future<void> recuperarContrasena() async {
    final correo =
        correoController.text.trim();

    if (correo.isEmpty) {
      mostrarMensaje(
        'Ingresá primero tu correo.',
      );
      return;
    }

    setState(() {
      recuperando = true;
    });

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(
        email: correo,
      );

      mostrarMensaje(
        'Si existe una cuenta con ese correo, recibirás instrucciones para restablecer la contraseña.',
      );
    } on FirebaseAuthException catch (e) {
      String mensaje =
          'No se pudo enviar el correo de recuperación.';

      if (e.code == 'invalid-email') {
        mensaje =
            'El correo ingresado no es válido.';
      }

      mostrarMensaje(mensaje);
    } finally {
      if (mounted) {
        setState(() {
          recuperando = false;
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(
                maxWidth: 420,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.fitness_center,
                    size: 72,
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  Text(
                    'Mi Entrenamiento',
                    textAlign:
                        TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    'Ingresá a tu cuenta',
                    textAlign:
                        TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge,
                  ),

                  const SizedBox(
                    height: 32,
                  ),

                  TextField(
                    controller:
                        correoController,
                    keyboardType:
                        TextInputType
                            .emailAddress,
                    textInputAction:
                        TextInputAction.next,
                    autofillHints: const [
                      AutofillHints.email,
                    ],
                    decoration:
                        const InputDecoration(
                      labelText: 'Correo',
                      prefixIcon: Icon(
                        Icons.email_outlined,
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
                        TextInputAction.done,
                    autofillHints: const [
                      AutofillHints.password,
                    ],
                    onSubmitted: (_) {
                      iniciarSesion();
                    },
                    decoration:
                        InputDecoration(
                      labelText:
                          'Contraseña',
                      prefixIcon:
                          const Icon(
                        Icons.lock_outline,
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
                    height: 8,
                  ),

                  Align(
                    alignment:
                        Alignment.centerRight,
                    child: TextButton(
                      onPressed:
                          cargando ||
                                  recuperando
                              ? null
                              : recuperarContrasena,
                      child: Text(
                        recuperando
                            ? 'Enviando...'
                            : '¿Olvidaste tu contraseña?',
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  FilledButton(
                    onPressed: cargando
                        ? null
                        : iniciarSesion,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: cargando
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Ingresar',
                            ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  OutlinedButton(
                    onPressed: cargando
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        const RegistroPagina(),
                              ),
                            );
                          },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Text(
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