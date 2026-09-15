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

    // Para archivos de demostración (< 800 KB, como GIFs cortos o fotos):
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
      case 'mov':
        return 'video/quicktime';
      default:
        return 'application/octet-stream';
    }
  }

  static Future<String> _subirArchivoGrande(
    Uint8List bytes,
    String nombreArchivo,
  ) async {
    // Intento 1: Catbox.moe (Soporta GIF, MP4, WebP, PNG, JPG hasta 200MB, respuesta texto plano)
    final urlCatbox = await _subirACatbox(bytes, nombreArchivo);
    if (urlCatbox != null && urlCatbox.isNotEmpty) {
      return urlCatbox;
    }

    // Intento 2: Litterbox (Servicio temporal de Catbox con alta disponibilidad)
    final urlLitterbox = await _subirALitterbox(bytes, nombreArchivo);
    if (urlLitterbox != null && urlLitterbox.isNotEmpty) {
      return urlLitterbox;
    }

    // Intento 3: FreeImage.host (Soporta imágenes y GIFs)
    final urlFreeImage = await _subirAFreeImage(bytes, nombreArchivo);
    if (urlFreeImage != null && urlFreeImage.isNotEmpty) {
      return urlFreeImage;
    }

    // Intento 4: TmpFiles API (Soporta cualquier archivo temporalmente)
    final urlTmpFiles = await _subirATmpFiles(bytes, nombreArchivo);
    if (urlTmpFiles != null && urlTmpFiles.isNotEmpty) {
      return urlTmpFiles;
    }

    throw Exception(
      'No se pudo subir el archivo pesado a los servidores externos. '
      'Recomendación: usa un GIF o imagen de menos de 800 KB para guardado instantáneo, '
      'o ingresa un enlace directo (ej: YouTube o enlace web).',
    );
  }

  static Future<String?> _subirACatbox(
    Uint8List bytes,
    String nombreArchivo,
  ) async {
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
        const Duration(seconds: 25),
      );

      final responseBody = (await response.stream.bytesToString()).trim();
      if (response.statusCode == 200 && responseBody.startsWith('https://files.catbox.moe/')) {
        return responseBody;
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> _subirALitterbox(
    Uint8List bytes,
    String nombreArchivo,
  ) async {
    try {
      final uri = Uri.parse('https://litterbox.catbox.moe/resources/internals/api.php');
      final request = http.MultipartRequest('POST', uri)
        ..fields['reqtype'] = 'fileupload'
        ..fields['time'] = '72h'
        ..files.add(
          http.MultipartFile.fromBytes(
            'fileToUpload',
            bytes,
            filename: nombreArchivo,
          ),
        );

      final response = await request.send().timeout(
        const Duration(seconds: 25),
      );

      final responseBody = (await response.stream.bytesToString()).trim();
      if (response.statusCode == 200 && responseBody.startsWith('https://litter.catbox.moe/')) {
        return responseBody;
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> _subirAFreeImage(
    Uint8List bytes,
    String nombreArchivo,
  ) async {
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
        const Duration(seconds: 25),
      );

      if (response.statusCode == 200) {
        final body = response.body.trim();
        if (body.startsWith('{') || body.startsWith('[')) {
          final jsonResponse = jsonDecode(body) as Map<String, dynamic>;
          if (jsonResponse['status_code'] == 200) {
            final link = jsonResponse['image']?['url'] as String?;
            if (link != null && link.isNotEmpty) {
              return link;
            }
          }
        }
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> _subirATmpFiles(
    Uint8List bytes,
    String nombreArchivo,
  ) async {
    try {
      final uri = Uri.parse('https://tmpfiles.org/api/v1/upload');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',
            bytes,
            filename: nombreArchivo,
          ),
        );

      final response = await request.send().timeout(
        const Duration(seconds: 25),
      );

      if (response.statusCode == 200) {
        final responseBody = (await response.stream.bytesToString()).trim();
        if (responseBody.startsWith('{')) {
          final jsonResponse = jsonDecode(responseBody) as Map<String, dynamic>;
          if (jsonResponse['status'] == 'success') {
            final url = jsonResponse['data']?['url'] as String?;
            if (url != null && url.isNotEmpty) {
              // Convertir tmpfiles.org/123/name a tmpfiles.org/dl/123/name para acceso directo al archivo
              return url.replaceFirst('tmpfiles.org/', 'tmpfiles.org/dl/');
            }
          }
        }
      }
    } catch (_) {}
    return null;
  }
}
