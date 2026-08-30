import 'package:flutter/material.dart';
import 'data/mock_games.dart';
import 'models/game.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const GameTrackerApp());
}

class GameTrackerApp extends StatefulWidget {
  const GameTrackerApp({super.key});

  @override
  State<GameTrackerApp> createState() => _GameTrackerAppState();
}

class _GameTrackerAppState extends State<GameTrackerApp> {
  final List<Game> _games = List.from(initialGames);

  void _updateGame(String id, double hoursChange, double ratingChange) {
    setState(() {
      final game = _games.firstWhere((g) => g.id == id);
      
      game.hoursPlayed = (game.hoursPlayed + hoursChange).clamp(0.0, 9999.0);
      
      game.rating = (game.rating + ratingChange).clamp(0.0, 10.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: DashboardScreen(
        games: _games,
        onUpdateGame: _updateGame,
      ),
    );
  }
}