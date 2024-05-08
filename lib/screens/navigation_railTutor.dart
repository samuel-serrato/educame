import 'package:educame/screens/tutor/comunicacion.dart';
import 'package:educame/screens/tutor/homeTutor.dart';
import 'package:educame/screens/tutor/perfil.dart';
import 'package:educame/screens/tutor/usuarios.dart';
import 'package:flutter/material.dart';

class NavigationRailTScreen extends StatefulWidget {
  final String tipoUsuario; // Nuevo
  final int idUsuario; // Agregamos el ID del usuario aquí
  final String nombreUsuario; // Nuevo parámetro para el nombre del usuario

  @override
  _NavigationRailTScreenState createState() => _NavigationRailTScreenState();

  NavigationRailTScreen({
    required this.tipoUsuario,
    required this.idUsuario,
    required this.nombreUsuario, // Agregar el nuevo parámetro
  });
}

class _NavigationRailTScreenState extends State<NavigationRailTScreen> {
  int _selectedIndex = 0;

  late List<Widget> _widgetOptions = <Widget>[
    HomeTutorScreen(
        userId: widget.idUsuario,
        userType: widget.tipoUsuario,
        nombre: widget
            .nombreUsuario /* nombre: widget.nombre, tipoUsuario: widget.tipoUsuario, idUsuario: widget.idUsuario, */),
    UsuariosTutorScreen(
        userId: widget
            .idUsuario /* nombre: widget.nombre, tipoUsuario: widget.tipoUsuario, idUsuario: widget.idUsuario */),
    ComunicacionTutorScreen(
        userId: widget
            .idUsuario /* nombre: widget.nombre, tipoUsuario: widget.tipoUsuario */),
    PerfilTutorScreen(
        /* nombre: widget.nombre,
      tipoUsuario: widget.tipoUsuario,
      idUsuario: widget.idUsuario, */
        )
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 600) {
          // Si el ancho de la pantalla es menor o igual a 600 (típicamente considerado como tamaño móvil)
          // mostrar BottomNavigationBar
          return Scaffold(
            body: _widgetOptions.elementAt(_selectedIndex),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              backgroundColor:
                  Colors.white, // Color de fondo similar al NavigationRail
              selectedItemColor:
                  Colors.blue[900], // Color de ícono seleccionado
              unselectedItemColor:
                  Colors.grey[600], // Color de ícono no seleccionado
              selectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.bold), // Estilo de texto seleccionado
              unselectedLabelStyle: TextStyle(
                  fontWeight:
                      FontWeight.bold), // Estilo de texto no seleccionado
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: 'Usuarios',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_sharp),
                  label: 'Comunicación',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
            ),
          );
        } else {
          // Si el ancho de la pantalla es mayor que 600, mostrar NavigationRail
          return Scaffold(
            body: Row(
              children: <Widget>[
                NavigationRail(
                  elevation: 5,
                  minWidth: 100,
                  labelType: NavigationRailLabelType.all,
                  selectedLabelTextStyle: TextStyle(
                      color: Color(0xFF181F4B), fontWeight: FontWeight.bold),
                  unselectedLabelTextStyle: TextStyle(
                      color: Colors.grey[600], fontWeight: FontWeight.bold),
                  backgroundColor: Colors.white,
                  indicatorColor: Color(0xFF181F4B),
                  useIndicator: true,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.home,
                        color: Colors.grey,
                      ),
                      selectedIcon: Icon(Icons.home, color: Colors.white),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.group, color: Colors.grey),
                      selectedIcon: Icon(Icons.group, color: Colors.white),
                      label: Text('Usuarios'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.chat_sharp, color: Colors.grey),
                      selectedIcon: Icon(Icons.chat_sharp, color: Colors.white),
                      label: Text('Comunicación'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person, color: Colors.grey),
                      selectedIcon: Icon(Icons.person, color: Colors.white),
                      label: Text('Perfil'),
                    ),
                  ],
                ),
                Expanded(
                  child: _widgetOptions.elementAt(_selectedIndex),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
