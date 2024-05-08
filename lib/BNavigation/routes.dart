import 'package:educame/screens/coordinacion/comunicacion.dart';
import 'package:educame/screens/coordinacion/perfil.dart';
import 'package:flutter/material.dart';
import 'package:educame/main.dart';
import 'package:educame/screens/coordinacion/homeCoordinacion.dart';
import 'package:educame/screens/coordinacion/usuarios.dart';

class Routes extends StatelessWidget {
  final int index;
  final int userId; // Agrega el parámetro username
  const Routes({super.key, required this.index, required this.userId});

  @override
  Widget build(BuildContext context) {
    List<Widget> myList = [
      /*  HomeScreen(userId: userId),
      UsuariosScreen(userId: userId), // Add the named parameter 'username'
      ComunicacionScreen(userId: userId),
      PerfilScreen() */
    ];
    return myList[index];
  }
}
