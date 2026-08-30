import 'package:flutter/material.dart';
import '../models/game.dart';

class GameDetailScreen extends StatefulWidget {
  final Game game;
  final Function(String, double, double) onUpdateGame;

  const GameDetailScreen({
    super.key,
    required this.game,
    required this.onUpdateGame,
  });

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.game.name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.game.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (ctx, err, stack) => const Icon(Icons.gamepad, size: 100),
            ),
            const SizedBox(height: 16),
            Text(widget.game.name, style: Theme.of(context).textTheme.headlineSmall),
            Text('${widget.game.genre} | ${widget.game.platform}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Text(widget.game.description),
            const SizedBox(height: 24),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Horas Jogadas: ${widget.game.hoursPlayed.toStringAsFixed(1)}h'),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () {
                            widget.onUpdateGame(widget.game.id, -1.0, 0.0);
                            setState(() {});
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: () {
                            widget.onUpdateGame(widget.game.id, 1.0, 0.0);
                            setState(() {});
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            
            // Controles de Avaliação
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Nota (0-10): ${widget.game.rating.toStringAsFixed(1)}'),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.star_border),
                          onPressed: () {
                            widget.onUpdateGame(widget.game.id, 0.0, -0.5);
                            setState(() {});
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.star),
                          onPressed: () {
                            widget.onUpdateGame(widget.game.id, 0.0, 0.5);
                            setState(() {});
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}