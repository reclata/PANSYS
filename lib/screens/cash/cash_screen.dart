import 'package:flutter/material.dart';

class CashScreen extends StatelessWidget {
  const CashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Módulo 11: Caixa e Faturamento'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Caixa Aberto (Mock)', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            Row(
              children: [
                _kpiCard(context, 'Faturamento Dia', 'R\$ 3.245,50', Icons.attach_money_rounded, Colors.green),
                const SizedBox(width: 16),
                _kpiCard(context, 'Sangrias Realizadas', 'R\$ 1.500,00', Icons.money_off_csred_rounded, Colors.redAccent),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.withValues(alpha: 0.3))),
              child: ListTile(
                leading: const Icon(Icons.point_of_sale_rounded, size: 40, color: Colors.blueAccent),
                title: const Text('Operador(a) Atual: Maria (Caixa 1)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Aberto às 08:00h - Fechamento previsto: 16:00h'),
                trailing: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.lock_rounded),
                  label: const Text('Fechar Caixa'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kpiCard(BuildContext context, String title, String val, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 16),
            Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(val, style: TextStyle(color: color, fontSize: 32, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
