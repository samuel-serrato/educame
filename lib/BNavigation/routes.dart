import 'package:flutter/material.dart';
import 'package:educame/main.dart';
import 'package:educame/screens/home.dart';
import 'package:educame/screens/usuarios.dart';
import 'package:educame/screens/personas.dart';

import '../screens/grupos.dart';

class Routes extends StatelessWidget {
  final int index;
  final String username; // Agrega el parámetro username
  const Routes({super.key, required this.index, required this.username});

  @override
  Widget build(BuildContext context) {
    List<Widget> myList =[
       HomeScreen(username: username),
      UsuariosScreen(username: username), // Add the named parameter 'username'
       GruposScreen(username: username),
       PersonasScreen(username: username)
    ];
    return myList[index];
  }
}

