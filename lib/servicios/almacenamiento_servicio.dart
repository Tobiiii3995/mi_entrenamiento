import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'web_helper_stub.dart' if (dart.library.html) 'web_helper_html.dart';

class AlmacenamientoServicio {
  static final ImagePicker _picker = ImagePicker();

  /// Permite al usuario seleccionar un archivo GIF/Video/Imagen de su dispositivo
  /// y lo sube de forma 100% gratuita y automática.
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

    return await _subirArchivoGratis(bytes, nombreArchivo);
  }

  static Future<String> _subirArchivoGratis(Uint8List bytes, String nombreArchivo) async {
    // Intento 1: Catbox.moe (Gratuito, rápido, acepta GIFs y Videos MP4 hasta 200MB)
    try {
      final uri = Uri.parse('https://catbox.moe/user/api.php');
      final request = http.MultipartRequest('POST', uri)
        ..fields['reqtype'] = 'fileupload'
        ..files.add(
          http.MultipartFile.fromBytes(
            'fileToUpload',
            bytes,
            filename: nombreArchivo,
          ),
        );

      final response = await request.send().timeout(
        const Duration(seconds: 30),
      );

      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 && responseBody.trim().startsWith('http')) {
        return responseBody.trim();
      }
    } catch (_) {}

    // Intento 2 (Fallback): FreeImage.host API
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
        const Duration(seconds: 30),
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

    throw Exception('No se pudo subir el archivo. Verificá tu conexión a internet.');
  }
}
