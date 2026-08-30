import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/task.dart';

class DashboardScreen extends StatelessWidget {
  final List<Task> tasks;
  final Function(TaskStatus) onNavigateWithFilter;

  const DashboardScreen({
    super.key,
    required this.tasks,
    required this.onNavigateWithFilter,
  });

  @override
  Widget build(BuildContext context) {
    int total = tasks.length;
    int pendentes = tasks.where((t) => t.status == TaskStatus.pendente).length;
    int emAndamento = tasks.where((t) => t.status == TaskStatus.emAndamento).length;
    int emRevisao = tasks.where((t) => t.status == TaskStatus.emRevisao).length;
    int concluidas = tasks.where((t) => t.status == TaskStatus.concluida).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Visão Geral das Tarefas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _buildVerticalCard('Total de Tarefas', total.toString(), Colors.blueGrey, Icons.list, null),
          _buildVerticalCard('Pendentes', pendentes.toString(), Colors.orange, Icons.hourglass_empty, TaskStatus.pendente),
          _buildVerticalCard('Em andamento', emAndamento.toString(), Colors.blue, Icons.work, TaskStatus.emAndamento),
          _buildVerticalCard('Em revisão', emRevisao.toString(), Colors.purple, Icons.rate_review, TaskStatus.emRevisao),
          _buildVerticalCard('Concluídas', concluidas.toString(), Colors.green, Icons.check_circle, TaskStatus.concluida),
          const SizedBox(height: 30),
          const Text('Comparativo de Status', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: total == 0
                ? const Center(child: Text('Sem dados.'))
                : PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        if (pendentes > 0) PieChartSectionData(value: pendentes.toDouble(), color: Colors.orange, title: '$pendentes', radius: 45),
                        if (emAndamento > 0) PieChartSectionData(value: emAndamento.toDouble(), color: Colors.blue, title: '$emAndamento', radius: 45),
                        if (emRevisao > 0) PieChartSectionData(value: emRevisao.toDouble(), color: Colors.purple, title: '$emRevisao', radius: 45),
                        if (concluidas > 0) PieChartSectionData(value: concluidas.toDouble(), color: Colors.green, title: '$concluidas', radius: 45),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalCard(String title, String value, Color color, IconData icon, TaskStatus? statusFilter) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        onTap: statusFilter != null ? () => onNavigateWithFilter(statusFilter) : null,
      ),
    );
  }
}