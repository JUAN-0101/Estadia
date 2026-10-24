class ReporteModel {
  final String id;
  final double latitud;
  final double longitud;
  final String? fotoUrl;
  final String descripcion;
  final String estado;
  final DateTime fecha;

  ReporteModel({
    required this.id,
    required this.latitud,
    required this.longitud,
    this.fotoUrl,
    required this.descripcion,
    required this.estado,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'latitud': latitud,
      'longitud': longitud,
      'fotoUrl': fotoUrl,
      'descripcion': descripcion,
      'estado': estado,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory ReporteModel.fromMap(String id, Map<String, dynamic> map) {
    return ReporteModel(
      id: id,
      latitud: (map['latitud'] as num).toDouble(),
      longitud: (map['longitud'] as num).toDouble(),
      fotoUrl: map['fotoUrl'],
      descripcion: map['descripcion'] ?? '',
      estado: map['estado'] ?? 'Pendiente',
      fecha: DateTime.parse(map['fecha']),
    );
  }
}
