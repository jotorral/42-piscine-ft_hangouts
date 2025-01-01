import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

Future<Database> initializeDB() async {
  String path = await getDatabasesPath();
  debugPrint(path); // AQUI VISUALIZO LA RUTA POR DEFECTO DE LA BD
  path =
      '/storage/emulated/0/Download/'; // AQUÍ PISO LA RUTA DE LA BD POR DEFECTO Y LA PONGO EN LA CARPETA DOWNLOAD
  return openDatabase(
    join(path, 'ft_hangouts.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, surename TEXT, phone INTEGER, email TEXT, address TEXT)',
      );
    },
    version: 1,
  );
}

Future<int> insertItem(String name, String surename, int phone, String email,
    String address) async {
  final db = await initializeDB();
  return await db.insert(
    'items',
    {
      'name': name,
      'surename': surename,
      'phone': phone,
      'email': email,
      'address': address
    },
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}
