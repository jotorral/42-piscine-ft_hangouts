import 'package:flutter/material.dart';
import 'dart:ui';

import '/utils/page_utils.dart';
import '/utils/db_utils.dart';
import '/utils/language_utils.dart';
import '/utils/color_utils.dart';


dynamic contact = {}; // Inicialización vacía de la variable global
Color appBarColor = Colors.blue;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Map<String, dynamic>>> _futureContacts;

  void _changeAppBarColor(Color color) async {
    await ColorManager.instance.setColor(color);
    setState(() {});
  }

  void _navigateToContactDetails(BuildContext buildContext) {
    final MyPageState? parentState =
        buildContext.findAncestorStateOfType<MyPageState>();
    if (parentState != null) {
      // Llamamos a la función 'cambiarPantalla' en MyPageState
      parentState.cambiarPantalla(2); // Cambiar a la pantalla 2
    } else {
      debugPrint('No se encontró el estado del padre');
    }
  }

    void _navigateToSmsPage(BuildContext buildContext) {
    final MyPageState? parentState =
        buildContext.findAncestorStateOfType<MyPageState>();
    if (parentState != null) {
      // Llamamos a la función 'cambiarPantalla' en MyPageState
      parentState.cambiarPantalla(5); // Cambiar a la pantalla 4
    } else {
      debugPrint('No se encontró el estado del padre');
    }
  }

    void _navigateToSendSmsPage(BuildContext buildContext) {
    final MyPageState? parentState =
        buildContext.findAncestorStateOfType<MyPageState>();
    if (parentState != null) {
      // Llamamos a la función 'cambiarPantalla' en MyPageState
      parentState.cambiarPantalla(4); // Cambiar a la pantalla 4
    } else {
      debugPrint('No se encontró el estado del padre');
    }
  }

  @override
  void initState() {
    super.initState();
    _futureContacts = fetchAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.instance.currentColor,
        title: Text(LanguageManager.instance.translate('Contacts list')),
        actions: [
          IconButton(
              icon: const Icon(Icons.language),
              onPressed: () {
                languageShowMenu(context).then((selectedLanguage) {
                  if (selectedLanguage != null) {
                    debugPrint('Selected language: $selectedLanguage');
                    debugPrint(
                        'System language: ${PlatformDispatcher.instance.locale.languageCode}');
                    // Cambia el idioma usando el LanguageManager
                    LanguageManager.instance.setLanguage(selectedLanguage);
                    debugPrint('Selected language: $selectedLanguage');
                    // Redibuja la UI (asume que estás en un StatefulWidget)
                    setState(() {});
                  }
                });
              }),
          IconButton(
              icon: const Icon(Icons.color_lens),
              onPressed: () {
                colorShowMenu(context).then((color) {
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
            return Center(
                child: Text(
                    LanguageManager.instance.translate('No contacts found')));
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
                      contact = Map<String, dynamic>.from(contacts[index]);
                      _navigateToContactDetails(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Nombre y apellido
                        Expanded(
                          flex: 4,
                          child: Wrap(
                            spacing: 4.0,
                            children: [
                              Text(
                                  contact['name'] ??
                                      LanguageManager.instance
                                          .translate('unknown'),
                                  style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                  contact['surename'] ??
                                      LanguageManager.instance
                                          .translate('unknown'),
                                  style: const TextStyle(
                                      fontSize: 16.0, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        // Botones
                        Expanded(
                          flex: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // ElevatedButton(
                              //     onPressed: () {
                              //       actualContactPhoneNumber = contacts[index]['phone'];
                              //       // Acción para realizar una llamada
                              //       debugPrint(
                              //           'Call contact: ${contacts[index]['phone']}');
                              //     },
                              //     style: ElevatedButton.styleFrom(
                              //       minimumSize: const Size(0, 0),
                              //       padding: const EdgeInsets.symmetric(
                              //           vertical: 8.0, horizontal: 8.0),
                              //     ),
                              //     child: Text(
                              //         LanguageManager.instance
                              //             .translate('CALL'),
                              //         style: const TextStyle(
                              //             fontSize: 10.0,
                              //             color: Colors.black))),
                              const SizedBox(
                                width: 3,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Acción para enviar un mensaje
                                  actualContactPhoneNumber = contacts[index]['phone'].toString();
                                  if (mounted) _navigateToSendSmsPage(context);
                                  debugPrint(
                                      'Send SMS to contact: ${contacts[index]['phone']}');
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 8.0),
                                  minimumSize: const Size(0, 0),
                                ),
                                child: Text(
                                    LanguageManager.instance
                                        .translate('MESSAGE'),
                                    style: const TextStyle(
                                        fontSize: 10.0, color: Colors.black)),
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
      
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          FloatingActionButton(
            onPressed: () {
              if (mounted) _navigateToSmsPage(context);
            },
            tooltip: LanguageManager.instance.translate('Go to Messages Page'),
            child: const Icon(Icons.message_outlined),
          ),

          FloatingActionButton(
            onPressed: () {
              (context.findAncestorStateOfType<MyPageState>()!).cambiarPantalla(3);
            },
            tooltip: LanguageManager.instance.translate('Go to Login Page'),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Future<Color?> colorShowMenu(BuildContext context) {
    return showMenu<Color>(
                context: context,
                position: const RelativeRect.fromLTRB(100, 50, 0, 0),
                items: [
                  PopupMenuItem<Color>(
                      value: Colors.blue,
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.blue,
                          child: Text(
                              LanguageManager.instance.translate('Blue'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)))),
                  PopupMenuItem<Color>(
                      value: Colors.green,
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.green,
                          child: Text(
                              LanguageManager.instance.translate('Green'),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)))),
                  PopupMenuItem<Color>(
                      value: Colors.yellow,
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.yellow,
                          child: Text(
                              LanguageManager.instance.translate('Yellow'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              )))),
                  PopupMenuItem<Color>(
                      value: Colors.red,
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.red,
                          child:
                              Text(LanguageManager.instance.translate('Red'),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  )))),
                  PopupMenuItem<Color>(
                      value: Colors.orange,
                      child: Container(
                          padding: const EdgeInsets.all(8),
                          color: Colors.orange,
                          child: Text(
                              LanguageManager.instance.translate('Orange'),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              )))),
                  PopupMenuItem<Color>(
                    value: Colors.purple,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.purple,
                      child: Text(
                        LanguageManager.instance.translate('Purple'),
                        style: const TextStyle(
                          color: Colors.white, // Color del texto
                          fontWeight:
                              FontWeight.bold, // Para resaltar el texto
                        ),
                      ),
                    ),
                  ),
                ],
                elevation: 8.0,
              );
  }

  Future<String?> languageShowMenu(BuildContext context) {
    return showMenu<String>(
                context: context,
                position: const RelativeRect.fromLTRB(100, 50, 0, 0),
                items: [
                  PopupMenuItem<String>(
                      value: 'en',
                      child: Text(
                        PlatformDispatcher.instance.locale.languageCode ==
                                'en'
                            ? 'English (system)'
                            : 'English',
                      )),
                  PopupMenuItem<String>(
                      value: 'es',
                      child: Text(
                        PlatformDispatcher.instance.locale.languageCode ==
                                'es'
                            ? 'Español (sistema)'
                            : 'Español',
                      )),
                ],
                elevation: 8.0,
              );
  }
}
