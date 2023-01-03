import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:hive/hive.dart';
import '../adapters/moeda_hive_adapter.dart';
import '../models/moeda.dart';

class FavoritasRepository extends ChangeNotifier {
  final List<Moeda> _lista = [];
  late LazyBox box;

  FavoritasRepository() {
    startRepository();
  }

  startRepository() async {
    await _openBox();
    await _readFavoritas();
  }

  _openBox() async {
    Hive.registerAdapter(MoedaHiveAdapter()); // O Hive trabalha com tipos primitivos; para armazenas objetos mais complexos é necessário passar uma classe auxiliar
    box = await Hive.openLazyBox<Moeda>('moedas_favoritas');
  }

  _readFavoritas() {
    box.keys.forEach((moeda) async {
      Moeda m = await box.get(moeda);
      _lista.add(m);
      notifyListeners();
    });
  }

  UnmodifiableListView<Moeda> get lista => UnmodifiableListView(_lista);

  saveAll(List<Moeda> moedas) {
    for (var moeda in moedas) {
      // if(!_lista.contains(moeda)) _lista.add(moeda); // Salva na lista apenas as moedas que ainda não existem
      if(!_lista.any((atual) => atual.sigla == moeda.sigla)) {
        _lista.add(moeda);
        box.put(moeda.sigla, moeda);
      }
    }
    // Após realizar operações na lista, precisamos notificar o Flutter para redezenhar a tela
    notifyListeners();
  }

  remove(Moeda moeda) {
    _lista.remove(moeda);
    box.delete(moeda.sigla);
    // Após realizar operações na lista, precisamos notificar o Flutter para redezenhar a tela
    notifyListeners();
  }
}