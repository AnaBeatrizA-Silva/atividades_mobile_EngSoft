import '../models/task.dart';

final List<Task> mockTasks = [
  Task(
    titulo: 'Criar documentação da N1',
    descricao: 'Escrever os 13 tópicos exigidos no PDF da Faixa 10',
    categoria: 'Estudos',
    status: TaskStatus.emAndamento,
  ),
  Task(
    titulo: 'Implementar gráfico de pizza',
    descricao: 'Integrar o pacote fl_chart no dashboard para exibição visual',
    categoria: 'Desenvolvimento',
    status: TaskStatus.concluida,
  ),
  Task(
    titulo: 'Revisar código fonte',
    descricao: 'Verificar se todas as regras de POO e Clean Architecture foram aplicadas',
    categoria: 'Qualidade',
    status: TaskStatus.emRevisao,
  ),
  Task(
    titulo: 'Gravar vídeo de demonstração',
    descricao: 'Apresentar as funcionalidades do TaskFlow rodando no emulador Android',
    categoria: 'Apresentação',
    status: TaskStatus.pendente,
  ),
];