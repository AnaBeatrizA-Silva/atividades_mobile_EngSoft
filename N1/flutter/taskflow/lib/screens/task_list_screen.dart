import 'package:flutter/material.dart';
import '../models/task.dart';
import 'task_detail_screen.dart';

class TaskListScreen extends StatefulWidget {
  final List<Task> tasks;
  final TaskStatus? filtroInicialStatus;
  final VoidCallback onUpdate;
  final Function(int) onDelete;
  final Function(String, String, String) onAdd;

  const TaskListScreen({
    super.key,
    required this.tasks,
    this.filtroInicialStatus,
    required this.onUpdate,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _termoBusca = '';
  TaskStatus? _filtroStatus;

  @override
  void initState() {
    super.initState();
    _filtroStatus = widget.filtroInicialStatus;
  }

  void _abrirFormulario(BuildContext context) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    final categoryController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Nova Tarefa', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Título')),
              const SizedBox(height: 8),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Descrição')),
              const SizedBox(height: 8),
              TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Categoria')),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.trim().isNotEmpty) {
                    widget.onAdd(titleController.text, descController.text, categoryController.text);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Salvar'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tarefasFiltradas = widget.tasks.where((task) {
      final matchBusca = task.titulo.toLowerCase().contains(_termoBusca.toLowerCase()) ||
          task.descricao.toLowerCase().contains(_termoBusca.toLowerCase()) ||
          task.categoria.toLowerCase().contains(_termoBusca.toLowerCase());

      final matchStatus = _filtroStatus == null || task.status == _filtroStatus;

      return matchBusca && matchStatus;
    }).toList();

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Pesquisar por título, descrição ou categoria',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => setState(() => _termoBusca = value),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Filtrar Status:'),
                    DropdownButton<TaskStatus?>(
                      value: _filtroStatus,
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Todos')),
                        ...TaskStatus.values.map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(Task(titulo: '', descricao: '', categoria: '', status: s).statusLabel),
                            )),
                      ],
                      onChanged: (val) => setState(() => _filtroStatus = val),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: tarefasFiltradas.isEmpty
                ? const Center(child: Text('Nenhuma tarefa encontrada.'))
                : ListView.builder(
                    itemCount: tarefasFiltradas.length,
                    itemBuilder: (context, index) {
                      final task = tarefasFiltradas.getRange(0, tarefasFiltradas.length).elementAt(index);
                      final originalIndex = widget.tasks.indexOf(task);

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(task.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(task.descricao, maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Cat: ${task.categoria}', style: const TextStyle(color: Colors.grey)),
                                  Text(
                                    'Criado em: ${task.dataCriacao.day}/${task.dataCriacao.month}',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: task.statusColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(task.statusLabel, style: TextStyle(color: task.statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailScreen(
                                  task: task,
                                  onUpdate: widget.onUpdate,
                                  onDelete: () => widget.onDelete(originalIndex),
                                ),
                              ),
                            ).then((_) => setState(() {}));
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}