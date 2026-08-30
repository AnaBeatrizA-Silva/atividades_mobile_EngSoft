import 'package:flutter/material.dart';
import '../models/game.dart';
import 'game_list_screen.dart';
import 'random_game_screen.dart';
import 'statistics_screen.dart';

class DashboardScreen extends StatelessWidget {
  final List<Game> games;
  final Function(String, double, double) onUpdateGame;

  const DashboardScreen({
    super.key,
    required this.games,
    required this.onUpdateGame,
  });

  @override
  Widget build(BuildContext context) {
    final totalGames = games.length;
    final totalHours = games.fold(0.0, (sum, item) => sum + item.hoursPlayed);
    final avgRating = totalGames > 0
        ? games.fold(0.0, (sum, item) => sum + item.rating) / totalGames
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Tracker - Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Resumo da Coleção', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _MetricItem(label: 'Total Jogos', value: '$totalGames'),
                        _MetricItem(label: 'Total Horas', value: '${totalHours.toStringAsFixed(1)}h'),
                        _MetricItem(label: 'Média Nota', value: avgRating.toStringAsFixed(1)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.videogame_asset),
              label: const Text('Ver Lista de Jogos'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameListScreen(
                      games: games,
                      onUpdateGame: onUpdateGame,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.bar_chart),
              label: const Text('Estatísticas e Gráficos'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatisticsScreen(games: games),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              icon: const Icon(Icons.casino),
              label: const Text('O que jogar? (Sorteio)'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RandomGameScreen(games: games),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String label;
  final String value;
  const _MetricItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}