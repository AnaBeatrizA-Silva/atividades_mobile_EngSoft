import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/game.dart';

class StatisticsScreen extends StatelessWidget {
  final List<Game> games;

  const StatisticsScreen({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    Game? mostPlayed = games.isEmpty ? null : games.reduce((curr, next) => curr.hoursPlayed > next.hoursPlayed ? curr : next);
    Game? topRated = games.isEmpty ? null : games.reduce((curr, next) => curr.rating > next.rating ? curr : next);

    return Scaffold(
      appBar: AppBar(title: const Text('Estatísticas da Coleção')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text('Jogo Mais Jogado'),
                subtitle: Text(mostPlayed != null ? '${mostPlayed.name} (${mostPlayed.hoursPlayed}h)' : 'N/A'),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Jogo Mais Bem Avaliado'),
                subtitle: Text(topRated != null ? '${topRated.name} (${topRated.rating}★)' : 'N/A'),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Horas Jogadas por Jogo', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Expanded(
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (games.fold(0.0, (max, g) => g.hoursPlayed > max ? g.hoursPlayed : max) * 1.2),
                  barGroups: games.asMap().entries.map((entry) {
                    return BarChartGroupData(
                      x: entry.key,
                      barRods: [
                        BarChartRodData(
                          toY: entry.value.hoursPlayed,
                          color: Colors.deepPurple,
                          width: 16,
                        ),
                      ],
                    );
                  }).toList(),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < games.length) {
                            return Text(
                              games[index].name.split(' ').first,
                              style: const TextStyle(fontSize: 10),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}