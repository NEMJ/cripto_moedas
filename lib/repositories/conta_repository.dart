import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import '../models/posicao.dart';
import '../database/db.dart';

class ContaRepository extends ChangeNotifier {
  late Database db;
  List<Posicao> _cateira = [];
  double _saldo = 0;

  get saldo => _saldo;
  List<Posicao> get carteira => _cateira;

  ContaRepository() {
    _initRepository();
  }

  _initRepository() async {
    await _getSaldo();
  }

  _getSaldo() async {
    db = await DB.instance.database;
    List conta = await db.query('conta', limit: 1);
    _saldo = conta.first['saldo'];
    notifyListeners();
  }

  setSaldo(double valor) async {
    db = await DB.instance.database;
    db.update('conta', {
      'saldo': valor,
    });
    _saldo = valor;
    notifyListeners();
  }
}