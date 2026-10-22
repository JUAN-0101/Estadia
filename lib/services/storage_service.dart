import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Sube una fotografía y devuelve su URL de descarga.
  Future<String> subirFoto({
    required File archivo,
    required String reporteId,
  }) async {
    final extension = archivo.path.split('.').last.toLowerCase();

    const extensionesPermitidas = ['jpg', 'jpeg', 'png', 'webp'];

    if (!extensionesPermitidas.contains(extension)) {
      throw Exception('Formato de imagen no permitido.');
    }

    final nombreArchivo =
        'reportes/$reporteId/foto_${DateTime.now().millisecondsSinceEpoch}.$extension';

    final referencia = _storage.ref().child(nombreArchivo);

    final metadata = SettableMetadata(
      contentType: switch (extension) {
        'jpg' || 'jpeg' => 'image/jpeg',
        'png' => 'image/png',
        'webp' => 'image/webp',
        _ => 'application/octet-stream',
      },
    );

    final resultado = await referencia.putFile(archivo, metadata);

    return await resultado.ref.getDownloadURL();
  }

  /// Elimina una fotografía de Firebase Storage mediante su ruta.
  Future<void> eliminarFoto(String ruta) async {
    await _storage.ref().child(ruta).delete();
  }
}
