import 'package:flutter/material.dart';
import '/pages/home_page.dart';
import '/utils/page_utils.dart';
import '/utils/db_utils.dart';

class AddContactPage extends StatefulWidget{
  const AddContactPage({super.key});

  @override
  AddContactPageState createState() => AddContactPageState();
}


class AddContactPageState extends State<AddContactPage> {
  late TextEditingController nameController;
  late TextEditingController surenameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  @override
  void initState(){
    super.initState();
    nameController = TextEditingController();
    surenameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
  }

  @override
  void dispose(){
    nameController.dispose();
    surenameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> saveContact() async {
    // Actualiza los valores de la variable global contact
    final name = nameController.text;
    final surename = surenameController.text;
    final phoneText = phoneController.text;
    final email = emailController.text;
    final address = addressController.text;

    final phone = int.tryParse(phoneText);

    if (name.isEmpty || surename.isEmpty || phone == null || email.isEmpty || address.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all fields')),
      );
      return;
    }

    final id = await insertItem(name, surename, phone, email, address);

    if (mounted){
    if (id >0){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Contact $name added succesfully'),)
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add contact'))
      );
    }
      // Regresa a la pantalla principal
      (context.findAncestorStateOfType<MyPageState>()!).cambiarPantalla(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'BACK',
              onPressed: (){
                (context.findAncestorStateOfType<MyPageState>()!).cambiarPantalla(0);
              }
            ),

            const Text('Add new contact'),
            
            Expanded(child: Container()),
            
            Row(children: [


              IconButton(
                icon: const Icon(Icons.save),
                tooltip: 'SAVE',
                onPressed: (){
                // Acción para guardar
                  saveContact();
                  debugPrint ('CONTACT SAVED');
                }),
            ],)
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: surenameController,
              decoration: const InputDecoration(labelText: 'Surename'),
            ),
            TextFormField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(labelText: 'Adress'),
            ),
          ],
        ),
      ),
    );
  }
}
