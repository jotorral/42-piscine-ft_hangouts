import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

String actualContactPhoneNumber = '';

Future<Database> initializeDB() async {
  String path = await getDatabasesPath();
  debugPrint(path); // AQUI VISUALIZO LA RUTA POR DEFECTO DE LA BD
  // path =
  //     '/storage/emulated/0/Download/'; // AQUÍ PISO LA RUTA DE LA BD POR DEFECTO Y LA PONGO EN LA CARPETA DOWNLOAD
  return openDatabase(
    join(path, 'ft_hangouts.db'),
    onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, surename TEXT, phone TEXT, email TEXT, address TEXT)',
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

Future<List<Map<String, dynamic>>> fetchAllContacts() async {
  final db = await openDatabase('ft_hangouts.db');
  return await db.query('items', columns: ['id', 'name', 'surename', 'phone', 'email', 'address']);
}

Future<void> deleteContact(int id) async {
  final db = await initializeDB();
  await db.delete(
    'items',
    where: 'id = ?', // Condición para identificar el registro a eliminar
    whereArgs: [id], // Argumentos para la condición
  );
  debugPrint('Contact with ID $id deleted');
}

Future<void> updateContact(contact) async {
  final db = await initializeDB();

  await db.update(
    'items', // Nombre de la tabla
    {
      'name': contact['name'],
      'surename': contact['surename'],
      'phone': contact['phone'],
      'email': contact['email'],
      'address': contact['address'],
    }, // Los datos que queremos actualizar
    where: 'id = ?', // Condición para identificar el registro a actualizar
    whereArgs: [contact['id']], // Argumentos para la condición (en este caso el ID del contacto)
  );

  debugPrint('Updated contact with ID ${contact['id']}');
}