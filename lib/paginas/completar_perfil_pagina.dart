import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../repositorios/usuario_repositorio.dart';
import '../servicios/base_datos_servicio.dart';
import '../servicios/usuario_firestore_servicio.dart';

class CompletarPerfilPagina
    extends StatefulWidget {
  final VoidCallback onCompletado;

  const CompletarPerfilPagina({
    super.key,
    required this.onCompletado,
  });

  @override
  State<CompletarPerfilPagina> createState() =>
      _CompletarPerfilPaginaState();
}

class _CompletarPerfilPaginaState
    extends State<CompletarPerfilPagina> {
  final alturaController =
      TextEditingController();

  final pesoController =
      TextEditingController();

  DateTime? fechaNacimiento;

  String? objetivo;

  bool guardando = false;

  final objetivos = const [
    'Mejorar condición física',
    'Bajar grasa corporal',
    'Ganar masa muscular',
    'Aumentar fuerza',
    'Rendimiento deportivo',
    'Salud y bienestar',
  ];

  @override
  void dispose() {
    alturaController.dispose();
    pesoController.dispose();
    super.dispose();
  }

  int calcularEdad(
    DateTime nacimiento,
  ) {
    final hoy = DateTime.now();

    var edad =
        hoy.year - nacimiento.year;

    if (hoy.month < nacimiento.month ||
        (hoy.month ==
                nacimiento.month &&
            hoy.day < nacimiento.day)) {
      edad--;
    }

    return edad;
  }

  Future<void>
      seleccionarFechaNacimiento() async {
    final hoy = DateTime.now();

    final ultimaFechaPermitida =
        DateTime(
      hoy.year - 14,
      hoy.month,
      hoy.day,
    );

    final primeraFechaPermitida =
        DateTime(
      hoy.year - 90,
      hoy.month,
      hoy.day,
    );

    final seleccionada =
        await showDatePicker(
      context: context,
      initialDate: DateTime(
        hoy.year - 20,
        hoy.month,
        hoy.day,
      ),
      firstDate:
          primeraFechaPermitida,
      lastDate:
          ultimaFechaPermitida,
      helpText:
          'Fecha de nacimiento',
    );

    if (seleccionada == null) {
      return;
    }

    setState(() {
      fechaNacimiento =
          seleccionada;
    });
  }

  double? convertirNumero(
    String texto,
  ) {
    return double.tryParse(
      texto
          .trim()
          .replaceAll(',', '.'),
    );
  }

  Future<void> guardarPerfil() async {
    if (fechaNacimiento == null) {
      mostrarMensaje(
        'Seleccioná tu fecha de nacimiento.',
      );
      return;
    }

    final edad =
        calcularEdad(
      fechaNacimiento!,
    );

    if (edad < 14 ||
        edad > 90) {
      mostrarMensaje(
        'La edad permitida es de 14 a 90 años.',
      );
      return;
    }

    final altura =
        convertirNumero(
      alturaController.text,
    );

    if (altura == null ||
        altura < 1.20 ||
        altura > 2.30) {
      mostrarMensaje(
        'Ingresá una altura válida entre 1,20 y 2,30 m.',
      );
      return;
    }

    final peso =
        convertirNumero(
      pesoController.text,
    );

    if (peso == null ||
        peso < 25 ||
        peso > 300) {
      mostrarMensaje(
        'Ingresá un peso válido entre 25 y 300 kg.',
      );
      return;
    }

    if (objetivo == null) {
      mostrarMensaje(
        'Seleccioná tu objetivo.',
      );
      return;
    }

    final usuarioAuth =
        FirebaseAuth.instance.currentUser;

    if (usuarioAuth == null) {
      mostrarMensaje(
        'No se encontró la sesión del usuario.',
      );
      return;
    }

    setState(() {
      guardando = true;
    });

    try {
      final datos =
          await UsuarioFirestoreServicio
              .completarPerfilActual(
        fechaNacimiento:
            fechaNacimiento!,
        edad: edad,
        altura: altura,
        peso: peso,
        objetivo: objetivo!,
      );

      final usuarioRepositorio =
          UsuarioRepositorio(
        BaseDatosServicio.db,
      );

      final nombre =
          (datos['nombre'] ??
                  usuarioAuth.displayName ??
                  '')
              .toString();

      final correo =
          (datos['correo'] ??
                  usuarioAuth.email ??
                  '')
              .toString();

      final rol =
          (datos['rol'] ?? 'alumno')
              .toString();

      await usuarioRepositorio
          .guardarUsuario(
        id: usuarioAuth.uid,
        nombre: nombre,
        edad: edad,
        altura: altura,
        pesoActual: peso,
        objetivo: objetivo!,
        correo: correo,
        rol: rol,
      );

      final historial =
          await usuarioRepositorio
              .obtenerHistorialPeso(
        usuarioAuth.uid,
      );

      if (historial.isEmpty) {
        final ahora =
            DateTime.now();

        await usuarioRepositorio
            .guardarPeso(
          id: ahora
              .microsecondsSinceEpoch
              .toString(),
          usuarioId:
              usuarioAuth.uid,
          peso: peso,
          fecha: ahora,
        );
      }

      widget.onCompletado();
    } catch (_) {
      mostrarMensaje(
        'No se pudo guardar el perfil.',
      );
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
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
        content: Text(mensaje),
      ),
    );
  }

  String textoFecha() {
    if (fechaNacimiento == null) {
      return 'Seleccionar fecha';
    }

    final fecha =
        fechaNacimiento!;

    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Completar perfil',
        ),
        automaticallyImplyLeading:
            false,
      ),
      body: SafeArea(
        top: false,
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
                  Text(
                    'Contanos un poco sobre vos',
                    textAlign:
                        TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  const Text(
                    'Estos datos se utilizan para personalizar tu seguimiento.',
                    textAlign:
                        TextAlign.center,
                  ),

                  const SizedBox(
                    height: 32,
                  ),

                  OutlinedButton.icon(
                    onPressed:
                        seleccionarFechaNacimiento,
                    icon: const Icon(
                      Icons
                          .calendar_month_outlined,
                    ),
                    label: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Text(
                        'Fecha de nacimiento: ${textoFecha()}',
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  TextField(
                    controller:
                        alturaController,
                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .allow(
                        RegExp(
                          r'[0-9,.]',
                        ),
                      ),
                    ],
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Altura en metros',
                      hintText: 'Ej: 1,75',
                      prefixIcon: Icon(
                        Icons.height,
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
                        pesoController,
                    keyboardType:
                        const TextInputType
                            .numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .allow(
                        RegExp(
                          r'[0-9,.]',
                        ),
                      ),
                    ],
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Peso en kg',
                      hintText: 'Ej: 74,5',
                      prefixIcon: Icon(
                        Icons
                            .monitor_weight_outlined,
                      ),
                      border:
                          OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  DropdownButtonFormField<String>(
                    initialValue: objetivo,
                    decoration:
                        const InputDecoration(
                      labelText:
                          'Objetivo principal',
                      prefixIcon: Icon(
                        Icons.flag_outlined,
                      ),
                      border:
                          OutlineInputBorder(),
                    ),
                    items: objetivos
                        .map(
                          (valor) =>
                              DropdownMenuItem(
                            value: valor,
                            child:
                                Text(valor),
                          ),
                        )
                        .toList(),
                    onChanged: (valor) {
                      setState(() {
                        objetivo =
                            valor;
                      });
                    },
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  FilledButton(
                    onPressed: guardando
                        ? null
                        : guardarPerfil,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: guardando
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Guardar y continuar',
                            ),
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  TextButton(
                    onPressed: guardando
                        ? null
                        : () async {
                            await FirebaseAuth
                                .instance
                                .signOut();
                          },
                    child: const Text(
                      'Cerrar sesión',
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