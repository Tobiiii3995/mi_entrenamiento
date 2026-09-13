import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'web_helper_stub.dart' if (dart.library.html) 'web_helper_html.dart';

class AlmacenamientoServicio {
  static final ImagePicker _picker = ImagePicker();

  /// Permite al usuario seleccionar un archivo GIF/Video/Imagen de su dispositivo
  /// y lo procesa de forma 100% gratuita, instantánea y compatible con Web y Móvil.
  static Future<String?> seleccionarYSubirDemostracion() async {
    Uint8List? bytes;
    String? nombreArchivo;

    if (kIsWeb) {
      final resultado = await seleccionarArchivoWeb();
      if (resultado == null) return null;
      nombreArchivo = resultado['name'] as String?;
      bytes = resultado['bytes'] as Uint8List?;
    } else {
      final XFile? archivo = await _picker.pickMedia();
      if (archivo == null) return null;
      nombreArchivo = archivo.name;
      bytes = await archivo.readAsBytes();
    }

    if (bytes == null || bytes.isEmpty || nombreArchivo == null) {
      throw Exception('No se pudieron leer los datos del archivo seleccionado.');
    }

    // Para archivos de demostración optimizados (< 800 KB, como GIFs cortos o fotos):
    // Se codifican como Data URI en ultra alta velocidad (0ms, 100% inmune a errores de CORS o red).
    if (bytes.lengthInBytes <= 800 * 1024) {
      final mimeType = _obtenerMimeType(nombreArchivo);
      final base64String = base64Encode(bytes);
      return 'data:$mimeType;base64,$base64String';
    }

    return await _subirArchivoGrande(bytes, nombreArchivo);
  }

  static String _obtenerMimeType(String nombre) {
    final ext = nombre.split('.').last.toLowerCase();
    switch (ext) {
      case 'gif':
        return 'image/gif';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      case 'mp4':
        return 'video/mp4';
      default:
        return 'application/octet-stream';
    }
  }

  static Future<String> _subirArchivoGrande(Uint8List bytes, String nombreArchivo) async {
    // Intento 1: ImgBB API (Soporta CORS Web y hasta 32MB)
    try {
      final uri = Uri.parse('https://api.imgbb.com/1/upload?key=6d207e02198a847aa98d0a2a901485a5');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: nombreArchivo,
          ),
        );

      final response = await request.send().timeout(
        const Duration(seconds: 35),
      );

      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        final data = jsonResponse['data'] as Map<String, dynamic>;
        final url = data['url'] as String? ?? data['display_url'] as String?;
        if (url != null && url.isNotEmpty) {
          return url;
        }
      }
    } catch (_) {}

    // Intento 2: FreeImage.host
    try {
      final uri = Uri.parse('https://freeimage.host/api/1/upload');
      final base64Image = base64Encode(bytes);
      final response = await http.post(
        uri,
        body: {
          'key': '6d207e02198a847aa98d0a2a901485a5',
          'action': 'upload',
          'source': base64Image,
          'format': 'json',
        },
      ).timeout(
        const Duration(seconds: 35),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
        if (jsonResponse['status_code'] == 200) {
          final link = jsonResponse['image']?['url'] as String?;
          if (link != null && link.isNotEmpty) {
            return link;
          }
        }
      }
    } catch (_) {}

    throw Exception('No se pudo subir el archivo. Verificá que el archivo sea una imagen o GIF válido.');
  }
}
