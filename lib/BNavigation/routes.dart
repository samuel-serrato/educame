import 'package:educame/screens/comunicacion.dart';
import 'package:educame/screens/perfil.dart';
import 'package:flutter/material.dart';
import 'package:educame/main.dart';
import 'package:educame/screens/home.dart';
import 'package:educame/screens/usuarios.dart';

class Routes extends StatelessWidget {
  final int index;
  final int userId; // Agrega el parámetro username
  const Routes({super.key, required this.index, required this.userId});

  @override
  Widget build(BuildContext context) {
    List<Widget> myList = [
      HomeScreen(userId: userId),
      UsuariosScreen(userId: userId), // Add the named parameter 'username'
      ComunicacionScreen(userId: userId),
      PerfilScreen()
    ];
    return myList[index];
  }
}
