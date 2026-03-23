import 'package:flutter/material.dart';

class ProductionScreen extends StatelessWidget {
  const ProductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Módulo 9: Produção da Padaria'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Controle de Produção por Turno (Mock)', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Produto', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Produzido', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Vendido', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Perdas', style: TextStyle(color: Colors.red))),
                  DataColumn(label: Text('Ação', style: TextStyle(color: Colors.blue))),
                ],
                rows: [
                  _row('Pão Francês', '500 unid', '452 unid', '12 unid'),
                  _row('Bolo Cenoura', '10 unid', '8 unid', '0 unid'),
                  _row('Salgados Assados', '150 unid', '140 unid', '10 unid'),
                  _row('Café Expresso', '50 copos', '50 copos', '0 copos'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add_chart_rounded),
        tooltip: "Registrar Nova Fornada",
      ),
    );
  }

  DataRow _row(String prod, String prodCount, String sold, String lost) {
    return DataRow(cells: [
      DataCell(Text(prod, style: const TextStyle(fontWeight: FontWeight.w600))),
      DataCell(Text(prodCount, style: const TextStyle(color: Colors.blue))),
      DataCell(Text(sold, style: const TextStyle(color: Colors.green))),
      DataCell(Text(lost, style: const TextStyle(color: Colors.red))),
      DataCell(OutlinedButton(onPressed: () {}, child: const Text('Ajustar'))),
    ]);
  }
}
