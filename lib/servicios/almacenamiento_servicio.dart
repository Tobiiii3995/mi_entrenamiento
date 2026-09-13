import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'web_helper_stub.dart' if (dart.library.html) 'web_helper_html.dart';

class AlmacenamientoServicio {
  static final ImagePicker _picker = ImagePicker();

  // Imgur API Client ID (Anon upload endpoint)
  static const String _imgurClientId = 'c8670868f075d9e';

  /// Permite al usuario seleccionar un archivo GIF/Video/Imagen de su dispositivo
  /// y lo sube de forma 100% gratuita y automática a Imgur (sin tarjeta ni costos en Firebase).
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

    return await _subirAImgur(bytes, nombreArchivo);
  }

  static Future<String> _subirAImgur(Uint8List bytes, String nombreArchivo) async {
    final uri = Uri.parse('https://api.imgur.com/3/upload');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Client-ID $_imgurClientId'
      ..files.add(
        http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: nombreArchivo,
        ),
      );

    final response = await request.send().timeout(
      const Duration(seconds: 45),
      onTimeout: () => throw Exception('La subida tardó demasiado (Timeout). Verificá tu conexión.'),
    );

    final responseBody = await response.stream.bytesToString();
    final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;

    if (response.statusCode == 200 && jsonResponse['success'] == true) {
      final data = jsonResponse['data'] as Map<String, dynamic>;
      final link = data['link'] as String?;
      if (link != null && link.isNotEmpty) {
        return link;
      }
    }

    final errorMsg = jsonResponse['data']?['error'] ?? 'Error al subir a Imgur (Código: ${response.statusCode})';
    throw Exception(errorMsg.toString());
  }
}
