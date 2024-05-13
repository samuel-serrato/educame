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

class HomeTutorScreen extends StatefulWidget {
  //String user;
  final String nombre;
  final String userType;
  final int userId; // Agregar esta línea

  HomeTutorScreen(
      {super.key,
      required this.userId,
      required this.userType,
      required this.nombre});

  @override
  State<HomeTutorScreen> createState() => _HomeTutorScreenState();
}

class _HomeTutorScreenState extends State<HomeTutorScreen> {
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

  @override
  Widget build(BuildContext context) {
    //_getUser();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(body: content())),
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
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: floatingCard(),
            ),
            Positioned(
              top: 160,
              left: 0,
              right: 0,
              child: carrouselContainer(context),
            ),
            Positioned(
              top: 350,
              left: 10,
              right: 10,
              child: mostrarAlumnos(),
            ),
          ],
        ),
      ),
    );
  }

  /* Widget content1() {
    
  } */
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
          0.5, // Establece una altura específica
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Gestión de Alumnos',
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
                      mostrarInformacionAlumno(context, alumno);
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

  void mostrarInformacionAlumno(BuildContext context, Alumno alumno) {
    // Verificar si alumno.fechaNacimiento es de tipo DateTime
    DateTime fechaNacimientoDateTime;
    if (alumno.fechaNacimiento is DateTime) {
      fechaNacimientoDateTime = alumno.fechaNacimiento as DateTime;
    } else if (alumno.fechaNacimiento is String) {
      // Convertir la fecha de nacimiento de String a DateTime si es necesario
      fechaNacimientoDateTime = DateTime.parse(alumno.fechaNacimiento);
    } else {
      // Manejar el caso en que el tipo no sea ni DateTime ni String
      // Aquí puedes lanzar una excepción, mostrar un mensaje de error, o manejarlo según tus necesidades
      return;
    }

    // Formatear la fecha de nacimiento
    String fechaNacimiento =
        DateFormat('dd/MM/yyyy').format(fechaNacimientoDateTime);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width *
                0.8, // Ancho del 80% de la pantalla
            height: MediaQuery.of(context).size.height *
                0.7, // Ancho del 80% de la pantalla
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Container(
                        height: 180, // Altura del contenedor decorativo
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 28, 100, 163),
                              Color(0xFF181F4B)
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              // Puedes personalizar el avatar según tus necesidades
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: Color(0xFF181F4B),
                              ),
                              backgroundColor:
                                  Colors.white, // Color de fondo del avatar
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 80),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Sección: ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(
                                alumno.seccion,
                                style: TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Grado: ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(
                                alumno.grado,
                                style: TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Fecha de nacimiento: ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(
                                fechaNacimiento,
                                style: TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Sexo: ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(
                                alumno.sexo,
                                style: TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Dirección: ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  )),
                              Text(
                                alumno.direccion,
                                style: TextStyle(fontSize: 14),
                              )
                            ],
                          ),
                          // Añade más información si es necesario
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 150,
                  child: Container(
                    height: 50, // Altura del contenedor blanco
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.5), // Color de la sombra
                          spreadRadius: 5, // Radio de propagación de la sombra
                          blurRadius: 7, // Radio de desenfoque de la sombra
                          offset: Offset(
                              0, 3), // Desplazamiento de la sombra en x e y
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${alumno.nombre} ${alumno.apellidop} ${alumno.apellidom}",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                        Text('Alumno')
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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

  Widget floatingCard() {
    return Material(
      elevation: 20,
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(100), bottomRight: Radius.circular(100)),
      child: SizedBox(
        width: 420,
        height: 250,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 28, 100, 163), Color(0xFF181F4B)],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(60),
                bottomRight: Radius.circular(60)),
          ),
          child: Column(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 80), child: bienvenida()),
            ],
          ),
        ),
      ),
    );
  }

  Widget bienvenida() {
    String userType = obtenerTipoUsuario(widget.userId);
    String greeting = '';
    if (userType == '3') {
      greeting = 'Hola, Maestro';
    } else {
      greeting = 'Hola, $nombreUsuario';
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Bienvenido',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20, bottom: 20),
          child: FloatingActionButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.white,
            child: Image.asset(
              'assets/logo_soc.png', // Ruta de tu imagen
              width: 40, // Ancho de la imagen
              height: 40, // Alto de la imagen
              fit: BoxFit.cover, // Ajuste de la imagen
            ),
            onPressed: () {
              const String url = 'https://www.institutosocrates.mx';
              launchUrl(Uri.parse(url));
            },
          ),
        ),
      ],
    );
  }

  Widget carrouselContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          // Primer Card con un tamaño específico
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width * 0.6,
            child: Card(
              surfaceTintColor: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'La educación no crea al hombre, le ayuda a crearse a sí mismo',
                      style: TextStyle(fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Segundo Card expandido para ocupar el resto del espacio
          Expanded(
            child: Card(
              surfaceTintColor: Colors.white,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Alinea los elementos al centro verticalmente
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Alinea los elementos al centro horizontalmente
                  children: [
                    // Día de la semana en letra
                    Text(
                      DateFormat('EEE', 'es')
                          .format(DateTime.now())
                          .toUpperCase(), // Especifica 'es' para español
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.red,
                      ),
                    ),
                    // Número del día en grande
                    Text(
                      DateFormat('dd').format(DateTime.now()),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Nombre del mes
                    Text(
                      DateFormat('MMM', 'es')
                          .format(DateTime.now())
                          .toUpperCase(), // Especifica 'es' para español
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget qActions() {
    return Container(
      alignment: Alignment.center,
      //color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Text(
            "Gestion de Alumnos",
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF444444),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 80,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => nAlumno()),
                );
              },
              style: ElevatedButton.styleFrom(
                surfaceTintColor: Colors.white,
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                backgroundColor: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 16, bottom: 16, left: 3),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      width: 50,
                      height: 50,
                      child: const SizedBox(
                        child: Center(
                            child: Icon(Icons.person_add,
                                size: 40,
                                color: Color.fromARGB(255, 14, 47, 117))),
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Text(
                      "Agregar Alumno",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 20), // Añadir espacio entre los botones
          // Segundo botón
          SizedBox(
            height: 80,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                surfaceTintColor: Colors.white,
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                backgroundColor: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 16, bottom: 16, left: 3),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      width: 50,
                      height: 50,
                      child: const SizedBox(
                        child: Center(
                            child: Icon(Icons.co_present_rounded,
                                size: 40,
                                color: Color.fromARGB(255, 14, 47, 117))),
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Text(
                      "Agregar Maestro",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20), // Añadir espacio entre los botones
          // Tercer botón
          SizedBox(
            height: 80,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                surfaceTintColor: Colors.white,
                elevation: 10,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                backgroundColor: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 16, right: 16, bottom: 16, left: 3),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      width: 50,
                      height: 50,
                      child: const SizedBox(
                        child: Center(
                            child: Icon(Icons.message,
                                size: 40,
                                color: Color.fromARGB(255, 14, 47, 117))),
                      ),
                    ),
                    const SizedBox(width: 30),
                    const Text(
                      "Aviso General",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
