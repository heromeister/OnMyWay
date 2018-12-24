import 'dart:io';
import 'globals.dart' as globals;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = "Contacts";

class DataAccess {
  static Database _database;
  String _dirPath = "";
  String _dbName = "saved_contacts.db";

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
    return retDb;
  }

  openConnection(path) async {
    try {
      var retDb = await openDatabase(path, version: 4, onCreate: _onCreate);
      return retDb;
    } catch(e) {
      print(e);
    }
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $TABLE_NAME (id INTEGER PRIMARY KEY AUTOINCREMENT, '
                                  'identifier TEXT NOT NULL, '
                                  'displayName TEXT NOT NULL, '
                                  'phoneNumber TEXT NOT NULL, '
                                  'latitude REAL NOT NULL,'
                                  'longitude REAL  NOT NULL,'
                                  'address TEXT)');
    print("$TABLE_NAME table created");
  }

  clearTable(String tableName) async {
    var dbClient = await database;
    dbClient.delete(tableName);
  }

  Future<List<Map>> getContacts() async {
    print("getContacts started");
    var dbClient = await database;
    List<Map> contacts = await dbClient.query(TABLE_NAME);
    return contacts;
  }

  insertContact(globals.SavedContact contact) async {
    print("insertContact started");
    print("SavedContact as map");
    print(contact.toMap());

    var dbClient = await database;
    int id = await dbClient.insert(TABLE_NAME, contact.toMap());
    print("Strong id: " + id.toString());

    return id;
  }

  updateContact(globals.SavedContact contact) async {
    print("updateContact started");
    var dbClient = await database;
    await dbClient.update(TABLE_NAME, contact.toMap(), where: 'id = ?', whereArgs: [contact.id]);
  }

  deleteContact(globals.SavedContact contact) async {
    print("deleteContact started");
    var dbClient = await database;
    await dbClient.delete(TABLE_NAME, where: "id = ?", whereArgs: [contact.id]);
  }

  deleteContacts(List contactIdsToDelete) async {
    print("deleteContacts started");
    var dbClient = await database;
    for(int contactIdToDelete in contactIdsToDelete) {
      await dbClient.delete(TABLE_NAME, where: "id = ?", whereArgs: [contactIdToDelete]);
    }
  }
}