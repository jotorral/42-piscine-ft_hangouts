// import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


// Clase del tipo SINGLETON. Sólo permite una única instancia. Aunque la instancies varias veces, sólo hay una instancia
class LanguageManager {
  static final LanguageManager _instance = LanguageManager._internal();

  LanguageManager._internal();

  static LanguageManager get instance => _instance;

  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  // Inicializar cargando el idioma guardado
  Future<void> initializeLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('selected_language') ?? 'en'; // Idioma por defecto 'en'
  }

  void setLanguage(String language) async {
    _currentLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', language); // Guarda el idioma seleccionado
  }

  String translate(String key) {
    return Translations.texts[_currentLanguage]?[key] ?? key;
  }
}


class Translations {
  static const Map<String, Map<String, String>> texts = {
    'en': {
      'hello': 'Hello',
      'welcome': 'Welcome',
      'goodbye': 'Goodbye',
      'Contacts list': 'Contacts list',
      'CALL': 'CALL',
      'MESSAGE': 'MESSAGE',
      'Blue': 'Blue',
      'Green': 'Green',
      'Yellow': 'Yellow',
      'Red': 'Red',
      'Orange': 'Orange',
      'Purple': 'Purple',
      'No contacts found': 'No contacts found',
      'unknown': 'unknown',
      'Go to Login Page': 'Go to Login Page',
      'Please fill out all fields properly': 'Please fill out all fields properly',
      'Contact': 'Contact',
      'Failed to add contact': 'Failed to add contact',
      'BACK': 'BACK',
      'Add new contact': 'Add new contact',
      'SAVE': 'SAVE',
      'Name': 'Name',
      'Surename': 'Surename',
      'Phone': 'Phone',
      'Email': 'Email',
      'Address': 'Address',
      'updated': 'updated',
      'DELETE': 'DELETE',
      'deleted succesfully': 'deleted succesfully',
      'Time in background: ': 'Time in background: ',
      ' minutes and ': ' minutes and ',
      ' seconds.': ' seconds.',
      ' during ': ' during ',
      'In background since: ': 'In background since: ',
    },
    'es': {
      'hello': 'Hola',
      'welcome': 'Bienvenido',
      'goodbye': 'Adiós',
      'Contacts list': 'Lista de contactos',
      'CALL': 'LLAMAR',
      'MESSAGE': 'MENSAJE',
      'Blue': 'Azul',
      'Green': 'Verde',
      'Yellow': 'Amarillo',
      'Red': 'Rojo',
      'Orange': 'Naranja',
      'Purple': 'Violeta',
      'No contacts found': 'Lista de contactos vacía',
      'unknown': 'desconocido',
      'Go to Login Page': 'Ir a la página de inicio',
      'Please fill out all fields properly': 'Por favor rellena todos los campos correctamente',
      'Contact': 'Contacto',
      'Failed to add contact': 'No ha sido posible añadir el contacto',
      'BACK': 'VOLVER',
      'Add new contact': 'Añadir nuevo contacto',
      'SAVE': 'GUARDAR',
      'Name': 'Nombre',
      'Surename': 'Apellido',
      'Phone': 'Teléfono',
      'Email': 'Correo electrónico',
      'Address': 'Dirección',
      'updated': 'actualizado',
      'DELETE': 'ELIMINAR',
      'deleted succesfully': 'eliminado correctamente',
      'Time in background: ': 'Tiempo en segundo plano: ',
      ' minutes and ': ' minutos y ',
      ' seconds.': ' segundos.',
      ' during ': ' durante ',
      'In background since: ': 'En segundo plano desde: ',
    },
    'fr': {
      'hello': 'Bonjour',
      'welcome': 'Bienvenue',
      'goodbye': 'Au revoir',
      'Contacts list': 'Liste de contacts',
      'CALL': 'CALL',
      'MESSAGE': 'APPEL',
      'Blue': 'Bleu',
      'Green': 'Vert',
      'Yellow': 'Jaune',
      'Red': 'Rouge',
      'Orange': 'Orange',
      'Purple': 'Violet',
      'No contacts found': 'Aucun contact trouvé',
      'Unknown': 'inconnu',
      'Go to Login Page': 'Aller à la page de connexion',
      'Please fill out all fields properly': 'Veuillez remplir tous les champs correctement',
      'Contact': 'Le contact',
      'added succesfully': 'a été ajouté correctement',
      'Failed to add contact': 'Échec de l\'ajout du contact',
      'VOLVER': 'RETOUR',
      'Add new contact': 'Ajouter un nouveau contact',
      'SAVE': 'GARDER',
      'Name': 'Nom',
      'Surename': 'Nom de famille',
      'Phone': 'Téléphone',
      'Email': 'E-mail',
      'Address': 'Adresse',
      'updated': 'mis à jour',
      'DELETE':'ÉLIMINER',
      'deleted succesfully': 'a été supprimé avec succès',
      'Time in background: ': 'Temps en arrière-plan : ',
      ' minutes and ': ' minutes et ',
      ' seconds.': ' secondes.',
      ' during ': ' pendant ',
      'In background since: ': 'En arrière-plan depuis: ',
    },
  };
}
