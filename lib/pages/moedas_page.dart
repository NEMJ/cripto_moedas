import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/moeda.dart';
import '../repositories/moeda_repository.dart';
import './moeda_detalhes_page.dart';


class MoedasPage extends StatefulWidget {
  const MoedasPage({ Key? key }) : super(key: key);

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  final tabela = MoedaRepository.tabela;
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  List<Moeda> selecionadas = [];

  appBarDinamica() {
    if(selecionadas.isEmpty) {
      return AppBar(
        centerTitle: true,
        title: const Text('Cripto Moedas'),
      );
    } else {
      return AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selecionadas = [];
            });
          }
        ),
        title: Text('${selecionadas.length} selecionadas'),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),
      );
    }
  }

  mostrarDetalhes(Moeda moeda) {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (_) => MoedaDetalhesPage(moeda: moeda),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDinamica(),
      body: ListView.separated(
        itemCount: tabela.length,
        separatorBuilder: (_, __) => const Divider(),
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext context, int moeda) {
          return ListTile(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            leading: (selecionadas.contains(tabela[moeda]))
              ? const CircleAvatar(
                child: Icon(Icons.check),
              )
              : SizedBox(
                width: 40,
                child: Image.asset(tabela[moeda].icone),
              ),
            title: Text(
              tabela[moeda].nome,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            trailing: Text(
              real.format(tabela[moeda].preco),
            ),
            selected: selecionadas.contains(tabela[moeda]),
            selectedTileColor: Colors.indigo[50],
            onLongPress: () {
              setState(() {
                (selecionadas.contains(tabela[moeda]))
                  ? selecionadas.remove(tabela[moeda])
                  : selecionadas.add(tabela[moeda]);
              });
            },
            onTap: () => mostrarDetalhes(tabela[moeda]),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selecionadas.isNotEmpty
      ? FloatingActionButton.extended(
        icon: const Icon(Icons.star),
        label: const Text(
          'FAVORITAR',
          style: TextStyle(
            letterSpacing: 0,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {}
      )
      : null,
    );
  }
}