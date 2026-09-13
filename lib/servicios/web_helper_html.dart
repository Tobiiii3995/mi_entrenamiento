// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

Future<Map<String, dynamic>?> seleccionarArchivoWeb() async {
  final completer = Completer<Map<String, dynamic>?>();
  final input = html.FileUploadInputElement();
  input.accept = 'image/*,video/*,.gif,.mp4,.mov,.png,.jpg,.jpeg,.webp';

  input.onChange.listen((event) {
    final files = input.files;
    if (files == null || files.isEmpty) {
      if (!completer.isCompleted) completer.complete(null);
      return;
    }
    final file = files.first;
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    reader.onLoadEnd.listen((event) {
      try {
        final result = reader.result;
        Uint8List? bytes;
        if (result is Uint8List) {
          bytes = result;
        } else if (result is ByteBuffer) {
          bytes = Uint8List.view(result);
        } else if (result != null) {
          bytes = Uint8List.fromList(List<int>.from(result as dynamic));
        }

        if (!completer.isCompleted) {
          completer.complete(bytes != null ? {'name': file.name, 'bytes': bytes} : null);
        }
      } catch (e) {
        if (!completer.isCompleted) completer.complete(null);
      }
    });
    reader.onError.listen((event) {
      if (!completer.isCompleted) completer.complete(null);
    });
  });

  input.click();
  return completer.future;
}

void abrirUrlWeb(String url) {
  html.window.open(url, '_blank');
}
