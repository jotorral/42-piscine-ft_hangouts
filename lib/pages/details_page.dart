import 'package:flutter/material.dart';
import '/pages/home_page.dart';
import '/utils/page_utils.dart';
import '/utils/db_utils.dart';
import '/utils/language_utils.dart';
import '/utils/color_utils.dart';

class ContactDetailsPage extends StatefulWidget{
  const ContactDetailsPage({Key? key}) : super(key: key);

  @override
  ContactDetailsPageState createState() => ContactDetailsPageState();
}


class ContactDetailsPageState extends State<ContactDetailsPage> {
  late TextEditingController nameController;
  late TextEditingController surenameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  @override
  void initState(){
    super.initState();
    nameController = TextEditingController(text: contact['name']);
    surenameController = TextEditingController(text: contact['surename']);
    phoneController = TextEditingController(text: contact['phone'].toString());
    emailController = TextEditingController(text: contact['email']);
    addressController = TextEditingController(text: contact['address']);
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
    contact['name'] = nameController.text;
    contact['surename'] = surenameController.text;
    contact['phone'] = phoneController.text;
    contact['email'] = emailController.text;
    contact['address'] = addressController.text;


    await updateContact(contact);

    if (mounted){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${LanguageManager.instance.translate('Contact')} ${contact['name']} ${LanguageManager.instance.translate('updated')}'), backgroundColor: Colors.green,)
      );
 
      // Regresa a la pantalla principal
      (context.findAncestorStateOfType<MyPageState>()!).cambiarPantalla(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.instance.currentColor,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: LanguageManager.instance.translate('BACK'),
              onPressed: (){
                (context.findAncestorStateOfType<MyPageState>()!).cambiarPantalla(1);
              }
            ),

            const Text('ft_hangouts'),
            
            Expanded(child: Container()),
            
            Row(children: [


              IconButton(
                icon: const Icon(Icons.save),
                tooltip: LanguageManager.instance.translate('SAVE'),
                onPressed: (){
                // Acción para guardar
                  saveContact();
                  debugPrint ('SAVE: ${contact['name']}');
                }),


              IconButton(icon: const Icon(Icons.delete),
              tooltip: LanguageManager.instance.translate('DELETE'),
              onPressed: () async {
                //acción para eliminar contacto
                final contactId = contact['id'];
                if (contactId != null){
                  await deleteContact(contactId);
                  debugPrint('Deleted contact: $contactId');
                  if (context.mounted){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${LanguageManager.instance.translate('Contact')} ${contact['name']} ${LanguageManager.instance.translate('deleted succesfully')}'), backgroundColor: Colors.green,));
                    (context.findAncestorStateOfType<MyPageState>()!).cambiarPantalla(1);
                  }
                } else{
                debugPrint ('Contact ID is null');
                }
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
              decoration: InputDecoration(labelText: LanguageManager.instance.translate('Name')),
            ),
            TextFormField(
              controller: surenameController,
              decoration: InputDecoration(labelText: LanguageManager.instance.translate('Surename')),
            ),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(labelText: LanguageManager.instance.translate('Phone')),
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: LanguageManager.instance.translate('Email')),
            ),
            TextFormField(
              controller: addressController,
              decoration: InputDecoration(labelText: LanguageManager.instance.translate('Address')),
            ),

            // Text('${contact['id']}', style: const TextStyle(fontSize: 18)),
            // Text('${contact['name']}', style: const TextStyle(fontSize: 18)),
            // Text('${contact['surename']}', style: const TextStyle(fontSize: 18)),
            // Text('${contact['phone']}', style: const TextStyle(fontSize: 18)),
            // Text('${contact['email']}', style: const TextStyle(fontSize: 18)),
            // Text('${contact['address']}', style: const TextStyle(fontSize: 18)),
            // Puedes agregar más campos de tu base de datos aquí si es necesario
          ],
        ),
      ),
    );
  }
}
