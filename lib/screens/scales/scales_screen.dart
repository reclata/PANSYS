import 'package:flutter/material.dart';

class ScalesScreen extends StatelessWidget {
  const ScalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Módulo 3: Escalas de Trabalho'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Turnos e Escalas do Dia (Mock)', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildTurnoCard(context, 'Madrugada', '00:00 - 08:00', 'João, Padeiro Chefe', Colors.indigo),
                _buildTurnoCard(context, 'Manhã', '08:00 - 16:00', 'Maria, Caixa 1', Colors.orange),
                _buildTurnoCard(context, 'Tarde', '16:00 - 00:00', 'André, Atendente', Colors.deepPurple),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTurnoCard(BuildContext context, String title, String time, String employee, Color color) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time_rounded, color: color),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          Text(time, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16),
              const SizedBox(width: 8),
              Text(employee, style: const TextStyle(fontSize: 14)),
            ],
          )
        ],
      ),
    );
  }
}
