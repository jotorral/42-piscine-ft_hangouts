import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'pages/home_page.dart';
import 'utils/db_utils.dart';
import 'utils/language_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locale deviceLocale = PlatformDispatcher.instance.locale;

  debugPrint('Idioma del dispositivo: ${deviceLocale.languageCode}');
  debugPrint('País del dispositivo: ${deviceLocale.countryCode}');
  LanguageManager.instance.setLanguage(deviceLocale.languageCode);
  debugPrint(LanguageManager.instance.translate('hello'));
  await initializeDB(); // INICIALIZA LA BD Y SI NO ESTÁ CREADA, LA CREA
  await insertItem('Pepe', 'Gomez', 787868768, 'kjhjk@kjhkjh.com', 'Calle Mayor 15'); // AÑADE UN REGISTRO A LA BD
  LanguageManager.instance.setLanguage('es');
  debugPrint(LanguageManager.instance.translate('hello'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: '42 Mobile ft_hangouts',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ft_hangouts'),
    );
  }
}
