// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/task.dart';
import '../data/mock_task.dart';
import 'dashboard_screen.dart';
import 'task_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  TaskStatus? _filtroAtivo;
  final List<Task> _tasks = List.from(mockTasks);

  void _addTask(String titulo, String descricao, String categoria) {
    setState(() {
      _tasks.add(Task(titulo: titulo, descricao: descricao, categoria: categoria));
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DashboardScreen(
        tasks: _tasks,
        onNavigateWithFilter: (status) {
          setState(() {
            _filtroAtivo = status;
            _currentIndex = 1; 
          });
        },
      ),
      TaskListScreen(
        key: ValueKey(_filtroAtivo),
        tasks: _tasks,
        filtroInicialStatus: _filtroAtivo,
        onUpdate: () => setState(() {}),
        onDelete: _deleteTask,
        onAdd: _addTask,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow - Avançado'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            if (index == 1) _filtroAtivo = null;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tarefas'),
        ],
      ),
    );
  }
}