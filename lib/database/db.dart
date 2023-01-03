import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  // Singleton é um padrão de projeto que permite que uma classe gerencie sua instanciação; e que apenas uma instância dessa classe seja criada.
  // É insteressante usar neste cenário porque podemos gerenciar o número de conexões / aberturas para operações no banco de dados; restringimos a uma única vez.
  // Mais vável do que abrir várias conexões de acesso interno do banco no dispositivo.

  // Construtor com acesso privado para este singleton
  DB._();

  // Criar uma instância de DB
  static final DB instance = DB._();

  // Instância do SQLite
  static Database? _database;

  get database async {
    if(_database != null) return _database;
    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'cripto.db'), // Caminho no Android ou IOS para salvar o banco de dados
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    await db.execute(_conta);
    await db.execute(_carteira);
    await db.execute(_historico);
    await db.insert('conta', {'saldo': 0});
  }

  String get _conta => '''
    CREATE TABLE conta (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      saldo REAL
    );
  ''';

  String get _carteira => '''
    CREATE TABLE carteira (
      sigla TEXT PRIMARY KEY,
      moeda TEXT,
      quantidade TEXT
    );
  ''';

  String get _historico => '''
    CREATE TABLE historico (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      data_operacao INT,
      tipo_operacao TEXT,
      moeda TEXT,
      sigla TEXT,
      valor REAL,
      quantidade TEXT
    );
  ''';
}