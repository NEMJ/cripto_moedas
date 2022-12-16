import 'package:flutter/material.dart';
import '../models/moeda.dart';

class MoedaDetalhesPage extends StatefulWidget {
  final Moeda moeda;

  const MoedaDetalhesPage({ Key? key, required this.moeda }) : super(key: key);

  @override
  State<MoedaDetalhesPage> createState() => _MoedaDetalhesPageState();
}

class _MoedaDetalhesPageState extends State<MoedaDetalhesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.moeda.nome),
      ),
      body: Column(
        children: [
          Divider(),
          Row(
            children: [
              SizedBox(
                width: 50,
                child: Image.asset(widget.moeda.icone),
              ),
            ],
          ),
        ],
      ),
    );
  }
}