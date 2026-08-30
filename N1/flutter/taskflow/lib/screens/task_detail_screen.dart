// lib/screens/task_detail_screen.dart
import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  late TextEditingController _titleController;
  late TextEditingController _descController;
  late TextEditingController _categoryController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _titleController = TextEditingController(text: widget.task.titulo);
    _descController = TextEditingController(text: widget.task.descricao);
    _categoryController = TextEditingController(text: widget.task.categoria);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _categoryController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _mudarStatus(TaskStatus novoStatus) {
    setState(() {
      widget.task.status = novoStatus;
      widget.task.registrarLog('Status alterado para: ${widget.task.statusLabel}');
    });
    widget.onUpdate();
  }

  void _salvarEdicoes() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O título não pode ser vazio!')),
      );
      return;
    }

    setState(() {
      widget.task.editar(
        novoTitulo: _titleController.text,
        novaDescricao: _descController.text,
        novaCategoria: _categoryController.text,
      );
      _isEditing = false;
    });
    widget.onUpdate();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarefa atualizada com sucesso!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editando Tarefa' : task.titulo),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Detalhes e Ações', icon: Icon(Icons.info)),
            Tab(text: 'Histórico de Logs', icon: Icon(Icons.history)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Criado em: ${task.dataCriacao.day}/${task.dataCriacao.month}/${task.dataCriacao.year}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isEditing ? Colors.green : Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      icon: Icon(_isEditing ? Icons.save : Icons.edit, size: 16),
                      label: Text(_isEditing ? 'Salvar' : 'Editar'),
                      onPressed: () {
                        if (_isEditing) {
                          _salvarEdicoes();
                        } else {
                          setState(() {
                            _isEditing = true;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (_isEditing) ...[
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(labelText: 'Título', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Categoria', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _descController,
                    decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _titleController.text = task.titulo;
                        _categoryController.text = task.categoria;
                        _descController.text = task.descricao;
                        _isEditing = false;
                      });
                    },
                    child: const Text('Cancelar Edição', style: TextStyle(color: Colors.red)),
                  ),
                ] else ...[
                  Text('Categoria: ${task.categoria}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                  const SizedBox(height: 16),
                  const Text('Descrição:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(task.descricao, style: const TextStyle(fontSize: 16)),
                ],

                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 10),
                
                const Text('Alterar Status:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: TaskStatus.values.map((status) {
                    return ChoiceChip(
                      label: Text(Task(titulo: '', descricao: '', categoria: '', status: status).statusLabel),
                      selected: task.status == status,
                      onSelected: (selected) {
                        if (selected) _mudarStatus(status);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 40),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100, foregroundColor: Colors.red),
                  icon: const Icon(Icons.delete),
                  label: const Text('Excluir Tarefa'),
                  onPressed: () {
                    widget.onDelete();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),

          // ABA 2: Logs de Alterações
          ListView.builder(
            itemCount: task.logs.length,
            itemBuilder: (context, index) {
              final log = task.logs[index];
              return ListTile(
                leading: const Icon(Icons.fiber_manual_record, size: 12, color: Colors.blue),
                title: Text(log.acao),
                subtitle: Text('${log.dataHora.day}/${log.dataHora.month}/${log.dataHora.year} - ${log.dataHora.hour}:${log.dataHora.minute.toString().padLeft(2, '0')}'),
              );
            },
          ),
        ],
      ),
    );
  }
}