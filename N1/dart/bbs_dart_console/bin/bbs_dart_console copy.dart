class Mensagem {
  final int id;
  final String area;
  final String titulo;
  final String autor;
  final String conteudo;
  final int visualizacoes;
  final bool nova;

  const Mensagem({
    required this.id,
    required this.area,
    required this.titulo,
    required this.autor,
    required this.conteudo,
    required this.visualizacoes,
    this.nova = false,
  });
}

class Bbs {
  final String nome;
  final String sysop;
  final int velocidadeModem;
  final List<Mensagem> mensagens;

  const Bbs({
    required this.nome,
    required this.sysop,
    required this.velocidadeModem,
    required this.mensagens,
  });

  int get totalMensagens => mensagens.length;

  int get totalVisualizacoes => mensagens.fold(0, (sum, m) => sum + m.visualizacoes);

  int get mensagensNovas => mensagens.where((m) => m.nova).length;

  List<String> get areas {
    final Set<String> areasUnicas = {};
    for (var m in mensagens) {
      areasUnicas.add(m.area.toUpperCase());
    }
    return areasUnicas.toList();
  }

  List<Mensagem> mensagensDaArea(String nomeArea) {
    return mensagens.where((m) => m.area.toLowerCase() == nomeArea.toLowerCase()).toList();
  }

  Mensagem? buscarMensagem(int id) {
    try {
      return mensagens.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }
}

void imprimirCabecalho(Bbs bbs) {
  print('==========================================');
  print('           ${bbs.nome}');
  print('==========================================');
  print('SysOp: ${bbs.sysop}');
  print('Modem: ${bbs.velocidadeModem} bps');
  print('Mensagens: ${bbs.totalMensagens} | Novas: ${bbs.mensagensNovas}');
}

void imprimirMenu(Bbs bbs) {
  // TODO 8:
  print('ÁREAS DISPONÍVEIS');
  final listaAreas = bbs.areas;
  for (int i = 0; i < listaAreas.length; i++) {
    final nomeArea = listaAreas[i];
    final qtdMensagens = bbs.mensagensDaArea(nomeArea).length;
    print('[${i + 1}] $nomeArea'.padRight(14) + ' - $qtdMensagens mensagens');
  }
}

void imprimirArea(Bbs bbs, String area) {
  print('=== ÁREA: ${area.toUpperCase()} ===');
  final msgs = bbs.mensagensDaArea(area);
  for (var m in msgs) {
    final idFormatado = m.id.toString().padLeft(2, '0');
    final indicadorNovo = m.nova ? '[NOVO] ' : '';
    print('#$idFormatado $indicadorNovo${m.titulo}');
    print('    por: ${m.autor} | visualizações: ${m.visualizacoes}');
  }
}

void imprimirMensagem(Bbs bbs, int id) {
  final mensagem = bbs.buscarMensagem(id);
  if (mensagem == null) {
    print('Mensagem não encontrada.');
  } else {
    final idFormatado = mensagem.id.toString().padLeft(2, '0');
    print('=== MENSAGEM #$idFormatado ===');
    print('Título: ${mensagem.titulo}');
    print('Autor: ${mensagem.autor}');
    print('Área: ${mensagem.area}');
    print('Visualizações: ${mensagem.visualizacoes}');
    print('------------------------------------------');
    print(mensagem.conteudo);
  }
}

void imprimirEstatisticas(Bbs bbs) {
  print('=== ESTATÍSTICAS ===');
  print('Áreas: ${bbs.areas.length}');
  print('Mensagens: ${bbs.totalMensagens}');
  print('Mensagens novas: ${bbs.mensagensNovas}');
  print('Visualizações: ${bbs.totalVisualizacoes}');
}

void main() {
  final mensagens = <Mensagem>[
    Mensagem(
      id: 1,
      area: 'GERAL',
      titulo: 'Bem-vindos à Byte Line BBS',
      autor: 'Morgan',
      conteudo:
          'A BBS está oficialmente no ar. Leia as regras e aproveite as áreas.',
      visualizacoes: 85,
      nova: false,
    ),
    Mensagem(
      id: 2,
      area: 'GERAL',
      titulo: 'Horário de manutenção',
      autor: 'Morgan',
      conteudo:
          'No domingo, entre 02:00 e 03:00, o sistema ficará indisponível.',
      visualizacoes: 31,
      nova: true,
    ),
    Mensagem(
      id: 3,
      area: 'GAMES',
      titulo: 'Doom: dicas para o episódio 1',
      autor: 'Raven',
      conteudo:
          'Procure paredes com texturas diferentes. Algumas escondem áreas secretas.',
      visualizacoes: 42,
      nova: true,
    ),
    Mensagem(
      id: 4,
      area: 'GAMES',
      titulo: 'SimCity 2000 - estratégias iniciais',
      autor: 'Vector',
      conteudo:
          'Comece pequeno, controle os gastos e não expanda a cidade rápido demais.',
      visualizacoes: 64,
      nova: false,
    ),
    Mensagem(
      id: 5,
      area: 'TECNOLOGIA',
      titulo: 'Vale a pena trocar para modem 14400?',
      autor: 'ByteKid',
      conteudo:
          'A diferença é perceptível em arquivos maiores, mas depende da qualidade da linha.',
      visualizacoes: 53,
      nova: true,
    ),
    Mensagem(
      id: 6,
      area: 'DOWNLOADS',
      titulo: 'Novo pacote de ANSI art',
      autor: 'Neon',
      conteudo:
          'Adicionei um pacote com telas ANSI para quem mantém BBS própria.',
      visualizacoes: 27,
      nova: false,
    ),
  ];

  final bbs = Bbs(
    nome: 'BYTE LINE BBS',
    sysop: 'Morgan',
    velocidadeModem: 14400,
    mensagens: mensagens,
  );

  print('Discando...');
  print('CONNECT ${bbs.velocidadeModem}');
  print('');

  imprimirCabecalho(bbs);

  print('');
  imprimirMenu(bbs);

  print('');
  imprimirArea(bbs, 'GAMES');

  print('');
  imprimirMensagem(bbs, 4);

  print('');
  imprimirEstatisticas(bbs);

  print('');
  print('NO CARRIER');
}