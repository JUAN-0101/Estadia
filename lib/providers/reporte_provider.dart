import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/reporte_models.dart';
import '../services/auth_service.dart';
import '../services/reporte_service.dart';
import '../services/storage_service.dart';

class ReporteProvider extends ChangeNotifier {
  final ReporteService _reporteService = ReporteService();
  final StorageService _storageService = StorageService();
  final AuthService _authService = AuthService();

  List<ReporteModel> _reportes = [];
  bool _cargando = false;
  String? _error;

  List<ReporteModel> get reportes => _reportes;
  bool get cargando => _cargando;
  String? get error => _error;
  bool get estaAutenticado => _authService.usuarioActual != null;

  Future<void> cargarReportes() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _reportes = await _reporteService.obtenerReportes();
    } catch (e) {
      _error = 'Error al cargar reportes: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<String?> enviarReporte({
    required double latitud,
    required double longitud,
    required String descripcion,
    File? foto,
  }) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final nuevoReporte = ReporteModel(
        id: '',
        latitud: latitud,
        longitud: longitud,
        fotoUrl: null,
        descripcion: descripcion.trim(),
        estado: 'Pendiente',
        fecha: DateTime.now(),
      );

      // 1. Crea el documento en Firestore y obtiene su ID
      final idCreado = await _reporteService.crearReporte(nuevoReporte);

      // 2. Si hay foto, la sube a Storage y guarda la URL en el documento
      if (foto != null) {
        final urlFoto = await _storageService.subirFoto(
          archivo: foto,
          reporteId: idCreado,
        );
        await FirebaseFirestore.instance
            .collection('reportes')
            .doc(idCreado)
            .update({'fotoUrl': urlFoto});
      }

      await cargarReportes();
      return idCreado;
    } catch (e) {
      _error = 'Error al enviar reporte: $e';
      return null;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> cambiarEstado({
    required String id,
    required String nuevoEstado,
  }) async {
    _error = null;
    notifyListeners();

    try {
      await _reporteService.actualizarEstado(id, nuevoEstado);
      await cargarReportes();
    } catch (e) {
      _error = 'Error al actualizar estado: $e';
      notifyListeners();
    }
  }

  Future<bool> loginAdmin({
    required String email,
    required String password,
  }) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _authService.iniciarSesion(email: email, password: password);
      return true;
    } catch (e) {
      _error = 'Error al iniciar sesión: $e';
      return false;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> logoutAdmin() async {
    await _authService.cerrarSesion();
    notifyListeners();
  }
}
