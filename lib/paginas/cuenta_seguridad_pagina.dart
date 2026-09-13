import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CuentaSeguridadPagina extends StatefulWidget {
  const CuentaSeguridadPagina({
    super.key,
  });

  @override
  State<CuentaSeguridadPagina> createState() =>
      _CuentaSeguridadPaginaState();
}

class _CuentaSeguridadPaginaState
    extends State<CuentaSeguridadPagina> {
  bool procesando = false;

  User? get usuario =>
      FirebaseAuth.instance.currentUser;

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

  Future<bool> reautenticar(
    String contrasena,
  ) async {
    final actual = usuario;

    if (actual == null ||
        actual.email == null) {
      mostrarMensaje(
        'No se encontró la cuenta actual.',
      );
      return false;
    }

    try {
      final credencial =
          EmailAuthProvider.credential(
        email: actual.email!,
        password: contrasena,
      );

      await actual.reauthenticateWithCredential(
        credencial,
      );

      return true;
    } on FirebaseAuthException catch (e) {
      String mensaje =
          'No se pudo confirmar tu identidad.';

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          mensaje =
              'La contraseña actual es incorrecta.';
          break;

        case 'too-many-requests':
          mensaje =
              'Demasiados intentos. Probá nuevamente más tarde.';
          break;

        case 'network-request-failed':
          mensaje =
              'No se pudo conectar a internet.';
          break;
      }

      mostrarMensaje(mensaje);
      return false;
    }
  }

  Future<void> cambiarContrasena() async {
    final resultado =
        await showDialog<_DatosCambioContrasena>(
      context: context,
      builder: (context) {
        return const _CambiarContrasenaDialog();
      },
    );

    if (resultado == null ||
        procesando) {
      return;
    }

    setState(() {
      procesando = true;
    });

    try {
      final correcto =
          await reautenticar(
        resultado.contrasenaActual,
      );

      if (!correcto) {
        return;
      }

      final actual = usuario;

      if (actual == null) {
        mostrarMensaje(
          'No se encontró la cuenta actual.',
        );
        return;
      }

      await actual.updatePassword(
        resultado.nuevaContrasena,
      );

      mostrarMensaje(
        'Contraseña actualizada correctamente.',
      );
    } on FirebaseAuthException catch (e) {
      String mensaje =
          'No se pudo cambiar la contraseña.';

      switch (e.code) {
        case 'weak-password':
          mensaje =
              'La nueva contraseña es demasiado débil.';
          break;

        case 'requires-recent-login':
          mensaje =
              'Por seguridad, volvé a iniciar sesión e intentá nuevamente.';
          break;

        case 'network-request-failed':
          mensaje =
              'No se pudo conectar a internet.';
          break;
      }

      mostrarMensaje(mensaje);
    } finally {
      if (mounted) {
        setState(() {
          procesando = false;
        });
      }
    }
  }

  Future<void> cambiarCorreo() async {
    final resultado =
        await showDialog<_DatosCambioCorreo>(
      context: context,
      builder: (context) {
        return const _CambiarCorreoDialog();
      },
    );

    if (resultado == null ||
        procesando) {
      return;
    }

    final nuevoCorreo =
        resultado.nuevoCorreo.trim();

    if (nuevoCorreo ==
        usuario?.email) {
      mostrarMensaje(
        'Ese ya es tu correo actual.',
      );
      return;
    }

    setState(() {
      procesando = true;
    });

    try {
      final correcto =
          await reautenticar(
        resultado.contrasenaActual,
      );

      if (!correcto) {
        return;
      }

      final actual = usuario;

      if (actual == null) {
        mostrarMensaje(
          'No se encontró la cuenta actual.',
        );
        return;
      }

      await FirebaseAuth.instance
          .setLanguageCode('es');

      await actual.verifyBeforeUpdateEmail(
        nuevoCorreo,
      );

      if (!mounted) {
        return;
      }

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text(
              'Verificá el nuevo correo',
            ),
            content: Text(
              'Enviamos un enlace a $nuevoCorreo.\n\n'
              'El correo de tu cuenta no cambiará hasta que abras ese enlace y lo confirmes.\n\n'
              'Si no lo encontrás, revisá Spam o Correo no deseado.',
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
    } on FirebaseAuthException catch (e) {
      String mensaje =
          'No se pudo iniciar el cambio de correo.';

      switch (e.code) {
        case 'invalid-email':
          mensaje =
              'El nuevo correo no es válido.';
          break;

        case 'email-already-in-use':
          mensaje =
              'Ese correo ya está siendo utilizado por otra cuenta.';
          break;

        case 'requires-recent-login':
          mensaje =
              'Por seguridad, volvé a iniciar sesión e intentá nuevamente.';
          break;

        case 'too-many-requests':
          mensaje =
              'Demasiados intentos. Probá nuevamente más tarde.';
          break;

        case 'network-request-failed':
          mensaje =
              'No se pudo conectar a internet.';
          break;
      }

      mostrarMensaje(mensaje);
    } finally {
      if (mounted) {
        setState(() {
          procesando = false;
        });
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final actual = usuario;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cuenta y seguridad',
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
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                'Cuenta',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.email_outlined,
                  ),
                  title: const Text(
                    'Correo electrónico',
                  ),
                  subtitle: Text(
                    actual?.email ??
                        'Sin correo',
                  ),
                ),
              ),

              Card(
                child: ListTile(
                  leading: Icon(
                    actual?.emailVerified ==
                            true
                        ? Icons.verified_outlined
                        : Icons.warning_amber_outlined,
                  ),
                  title: const Text(
                    'Estado del correo',
                  ),
                  subtitle: Text(
                    actual?.emailVerified ==
                            true
                        ? 'Correo verificado'
                        : 'Correo sin verificar',
                  ),
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              const Text(
                'Seguridad',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              SizedBox(
                width: double.infinity,
                child:
                    OutlinedButton.icon(
                  onPressed: procesando
                      ? null
                      : cambiarContrasena,
                  icon: const Icon(
                    Icons.lock_outline,
                  ),
                  label: const Text(
                    'Cambiar contraseña',
                  ),
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              SizedBox(
                width: double.infinity,
                child:
                    OutlinedButton.icon(
                  onPressed: procesando
                      ? null
                      : cambiarCorreo,
                  icon: const Icon(
                    Icons.alternate_email,
                  ),
                  label: const Text(
                    'Cambiar correo electrónico',
                  ),
                ),
              ),

              if (procesando) ...[
                const SizedBox(
                  height: 24,
                ),
                const Center(
                  child:
                      CircularProgressIndicator(),
                ),
              ],

              const SizedBox(
                height: 28,
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
                        Icons.info_outline,
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Text(
                          'Los correos de verificación o seguridad pueden llegar a Spam o Correo no deseado. Si no los encontrás en la bandeja de entrada, revisá esas carpetas.',
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

class _DatosCambioContrasena {
  final String contrasenaActual;
  final String nuevaContrasena;

  const _DatosCambioContrasena({
    required this.contrasenaActual,
    required this.nuevaContrasena,
  });
}

class _CambiarContrasenaDialog
    extends StatefulWidget {
  const _CambiarContrasenaDialog();

  @override
  State<_CambiarContrasenaDialog>
      createState() =>
          _CambiarContrasenaDialogState();
}

class _CambiarContrasenaDialogState
    extends State<_CambiarContrasenaDialog> {
  final actualController =
      TextEditingController();

  final nuevaController =
      TextEditingController();

  final repetirController =
      TextEditingController();

  bool ocultarActual = true;
  bool ocultarNueva = true;
  bool ocultarRepetir = true;

  @override
  void dispose() {
    actualController.dispose();
    nuevaController.dispose();
    repetirController.dispose();
    super.dispose();
  }

  void guardar() {
    final actual =
        actualController.text;

    final nueva =
        nuevaController.text;

    final repetir =
        repetirController.text;

    if (actual.isEmpty ||
        nueva.isEmpty ||
        repetir.isEmpty) {
      mostrarError(
        'Completá todos los campos.',
      );
      return;
    }

    if (nueva.length < 8) {
      mostrarError(
        'La nueva contraseña debe tener al menos 8 caracteres.',
      );
      return;
    }

    if (nueva != repetir) {
      mostrarError(
        'Las contraseñas nuevas no coinciden.',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    Navigator.pop(
      context,
      _DatosCambioContrasena(
        contrasenaActual: actual,
        nuevaContrasena: nueva,
      ),
    );
  }

  void mostrarError(
    String mensaje,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      title: const Text(
        'Cambiar contraseña',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            TextField(
              controller:
                  actualController,
              obscureText:
                  ocultarActual,
              decoration:
                  InputDecoration(
                labelText:
                    'Contraseña actual',
                suffixIcon:
                    IconButton(
                  onPressed: () {
                    setState(() {
                      ocultarActual =
                          !ocultarActual;
                    });
                  },
                  icon: Icon(
                    ocultarActual
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
                  nuevaController,
              obscureText:
                  ocultarNueva,
              decoration:
                  InputDecoration(
                labelText:
                    'Nueva contraseña',
                helperText:
                    'Mínimo 8 caracteres',
                suffixIcon:
                    IconButton(
                  onPressed: () {
                    setState(() {
                      ocultarNueva =
                          !ocultarNueva;
                    });
                  },
                  icon: Icon(
                    ocultarNueva
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
                  repetirController,
              obscureText:
                  ocultarRepetir,
              decoration:
                  InputDecoration(
                labelText:
                    'Repetir nueva contraseña',
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
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              onSubmitted: (_) {
                guardar();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          child: const Text(
            'Cancelar',
          ),
        ),
        FilledButton(
          onPressed: guardar,
          child: const Text(
            'Guardar',
          ),
        ),
      ],
    );
  }
}

class _DatosCambioCorreo {
  final String contrasenaActual;
  final String nuevoCorreo;

  const _DatosCambioCorreo({
    required this.contrasenaActual,
    required this.nuevoCorreo,
  });
}

class _CambiarCorreoDialog
    extends StatefulWidget {
  const _CambiarCorreoDialog();

  @override
  State<_CambiarCorreoDialog>
      createState() =>
          _CambiarCorreoDialogState();
}

class _CambiarCorreoDialogState
    extends State<_CambiarCorreoDialog> {
  final correoController =
      TextEditingController();

  final contrasenaController =
      TextEditingController();

  bool ocultarContrasena = true;

  @override
  void dispose() {
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  void continuar() {
    final correo =
        correoController.text.trim();

    final contrasena =
        contrasenaController.text;

    if (correo.isEmpty ||
        contrasena.isEmpty) {
      mostrarError(
        'Completá todos los campos.',
      );
      return;
    }

    if (!correo.contains('@') ||
        !correo.contains('.')) {
      mostrarError(
        'Ingresá un correo válido.',
      );
      return;
    }

    FocusScope.of(context).unfocus();

    Navigator.pop(
      context,
      _DatosCambioCorreo(
        contrasenaActual:
            contrasena,
        nuevoCorreo: correo,
      ),
    );
  }

  void mostrarError(
    String mensaje,
  ) {
    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(mensaje),
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return AlertDialog(
      title: const Text(
        'Cambiar correo',
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            TextField(
              controller:
                  correoController,
              keyboardType:
                  TextInputType.emailAddress,
              decoration:
                  const InputDecoration(
                labelText:
                    'Nuevo correo',
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            TextField(
              controller:
                  contrasenaController,
              obscureText:
                  ocultarContrasena,
              decoration:
                  InputDecoration(
                labelText:
                    'Contraseña actual',
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
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              onSubmitted: (_) {
                continuar();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
          child: const Text(
            'Cancelar',
          ),
        ),
        FilledButton(
          onPressed: continuar,
          child: const Text(
            'Continuar',
          ),
        ),
      ],
    );
  }
}