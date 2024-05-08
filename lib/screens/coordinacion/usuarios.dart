import 'dart:convert';

import 'package:educame/screens/coordinacion/nalumno.dart';
import 'package:educame/screens/coordinacion/nmaestro.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UsuariosCoordinacionScreen extends StatefulWidget {
  final int userId;

  const UsuariosCoordinacionScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _UsuariosCoordinacionScreenState createState() =>
      _UsuariosCoordinacionScreenState();
}

class _UsuariosCoordinacionScreenState
    extends State<UsuariosCoordinacionScreen> {
  String _selectedMenu = 'Alumnos';
  String nombreUsuario = ''; // Variable para almacenar el nombre del usuario
  bool isLoading = true;

  final TextEditingController _searchController = TextEditingController();

  String _filtroSeccion = 'Todos';
  String _filtroGrado = 'Todos';

  //List<Alumno> _alumno = [];

  List<Alumno> _alumnos = []; // Lista vacía inicialmente
  List<Tutor> _tutores = []; // Lista vacía inicialmente

  List<Maestro> _maestros = [];

  @override
  void initState() {
    super.initState();
    _fetchAlumnos();
    _fetchTutores();
    _fetchMaestros();
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
                    seccion: item['SECCION'],
                    sexo: item['SEXO'],
                    fechaNacimiento: item['FECHA_NACIMIENTO'].toString(),
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

  void obtenerNombreUsuario() async {
    final url = Uri.parse('https://localhost:44364/api/coordinacion');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> coordinaciones = jsonDecode(response.body);

        for (final coordinacion in coordinaciones) {
          final int idUsuario = coordinacion['ID_USUARIO'];
          final String nombre = coordinacion['NOMBRE'];

          if (idUsuario == widget.userId) {
            setState(() {
              nombreUsuario = nombre; // Guarda el nombre del usuario
              isLoading = false; // Cambia el estado a "no cargando"
            });
            return; // Termina la función una vez que se ha encontrado el nombre del usuario
          }
        }

        // Si no se encuentra el usuario en la tabla de coordinación
        setState(() {
          nombreUsuario = 'Usuario no encontrado';
          isLoading = false; // Cambia el estado a "no cargando"
        });
      } else {
        // Si la solicitud a la API falla
        setState(() {
          nombreUsuario = 'Error en la solicitud';
          isLoading = false; // Cambia el estado a "no cargando"
        });
      }
    } catch (e) {
      // Error al realizar la solicitud HTTP
      setState(() {
        nombreUsuario = 'Error en la solicitud';
        isLoading = false; // Cambia el estado a "no cargando"
      });
    }
  }

  void _mostrarInformacionUsuario(BuildContext context, Alumno alumno) {
    // Encuentra el tutor correspondiente al idTutor del alumno
    Tutor? tutor;
    for (final t in _tutores) {
      if (t.idTutor.toString() == alumno.idTutor) {
        tutor = t;
        break;
      }
    }

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Información del Usuario',
                    style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.0),
                  Text(
                      'Nombre: ${alumno.nombre} ${alumno.apellidop} ${alumno.apellidom}'),
                  Text('Sección: ${alumno.seccion}'),
                  Text('Grado: ${alumno.grado}'),
                  Text('Fecha de Nacimiento: ${alumno.fechaNacimiento}'),
                  Text('Sexo: ${alumno.sexo}'),
                  Text('Dirección: ${alumno.direccion}'),
                  SizedBox(height: 20.0),
                  Text(
                    'Información del Tutor:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  if (tutor != null) ...[
                    Text(
                        'Nombre: ${tutor.nombre} ${tutor.apellidop} ${tutor.apellidom}'),
                    Text('Ocupación: ${tutor.ocupacion}'),
                    Text('Teléfono: ${tutor.telefono}'),
                    Text('Dirección: ${tutor.direccion}'),
                    Text('Fecha de Nacimiento: ${tutor.fechaNacimiento}'),
                    Text('Sexo: ${tutor.sexo}'),
                  ] else
                    Text('Tutor no encontrado'),
                ],
              ),
            ],
          ),
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
                            _mostrarformMaestro(context);
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
            // Filtros
            if (_selectedMenu == 'Alumnos') ...[
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  color: Colors.white,
                ),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceEvenly, // Ajustar el espaciado
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: RoundedDropdownFormField(
                          borderColor: Color(0xFF181F4B),
                          items: ['Todos', 'Secundaria', 'Preparatoria'],
                          hintText: 'Sección',
                          onChanged: (String? value) {
                            setState(() {
                              _filtroSeccion = value ?? 'Todos';
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: RoundedDropdownFormField(
                          borderColor: Color(0xFF181F4B),
                          items: ['Todos', '1', '2', '3'],
                          hintText: 'Grado',
                          onChanged: (String? value) {
                            setState(() {
                              _filtroGrado = value ?? 'Todos';
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            //Lista de usuarios
            Expanded(
              child: Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListView.builder(
                  itemCount: _selectedMenu == 'Alumnos'
                      ? _alumnos.length
                      : _maestros.length,
                  itemBuilder: (context, index) {
                    if (_selectedMenu == 'Alumnos') {
                      final reversedIndex = _alumnos.length - 1 - index;
                      // Filtrar por sección y grado
                      if ((_filtroSeccion == 'Todos' ||
                              _alumnos[reversedIndex].seccion ==
                                  _filtroSeccion) &&
                          (_filtroGrado == 'Todos' ||
                              _alumnos[reversedIndex].grado == _filtroGrado)) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            onTap: () => _mostrarInformacionUsuario(
                                context, _alumnos[reversedIndex]),
                            title: Text(
                              '${_alumnos[reversedIndex].nombre} ${_alumnos[reversedIndex].apellidop} ${_alumnos[reversedIndex].apellidom}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Sección: ${_alumnos[reversedIndex].seccion}'),
                                Text('Grado: ${_alumnos[reversedIndex].grado}'),
                              ],
                            ),
                          ),
                        );
                      } else {
                        // Si no coincide con los filtros, retornar un contenedor vacío
                        return Container();
                      }
                    } else {
                      // Para la sección de maestros
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_maestros[index].nombre}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Sexo: ${_maestros[index].sexo}'),
                                      Text(
                                          'Sección: ${_maestros[index].seccion}'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
            //Buscador
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: TextField(
                // controller: ,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText:
                      'Buscar ${_selectedMenu == 'Alumnos' ? 'alumno' : 'maestro'}',
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
                  if (_selectedMenu == 'Alumnos') {
                    searchAlumnos(value);
                  } else {
                    // Implementa la función de búsqueda para maestros
                    searchMaestros(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
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

  void searchMaestros(String query) {
    setState(() {
      // Restaurar la lista completa de alumnos si la consulta está vacía
      if (query.isEmpty) {
        _fetchMaestros(); // Esto vuelve a cargar la lista completa de alumnos desde tu fuente de datos
      } else {
        // Filtrar los alumnos según la consulta
        _maestros = _maestros.where((maestro) {
          final nombreCompleto = '${maestro.nombre}';
          return nombreCompleto.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
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
      _fetchTutores();
    }
  }

  void _mostrarformMaestro(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        transitionDuration:
            Duration.zero, // Establece la duración de transición como cero
        pageBuilder: (context, animation, secondaryAnimation) => nMaestro(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child, // Establece una transición nula
      ),
    );

    if (result == true) {
      _fetchMaestros();
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
}

/* void main() {
  runApp(MaterialApp(
    home: UsuariosCoordinacionScreen(username: 'example_username'),
  ));
} */

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

class Maestro {
  final int idMaestro;
  final int idUsuario;
  final String nombre;
  final String sexo;
  final String seccion;
  final String fechaNacimiento;

  Maestro({
    required this.idMaestro,
    required this.idUsuario,
    required this.nombre,
    required this.sexo,
    required this.seccion,
    required this.fechaNacimiento,
  });
}

class RoundedDropdownFormField extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final Color borderColor;
  final Function(String?) onChanged;

  RoundedDropdownFormField({
    required this.items,
    required this.hintText,
    required this.borderColor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.0),
        border: Border.all(
          color: borderColor,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonFormField<String>(
          iconSize: 20,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(fontSize: 15)),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
