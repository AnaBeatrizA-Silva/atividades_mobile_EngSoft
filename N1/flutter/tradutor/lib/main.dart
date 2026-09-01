import 'package:flutter/material.dart';

void main() {
  runApp(const TradutorApp());
}

class TradutorApp extends StatelessWidget {
  const TradutorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tradutor de Palavras',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TelaTradutor(),
    );
  }
}

class ItemPalavra {
  final String portugues;
  final String ingles;
  final String frances;

  const ItemPalavra({
    required this.portugues,
    required this.ingles,
    required this.frances,
  });
}

class TelaTradutor extends StatefulWidget {
  const TelaTradutor({super.key});

  @override
  State<TelaTradutor> createState() => _TelaTradutorState();
}

class _TelaTradutorState extends State<TelaTradutor> {
  int _indiceAtual = 0;

  bool _mostrarTraducao = false;

  final List<ItemPalavra> _palavras = const [
    ItemPalavra(portugues: 'Casa', ingles: 'House', frances: 'Maison'),
    ItemPalavra(portugues: 'Cachorro', ingles: 'Dog', frances: 'Chien'),
    ItemPalavra(portugues: 'Livro', ingles: 'Book', frances: 'Livre'),
    ItemPalavra(portugues: 'Água', ingles: 'Water', frances: 'Eau'),
    ItemPalavra(portugues: 'Gato', ingles: 'Cat', frances: 'Chat'),
    ItemPalavra(portugues: 'Carro', ingles: 'Car', frances: 'Voiture'),
    ItemPalavra(portugues: 'Maçã', ingles: 'Apple', frances: 'Pomme'),
    ItemPalavra(portugues: 'Sol', ingles: 'Sun', frances: 'Soleil'),
    ItemPalavra(portugues: 'Lua', ingles: 'Moon', frances: 'Lune'),
    ItemPalavra(portugues: 'Árvore', ingles: 'Tree', frances: 'Arbre'),
    ItemPalavra(portugues: 'Computador', ingles: 'Computer', frances: 'Ordinateur'),
  ];

  void _proximaPalavra() {
    setState(() {
      _indiceAtual = (_indiceAtual + 1) % _palavras.length;
      _mostrarTraducao = false; 
    });
  }

  void _palavraAnterior() {
    setState(() {
      _indiceAtual = (_indiceAtual - 1 + _palavras.length) % _palavras.length;
      _mostrarTraducao = false; 
    });
  }

  void _alternarTraducao() {
    setState(() {
      _mostrarTraducao = !_mostrarTraducao;
    });
  }

  @override
  Widget build(BuildContext context) {
    final palavraAtual = _palavras[_indiceAtual];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tradutor de Palavras (PT - EN - FR)'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Línguas: Português ➔ Inglês ➔ Francês',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            Text(
              palavraAtual.portugues,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),

            if (_mostrarTraducao) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    palavraAtual.ingles,
                    style: const TextStyle(fontSize: 24, color: Colors.black87),
                  ),
                  const SizedBox(width: 30),
                  Text(
                    palavraAtual.frances,
                    style: const TextStyle(fontSize: 24, color: Colors.black87),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 60),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _palavraAnterior,
                    child: const Text('Anterior', overflow: TextOverflow.ellipsis),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: _alternarTraducao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(
                      _mostrarTraducao ? 'Ocultar' : 'Traduzir',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _proximaPalavra,
                    child: const Text('Próxima', overflow: TextOverflow.ellipsis),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}