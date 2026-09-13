import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'web_helper_stub.dart' if (dart.library.html) 'web_helper_html.dart';

class AlmacenamientoServicio {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final ImagePicker _picker = ImagePicker();

  /// Permite al usuario seleccionar un archivo GIF/Video/Imagen de su dispositivo
  /// y lo sube directamente a Firebase Storage.
  /// Funciona de forma 100% nativa y compatible tanto en Web como en Android/iOS.
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

    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final nombreLimpio = nombreArchivo.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final rutaStorage = 'ejercicios_demostraciones/${timestamp}_$nombreLimpio';

    final ref = _storage.ref().child(rutaStorage);

    final String? extension = nombreArchivo.contains('.') ? nombreArchivo.split('.').last : null;

    final metadata = SettableMetadata(
      contentType: _obtenerContentType(extension),
    );

    try {
      final UploadTask task = ref.putData(bytes, metadata);
      final snapshot = await task.whenComplete(() {}).timeout(
        const Duration(seconds: 45),
        onTimeout: () => throw Exception('La subida a Firebase Storage excedió el tiempo límite (45s).'),
      );
      final urlDescarga = await snapshot.ref.getDownloadURL();
      return urlDescarga;
    } catch (e) {
      rethrow;
    }
  }

  static String _obtenerContentType(String? extension) {
    switch (extension?.toLowerCase()) {
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
}
