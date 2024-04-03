import 'package:flutter/material.dart';

class UsuariosScreen extends StatefulWidget {
  final String username;

  const UsuariosScreen({Key? key, required this.username}) : super(key: key);

  @override
  _UsuariosScreenState createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  String _selectedMenu = 'Alumnos';

  List<Alumno> _alumno = [
    Alumno(nombre: 'Juan Hernandez Benitez', seccion: 'Primaria', grado: '10'),
    Alumno(
        nombre: 'María Becerra Gutierrez', seccion: 'Secundaria', grado: '11'),
    Alumno(nombre: 'Pedro Montes Garrido', seccion: 'Primaria', grado: '12'),
  ];

  List<Maestro> _maestro = [
    Maestro(
      nombre: 'Maestro 1',
      seccion: 'A',
    ),
    Maestro(nombre: 'Maestro 2', seccion: 'B'),
    Maestro(nombre: 'Maestro 3', seccion: 'C'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 28, 100, 163), Color(0xFF181F4B)],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: Text(
                'Usuarios',
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Colors.transparent,
          ),
        ),
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
                        onPressed: () {},
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
                        itemCount: _alumno.length,
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
                                        '${_alumno[index].nombre}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              'Sección: ${_alumno[index].seccion}'),
                                          Text(
                                              'Grado: ${_alumno[index].grado}'),
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
                    hintText: 'Buscar alumno', hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                   border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black, // Cambia el color del borde según sea necesario
                    width: 2.0, // Cambia el grosor del borde según sea necesario
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
}

void main() {
  runApp(MaterialApp(
    home: UsuariosScreen(username: 'example_username'),
  ));
}

class Alumno {
  final String nombre;
  final String seccion;
  final String grado;

  Alumno({required this.nombre, required this.seccion, required this.grado});
}

class Maestro {
  final String nombre;
  final String seccion;

  Maestro({required this.nombre, required this.seccion});
}
