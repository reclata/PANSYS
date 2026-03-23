import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.userModel;

    return Scaffold(
      appBar: AppBar(
        title: const Text('PanSys - Painel Gerencial', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () => auth.logout(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user != null ? 'Bem-vindo(a), \${user.name}!' : 'Bem-vindo(a) à Visualização (Mock)!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Resumo Diário da Padaria',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.6), fontSize: 16),
            ),
            const SizedBox(height: 24),
            
            // KPI Cards
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 800;
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _kpiCard(context, 'Faturamento', 'R\$ 3.245,50', Icons.attach_money_rounded, Colors.green, isDesktop ? constraints.maxWidth / 4 - 16 : constraints.maxWidth / 2 - 8),
                    _kpiCard(context, 'Pães Vendidos', '840 un', Icons.bakery_dining_rounded, Colors.orange, isDesktop ? constraints.maxWidth / 4 - 16 : constraints.maxWidth / 2 - 8),
                    _kpiCard(context, 'Estoque Baixo', '3 itens', Icons.warning_rounded, Colors.redAccent, isDesktop ? constraints.maxWidth / 4 - 16 : constraints.maxWidth / 2 - 8),
                    _kpiCard(context, 'Equipe Ativa', '12/15', Icons.people_rounded, Colors.blue, isDesktop ? constraints.maxWidth / 4 - 16 : constraints.maxWidth / 2 - 8),
                  ],
                );
              }
            ),
            
            const SizedBox(height: 32),
            
            // Gráficos
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 800;
                return Flex(
                  direction: isDesktop ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: isDesktop ? 2 : 0,
                      child: _buildChart(context, isDesktop),
                    ),
                    if (isDesktop) const SizedBox(width: 24),
                    if (!isDesktop) const SizedBox(height: 24),
                    Expanded(
                      flex: isDesktop ? 1 : 0,
                      child: _buildEstoqueAlert(context),
                    ),
                  ],
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _kpiCard(BuildContext context, String title, String value, IconData icon, Color color, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: color, size: 24),
              ),
              const Spacer(),
              Icon(Icons.more_horiz_rounded, color: Colors.grey.shade400),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildChart(BuildContext context, bool isDesktop) {
    return Container(
      height: 350,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vendas nas Últimas 6 Horas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(color: Colors.grey, fontSize: 12);
                        Widget text;
                        switch (value.toInt()) {
                          case 0: text = const Text('06h', style: style); break;
                          case 2: text = const Text('08h', style: style); break;
                          case 4: text = const Text('10h', style: style); break;
                          case 6: text = const Text('12h', style: style); break;
                          default: text = const Text('', style: style); break;
                        }
                        return SideTitleWidget(axisSide: meta.axisSide, child: text);
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(1, 4.5),
                      FlSpot(2, 6),
                      FlSpot(3, 8),
                      FlSpot(4, 5),
                      FlSpot(5, 7),
                      FlSpot(6, 10),
                    ],
                    isCurved: true,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(
                      show: true,
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEstoqueAlert(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      // Removida altura fixa para que em layout responsivo vertical ocoleção cresca
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Avisos do Sistema', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          _alertItem(Icons.inventory_2_rounded, 'Farinha de Trigo', 'Abaixo do nível mínimo (20kg)', Colors.redAccent),
          _alertItem(Icons.schedule_rounded, 'Atraso de Funcionário', 'João, Padeiro (Turno Manhã)', Colors.orange),
          _alertItem(Icons.insert_drive_file_rounded, 'Documento Vencendo', 'ASO: Maria (Caixa)', Colors.orange),
        ],
      ),
    );
  }

  Widget _alertItem(IconData icon, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
