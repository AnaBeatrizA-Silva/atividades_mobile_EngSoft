String dinheiro(double valor) => 'R\$ ${valor.toStringAsFixed(2)}';

class Jogo {
  final String titulo;
  final String plataforma;
  final double preco;

  const Jogo({
    required this.titulo,
    required this.plataforma,
    required this.preco,
  });

  Jogo.promocional({
    required String titulo,
    required String plataforma,
    required double precoOriginal,
    required double percentualDesconto,
  })  : assert(precoOriginal >= 0, 'O preço original não pode ser negativo.'),
        assert(
          percentualDesconto >= 0 && percentualDesconto <= 100,
          'O desconto deve estar entre 0 e 100.',
        ),
        titulo = titulo,
        plataforma = plataforma,
        preco = precoOriginal * (1 - percentualDesconto / 100);
}

class ItemCarrinho {
  final Jogo jogo;
  final int quantidade;
  final double descontoExtra;

  const ItemCarrinho({
    required this.jogo,
    required this.quantidade,
    this.descontoExtra = 0,
  })  : assert(quantidade > 0, 'A quantidade deve ser maior que zero.'),
        assert(
          descontoExtra >= 0 && descontoExtra <= 50,
          'O desconto extra deve estar entre 0 e 50.',
        );

  double get subtotal => (jogo.preco * quantidade) * (1 - descontoExtra / 100);
}

class Pedido {
  final String cliente;
  final List<ItemCarrinho> itens;
  final String? cupom;

  const Pedido({
    required this.cliente,
    required this.itens,
    this.cupom,
  });

  double get subtotalDosItens => itens.fold(0, (soma, item) => soma + item.subtotal);

  double get valorDoDesconto {
    if (cupom != null && cupom!.toLowerCase() == 'aluno10') {
      return subtotalDosItens * 0.10;
    }
    return 0.0;
  }

  double get valorDoFrete => subtotalDosItens >= 250.0 ? 0.0 : 20.0;

  double get totalFinal => subtotalDosItens - valorDoDesconto + valorDoFrete;

  String get classificacao {
    if (subtotalDosItens < 150.0) {
      return 'Pedido econômico';
    } else if (subtotalDosItens <= 300.0) {
      return 'Pedido padrão';
    } else {
      return 'Pedido premium';
    }
  }

  int get quantidadeTotalDeUnidades => itens.fold(0, (soma, item) => soma + item.quantidade);
}

void imprimirRecibo(Pedido pedido) {
  print('======');
  print('Cliente: ${pedido.cliente}');
  print('Cupom: ${pedido.cupom ?? 'Nenhum'}');
  print('GAMESTORE DART');
  print('============================');
  print('ITENS DO PEDIDO');

  for (int i = 0; i < pedido.itens.length; i++) {
    final item = pedido.itens[i];
    print('${i + 1}. ${item.jogo.titulo}');
    print('Plataforma: ${item.jogo.plataforma}');
    print('Preço unitário: ${dinheiro(item.jogo.preco)}');
    print('Quantidade: ${item.quantidade}');
    print('Desconto extra: ${item.descontoExtra.toInt()}%');
    print('Subtotal: ${dinheiro(item.subtotal)}');
  }

  print('Subtotal dos itens: ${dinheiro(pedido.subtotalDosItens)}');
  print('Desconto do cupom: ${dinheiro(pedido.valorDoDesconto)}');
  
  final freteTexto = pedido.valorDoFrete == 0.0 ? 'GRÁTIS' : dinheiro(pedido.valorDoFrete);
  print('Frete: $freteTexto');
  
  print('TOTAL FINAL: ${dinheiro(pedido.totalFinal)}');
  print('Classificação: ${pedido.classificacao}');
  print('Quantidade de produtos diferentes: ${pedido.itens.length}');
  print('Quantidade total de unidades: ${pedido.quantidadeTotalDeUnidades}');
  print('============================');
  print('=========');
}

void main() {
  final jogo1 = Jogo(
    titulo: 'Galaxy Battle',
    plataforma: 'PC',
    preco: 99.90,
  );

  final jogo2 = Jogo(
    titulo: 'Kart Turbo',
    plataforma: 'Nintendo Switch',
    preco: 189.90,
  );

  final jogo3 = Jogo.promocional(
    titulo: 'Dungeon Quest',
    plataforma: 'PlayStation 5',
    precoOriginal: 200.00,
    percentualDesconto: 20,
  );

  final jogo4 = Jogo(
    titulo: 'Pixel Farm',
    plataforma: 'PC',
    preco: 39.90,
  );

  final catalogo = <Jogo>[jogo1, jogo2, jogo3, jogo4];
  print('Catálogo carregado: ${catalogo.length} jogos');
  print('');

  final itens = <ItemCarrinho>[
    ItemCarrinho(
      jogo: jogo1,
      quantidade: 1,
    ),
    ItemCarrinho(
      jogo: jogo2,
      quantidade: 1,
      descontoExtra: 10,
    ),
    ItemCarrinho(
      jogo: jogo4,
      quantidade: 2,
    ),
  ];

  final pedido = Pedido(
    cliente: 'Ana',
    itens: itens,
    cupom: 'ALUNO10',
  );

  imprimirRecibo(pedido);
}