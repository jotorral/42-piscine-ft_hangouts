import 'package:flutter/material.dart';
import '/pages/home_page.dart';

class MyPage extends StatefulWidget {
	const MyPage({super.key});

	@override
	MyPageState createState() => MyPageState();
}


class MyPageState extends State<MyPage> {
	// Controlamos el estado con un índice para cambiar el contenido
	int _currentIndex = 0;

	// Lista de pantallas que vamos a mostrar, basada en el índice
	final List<Widget> _pantallas = [
		const MyHomePage(title: 'Contacts list', cambiarPantalla: cambiarPantalla),      // Pantalla 0
		const Login(),        // Pantalla 1
		const ProfilePage(),  // Pantalla 2
    	const CalendarPage(),    // Pantalla 3
	];

	// Función callback para cambiar el índice desde las pantallas hijas
	void cambiarPantalla(int nuevoIndex) {
    debugPrint('cambiar pantalla lamado con nuevoIndex: $nuevoIndex');
		setState(() {
			_currentIndex = nuevoIndex;  // Cambia la pantalla según el nuevo índice
		});
	}

	@override
	Widget build(BuildContext context) {


		return Scaffold(
			body: _pantallas[_currentIndex],  // Muestra la pantalla correspondiente
    );
	}
}
