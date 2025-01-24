import 'package:flutter/material.dart';

import 'utils/db_utils.dart';
import 'utils/language_utils.dart';
import 'utils/page_utils.dart';
import 'utils/color_utils.dart';

import 'pages/advanced_sms_page.dart';

void main() async {
    FlutterError.onError = (FlutterErrorDetails details) {
    // Imprime los detalles del error en la consola
    FlutterError.dumpErrorToConsole(details);

    // Si necesitas manejarlo de manera personalizada:
    debugPrint('FlutterError: ${details.exceptionAsString()}');
    if (details.stack != null) {
      debugPrint('StackTrace: ${details.stack}');
    }
  };
  WidgetsFlutterBinding.ensureInitialized();
  await LanguageManager.instance.initializeLanguage();
  await ColorManager.instance.initializeColor();

  await initializeDB(); // INICIALIZA LA BD Y SI NO ESTÁ CREADA, LA CREA

  debugPrint(LanguageManager.instance.translate('hello'));
  runApp(const MyApp());
  //runApp(const AdvancedApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: '42 Mobile ft_hangouts',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyPage(),
    );
  }
}
