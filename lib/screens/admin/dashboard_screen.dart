
import 'package:flutter/material.dart';

// DATOS TEMPORALES PARA PROBAR EL DASHBOARD
const List<Map<String, String>> reportesDemo = [
  {
    'folio': 'AA-001',
    'ubicacion': 'Zona Centro',
    'fecha': '16/10/2026',
    'estado': 'Pendiente',
  },
  {
    'folio': 'AA-002',
    'ubicacion': 'Colonia Lázaro Cárdenas',
    'fecha': '15/10/2026',
    'estado': 'En proceso',
  },
  {
    'folio': 'AA-003',
    'ubicacion': 'Zona Centro',
    'fecha': '14/10/2026',
    'estado': 'Reparado',
  },
  {
    'folio': 'AA-004',
    'ubicacion': 'Colonia El Tolento',
    'fecha': '16/10/2026',
    'estado': 'Pendiente',
  },
];

// PUNTO DE ENTRADA TEMPORAL PARA PROBAR ESTA PANTALLA
void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    ),
  );
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String busqueda = '';
  String filtro = 'Todos';

  @override
  Widget build(BuildContext context) {
    final reportesFiltrados = reportesDemo.where((reporte) {
      final coincideBusqueda =
          reporte['folio']!.toLowerCase().contains(busqueda.toLowerCase()) ||
          reporte['ubicacion']!.toLowerCase().contains(busqueda.toLowerCase());

      final coincideEstado =
          filtro == 'Todos' || reporte['estado'] == filtro;

      return coincideBusqueda && coincideEstado;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FA),

      appBar: AppBar(
        backgroundColor: const Color(0xFF156B85),
        foregroundColor: Colors.white,
        title: const Text('AquaAlerta | Administración'),
      ),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Text(
                'Panel de control',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Gestión de reportes de fugas de agua - Pénjamo',
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 25),

              // TARJETAS DE ESTADÍSTICAS
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  tarjetaResumen(
                    'Total de reportes',
                    reportesDemo.length,
                    Colors.blue,
                    Icons.assignment,
                  ),
                  tarjetaResumen(
                    'Pendientes',
                    contarEstado('Pendiente'),
                    Colors.orange,
                    Icons.pending_actions,
                  ),
                  tarjetaResumen(
                    'En proceso',
                    contarEstado('En proceso'),
                    Colors.purple,
                    Icons.build,
                  ),
                  tarjetaResumen(
                    'Reparados',
                    contarEstado('Reparado'),
                    Colors.green,
                    Icons.check_circle,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Card(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Reportes registrados',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // BUSCADOR Y FILTRO
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        children: [
                          SizedBox(
                            width: 280,
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Buscar reporte',
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (valor) {
                                setState(() {
                                  busqueda = valor;
                                });
                              },
                            ),
                          ),

                          DropdownButton<String>(
                            value: filtro,
                            items: [
                              'Todos',
                              'Pendiente',
                              'En proceso',
                              'Reparado',
                            ].map((estado) {
                              return DropdownMenuItem(
                                value: estado,
                                child: Text(estado),
                              );
                            }).toList(),
                            onChanged: (valor) {
                              if (valor != null) {
                                setState(() {
                                  filtro = valor;
                                });
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // TABLA DE REPORTES
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Folio')),
                            DataColumn(label: Text('Ubicación')),
                            DataColumn(label: Text('Fecha')),
                            DataColumn(label: Text('Estado')),
                          ],
                          rows: reportesFiltrados.map((reporte) {
                            return DataRow(
                              cells: [
                                DataCell(Text(reporte['folio']!)),
                                DataCell(Text(reporte['ubicacion']!)),
                                DataCell(Text(reporte['fecha']!)),
                                DataCell(
                                  Chip(
                                    label: Text(reporte['estado']!),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),

                      if (reportesFiltrados.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'No se encontraron reportes.',
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'AquaAlerta - Datos de demostración',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int contarEstado(String estado) {
    return reportesDemo
        .where((reporte) => reporte['estado'] == estado)
        .length;
  }

  Widget tarjetaResumen(
    String titulo,
    int cantidad,
    Color color,
    IconData icono,
  ) {
    return SizedBox(
      width: 225,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icono, color: color, size: 30),
              const SizedBox(height: 12),
              Text(
                '$cantidad',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(titulo),
            ],
          ),
        ),
      ),
    );
  }
}
