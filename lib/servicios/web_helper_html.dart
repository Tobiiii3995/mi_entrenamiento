// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

Future<Map<String, dynamic>?> seleccionarArchivoWeb() async {
  final completer = Completer<Map<String, dynamic>?>();
  final input = html.FileUploadInputElement();
  input.accept = 'image/*,video/*,.gif,.mp4,.mov,.png,.jpg,.jpeg,.webp';
  input.click();

  input.onChange.listen((event) {
    final files = input.files;
    if (files == null || files.isEmpty) {
      completer.complete(null);
      return;
    }
    final file = files.first;
    final reader = html.FileReader();
    reader.readAsArrayBuffer(file);
    reader.onLoadEnd.listen((event) {
      final result = reader.result;
      if (result is Uint8List) {
        completer.complete({
          'name': file.name,
          'bytes': result,
        });
      } else if (result is ByteBuffer) {
        completer.complete({
          'name': file.name,
          'bytes': Uint8List.view(result),
        });
      } else {
        completer.complete(null);
      }
    });
    reader.onError.listen((event) {
      completer.complete(null);
    });
  });

  return completer.future;
}

void abrirUrlWeb(String url) {
  html.window.open(url, '_blank');
}
