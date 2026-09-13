import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../servicios/web_helper_stub.dart' if (dart.library.html) '../servicios/web_helper_html.dart';

class DialogoDemostracion extends StatelessWidget {
  final String nombreEjercicio;
  final String urlMedia;

  const DialogoDemostracion({
    super.key,
    required this.nombreEjercicio,
    required this.urlMedia,
  });

  static String? obtenerYouTubeId(String url) {
    final regExp = RegExp(
      r'(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|e(?:mbed)?)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }

  static bool esImagenOGif(String url) {
    final urlMinuscula = url.toLowerCase();
    return urlMinuscula.contains('.gif') ||
        urlMinuscula.contains('.png') ||
        urlMinuscula.contains('.jpg') ||
        urlMinuscula.contains('.jpeg') ||
        urlMinuscula.contains('.webp') ||
        urlMinuscula.contains('giphy.com') ||
        urlMinuscula.contains('tenor.com') ||
        urlMinuscula.contains('imgur.com') ||
        urlMinuscula.contains('pinimg.com') ||
        urlMinuscula.contains('firebasestorage.googleapis.com');
  }

  Future<void> _abrirEnlace(BuildContext context, String url) async {
    String urlFormateada = url.trim();
    if (urlFormateada.isEmpty) return;
    if (!urlFormateada.startsWith('http://') && !urlFormateada.startsWith('https://')) {
      urlFormateada = 'https://$urlFormateada';
    }

    if (kIsWeb) {
      abrirUrlWeb(urlFormateada);
      return;
    }

    final uri = Uri.tryParse(urlFormateada);
    if (uri != null) {
      bool launched = false;
      try {
        launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } catch (_) {}

      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo abrir el enlace.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final urlLimpia = urlMedia.trim();
    final youtubeId = obtenerYouTubeId(urlLimpia);
    final esImagen = esImagenOGif(urlLimpia);

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.play_circle_fill, color: Colors.blue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Ejemplo: $nombreEjercicio',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (esImagen) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  urlLimpia,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        border: Border.all(color: Colors.amber.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              size: 40, color: Colors.amber),
                          const SizedBox(height: 8),
                          const Text(
                            'Vista previa no disponible por restricciones del sitio externo (CORS / Hotlink).',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 12),
                          FilledButton.icon(
                            onPressed: () => _abrirEnlace(context, urlLimpia),
                            icon: const Icon(Icons.open_in_new, size: 16),
                            label: const Text('Abrir imagen en navegador'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.amber.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '💡 Consejo: Podés subir el archivo GIF/Video directamente desde tu dispositivo al crear el ejercicio.',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ] else if (youtubeId != null) ...[
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 180,
                        color: Colors.black12,
                        child: const Center(
                          child: Icon(Icons.video_library, size: 48),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => _abrirEnlace(context, urlLimpia),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Toca para ver el video en YouTube',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.open_in_new, size: 40, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      urlLimpia,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.blue.shade900),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        if (!esImagen || youtubeId != null)
          FilledButton.icon(
            onPressed: () => _abrirEnlace(context, urlLimpia),
            icon: const Icon(Icons.open_in_browser),
            label: const Text('Abrir enlace'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
