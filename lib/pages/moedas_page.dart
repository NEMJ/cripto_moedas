import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../configs/app_settings.dart';
import '../models/moeda.dart';
import '../repositories/favoritas_repository.dart';
import '../repositories/moeda_repository.dart';
import './moeda_detalhes_page.dart';


class MoedasPage extends StatefulWidget {
  const MoedasPage({ Key? key }) : super(key: key);

  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  final tabela = MoedaRepository.tabela;
  late NumberFormat real;
  late Map<String, String> loc;
  List<Moeda> selecionadas = [];
  late FavoritasRepository favoritas;

  // Lê e altera a forma de exibição dos valores das moedas
  readNumberFormat() {
    loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  changeLanguageButton() {
    final locale = loc['locale'] == 'pt_BR' ? 'en_US' : 'pt_BR';
    final name = loc['locale'] == 'pt_BR' ? '\$ ' : 'R\$';

    return PopupMenuButton(
      icon: const Icon(Icons.language),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.swap_vert),
            title: Text('Usar $locale'),
            onTap: () {
              context.read<AppSettings>().setLocale(locale, name);
              Navigator.pop(context);
            },
          ),
        ),
      ]
    );
  }

  appBarDinamica() {
    if(selecionadas.isEmpty) {
      return AppBar(
        centerTitle: true,
        title: const Text('Cripto Moedas'),
        actions: [
          changeLanguageButton(),
        ],
      );
    } else {
      return AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => limparSelecionadas(),
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

  limparSelecionadas() {
    setState(() {
      selecionadas = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Instancia 'padrão' do Provider
    // >>- favoritas = Provider.of<FavoritasRepository>(context);

    // Utiliza o context do build com 'watch' para esperar por mudanças e as usar de forma realiva.
    favoritas = context.watch<FavoritasRepository>();
    readNumberFormat();

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
            title: Row(
              children: [
                Text(
                  tabela[moeda].nome,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if(favoritas.lista.any((fav) => fav.sigla == tabela[moeda].sigla))
                  const Icon(Icons.circle, color: Colors.amber, size: 8),
              ],
            ),
            trailing: Text(
              real.format(tabela[moeda].preco),
              style: const TextStyle(fontSize: 15),
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
        onPressed: () {
          favoritas.saveAll(selecionadas);
          limparSelecionadas();
        }
      )
      : null,
    );
  }
}