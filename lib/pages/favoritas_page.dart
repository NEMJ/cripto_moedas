import 'package:flutter/material.dart';

class FavoritasPage extends StatefulWidget {
  const FavoritasPage({ Key? key }) : super(key: key);

  @override
  State<FavoritasPage> createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Moedas Favoritas'),
      ),
    );
  }
}