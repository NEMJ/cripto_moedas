import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveConfig {
  static start() async {
    Directory dir = await getApplicationDocumentsDirectory(); // Local onde serão armazenados os documentos do app
    await Hive.initFlutter(dir.path);
  }
}