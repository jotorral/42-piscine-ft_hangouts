import 'package:flutter/material.dart';
import 'package:sms_advanced/sms_advanced.dart';
import 'package:permission_handler/permission_handler.dart';
import '/utils/language_utils.dart';
import '/utils/page_utils.dart';
import '/utils/color_utils.dart';


class AdvancedApp extends StatefulWidget {
  const AdvancedApp({Key? key}) : super(key: key);

  @override
  State<AdvancedApp> createState() => _AdvancedAppState();
}

class _AdvancedAppState extends State<AdvancedApp> {
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
          backgroundColor: ColorManager.instance.currentColor,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                tooltip: LanguageManager.instance.translate('BACK'),
                onPressed: () {
                  (context.findAncestorStateOfType<MyPageState>()!)
                      .cambiarPantalla(1);
                },
              ),
              const Text("Mensajes SMS"),
            ],
          ),
        ),
        body: Column(
          children: [
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
