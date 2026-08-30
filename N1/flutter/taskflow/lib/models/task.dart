// lib/models/task.dart
import 'package:flutter/material.dart';

enum TaskStatus { pendente, emAndamento, emRevisao, concluida }

class TaskLog {
  String acao;
  DateTime dataHora;

  TaskLog({required this.acao, required this.dataHora});
}

class Task {
  String titulo;
  String descricao;
  String categoria;
  TaskStatus status;
  DateTime dataCriacao;
  List<TaskLog> logs;

  Task({
    required this.titulo,
    required this.descricao,
    required this.categoria,
    this.status = TaskStatus.pendente,
    DateTime? dataCriacao,
    List<TaskLog>? logs,
  })  : dataCriacao = dataCriacao ?? DateTime.now(),
        logs = logs ?? [TaskLog(acao: 'Tarefa criada', dataHora: DateTime.now())];

  void registrarLog(String acao) {
    logs.add(TaskLog(acao: acao, dataHora: DateTime.now()));
  }

  String get statusLabel {
    switch (status) {
      case TaskStatus.pendente:
        return 'Pendente';
      case TaskStatus.emAndamento:
        return 'Em andamento';
      case TaskStatus.emRevisao:
        return 'Em revisão';
      case TaskStatus.concluida:
        return 'Concluída';
    }
  }

  Color get statusColor {
    switch (status) {
      case TaskStatus.pendente:
        return Colors.orange;
      case TaskStatus.emAndamento:
        return Colors.blue;
      case TaskStatus.emRevisao:
        return Colors.purple;
      case TaskStatus.concluida:
        return Colors.green;
    }
  }

  void editar({
    required String novoTitulo,
    required String novaDescricao,
    required String novaCategoria,
  }) {
    titulo = novoTitulo;
    descricao = novaDescricao;
    categoria = novaCategoria;
    registrarLog('Tarefa editada (Título: $titulo, Categoria: $categoria)');
  }
}