import 'package:flutter/material.dart';
import 'dart:collection';
import '../models/moeda.dart';

class FavoritasRepository extends ChangeNotifier {
  final List<Moeda> _lista = [];

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  saveAll(List<Moeda> moedas) {
    for (var moeda in moedas) {
      if(!_lista.contains(moeda)) _lista.add(moeda); // Salva na lista apenas as moedas que ainda não existem
    }
    // Após realizar operações na lista, precisamos notificar o Flutter para redezenhar a tela
    notifyListeners();
  }

  remove(Moeda moeda) {
    _lista.remove(moeda);
    // Após realizar operações na lista, precisamos notificar o Flutter para redezenhar a tela
    notifyListeners();
  }
}