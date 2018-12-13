import 'dart:io';
import 'globals.dart' as globals;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataAccess {
  Database _database;
  String _dirPath = "";
  String _dbName = "contacts.db";

  DataAccess() {
    init();
  }

  init() async {
    _dirPath = await getDatabasesPath();
    String path = join(_dirPath, _dbName);

    if (!(await Directory(dirname(path)).exists())) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (e) {
        print(e);
      }
    }
    openConnection(path);
  }

  openConnection(path) async {
    _database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Contacts (id INTEGER PRIMARY KEY, displayName TEXT, phoneNumber TEXT, latitude REAL, longitude REAL)');
        });
  }

  getContacts() async {
    List<Map> contacts = await _database.rawQuery('SELECT * FROM Contacts');
    return contacts;
  }

  insertContact(globals.SavedContact contact) async {
    String displayName = contact.Name();
    String phoneNumber = contact.PhoneNumber();
    double latitude= contact.Location()["latitude"];
    double longitude = contact.Location()["longitude"];

    await _database.transaction((txn) async {
      int num = await txn.rawInsert(
          'INSERT INTO Contacts(displayName, phoneNumber, latitude, longitude) VALUES($displayName, $phoneNumber, $latitude, $longitude)');
      print('inserted1: $num');
    });
  }
}