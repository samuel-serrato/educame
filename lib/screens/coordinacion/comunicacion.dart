import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class ComunicacionCoordinacionScreen extends StatefulWidget {
  final int userId;

  const ComunicacionCoordinacionScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _ComunicacionCoordinacionScreenState createState() =>
      _ComunicacionCoordinacionScreenState();
}

class _ComunicacionCoordinacionScreenState
    extends State<ComunicacionCoordinacionScreen> {
  String nombreUsuario = ''; // Variable para almacenar el nombre del usuario
  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  String _filtroSeccion = 'Todos';
  String _filtroGrado = 'Todos';

  //List<Alumno> _alumno = [];

  List<Alumno> _alumnos = []; // Lista vacía inicialmente
  List<Tutor> _tutores = []; // Lista vacía inicialmente
  List<Coordinacion> _coordinacion = []; // Lista vacía inicialmente
  List<Maestro> _maestros = []; // Lista vacía inicialmente

  String _selectedMenu = 'Avisos';

  List<Aviso> _avisos = [];

  List<Citas> _citas = [
    Citas(
      tipo: 'Personal',
      descripcion: 'Acordar pago',
      emisor: 'Coordinación',
      receptor: 'Daniel',
      fechaCreacion: '10/04/2024',
    ),
    Citas(
      tipo: 'Personal',
      descripcion: 'Malas calificaciones',
      emisor: 'Emiliano Cruz',
      receptor: 'Alumnos',
      fechaCreacion: '08/04/2024',
    ),
    Citas(
      tipo: 'Personal',
      descripcion: 'Acordar pago',
      emisor: 'Coordinación',
      receptor: 'Daniel',
      fechaCreacion: '10/04/2024',
    ),
    Citas(
      tipo: 'Personal',
      descripcion: 'Malas calificaciones',
      emisor: 'Emiliano Cruz',
      receptor: 'Alumnos',
      fechaCreacion: '08/04/2024',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchAlumnos();
    _fetchTutores();
    _fetchAvisos();
    _fetchCoordinacion();
    _fetchMaestros();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
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
            'Comunicación',
            style: TextStyle(color: Colors.white),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Color(0xFFE5E5E5),
        child: Column(
          children: [
            // Menú principal
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
                        _selectedMenu = 'Avisos';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: _selectedMenu == 'Avisos'
                            ? Color.fromARGB(255, 14, 47, 117)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Avisos',
                        style: TextStyle(
                            color: _selectedMenu == 'Avisos'
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMenu = 'Citas';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: _selectedMenu == 'Citas'
                            ? Color.fromARGB(255, 14, 47, 117)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Citas',
                        style: TextStyle(
                            color: _selectedMenu == 'Citas'
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Recuadro botones filtros
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //color: Colors.red,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 14, 47, 117))),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Tipo',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //color: Colors.red,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 14, 47, 117))),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Fecha',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _selectedMenu == 'Avisos'
                ? Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: MediaQuery.of(context)
                              .size
                              .width, // Ancho de la pantalla
                          child: DataTable(
                            columnSpacing: 10,
                            dataRowMaxHeight: 100,
                            dataRowMinHeight: 50,
                            horizontalMargin: 20,
                            columns: [
                              DataColumn(
                                  label: Text('Tipo',
                                      style: TextStyle(fontSize: 12))),
                              DataColumn(
                                  label: Text('Descripción',
                                      style: TextStyle(fontSize: 12))),
                              DataColumn(
                                  label: Text('emisor',
                                      style: TextStyle(fontSize: 12))),
                              DataColumn(
                                  label: Text('Receptor',
                                      style: TextStyle(fontSize: 12))),
                              DataColumn(
                                  label: Text('Fecha',
                                      style: TextStyle(fontSize: 12))),
                            ],
                            rows: _avisos
                                .map(
                                  (aviso) => DataRow(cells: [
                                    DataCell(Text(
                                        aviso.tipo == '1'
                                            ? 'General'
                                            : 'Personal',
                                        style: TextStyle(fontSize: 10))),
                                    DataCell(Text(aviso.descripcion,
                                        style: TextStyle(fontSize: 10))),
                                    DataCell(Text(
                                      getNombreUsuario(
                                          aviso.emisor,
                                          aviso.idMaestro,
                                          _coordinacion,
                                          _maestros),
                                      style: TextStyle(fontSize: 10),
                                    )),
                                    DataCell(Text(aviso.receptor,
                                        style: TextStyle(fontSize: 10))),
                                    DataCell(Text(aviso.fechaCreacion,
                                        style: TextStyle(fontSize: 10))),
                                  ]),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  )
                //ESTÁ SELECCIONADO CITAS
                : Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: MediaQuery.of(context)
                              .size
                              .width, // Ancho de la pantalla
                          child: DataTable(
                            columnSpacing: 10,
                            dataRowMaxHeight: 100,
                            dataRowMinHeight: 50,
                            horizontalMargin: 20,
                            columns: [
                              DataColumn(
                                  label: Text('Tipo',
                                      style: TextStyle(fontSize: 12))),
                              DataColumn(
                                  label: Text('Descripción',
                                      style: TextStyle(fontSize: 12))),
                              DataColumn(
                                  label: Text('emisor',
                                      style: TextStyle(fontSize: 12))),
                              DataColumn(
                                  label: Text('Receptor',
                                      style: TextStyle(fontSize: 12))),
                              DataColumn(
                                  label: Text('Fecha',
                                      style: TextStyle(fontSize: 12))),
                            ],
                            rows: _citas
                                .map(
                                  (citas) => DataRow(cells: [
                                    DataCell(Text(citas.tipo,
                                        style: TextStyle(fontSize: 10))),
                                    DataCell(Text(citas.descripcion,
                                        style: TextStyle(fontSize: 10))),
                                    DataCell(Text(citas.emisor,
                                        style: TextStyle(fontSize: 10))),
                                    DataCell(Text(citas.receptor,
                                        style: TextStyle(fontSize: 10))),
                                    DataCell(Text(citas.fechaCreacion,
                                        style: TextStyle(fontSize: 10))),
                                  ]),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
            // Espacio vacío si no está seleccionado Avisos
            // Botones Inferiores
            // Botones Inferiores
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _selectedMenu == 'Avisos'
                    ? [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFB80000),
                              ),
                            ),
                            onPressed: () {
                              // _dialogAvisoGeneral(context);
                            },
                            child: Text(
                              'Nuevo Aviso General',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFB80000),
                              ),
                            ),
                            onPressed: () {
                              //_dialogAvisoPersonal(context);
                            },
                            child: Text(
                              'Nuevo Aviso Personal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ]
                    : [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFFB80000),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              'Nueva Cita',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ],
              ),
            ),

            // Barra de búsqueda
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: TextField(
                //controller: _searchController,
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

  Future<void> _fetchAlumnos() async {
    try {
      final response =
          await http.get(Uri.parse('https://localhost:44364/api/alumnos'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _alumnos = data
              .map((item) => Alumno(
                  nombre: item['NOMBRE'],
                  apellidop: item['APELLIDO_PATERNO'],
                  apellidom: item['APELLIDO_MATERNO'],
                  seccion: item['SECCION'],
                  grado: item['GRADO'],
                  fechaNacimiento: item['FECHA_NACIMIENTO'].toString(),
                  sexo: item['SEXO'],
                  direccion: item['DIRECCION'],
                  idTutor: item['ID_TUTOR']))
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

  Future<void> _fetchAvisos() async {
    try {
      final response =
          await http.get(Uri.parse('https://localhost:44364/api/avisos'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _avisos = data
              .map((item) => Aviso(
                    tipo: item['ID_TIPO_AVISO'] ?? '',
                    emisor: item['ID_EMISOR'] ?? '',
                    receptor: item['ID_RECEPTOR'] ?? '',
                    descripcion: item['DESCRIPCION'] ?? '',
                    fechaCreacion: item['FECHA_CREACION']?.toString() ?? '',
                    tipoUsuario: item['TIPO_USUARIO'] ?? '',
                    idMaestro: item['ID_MAESTRO'] ?? '',
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

  Future<void> _fetchCoordinacion() async {
    try {
      final response =
          await http.get(Uri.parse('https://localhost:44364/api/coordinacion'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _coordinacion = data
              .map((item) => Coordinacion(
                    idCoordinacion: item['ID_COORDINACION'],
                    nombre: item['NOMBRE'],
                    tipousuario: item['TIPO_USUARIO'],
                    idUsuario: item['ID_USUARIO'],
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

  Future<void> _fetchMaestros() async {
    try {
      final response =
          await http.get(Uri.parse('https://localhost:44364/api/maestros'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _maestros = data
              .map((item) => Maestro(
                  idMaestro: item['ID_MAESTRO'],
                  idUsuario: item['ID_USUARIO'],
                  nombre: item['NOMBRE'],
                  sexo: item['SEXO'],
                  seccion: item['SECCION'],
                  fechaNacimiento: item['FECHA_NACIMIENTO'].toString(),
                  tipoUsuario: item['TIPO_USUARIO']))
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

  String getNombreUsuario(String idUsuario, String idMaestro,
      List<Coordinacion> coordinadores, List<Maestro> maestros) {
    // Si el idMaestro no está vacío, busca en la lista de maestros
    if (idMaestro.isNotEmpty) {
      for (var maestro in maestros) {
        if (maestro.idMaestro.toString() == idMaestro) {
          return 'Profesor: ${maestro.nombre}';
        }
      }
    }

    // Si no, busca en la lista de coordinadores
    for (var coordinador in coordinadores) {
      if (coordinador.idUsuario.toString() == idUsuario) {
        return coordinador.nombre;
      }
    }

    // Si no se encuentra el nombre, devuelve un valor predeterminado
    return 'Usuario Desconocido';
  }

  // Definición de la función searchAlumnos
  void searchAlumnos(String query) {
    setState(() {
      // Restaurar la lista completa de alumnos si la consulta está vacía
      if (query.isEmpty) {
        _fetchAlumnos(); // Esto vuelve a cargar la lista completa de alumnos desde tu fuente de datos
      } else {
        // Filtrar los alumnos según la consulta
        _alumnos = _alumnos.where((alumno) {
          final nombreCompleto =
              '${alumno.nombre} ${alumno.apellidop} ${alumno.apellidom}';
          return nombreCompleto.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }
}

class Aviso {
  final String tipo;
  final String emisor;
  final String receptor;
  final String descripcion;
  final String fechaCreacion;
  final String tipoUsuario;
  final String idMaestro;

  Aviso(
      {required this.tipo,
      required this.emisor,
      required this.receptor,
      required this.descripcion,
      required this.fechaCreacion,
      required this.tipoUsuario,
      required this.idMaestro});
}

class Citas {
  final String tipo;
  final String descripcion;
  final String emisor;
  final String receptor;
  final String fechaCreacion;

  Citas({
    required this.tipo,
    required this.descripcion,
    required this.emisor,
    required this.receptor,
    required this.fechaCreacion,
  });
}

class Alumno {
  final String nombre;
  final String apellidop;
  final String apellidom;
  final String seccion;
  final String grado;
  final String fechaNacimiento;
  final String sexo;
  final String direccion;
  final String idTutor;

  Alumno({
    required this.nombre,
    required this.apellidop,
    required this.apellidom,
    required this.seccion,
    required this.grado,
    required this.fechaNacimiento,
    required this.sexo,
    required this.direccion,
    required this.idTutor,
  });
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

class Coordinacion {
  final int idCoordinacion;
  final String nombre;
  final String tipousuario;
  final int idUsuario;

  Coordinacion(
      {required this.idCoordinacion,
      required this.nombre,
      required this.tipousuario,
      required this.idUsuario});
}

class Maestro {
  final int idMaestro;
  final int idUsuario;
  final String nombre;
  final String sexo;
  final String seccion;
  final String fechaNacimiento;
  final String tipoUsuario;

  Maestro(
      {required this.idMaestro,
      required this.idUsuario,
      required this.nombre,
      required this.sexo,
      required this.seccion,
      required this.fechaNacimiento,
      required this.tipoUsuario});
}
