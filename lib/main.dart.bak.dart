import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
    FlutterError.onError = (FlutterErrorDetails details) {
    // Imprime los detalles del error en la consola
    FlutterError.dumpErrorToConsole(details);
    // Si necesitas manejarlo de manera personalizada:
    debugPrint('FlutterError: ${details.exceptionAsString()}');
    if (details.stack != null) {
      debugPrint('StackTrace: ${details.stack}');
    }
  };
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SmsQuery query = SmsQuery();
  List<SmsThread> threads = <SmsThread>[];
  List<SmsMessage> messages =
      <SmsMessage>[]; // Esta es mi prueba para obtener todos los mensajes
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // requestPermissions();
    requestPermissions2();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Example"),
        ),
        body: Column(
          children: [
            // Botón para enviar SMS
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  SmsSender sender = SmsSender();
                  String address =
                      '656789661'; // Reemplaza con el número deseado
                  sender.sendSms(SmsMessage(address, 'Hello flutter world!'));
                  debugPrint('SMS enviado a $address');
                  requestPermissions2();
                },
                child: const Text('Send SMS'),
              ),
            ),
            const Divider(),
            // Contenido dinámico: Hilos de SMS o mensaje vacío
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : messages.isEmpty
                      ? const Center(child: Text('No messages found'))
                      : ListView.builder(
                          itemCount: messages.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  minVerticalPadding: 8,
                                  minLeadingWidth: 4,
                                  title: Text(
                                    // threads[index].messages.last.body ?? 'empty',
                                    messages[index].body ?? 'empty',
                                  ),
                                  subtitle: Text(
                                    // threads[index].contact?.address ?? 'empty',
                                    messages[index].address ?? 'empty',
                                  ),
                                  trailing: Column(
                                    children: [
                                      Text(
                                        getKindText(messages[index].kind),
                                      ),
                                      Text(
                                        messages[index].date.toString(),
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
      ),
    );
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
          messages = value;
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
