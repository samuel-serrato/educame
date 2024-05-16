import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListaTutoresScreen extends StatefulWidget {
  const ListaTutoresScreen({Key? key}) : super(key: key);

  @override
  _ListaTutoresScreenState createState() => _ListaTutoresScreenState();
}

class _ListaTutoresScreenState extends State<ListaTutoresScreen> {
  String _selectedMenu = 'Maestros';
  String nombreUsuario = ''; // Variable para almacenar el nombre del usuario
  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  String _filtroSeccion = 'Todos';
  String _filtroGrado = 'Todos';

  List<Tutor> _tutores = [];

  @override
  void initState() {
    super.initState();
    _fetchTutores();
  }

  Future<void> _fetchTutores() async {
    try {
      final response =
          await http.get(Uri.parse('https://localhost:44364/api/tutores'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _tutores = data
              .map((item) => Tutor(
                    idTutor: item['ID_TUTOR'],
                    idUsuario: item['ID_USUARIO'],
                    nombre: item['NOMBRE'],
                    apellidop: item['APELLIDO_PATERNO'],
                    apellidom: item['APELLIDO_MATERNO'],
                    ocupacion: item['OCUPACION'],
                    telefono: item['TELEFONO'],
                    direccion: item['DIRECCION'],
                    fechaNacimiento: item['FECHA_NACIMIENTO'].toString(),
                    sexo: item['SEXO'],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 28, 100, 163), Color(0xFF181F4B)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
        title: Text(
          'Seleccionar Tutor',
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Color(0xFFE5E5E5),
        child: Column(
          children: [
            // Lista de maestros
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListView.builder(
                  itemCount: _tutores.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop({
                          'id': _tutores[index].idTutor,
                          'nombre': _tutores[index].nombre,
                        });
                      },
                      child: Container(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_tutores[index].nombre} ${_tutores[index].apellidop} ${_tutores[index].apellidom}',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Sexo: ${_tutores[index].sexo}'),
                                      Text(
                                          'Ocupación: ${_tutores[index].ocupacion}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            // Buscador
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Buscar maestro',
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                ),
                onChanged: (value) {
                  searchMaestros(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void searchMaestros(String query) {
    setState(() {
      // Restaurar la lista completa de maestros si la consulta está vacía
      if (query.isEmpty) {
        _fetchTutores(); // Esto vuelve a cargar la lista completa de maestros desde tu fuente de datos
      } else {
        // Filtrar los maestros según la consulta
        _tutores = _tutores.where((maestro) {
          final nombreCompleto = '${maestro.nombre}';
          return nombreCompleto.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }
}

class Tutor {
  final int idTutor;
  final int idUsuario;
  final String nombre;
  final String apellidop;
  final String apellidom;
  final String ocupacion;
  final String telefono;
  final String direccion;
  final String fechaNacimiento;
  final String sexo;

  Tutor({
    required this.idTutor,
    required this.idUsuario,
    required this.nombre,
    required this.apellidop,
    required this.apellidom,
    required this.ocupacion,
    required this.telefono,
    required this.direccion,
    required this.fechaNacimiento,
    required this.sexo,
  });
}
