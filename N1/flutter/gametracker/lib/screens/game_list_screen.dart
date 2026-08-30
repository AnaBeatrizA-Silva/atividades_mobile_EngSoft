import 'package:flutter/material.dart';
import '../models/game.dart';
import 'game_detail_screen.dart';

class GameListScreen extends StatelessWidget {
  final List<Game> games;
  final Function(String, double, double) onUpdateGame;

  const GameListScreen({
    super.key,
    required this.games,
    required this.onUpdateGame,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coleção de Jogos')),
      body: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Image.network(
                game.imageUrl,
                width: 60,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => const Icon(Icons.gamepad, size: 40),
              ),
              title: Text(game.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('${game.genre} • ${game.platform}'),
              trailing: Text('★ ${game.rating.toStringAsFixed(1)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.amber)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameDetailScreen(
                      game: game,
                      onUpdateGame: onUpdateGame,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}