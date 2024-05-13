import 'dart:convert';

import 'package:educame/screens/coordinacion/nalumno.dart';
import 'package:flutter/material.dart';
//import 'package:educame/screens/miCuenta.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Importa el paquete de internacionalización para formatear la fecha
import 'package:intl/date_symbol_data_local.dart'; // Importa este paquete para inicializar los símbolos de fecha localmente
import 'package:url_launcher/url_launcher.dart';

// Antes de usar DateFormat, asegúrate de inicializar los símbolos de fecha localmente

//import 'nexp_screen.dart';
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

class AvisosTutorScreen extends StatefulWidget {
  //String user;
  final String nombre;
  final String userType;
  final int userId; // Agregar esta línea

  AvisosTutorScreen(
      {super.key,
      required this.userId,
      required this.userType,
      required this.nombre});

  @override
  State<AvisosTutorScreen> createState() => _AvisosTutorScreenState();
}

class _AvisosTutorScreenState extends State<AvisosTutorScreen> {
  String obtenerTipoUsuario(int userId) {
    for (Usuario usuario in listausuarios) {
      if (usuario.idUsuario.toString() == userId.toString()) {
        return usuario.tipoUsuario;
      }
    }
    print('Tipo de usuario no encontrado para el ID: $userId');
    return 'Tipo de usuario no encontrado';
  }

  final int _selectedIndex = 0;
  bool usuarioEncontrado =
      false; // Variable para controlar si el usuario ya fue encontrado

  String nombreUsuario = ''; // Variable para almacenar el nombre del usuario
  List<Usuario> listausuarios = [];
  bool isLoading = true;
  bool showErrorDialog = false;
  List<Alumno> listaAlumnos = [];
  int? idTutorEncontrado; // Variable para almacenar el ID_TUTOR encontrado
  List<Aviso> _avisos = [];
  List<Coordinacion> _coordinacion = []; // Lista vacía inicialmente
  List<Maestro> _maestros = []; // Lista vacía inicialmente

  @override
  void initState() {
    super.initState();
    //print('Inicializando pantalla de inicio...'); // Agregar este print

    obtenerusuarios();
    //userId = widget.userId;
    nombreUsuario = widget.nombre;
    obtenerAlumnos();
    obtenerTutores();
    print(widget.userType);
    print(widget.userId);
    _fetchAvisos();
    _fetchCoordinacion();
    _fetchMaestros();
  }

  void obtenerAlumnos() async {
    try {
      final response =
          await http.get(Uri.parse('https://localhost:44364/api/alumnos'));
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        setState(() {
          listaAlumnos = (parsedJson as List)
              .map((item) => Alumno(
                    nombre: item['NOMBRE'],
                    apellidop: item['APELLIDO_PATERNO'],
                    apellidom: item['APELLIDO_MATERNO'],
                    fechaNacimiento: item['FECHA_NACIMIENTO'].toString(),
                    sexo: item['SEXO'],
                    direccion: item['DIRECCION'],
                    seccion: item['SECCION'],
                    grado: item['GRADO'],
                    idTutor: item['ID_TUTOR'],
                  ))
              .toList();
        });
      } else {
        // Manejar el error si la solicitud no es exitosa
      }
    } catch (e) {
      // Manejar el error si ocurre una excepción
    }
  }

  void obtenerTutores() async {
    try {
      final response =
          await http.get(Uri.parse('https://localhost:44364/api/tutores'));
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        List<Tutor> tutores = (parsedJson as List)
            .map((tutorJson) => Tutor.fromJson(tutorJson))
            .toList();

        /* print('Lista de tutores:');
        for (var tutor in tutores) {
          print(
              'ID_TUTOR: ${tutor.idTutor}, ID_USUARIO: ${tutor.idUsuario}, Nombre: ${tutor.nombre}');
        } */
      } else {
        //print('Error: ${response.statusCode}');
      }
    } catch (e) {
      //print('Error: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
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
            'Avisos',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: content(),
      ),
    );
  }

  Widget content() {
    String tipoUsuario = obtenerTipoUsuario(widget.userId);
    print('Tipo de usuario: $tipoUsuario');

    buscarEnEndpoint(
        tipoUsuario, widget.userId); // Llamada al método buscarEnEndpoint

    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [mostrarAlumnos(), Expanded(child: avisosGenerales())],
        ),
      ),
    );
  }

  Widget mostrarAlumnos() {
    // Filtrar la lista de alumnos por el ID_TUTOR encontrado
    List<Alumno> alumnosFiltrados = listaAlumnos
        .where((alumno) => alumno.idTutor == idTutorEncontrado.toString())
        .toList();

    print(
        'Imprimiendo ID_TUTOR del usuario actual desde clase mostrar alumno: $idTutorEncontrado');
    print(
        'Imprimiendo lista alumnos filtrados desde clase mostrar alumno: $alumnosFiltrados');

    return SizedBox(
      // Envuelve SingleChildScrollView dentro de un SizedBox
      height: MediaQuery.of(context).size.height *
          0.3, // Establece una altura específica
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Seleccionar Alumnos',
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF444444),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: alumnosFiltrados.map((alumno) {
                  return buildCard(
                    icon: Icons.person,
                    text: '${alumno.nombre} ${alumno.apellidop}',
                    onPressed: () {
                      // Acción al presionar la tarjeta del alumno
                      mostrarDetallesAlumno(context, alumno);
                    },
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void mostrarDetallesAlumno(BuildContext context, Alumno alumno) {
    // Filtrar los avisos personales del alumno seleccionado que coincidan con el idUsuario
    List<Aviso> avisosPersonales = _avisos
        .where((aviso) => aviso.receptor == widget.userId.toString())
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallesAlumnoScreen(
          alumno: alumno,
          avisosPersonales: avisosPersonales,
          coordinacion: _coordinacion, // Pasando la lista _coordinacion
          maestros: _maestros, // Pasando la lista _maestros
        ),
      ),
    );
  }

  /* void mostrarInformacionAlumno(BuildContext context, Alumno alumno) {
    // Obtener los avisos personales del alumno seleccionado
    List<Aviso> avisosPersonales =
        _avisos.where((aviso) => aviso.receptor == alumno.idTutor).toList();

    print('Número de avisos personales: ${avisosPersonales.length}');
    print('Número de avisos personales filtrados: ${avisosPersonales.length}');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetallesAlumnoScreen(
          alumno: alumno,
          avisosPersonales: avisosPersonales,
        ),
      ),
    );
  } */

  Widget buildCard(
      {required IconData icon,
      required String text,
      required Function onPressed}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width *
          0.95, // Establece una altura específica
      child: Card(
        surfaceTintColor: Colors.white,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: InkWell(
          onTap: () {
            onPressed();
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.start, // Alinea los elementos al extremo
              children: [
                // Icono a la izquierda
                Icon(
                  icon,
                  size: 40,
                  color: Color.fromARGB(255, 14, 47, 117),
                ),
                SizedBox(width: 20),
                // Texto a la derecha
                Flexible(
                  // Utiliza Flexible para que el texto se ajuste correctamente
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.right, // Alinea el texto a la derecha
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void obtenerusuarios() async {
    //print('Obteniendo usuarios...');
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await http.get(Uri.parse('https://localhost:44364/api/usuarios'));
      //print('Respuesta recibida: ${response.statusCode}'); // Agregar esta línea
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);
        //print('JSON parseado: $parsedJson'); // Agregar esta línea

        setState(() {
          listausuarios = (parsedJson as List)
              .map((item) => Usuario(
                    item['ID_USUARIO'],
                    item['USUARIO'],
                    item['PASSWORD'],
                    item['ID_TIPO_USUARIO'],
                  ))
              .toList();
          isLoading = false;

          // Imprimir los usuarios
        });
      } else {
        setState(() {
          showErrorDialog = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        showErrorDialog = true;
        isLoading = false;
      });
    }
  }

  void buscarEnEndpoint(String tipoUsuario, int userId) async {
    if (!usuarioEncontrado) {
      // Verifica si el usuario ya fue encontrado
      int? tipoUsuarioInt = int.tryParse(tipoUsuario);
      if (tipoUsuarioInt != null) {
        String endpoint;
        switch (tipoUsuarioInt) {
          case 1:
            endpoint = 'https://localhost:44364/api/coordinacion';
            break;
          case 2:
            endpoint = 'https://localhost:44364/api/tutores';
            break;
          case 3:
            endpoint = 'https://localhost:44364/api/maestros';
            break;
          default:
            print('Tipo de usuario no reconocido');
            return;
        }
        try {
          final response = await http.get(Uri.parse(endpoint));
          if (response.statusCode == 200) {
            final parsedJson = json.decode(response.body);
            if (parsedJson is List) {
              for (var item in parsedJson) {
                if (item['ID_USUARIO'] == userId) {
                  print('Usuario encontrado en la tabla de tutores');
                  print('ID_TUTOR: ${item['ID_TUTOR']}');
                  setState(() {
                    nombreUsuario = item['NOMBRE'];
                  });
                  usuarioEncontrado =
                      true; // Marca que el usuario ha sido encontrado
                  idTutorEncontrado =
                      item['ID_TUTOR']; // Guarda el ID_TUTOR encontrado

                  return; // Termina la función una vez que se encuentra el usuario
                }
              }
              print(
                  'Usuario con ID $userId no encontrado en la tabla de tutores');
            } else {
              print('Error: La respuesta no es una lista');
            }
          } else {
            print(
                'Error al obtener datos del servidor: ${response.statusCode}');
          }
        } catch (e) {
          print('Error al realizar la solicitud: $e');
        }
      } else {
        print('Tipo de usuario no válido');
      }
    }
  }

  Widget avisosGenerales() {
    // Filtrar la lista de avisos por tipo igual a 1
    List<Aviso> avisosFiltrados =
        _avisos.where((aviso) => aviso.tipo == '1').toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 20, right: 10),
          child: Text(
            'Avisos Generales',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              //color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(5),
            child: ListView.builder(
              shrinkWrap:
                  true, // Esto permite que el ListView se ajuste a su contenido
              itemCount: avisosFiltrados.length,
              itemBuilder: (context, index) {
                Aviso aviso = avisosFiltrados[index];
                return CardItem(
                  title: aviso.descripcion,
                  subtitle:
                      'Emisor: ${getNombreUsuario(aviso.emisor, aviso.idMaestro, _coordinacion, _maestros)}\nFecha de creación: ${aviso.fechaCreacion}',
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class Usuario {
  final int idUsuario;
  final String user;
  final String pass;
  final String tipoUsuario;

  Usuario(this.idUsuario, this.user, this.pass, this.tipoUsuario);
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

  Tutor({required this.idTutor, required this.nombre, required this.idUsuario});
  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      idTutor: json['ID_TUTOR'],
      idUsuario: json['ID_USUARIO'],
      nombre: json['NOMBRE'],
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final String subtitle;

  CardItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20), // Ajusta el radio según sea necesario
      ),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 3,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
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

class DetallesAlumnoScreen extends StatelessWidget {
  final Alumno alumno;
  final List<Aviso> avisosPersonales;
  final List<Coordinacion> coordinacion;
  final List<Maestro> maestros;

  DetallesAlumnoScreen({
    required this.alumno,
    required this.avisosPersonales,
    required this.coordinacion,
    required this.maestros,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white), // Cambia el color de la flecha hacia atrás
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
          'Avisos Personales',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Avisos Personales de ${alumno.nombre}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: avisosPersonales.length,
                itemBuilder: (context, index) {
                  Aviso aviso = avisosPersonales[index];
                  return CardItem(
                    title: aviso.descripcion,
                    subtitle:
                        'Emisor: ${getNombreUsuario(aviso.emisor, aviso.idMaestro, coordinacion, maestros)}\nFecha de creación: ${aviso.fechaCreacion}',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
