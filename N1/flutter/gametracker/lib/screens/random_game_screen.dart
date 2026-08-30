import 'dart:math';
import 'package:flutter/material.dart';
import '../models/game.dart';

class RandomGameScreen extends StatefulWidget {
  final List<Game> games;

  const RandomGameScreen({super.key, required this.games});

  @override
  State<RandomGameScreen> createState() => _RandomGameScreenState();
}

class _RandomGameScreenState extends State<RandomGameScreen> {
  Game? _selectedGame;

  void _drawRandomGame() {
    if (widget.games.isNotEmpty) {
      final random = Random();
      setState(() {
        _selectedGame = widget.games[random.nextInt(widget.games.length)];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _drawRandomGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('O que jogar?')),
      body: Center(
        child: _selectedGame == null
            ? const Text('Nenhum jogo cadastrado.')
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(_selectedGame!.imageUrl, height: 180, fit: BoxFit.cover),
                    const SizedBox(height: 16),
                    Text(_selectedGame!.name, style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 8),
                    Text('Gênero: ${_selectedGame!.genre}'),
                    Text('Plataforma: ${_selectedGame!.platform}'),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _drawRandomGame,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Sortear Outro Jogo'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}