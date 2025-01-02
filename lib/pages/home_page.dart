import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '/utils/page_utils.dart';
import '/utils/db_utils.dart';

dynamic contact = {};  // Inicialización vacía de la variable global

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  late Future<List<Map<String, dynamic>>> _futureContacts;
  Color _appBarColor = Colors.blue;

  // void _changeAppBarColor() {
  //   setState(() {
  //     // Cambiar el color al azar o con un color fijo
  //     _appBarColor = _appBarColor == Colors.blue ? Colors.green : Colors.blue;
  //   });
  // }

  void _changeAppBarColor(Color color) {
    setState(() {
      _appBarColor = color;
    });
  }

  void _navigateToContactDetails(BuildContext buildContext){
    final MyPageState? parentState = buildContext.findAncestorStateOfType<MyPageState>();
    if (parentState != null) {
      // Llamamos a la función 'cambiarPantalla' en MyPageState
      parentState.cambiarPantalla(1);  // Cambiar a la pantalla 1
    } else {
      debugPrint('No se encontró el estado del padre');
    }
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState() {
    super.initState();
    _futureContacts = fetchAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: _appBarColor,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
              icon: const Icon(Icons.color_lens),
              onPressed: () {
                showMenu<Color>(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 50, 0, 0),
                  items: [
                    PopupMenuItem<Color>(
                        value: Colors.blue, child: Container(padding: const EdgeInsets.all(8),color: Colors.blue, child: const Text('Blue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                    PopupMenuItem<Color>(
                        value: Colors.green, child: Container(padding: const EdgeInsets.all(8), color: Colors.green,child: const Text('Green', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
                    PopupMenuItem<Color>(
                        value: Colors.yellow, child: Container(padding: const EdgeInsets.all(8), color: Colors.yellow, child: const Text('Yellow', style: TextStyle(fontWeight: FontWeight.bold,)))),
                    PopupMenuItem<Color>(
                        value: Colors.red, child: Container(padding: const EdgeInsets.all(8), color: Colors.red, child: const Text('Red', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,)))),
                    PopupMenuItem<Color>(
                        value: Colors.orange, child: Container(padding: const EdgeInsets.all(8), color: Colors.orange,child: const Text('Orange', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,)))),
                    PopupMenuItem<Color>(
                        value: Colors.purple,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.purple,
                          child: const Text('Purple', style: TextStyle(
                            color: Colors.white, // Color del texto
                            fontWeight: FontWeight.bold, // Para resaltar el texto
                          ),),
                        ),),
                  ],
                  elevation: 8.0,
                ).then((color) {
                  if (color != null) {
                    _changeAppBarColor(color);
                  }
                });
              }),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureContacts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No contacts found'));
          } else {
            final contacts = snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                contact = contacts[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 8.0),
                  child: GestureDetector(
                    
                    onTap: () {
                      contact = contacts[index];
                      _navigateToContactDetails(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nombre y apellido
                        Expanded(
                          flex: 2,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                contact['id']?.toString() ?? 'Unknown',
                                style: const TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                contact['name'] ?? 'Unknown',
                                style: const TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                ' ',
                                style: TextStyle(
                                    fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                contact['surename'] ?? 'Unknown',
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        // Botones
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    // Acción para editar el contacto
                                    debugPrint('Edit contact: ${contact['id']}');
                                  },
                                  child: const Text('CALL',
                                      style: TextStyle(
                                          fontSize: 12.0, color: Colors.black))
                                  // icon: const Icon(Icons.edit, color: Colors.blue),
                                  ),
                              const SizedBox(
                                width: 3,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Acción para eliminar el contacto
                                  debugPrint('Delete contact: ${contact['id']}');
                                },
                                child: const Text('MESSAGE',
                                    style: TextStyle(
                                        fontSize: 12.0, color: Colors.black)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          (context.findAncestorStateOfType<MyPageState>()!).cambiarPantalla(0);
        },
        tooltip: 'Go to Login Page',
        child: const Icon(Icons.login),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
