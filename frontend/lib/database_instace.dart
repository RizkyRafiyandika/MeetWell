import 'dart:io';
import 'package:fitness2/models/-/product_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseInstance {
  final String _databaseName = "my_database.db";
  final int _databaseversion = 1;

  // product table
  final String table = "product";
  final String id = "id";
  final String name = "name";
  final String category = "category";
  final String createAt = "create_at";
  final String updateAt = "update_at";

  Database? _database;

  Future<Database> database() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseversion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $table ($id INTEGER PRIMARY KEY, $name TEXT NULL, $category TEXT NULL, $createAt TEXT NULL, $updateAt TEXT NULL)");
  }

  Future<List<ProductModel>> all() async {
    final db = await database(); // Ensure _database is initialized
    final data = await db.query(table);
    List<ProductModel> result =
        data.map((e) => ProductModel.fromJson(e)).toList();
    // print(result);
    return result;
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final db = await database(); // Ensure _database is initialized
    return await db.insert(table, row);
  }

  Future<int> update(int idParams, Map<String, dynamic> row) async {
    final query = await _database!
        .update(table, row, where: "$id = ?", whereArgs: [idParams]);
    return query;
  }
}
