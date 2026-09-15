import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../modelos/registro_peso.dart';
import '../repositorios/usuario_repositorio.dart';
import '../servicios/almacenamiento_servicio.dart';
import '../servicios/base_datos_servicio.dart';
import '../servicios/datos_app.dart';
import '../servicios/usuario_firestore_servicio.dart';
import '../widgets/avatar_usuario.dart';

class EditarPerfilPagina extends StatefulWidget {
  const EditarPerfilPagina({
    super.key,
  });

  @override
  State<EditarPerfilPagina> createState() =>
      _EditarPerfilPaginaState();
}

class _EditarPerfilPaginaState
    extends State<EditarPerfilPagina> {
  late final UsuarioRepositorio usuarioRepositorio;

  late final TextEditingController nombreController;
  late final TextEditingController alturaController;
  late final TextEditingController pesoController;

  DateTime? fechaNacimiento;
  String? objetivo;
  String fotoUrl = '';

  bool cargando = true;
  bool guardando = false;
  bool subiendoFoto = false;

  final List<String> objetivos = const [
    'Mejorar condición física',
    'Bajar grasa corporal',
    'Ganar masa muscular',
    'Aumentar fuerza',
    'Rendimiento deportivo',
    'Salud y bienestar',
  ];

  @override
  void initState() {
    super.initState();

    usuarioRepositorio = UsuarioRepositorio(
      BaseDatosServicio.db,
    );

    final usuario =
        DatosApp.usuarioActual;

    nombreController =
        TextEditingController(
      text: usuario.nombre,
    );

    alturaController =
        TextEditingController(
      text: usuario.altura > 0
          ? usuario.altura.toString()
          : '',
    );

    pesoController =
        TextEditingController(
      text: usuario.peso > 0
          ? usuario.peso.toString()
          : '',
    );

    fotoUrl = usuario.fotoUrl;

    if (objetivos.contains(usuario.objetivo)) {
      objetivo =
          usuario.objetivo;
    }

    cargarDatosFirestore();
  }

  @override
  void dispose() {
    nombreController.dispose();
    alturaController.dispose();
    pesoController.dispose();
    super.dispose();
  }

  Future<void> cargarDatosFirestore() async {
    try {
      final datos =
          await UsuarioFirestoreServicio
              .obtenerUsuarioActual();

      if (!mounted) {
        return;
      }

      final fecha =
          datos['fechaNacimiento'];

      if (fecha is Timestamp) {
        fechaNacimiento =
            fecha.toDate();
      }

      final objetivoFirestore =
          (datos['objetivo'] ?? '')
              .toString();

      if (objetivos.contains(
        objetivoFirestore,
      )) {
        objetivo =
            objetivoFirestore;
      }

      final altura =
          datos['altura'];

      if (altura is num &&
          altura > 0) {
        alturaController.text =
            altura.toDouble().toString();
      }

      final peso =
          datos['peso'];

      if (peso is num &&
          peso > 0) {
        pesoController.text =
            peso.toDouble().toString();
      }

      final nombre =
          (datos['nombre'] ?? '')
              .toString()
              .trim();

      if (nombre.isNotEmpty) {
        nombreController.text =
            nombre;
      }

      final fotoUrlFs =
          (datos['fotoUrl'] ?? '')
              .toString()
              .trim();

      if (fotoUrlFs.isNotEmpty) {
        fotoUrl = fotoUrlFs;
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() {
          cargando = false;
        });
      }
    }
  }

  Future<void> seleccionarYSubirFoto() async {
    if (subiendoFoto || guardando) return;

    setState(() {
      subiendoFoto = true;
    });

    try {
      final nuevaUrl = await AlmacenamientoServicio.seleccionarYSubirDemostracion();
      if (nuevaUrl != null && mounted) {
        setState(() {
          fotoUrl = nuevaUrl;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Foto seleccionada con éxito! Guardá los cambios para confirmarla.'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        var mensaje = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No se pudo cargar la foto: $mensaje'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          subiendoFoto = false;
        });
      }
    }
  }

  int calcularEdad(
    DateTime nacimiento,
  ) {
    final hoy =
        DateTime.now();

    var edad =
        hoy.year - nacimiento.year;

    if (hoy.month < nacimiento.month ||
        (hoy.month == nacimiento.month &&
            hoy.day < nacimiento.day)) {
      edad--;
    }

    return edad;
  }

  Future<void>
      seleccionarFechaNacimiento() async {
    final hoy =
        DateTime.now();

    final fechaMinima =
        DateTime(
      hoy.year - 90,
      hoy.month,
      hoy.day,
    );

    final fechaMaxima =
        DateTime(
      hoy.year - 14,
      hoy.month,
      hoy.day,
    );

    var fechaInicial =
        fechaNacimiento ??
            DateTime(
              hoy.year - 30,
              hoy.month,
              hoy.day,
            );

    if (fechaInicial.isBefore(
      fechaMinima,
    )) {
      fechaInicial =
          fechaMinima;
    }

    if (fechaInicial.isAfter(
      fechaMaxima,
    )) {
      fechaInicial =
          fechaMaxima;
    }

    final seleccionada =
        await showDatePicker(
      context: context,
      initialDate:
          fechaInicial,
      firstDate:
          fechaMinima,
      lastDate:
          fechaMaxima,
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

  String textoFechaNacimiento() {
    final fecha =
        fechaNacimiento;

    if (fecha == null) {
      return 'Seleccionar fecha';
    }

    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }

  void mostrarMensaje(
    String mensaje,
  ) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
        ),
      ),
    );
  }

  Future<void> guardarCambios() async {
    if (guardando) {
      return;
    }

    final nombre =
        nombreController.text.trim();

    if (nombre.length < 2 ||
        nombre.length > 60) {
      mostrarMensaje(
        'Ingresá un nombre válido de entre 2 y 60 caracteres.',
      );
      return;
    }

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

    setState(() {
      guardando = true;
    });

    try {
      final usuario =
          DatosApp.usuarioActual;

      final pesoAnterior =
          usuario.peso;

      // Primero guardamos en la nube.
      await UsuarioFirestoreServicio
          .actualizarPerfilActual(
        nombre: nombre,
        fechaNacimiento:
            fechaNacimiento!,
        edad: edad,
        altura: altura,
        peso: peso,
        objetivo: objetivo!,
        fotoUrl: fotoUrl,
      );

      // Después actualizamos el usuario
      // que está utilizando la app.
      usuario.nombre =
          nombre;

      usuario.edad =
          edad;

      usuario.altura =
          altura;

      usuario.peso =
          peso;

      usuario.objetivo =
          objetivo!;

      usuario.fotoUrl =
          fotoUrl;

      await usuarioRepositorio
          .guardarUsuario(
        id: usuario.id,
        nombre: usuario.nombre,
        edad: usuario.edad,
        altura: usuario.altura,
        pesoActual: usuario.peso,
        objetivo: usuario.objetivo,
        correo: usuario.correo,
        rol: usuario.rol,
      );

      if (peso != pesoAnterior) {
        final ahora =
            DateTime.now();

        DatosApp.historialPeso.add(
          RegistroPeso(
            fecha: ahora,
            peso: peso,
          ),
        );

        await usuarioRepositorio
            .guardarPeso(
          id: ahora
              .microsecondsSinceEpoch
              .toString(),
          usuarioId: usuario.id,
          peso: peso,
          fecha: ahora,
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.pop(
        context,
        true,
      );
    } catch (_) {
      mostrarMensaje(
        'No se pudieron guardar los cambios.',
      );
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    if (cargando) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Editar perfil',
          ),
        ),
        body: const Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    final edadActual =
        fechaNacimiento == null
            ? null
            : calcularEdad(
                fechaNacimiento!,
              );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar perfil',
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
              Center(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        AvatarUsuario(
                          fotoUrl: fotoUrl,
                          nombre: nombreController.text.isNotEmpty
                              ? nombreController.text
                              : DatosApp.usuarioActual.nombre,
                          radio: 50,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Material(
                            color: Theme.of(context).colorScheme.primary,
                            shape: const CircleBorder(),
                            elevation: 3,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: subiendoFoto || guardando
                                  ? null
                                  : seleccionarYSubirFoto,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: subiendoFoto
                                    ? const SizedBox(
                                        width: 18,
                                        height: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: subiendoFoto || guardando
                          ? null
                          : seleccionarYSubirFoto,
                      icon: const Icon(
                        Icons.photo_library_outlined,
                        size: 16,
                      ),
                      label: const Text('Cambiar foto de perfil'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                'Datos personales',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              TextField(
                controller:
                    nombreController,
                maxLength: 60,
                textCapitalization:
                    TextCapitalization.words,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Nombre y apellido',
                  border:
                      OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.person_outline,
                  ),
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              OutlinedButton.icon(
                onPressed:
                    seleccionarFechaNacimiento,
                icon: const Icon(
                  Icons.calendar_month_outlined,
                ),
                label: Padding(
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  child: Text(
                    'Fecha de nacimiento: '
                    '${textoFechaNacimiento()}',
                  ),
                ),
              ),

              if (edadActual != null) ...[
                const SizedBox(
                  height: 8,
                ),
                Text(
                  'Edad actual: $edadActual años',
                ),
              ],

              const SizedBox(
                height: 14,
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
                  hintText:
                      'Ej: 1,75',
                  border:
                      OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.height,
                  ),
                ),
              ),

              const SizedBox(
                height: 14,
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
                      'Peso actual en kg',
                  hintText:
                      'Ej: 74,5',
                  border:
                      OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons
                        .monitor_weight_outlined,
                  ),
                ),
              ),

              const SizedBox(
                height: 14,
              ),

              DropdownButtonFormField<String>(
                initialValue:
                    objetivo,
                decoration:
                    const InputDecoration(
                  labelText:
                      'Objetivo principal',
                  border:
                      OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.flag_outlined,
                  ),
                ),
                items: objetivos
                    .map(
                      (valor) =>
                          DropdownMenuItem<String>(
                        value: valor,
                        child: Text(
                          valor,
                        ),
                      ),
                    )
                    .toList(),
                onChanged:
                    guardando
                        ? null
                        : (valor) {
                            setState(() {
                              objetivo =
                                  valor;
                            });
                          },
              ),

              const SizedBox(
                height: 24,
              ),

              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed:
                      guardando
                          ? null
                          : guardarCambios,
                  icon: guardando
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(
                          Icons.save_outlined,
                        ),
                  label: Text(
                    guardando
                        ? 'Guardando...'
                        : 'Guardar cambios',
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