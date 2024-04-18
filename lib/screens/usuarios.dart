import 'dart:convert';

import 'package:educame/screens/nalumno.dart';
import 'package:educame/screens/nmaestro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsuariosScreen extends StatefulWidget {
  final String username;

  const UsuariosScreen({Key? key, required this.username}) : super(key: key);

  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  String _selectedMenu = 'Alumnos';

  //List<Alumno> _alumno = [];

  List<Usuario> _usuarios = []; // Lista vacía inicialmente

  List<Maestro> _maestro = [
    Maestro(
      nombre: 'Maestro 1',
      seccion: 'A',
    ),
    Maestro(nombre: 'Maestro 2', seccion: 'B'),
    Maestro(nombre: 'Maestro 3', seccion: 'C'),
  ];

  @override
  void initState() {
    super.initState();
    _fetchAlumnos();
  }

  Future<void> _fetchAlumnos() async {
    try {
      final response =
          await http.get(Uri.parse('https://localhost:44364/api/alumnos'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _usuarios = data
              .map((item) => Usuario(
                    nombre: item['NOMBRE'],
                    apellidop: item['APELLIDO_PATERNO'],
                    apellidom: item['APELLIDO_MATERNO'],
                    seccion: item['SECCION'],
                    grado: item['GRADO'],
                  ))
              .toList();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print('Error: $error');
      // Manejar el error como prefieras, por ejemplo, mostrar un mensaje al usuario
    }
  }

  void _mostrarInformacionUsuario(BuildContext context, Usuario usuario) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: true,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                controller: scrollController,
                children: [
                  Text(
                    'Información del Usuario',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                      'Nombre: ${usuario.nombre} ${usuario.apellidop} ${usuario.apellidom}'),
                  Text('Sección: ${usuario.seccion}'),
                  Text('Grado: ${usuario.grado}'),
                  // Agrega aquí más información del usuario si es necesario
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Colors.blue,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 28, 100, 163), Color(0xFF181F4B)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Center(
          child: Text(
            'Usuarios',
            style: TextStyle(color: Colors.white),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Color(0xFFE5E5E5),
        child: Column(
          children: [
            //Menú principal
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMenu = 'Alumnos';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: _selectedMenu == 'Alumnos'
                            ? Color.fromARGB(255, 14, 47, 117)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Alumnos',
                        style: TextStyle(
                            color: _selectedMenu == 'Alumnos'
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMenu = 'Maestros';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: _selectedMenu == 'Maestros'
                            ? Color.fromARGB(255, 14, 47, 117)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Maestros',
                        style: TextStyle(
                            color: _selectedMenu == 'Maestros'
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Recuadro texto y botón Agregar
            Container(
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              decoration: BoxDecoration(),
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      _selectedMenu,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFB80000))),
                        onPressed: () {
                          if (_selectedMenu == 'Alumnos') {
                            _mostrarformAlumno(context);
                          } else if (_selectedMenu == 'Maestros') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => nMaestro()),
                            );
                          }
                        },
                        child: Text(
                          'Agregar ${_selectedMenu == 'Alumnos' ? 'Alumno' : 'Maestro'}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Filtros
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilterPill(text: 'Todos', isSelected: true),
                  FilterPill(text: 'Sección', isSelected: false),
                  FilterPill(text: 'Grado', isSelected: false),
                ],
              ),
            ),
            //Lista de alumnos
            _selectedMenu == 'Alumnos'
                ? Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListView.builder(
                        itemCount: _usuarios.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () => _mostrarInformacionUsuario(
                                context, _usuarios[index]),
                            title: Text(
                              '${_usuarios[index].nombre} ${_usuarios[index].apellidop} ${_usuarios[index].apellidom}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Sección: ${_usuarios[index].seccion}'),
                                Text('Grado: ${_usuarios[index].grado}'),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
                //Lista de maestros
                : Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: ListView.builder(
                        itemCount: _maestro.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${_maestro[index].nombre}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Sección: ${_maestro[index].seccion}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
            //Filtros
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: const TextField(
                // controller: ,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Buscar alumno',
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors
                          .black, // Cambia el color del borde según sea necesario
                      width:
                          2.0, // Cambia el grosor del borde según sea necesario
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarformAlumno(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        transitionDuration:
            Duration.zero, // Establece la duración de transición como cero
        pageBuilder: (context, animation, secondaryAnimation) => nAlumno(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child, // Establece una transición nula
      ),
    );

    if (result == true) {
      _fetchAlumnos();
    }
  }
}

class FilterPill extends StatelessWidget {
  final String text;
  final bool isSelected;

  const FilterPill({Key? key, required this.text, this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        color:
            isSelected ? Color.fromARGB(255, 14, 47, 117) : Colors.transparent,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(
        text,
        style: TextStyle(color: isSelected ? Colors.white : Colors.black),
      ),
    );
  }

  void _mostrarInformacionUsuario(BuildContext context, Usuario usuario) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: true,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                controller: scrollController,
                children: [
                  Text(
                    'Información del Usuario',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                      'Nombre: ${usuario.nombre} ${usuario.apellidop} ${usuario.apellidom}'),
                  Text('Sección: ${usuario.seccion}'),
                  Text('Grado: ${usuario.grado}'),
                  // Agrega aquí más información del usuario si es necesario
                ],
              ),
            );
          },
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UsuariosScreen(username: 'example_username'),
  ));
}

class Usuario {
  final String nombre;
  final String apellidop;
  final String apellidom;
  final String seccion;
  final String grado;

  Usuario({
    required this.nombre,
    required this.apellidop,
    required this.apellidom,
    required this.seccion,
    required this.grado,
  });
}

class Maestro {
  final String nombre;
  final String seccion;

  Maestro({required this.nombre, required this.seccion});
}
