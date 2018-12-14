import 'dart:io';
import 'globals.dart' as globals;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = "Contacts";

class DataAccess {
  static Database _database;
  String _dirPath = "";
  String _dbName = "contacts.db";

  Future<Database> get database async {
    if (_database == null) {
      _database  = await init();
    }
    return _database;
  }

  init() async {
    _dirPath = await getDatabasesPath();
    String path = join(_dirPath, _dbName);
    print(path);

    if (!(await Directory(dirname(path)).exists())) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
    }
    var retDb = await openConnection(path);
    //await db.rawDelete("DELETE FROM Contacts");
    return retDb;
  }

  openConnection(path) async {
    try {
      var retDb = await openDatabase(path, version: 1, /*onCreate: _onCreate*/);
      return retDb;
    } catch(e) {
      print(e);
    }
  }

  _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        'CREATE TABLE $TABLE_NAME (id INTEGER PRIMARY KEY, displayName TEXT, phoneNumber TEXT, latitude REAL, longitude REAL)');
    print("$TABLE_NAME table created");
  }

  Future<List<Map>> getContacts() async {
    var dbClient = await database;
    List<Map> contacts = await dbClient.rawQuery('SELECT * FROM $TABLE_NAME');
    return contacts;
  }

  insertContact(globals.SavedContact contact) async {
    print("SavedContact as map");
    print(contact.toMap());

    var dbClient = await database;
    int id = await dbClient.insert(TABLE_NAME, contact.toMap());
    print("Strong id: " + id.toString());
  }
}