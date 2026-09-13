import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificarCorreoPagina extends StatefulWidget {
  final VoidCallback onVerificado;

  const VerificarCorreoPagina({
    super.key,
    required this.onVerificado,
  });

  @override
  State<VerificarCorreoPagina> createState() =>
      _VerificarCorreoPaginaState();
}

class _VerificarCorreoPaginaState
    extends State<VerificarCorreoPagina> {
  bool comprobando = false;
  bool reenviando = false;

  int segundosReenvio = 0;
  Timer? temporizador;

  @override
  void dispose() {
    temporizador?.cancel();
    super.dispose();
  }

  void iniciarEsperaReenvio() {
    temporizador?.cancel();

    setState(() {
      segundosReenvio = 30;
    });

    temporizador = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (segundosReenvio <= 1) {
          timer.cancel();

          setState(() {
            segundosReenvio = 0;
          });

          return;
        }

        setState(() {
          segundosReenvio--;
        });
      },
    );
  }

  Future<void> comprobarCorreo() async {
    if (comprobando) {
      return;
    }

    setState(() {
      comprobando = true;
    });

    try {
      final usuario = FirebaseAuth.instance.currentUser;

      if (usuario == null) {
        mostrarMensaje(
          'No se encontró una sesión activa.',
        );
        return;
      }

      await usuario.reload();

final actualizado =
    FirebaseAuth.instance.currentUser;

if (actualizado?.emailVerified == true) {
  await actualizado!.getIdTokenResult(true);

  widget.onVerificado();
}

      mostrarMensaje(
        'El correo todavía no figura como verificado.',
      );
    } on FirebaseAuthException catch (e) {
      String mensaje =
          'No se pudo comprobar el correo.';

      if (e.code == 'network-request-failed') {
        mensaje =
            'No se pudo conectar a internet.';
      }

      mostrarMensaje(mensaje);
    } catch (_) {
      mostrarMensaje(
        'Ocurrió un error al comprobar el correo.',
      );
    } finally {
      if (mounted) {
        setState(() {
          comprobando = false;
        });
      }
    }
  }

  Future<void> reenviarCorreo() async {
    if (reenviando || segundosReenvio > 0) {
      return;
    }

    setState(() {
      reenviando = true;
    });

    try {
      final usuario = FirebaseAuth.instance.currentUser;

      if (usuario == null) {
        mostrarMensaje(
          'No se encontró una sesión activa.',
        );
        return;
      }

      if (usuario.emailVerified) {
        widget.onVerificado();
        return;
      }

      await usuario.sendEmailVerification();

      iniciarEsperaReenvio();

      mostrarMensaje(
        'Te enviamos un nuevo correo de verificación.',
      );
    } on FirebaseAuthException catch (e) {
      String mensaje =
          'No se pudo reenviar el correo.';

      switch (e.code) {
        case 'too-many-requests':
          mensaje =
              'Se hicieron demasiados intentos. Esperá unos minutos.';
          break;

        case 'network-request-failed':
          mensaje =
              'No se pudo conectar a internet.';
          break;
      }

      mostrarMensaje(mensaje);
    } catch (_) {
      mostrarMensaje(
        'Ocurrió un error al reenviar el correo.',
      );
    } finally {
      if (mounted) {
        setState(() {
          reenviando = false;
        });
      }
    }
  }

  Future<void> cerrarSesion() async {
    await FirebaseAuth.instance.signOut();
  }

  void mostrarMensaje(String mensaje) {
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
  Widget build(BuildContext context) {
    final usuario =
        FirebaseAuth.instance.currentUser;

    final correo =
        usuario?.email ?? 'tu correo electrónico';

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 420,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.mark_email_unread_outlined,
                    size: 80,
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Verificá tu correo',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                  ),

                  const SizedBox(height: 16),

                  Text(
                    'Te enviamos un enlace de verificación a:',
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    correo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    'Abrí el correo, tocá el enlace de verificación y después volvé a la aplicación.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 12,
                  ),

                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              '¿No encontrás el correo? Revisá también Spam o Correo no deseado.',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  FilledButton.icon(
                    onPressed:
                        comprobando ? null : comprobarCorreo,
                    icon: comprobando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons.verified_outlined,
                          ),
                    label: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Text(
                        'Ya verifiqué mi correo',
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  OutlinedButton.icon(
                    onPressed:
                        reenviando || segundosReenvio > 0
                            ? null
                            : reenviarCorreo,
                    icon: const Icon(
                      Icons.refresh,
                    ),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Text(
                        segundosReenvio > 0
                            ? 'Reenviar en $segundosReenvio s'
                            : 'Reenviar correo',
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextButton(
                    onPressed:
                        comprobando || reenviando
                            ? null
                            : cerrarSesion,
                    child: const Text(
                      'Usar otra cuenta',
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