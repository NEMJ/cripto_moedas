import '../repositories/moeda_repository.dart';
import 'package:flutter/material.dart';

class MoedasPage extends StatelessWidget {
  const MoedasPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabela = MoedaRepository.tabela;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cripto Moedas'),
      ),
      body: ListView.separated(
        itemCount: tabela.length,
        separatorBuilder: (_, __) => const Divider(),
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int moeda) {
          return ListTile(
            leading: Image.asset(tabela[moeda].icone),
            title: Text(tabela[moeda].nome),
            trailing: Text(tabela[moeda].preco.toString()),
          );
        },
      ),
    );
  }
}