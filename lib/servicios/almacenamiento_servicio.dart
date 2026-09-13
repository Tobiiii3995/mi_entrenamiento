import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AlmacenamientoServicio {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final ImagePicker _picker = ImagePicker();

  /// Permite al usuario seleccionar un archivo GIF/Video/Imagen de su dispositivo
  /// y lo sube directamente a Firebase Storage.
  /// Funciona de forma 100% nativa y compatible tanto en Web como en Android/iOS.
  static Future<String?> seleccionarYSubirDemostracion() async {
    final XFile? archivo = await _picker.pickMedia();

    if (archivo == null) {
      return null;
    }

    final Uint8List bytes = await archivo.readAsBytes();

    if (bytes.isEmpty) {
      throw Exception('No se pudieron leer los datos del archivo seleccionado.');
    }

    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final nombreLimpio = archivo.name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final rutaStorage = 'ejercicios_demostraciones/${timestamp}_$nombreLimpio';

    final ref = _storage.ref().child(rutaStorage);

    final String? extension = archivo.name.contains('.') ? archivo.name.split('.').last : null;

    final metadata = SettableMetadata(
      contentType: _obtenerContentType(extension),
    );

    final task = await ref.putData(bytes, metadata);
    final urlDescarga = await task.ref.getDownloadURL();

    return urlDescarga;
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
