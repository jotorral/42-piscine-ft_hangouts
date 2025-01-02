import 'package:flutter/material.dart';
import '/pages/home_page.dart';

class ContactDetailsPage extends StatelessWidget {
//  final Map<String, dynamic> contact;

  const ContactDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${contact['name']} ${contact['surename']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${contact['id']}', style: const TextStyle(fontSize: 18)),
            Text('${contact['name']}', style: const TextStyle(fontSize: 18)),
            Text('${contact['surename']}', style: const TextStyle(fontSize: 18)),
            Text('${contact['phone']}', style: const TextStyle(fontSize: 18)),
            Text('${contact['email']}', style: const TextStyle(fontSize: 18)),
            Text('${contact['address']}', style: const TextStyle(fontSize: 18)),
            // Puedes agregar más campos de tu base de datos aquí si es necesario
          ],
        ),
      ),
    );
  }
}
