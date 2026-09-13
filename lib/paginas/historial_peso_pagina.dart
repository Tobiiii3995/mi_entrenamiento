import 'package:flutter/material.dart';

import '../servicios/datos_app.dart';

class HistorialPesoPagina extends StatelessWidget {
  const HistorialPesoPagina({super.key});

  String fechaTexto(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');

    return '$dia/$mes/${fecha.year}';
  }

  @override
  Widget build(BuildContext context) {
    final historial = [...DatosApp.historialPeso];

    historial.sort(
      (a, b) => b.fecha.compareTo(a.fecha),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de peso'),
      ),
      body: SafeArea(
        top: false,
        child: historial.isEmpty
            ? const Center(
                child: Text(
                  'Todavía no hay registros de peso.',
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  80,
                ),
                itemCount: historial.length,
                itemBuilder: (context, index) {
                  final registro = historial[index];

                  return Card(
                    margin: const EdgeInsets.only(
                      bottom: 12,
                    ),
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(
                          Icons.monitor_weight_outlined,
                        ),
                      ),
                      title: Text(
                        '${registro.peso.toStringAsFixed(1)} kg',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        fechaTexto(registro.fecha),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}