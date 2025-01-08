import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart'; // Necesario para WidgetsBindingObserver
import 'package:fluttertoast/fluttertoast.dart'; // Necesario para mostrar el Toast con el tiempo tras estar en segundo plano
import 'package:intl/intl.dart'; // Necesario para formatear la fecha quitándole la hora
import '/pages/home_page.dart';
import '/pages/details_page.dart';
import '/pages/add_contact_page.dart';
import '/utils/language_utils.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  MyPageState createState() => MyPageState();
}

class MyPageState extends State<MyPage> with WidgetsBindingObserver {
  // Controlamos el estado con un índice para cambiar el contenido
  int _currentIndex = 0;
  late DateTime
      _appLaunchTime; // Para guardar el momento en que la app se lanza o entra en segundo plano
  String _backgroundTime = ""; // Para mostrar el tiempo en segundo plano
  String? _backgroundDate; // Para almacenar la fecha cuando la app se envía al fondo

  // Lista de pantallas que vamos a mostrar, basada en el índice
  final List<Widget> _pantallas = [
    const MyHomePage(), // Pantalla 0
    const ContactDetailsPage(), // Pantalla 1
    const AddContactPage(), // Pantalla 2
    // const CalendarPage(),    // Pantalla 3
  ];

  // Función callback para cambiar el índice desde las pantallas hijas
  void cambiarPantalla(int nuevoIndex) {
    debugPrint('cambiar pantalla lamado con nuevoIndex: $nuevoIndex');
    setState(() {
      _currentIndex = nuevoIndex; // Cambia la pantalla según el nuevo índice
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // Agregar el observador al ciclo de vida
    _appLaunchTime = DateTime.now(); // Guardar el tiempo cuando la app se lanza
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(
        this); // Eliminar el observador cuando se cierre el widget
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Calcular el tiempo que estuvo la app en segundo plano
      final timeInBackground = DateTime.now().difference(_appLaunchTime);
      setState(() {
        _backgroundTime =
            "${LanguageManager.instance.translate(' during ')} ${timeInBackground.inMinutes} ${LanguageManager.instance.translate(' minutes and ')} ${timeInBackground.inSeconds % 60} ${LanguageManager.instance.translate(' seconds.')}";
      });
      // Si la app fue al fondo, mostrar el Toast con la fecha
      if (_backgroundDate != null) {
        Fluttertoast.showToast(
          msg: "${LanguageManager.instance.translate('In background since: ')} $_backgroundDate\n $_backgroundTime",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
        );
      }
      _appLaunchTime = DateTime.now(); // Actualizar el tiempo de lanzamiento
    } else if (state == AppLifecycleState.paused) {
      // Guardar la fecha y hora cuando la app entra en segundo plano
      setState(() {
        _backgroundDate = DateFormat('yyyy-MM-dd').format(DateTime.now()); // Guardar la fecha
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: _pantallas[_currentIndex]
          ), // Muestra la pantalla correspondiente
        ],
      ),
    );
  }
}
