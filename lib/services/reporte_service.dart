import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reporte_models.dart';

class ReporteService {
  final CollectionReference<Map<String, dynamic>> _reportes = FirebaseFirestore
      .instance
      .collection('reportes');

  Future<String> crearReporte(ReporteModel reporte) async {
    final doc = await _reportes.add(reporte.toMap());
    return doc.id;
  }

  Future<List<ReporteModel>> obtenerReportes() async {
    final snapshot = await _reportes.get();

    return snapshot.docs.map((doc) {
      return ReporteModel.fromMap(doc.id, doc.data());
    }).toList();
  }

  Future<void> actualizarEstado(String id, String nuevoEstado) async {
    await _reportes.doc(id).update({'estado': nuevoEstado});
  }

  Future<ReporteModel?> obtenerReportePorId(String id) async {
    final doc = await _reportes.doc(id).get();

    if (!doc.exists || doc.data() == null) {
      return null;
    }

    return ReporteModel.fromMap(doc.id, doc.data()!);
  }
}
