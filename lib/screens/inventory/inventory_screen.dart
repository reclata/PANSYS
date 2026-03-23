import 'package:flutter/material.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Módulo 10: Controle de Estoque'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Insumos e Matéria Prima (Mock)', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildEstoqueItem(context, 'Farinha de Trigo', '50 kg', 'Mín: 20 kg', Colors.redAccent, alert: true),
                _buildEstoqueItem(context, 'Açúcar Cristal', '25 kg', 'Mín: 10 kg', Colors.green),
                _buildEstoqueItem(context, 'Fermento Fresco', '2 kg', 'Mín: 1 kg', Colors.orange),
                _buildEstoqueItem(context, 'Leite Integral', '30 L', 'Mín: 15 L', Colors.green),
                _buildEstoqueItem(context, 'Manteiga', '5 kg', 'Mín: 2 kg', Colors.green),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_shopping_cart_rounded),
        label: const Text('Dar Entrada em NF'),
      ),
    );
  }

  Widget _buildEstoqueItem(BuildContext context, String title, String curr, String min, Color statusColor, {bool alert = false}) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: alert ? Colors.redAccent : Colors.grey.withOpacity(0.3), width: alert ? 2 : 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(alert ? Icons.warning_rounded : Icons.check_circle_rounded, color: alert ? Colors.redAccent : Colors.green),
              const SizedBox(width: 8),
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
            ],
          ),
          const SizedBox(height: 16),
          Text(curr, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Theme.of(context).colorScheme.primary)),
          Text(min, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}
