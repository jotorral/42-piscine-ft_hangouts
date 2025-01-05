import 'package:flutter/material.dart';
import '/pages/home_page.dart';
import '/utils/page_utils.dart';
import '/utils/db_utils.dart';
import '/utils/language_utils.dart';
import '/utils/color_utils.dart';

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
  
    final name = nameController.text;
    final surename = surenameController.text;
    final phoneText = phoneController.text;
    final email = emailController.text;
    final address = addressController.text;

    final phone = int.tryParse(phoneText);

    if (name.isEmpty || surename.isEmpty || phone == null || email.isEmpty || address.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LanguageManager.instance.translate('Please fill out all fields properly')), backgroundColor: Colors.red,),
      );
      return;
    }

    final id = await insertItem(name, surename, phone, email, address);

    if (mounted){
    if (id >0){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${LanguageManager.instance.translate('Contact')} $name ${LanguageManager.instance.translate('added succesfully')}'), backgroundColor: Colors.green)
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LanguageManager.instance.translate('Failed to add contact')), backgroundColor: Colors.red,)
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
        backgroundColor: ColorManager.instance.currentColor,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: LanguageManager.instance.translate('BACK'),
              onPressed: (){
                (context.findAncestorStateOfType<MyPageState>()!).cambiarPantalla(0);
              }
            ),

            Text(LanguageManager.instance.translate('BACK')),
            
            Expanded(child: Container()),
            
            Row(children: [


              IconButton(
                icon: const Icon(Icons.save),
                tooltip: LanguageManager.instance.translate('SAVE'),
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
          ],
        ),
      ),
    );
  }
}
