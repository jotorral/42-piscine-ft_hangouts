import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_advanced/sms_advanced.dart';

import '/utils/page_utils.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key? key}) : super(key: key);
  @override
  PermissionPageState createState() => PermissionPageState();
}

class PermissionPageState extends State<PermissionPage> {
  @override
  void initState() {
    super.initState();
    _requestSmsPermission();
  }

  void _navigateToHomePage(BuildContext buildContext) {
    final MyPageState? parentState =
        buildContext.findAncestorStateOfType<MyPageState>();
    if (parentState != null) {
      // Llamamos a la función 'cambiarPantalla' en MyPageState
      parentState.cambiarPantalla(1); // Cambiar a la pantalla 2
    } else {
      debugPrint('No se encontró el estado del padre');
    }
  }

  Future<void> _requestSmsPermission() async {
    var status = await Permission.sms.status;

    if (status.isDenied) {
      // Si el permiso fue denegado, solicita nuevamente
      if (await Permission.sms.request().isGranted) {
        debugPrint("Permiso de SMS concedido");
        if (mounted) _navigateToHomePage(context);
      } else {
        debugPrint("Permiso de SMS denegado");
      openAppSettings();  
      }
    } else if (status.isPermanentlyDenied) {
      // Si el permiso fue permanentemente denegado, muestra un diálogo o guía para habilitarlo en configuración
      openAppSettings();
    } else if (status.isGranted) {
      // Si el permiso ya fue concedido, navega a la pantalla principal
      if (mounted) _navigateToHomePage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permisos de SMS'),
      ),
      body: const Center(
        child: Text('Solicitando permiso de SMS al iniciar...'),
      ),
    );
  }
}