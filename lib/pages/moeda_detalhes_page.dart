import 'package:cripto_moedas/repositories/conta_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../configs/app_settings.dart';
import '../models/moeda.dart';

class MoedaDetalhesPage extends StatefulWidget {
  final Moeda moeda;

  const MoedaDetalhesPage({ Key? key, required this.moeda }) : super(key: key);

  @override
  State<MoedaDetalhesPage> createState() => _MoedaDetalhesPageState();
}

class _MoedaDetalhesPageState extends State<MoedaDetalhesPage> {
  late NumberFormat real;
  final _form = GlobalKey<FormState>(); // Inicializa ou instancia uma chave aleatória para o formulário
  final _valor = TextEditingController();
  double quantidade = 0;
  late ContaRepository conta;

  readNumberFormat() {
    final loc = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  }

  comprar() async {
    if(_form.currentState!.validate()) {
      // Salvar a compra
      await conta.comprar(widget.moeda, double.parse(_valor.text));

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Compra realizada com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    readNumberFormat();
    conta = Provider.of<ContaRepository>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.moeda.nome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Image.asset(widget.moeda.icone),
                    width: 50,
                  ),
                  Container(width: 10),
                  Text(
                    real.format(widget.moeda.preco),
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -1,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            (quantidade > 0) 
            ? SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Container(
                margin: const EdgeInsets.only(bottom: 24),
                // padding: EdgeInsets.all(12),
                alignment: Alignment.center,
                // decoration: BoxDecoration(
                //   color: Colors.teal.withOpacity(0.05),
                // ),
                child: Text(
                  '$quantidade ${widget.moeda.sigla}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.teal,
                  ),
                ),
              ),
            )
            : Container(
              margin: const EdgeInsets.only(bottom: 24),
            ),
            Form(
              key: _form,
              child: TextFormField(
                controller: _valor,
                style: const TextStyle(fontSize: 22),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Valor',
                  prefixIcon: Icon(Icons.monetization_on_outlined),
                  suffix: Text(
                    'reais',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Impede que o usuário digite letras ou símbolos no campo de texto
                validator: (value) {
                  if(value!.isEmpty) {
                    return 'Informe o valor da compra';
                  } else if(double.parse(value) < 50) {
                    return 'Compra mínima é R\$ 50 reais';
                  } else if(double.parse(value) > conta.saldo) {
                    return 'Você não tem saldo suficiente';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    quantidade = (value.isEmpty)
                    ? 0
                    : double.parse(value) / widget.moeda.preco;
                  });
                },
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              margin: const EdgeInsets.only(top: 24),
              child: ElevatedButton(
                onPressed: comprar,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Comprar',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}