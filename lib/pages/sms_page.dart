import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:permission_handler/permission_handler.dart';
import '/utils/page_utils.dart';
import '/utils/color_utils.dart';
import '/utils/db_utils.dart';

// import '/pages/home_page.dart';
// import '/utils/page_utils.dart';
// import '/utils/db_utils.dart';
// import '/utils/language_utils.dart';
// import '/utils/color_utils.dart';

class SmsPage extends StatefulWidget {
  const SmsPage({Key? key}) : super(key: key);

  @override
  SmsPageState createState() => SmsPageState();
}

class SmsPageState extends State<SmsPage> {
  final SmsQuery query = SmsQuery();
  List<SmsThread> threads = <SmsThread>[];
  List<SmsMessage> messages = <SmsMessage>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    requestPermissions2();
  }

  Future<void> requestPermissions() async {
    bool granted = await Permission.sms.request().isGranted;
    if (granted) {
      query.getAllThreads.then<void>((List<SmsThread> value) {
        setState(() {
          threads = value;
          isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        debugPrint('Error al obtener hilos: $error');
      });
      debugPrint('Permiso para leer SMS concedido.');
    } else {
      setState(() {
        isLoading = false;
      });
      debugPrint('Permiso para leer SMS no otorgado.');
    }
  }

  Future requestPermissions2() async {
    PermissionStatus status = await Permission.sms.request();
    if (status.isGranted) {
      query.getAllSms.then<void>((List<SmsMessage> value) {
        setState(() {
          messages = List.from(messages)..addAll(value.where((msg) => !messages.contains(msg)));
          isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
        debugPrint('Error al obtener mensajes: $error');
      });
      debugPrint('Permiso para leer SMS concedido.');
    } else {
      setState(() {
        isLoading = false;
      });
      debugPrint('Permiso para leer SMS no otorgado.');
    }
  }

  void _showSmsDialog(BuildContext context, String address) {
    final TextEditingController messageController = TextEditingController();
    const int maxSmsLength = 160;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SMS para $address'),
          content: TextField(
            controller: messageController,
            maxLength: maxSmsLength,
            maxLines: 7,
            decoration: const InputDecoration(
              labelText: 'Escribe tu mensaje',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                final String messageText = messageController.text;
                if (messageText.isNotEmpty) {
                  SmsSender sender = SmsSender();
                  final SmsMessage newMessage = SmsMessage(address, messageText)
                    ..kind = SmsMessageKind.Sent
                    ..date = DateTime.now();
                  sender.sendSms(newMessage);
                  debugPrint('Mensaje enviado a $address: $messageText');

                  // await Future.delayed(const Duration(seconds: 1));

                  setState(() {
                    messages = List.from(messages)..add(newMessage);
                    isLoading = false;
                  });
                  debugPrint('Mensaje añadido a la lista. Total mensajes: ${messages.length}');
                  Navigator.of(context).pop();
                } else {
                  debugPrint('El mensaje está vacío');
                }
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter messages where Id matches the actualContactId
    final filteredMessages = messages
        .where((msg) => msg.address == actualContactPhoneNumber)
        .toList();
    debugPrint('actualContactPhoneNumber: $actualContactPhoneNumber');
    debugPrint('filteredMessages: ${filteredMessages.length}');
    for (var msg in filteredMessages) {
      debugPrint(
          'Message ID: ${msg.id}, Address: ${msg.address}, Body: ${msg.body}');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.instance.currentColor,
        title: Row(
          children: [
            IconButton(
                onPressed: () {
                  (context.findAncestorStateOfType<MyPageState>()!)
                      .cambiarPantalla(1);
                },
                icon: const Icon(Icons.arrow_back)),
            const Text("Enviar mensaje SMS"),
          ],
        ),
      ),
      body: Column(
        children: [
          // Botón para enviar SMS
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // SmsSender sender = SmsSender();
                String address = filteredMessages.isNotEmpty
                    ? filteredMessages[0].address ?? '0'
                    : '0'; // Reemplaza con el número deseado
                if (address != '0') {
                  // sender.sendSms(SmsMessage(address, 'Hello flutter world!'));
                  _showSmsDialog(context, address);
                }
                debugPrint('SMS enviado a $address');
                // requestPermissions2();
              },
              child: const Text('Send SMS'),
            ),
          ),
          const Divider(),
          // Contenido dinámico: Hilos de SMS o mensaje vacío
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredMessages.isEmpty
                    ? const Center(child: Text('No messages found'))
                    : ListView.builder(
                      key: ValueKey(filteredMessages.length),
                        itemCount: filteredMessages.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                minVerticalPadding: 8,
                                minLeadingWidth: 4,
                                title: Text(
                                  // threads[index].messages.last.body ?? 'empty',
                                  filteredMessages[index].body ?? 'empty',
                                ),
                                subtitle: Text(
                                  // threads[index].contact?.address ?? 'empty',
                                  filteredMessages[index].address ?? 'empty',
                                ),
                                trailing: Column(
                                  children: [
                                    Text(
                                      getKindText(filteredMessages[index].kind),
                                    ),
                                    Text(
                                      filteredMessages[index].date.toString(),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider()
                            ],
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

String getKindText(SmsMessageKind? kind) {
  if (kind == null) {
    return 'empty';
  }
  switch (kind) {
    case SmsMessageKind.Sent:
      return 'Sent';
    case SmsMessageKind.Received:
      return 'Received';
    default:
      return 'empty';
  }
}
