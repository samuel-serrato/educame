import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:educame/screens/npersona.dart';
//import '../widgets/CardUserWidget.dart';
//import 'nusuario.dart';
import 'dart:async';
import 'dart:io';

class PersonasScreen extends StatefulWidget {
  final String username; // Agregar esta línea
  const PersonasScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<PersonasScreen> createState() => _PersonasScreenState();
}

class _PersonasScreenState extends State<PersonasScreen> {
  late Timer timer;
  int selectedIndex = 0; // Agrega esta línea
  List<Usuario> listausuarios = [];
  List<Persona> listapersonas = [];
  bool isLoading = true;
  bool showErrorDialog = false;
  String username = '';
  String nombre = '';
  String formattedDate =
      DateFormat('EEEE, d MMMM yyyy', 'es').format(DateTime.now());
  String formattedDateTime = DateFormat('h:mm:ss a').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    obtenerusuarios();
    obtenerPersonas();
    username = widget.username;
    //nombre = buscarNombreUsuario(username);

    // Actualizar la fecha y la hora cada segundo
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        formattedDate =
            DateFormat('EEEE, d MMMM yyyy', 'es').format(DateTime.now());
        formattedDateTime = DateFormat('h:mm:ss a').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    // Cancelar el temporizador en el método dispose()
    timer.cancel();
    super.dispose();
  }

  String buscarNombreUsuario(String usuario) {
    for (Usuario usuarioObjeto in listausuarios) {
      if (usuarioObjeto.user == usuario) {
        return usuarioObjeto.nombre;
      }
    }
    return ''; // Retorna una cadena vacía si no se encuentra el nombre
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      appBar: isMobile
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Text(''),
              toolbarHeight: 0,
            )
          : null,
      body: Stack(
        children: [
          content(isMobile),
          if (isMobile) floatingActionButton(),
        ],
      ),
    );
  }

  Widget floatingActionButton() {
    return Positioned(
      bottom: 16.0,
      right: 16.0,
      child: FloatingActionButton(
        onPressed: () {
          _mostrarFormulariousuarios(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget content(bool isMobile) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (!isLoading && showErrorDialog) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Error al obtener datos',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showErrorDialog = false;
                });
                obtenerusuarios();
                //obtenerPersonas();
              },
              child: const Text('Recargar', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              flex: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //color: Colors.green, // Cambia el color a tu preferencia
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        fechayHora(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    /* child: CardUserWidget(
                      username: buscarNombreUsuario(username),
                    ), */
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                //color: Colors.purple, // Cambia el color a tu preferencia
                child: textoyBoton(isMobile),
              ),
            ),
            Expanded(
              flex: 80,
              child: Stack(
                children: [ Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: isDesktop ? tabla() : tablaMobile(),
                ),]
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget cardUser() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(
                5, 5), // Cambia la DIRECCION de la sombra según tus necesidades
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(right: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.account_circle),
          SizedBox(width: 8),
          Text(
            buscarNombreUsuario(username),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget fechayHora() {
    String formattedDate =
        DateFormat('EEEE, d MMMM yyyy', 'es').format(DateTime.now());
    formattedDate =
        capitalizeFirstLetter(formattedDate); // Capitalizar la primera letra

    String formattedDateTime =
        DateFormat('h:mm:ss a', 'es').format(DateTime.now());

    return FittedBox(
      fit: BoxFit.contain,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedDate,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          Text(
            formattedDateTime,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    return text.replaceFirst(text[0], text[0].toUpperCase());
  }

  Widget textoyBoton(bool isMobile) {
    if (isMobile) {
      return Container(
        alignment: Alignment.centerLeft,
        child: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Personas',
            style: TextStyle(
              //color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Personas',
                  style: TextStyle(
                    //color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: ElevatedButton(
                  onPressed: () {
                    _mostrarFormulariousuarios(context);
                  },
                  style: ButtonStyle(
                    surfaceTintColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Color(0xFF001D82),
                          width: 2,
                        ),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 10),
                    child: Text(
                      'Nueva Persona',
                      style: TextStyle(
                        color: Color(0xFF001D82),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget tablaMobile() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                columnSpacing: 40,
                dataRowHeight: 70,
                columns: [
                  DataColumn(
                      label: Text('Nombre',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Ocupación',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Edad',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: listapersonas.map((p) {
                  return DataRow(cells: [
                    DataCell(Text(p.nombre)),
                    DataCell(Text(p.ocupacion)),
                    DataCell(Text(p.edad)),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget tabla() {
    double fontsizecell = 12;
    final dateFormat = DateFormat('h:mm:ss a');
    return Padding(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                columnSpacing: 10,
                columns: const [
                  DataColumn(
                      label: Text('Nombre',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Dirección',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Edad',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Teléfono',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Ocupación',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Municipio',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Sexo',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Fecha de Creación',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: listapersonas.map((p) {
                  return DataRow(cells: [
                    DataCell(Text(p.nombre, style: TextStyle(fontSize: fontsizecell),)),
                    DataCell(Text(p.direccion, style: TextStyle(fontSize: fontsizecell),)),
                    DataCell(Text(p.edad, style: TextStyle(fontSize: fontsizecell),)),
                    DataCell(Text(p.telefono, style: TextStyle(fontSize: fontsizecell),)),
                    DataCell(Text(p.ocupacion, style: TextStyle(fontSize: fontsizecell),)),
                    DataCell(Text(p.municipio, style: TextStyle(fontSize: fontsizecell),)),
                    DataCell(Text(p.sexo, style: TextStyle(fontSize: fontsizecell),)),
                    DataCell(Text(dateFormat.format(DateTime.parse(p.fechaCreacion)), style: TextStyle(fontSize: fontsizecell),)),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  /* Future<List<Usuario>> fetchusuarios() async {
    try {
      final response =
          await http.get(Uri.parse('https://localhost:44305/api/usuarios'));

      if (response.statusCode == 200) {
        final List<dynamic> usuariosJson = jsonDecode(response.body);
        final List<Usuario> usuarios = usuariosJson.map((us) {
          final user = us['USUARIO'].toString();
          final nombre = us['NOMBRE'].toString();
          final pass = us['PASSWORD'].toString();
          return Usuario(nombre, user, pass);
        }).toList();

        return usuarios;
      } else {
        throw Exception('Error al obtener la lista de usuarios');
      }
    } catch (e) {
      throw Exception('Error al obtener la lista de usuarios');
    }
  } */

  void obtenerusuarios() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('https://localhost:44305/api/usuarios'));
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);

        setState(() {
          listausuarios = (parsedJson as List)
              .map((item) =>
                  Usuario(item['NOMBRE'], item['USUARIO'], item['PASSWORD']))
              .toList();
          isLoading = false;
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

  void _mostrarFormulariousuarios(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        transitionDuration:
            Duration.zero, // Establece la duración de transición como cero
        pageBuilder: (context, animation, secondaryAnimation) =>
            NPersona(nombre: buscarNombreUsuario(username)),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child, // Establece una transición nula
      ),
    );

    if (result == true) {
      obtenerusuarios();
      obtenerPersonas();
    }
  }

//PERSONAS

  Future<List<Persona>> fetchPersonas() async {
    try {
      final response =
          await http.get(Uri.parse('https://localhost:44305/api/personas'));

      if (response.statusCode == 200) {
        final List<dynamic> personasJson = jsonDecode(response.body);
        final List<Persona> personas = personasJson.map((p) {
          final idPersona = p['ID_PERSONA'] as int;
          final nombre = p['NOMBRE'].toString();
          final apellidoP = p['APELLIDO_P'].toString();
          final apellidoM = p['APELLIDO_M'].toString();
          final direccion = p['DIRECCION'].toString();
          final estado = p['ESTADO'].toString();
          final municipio = p['MUNICIPIO'].toString();
          final fechaNacimiento = p['FECHA_NACIMIENTO'].toString();
          final edad = p['EDAD'].toString();
          final telefono = p['TELEFONO'].toString();
          final email = p['EMAIL'].toString();
          final sexo = p['SEXO'].toString();
          final ocupacion = p['OCUPACION'].toString();
          final detalles = p['DETALLES'].toString();
          final fechaCreacion = p['FECHA_CREACION'].toString();
          final activo = p['ACTIVO'] as bool;
          return Persona(
              idPersona,
              nombre,
              apellidoP,
              apellidoM,
              direccion,
              estado,
              municipio,
              fechaNacimiento,
              edad,
              ocupacion,
              detalles,
              fechaCreacion,
              telefono,
              email,
              sexo,
              activo);
        }).toList();

        return personas;
      } else {
        throw Exception('Error al obtener la lista de personas');
      }
    } catch (e) {
      throw Exception('Error al obtener la lista de personas');
    }
  }

  void obtenerPersonas() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('https://localhost:44305/api/personas'));
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);

        //print(response.body); // Imprime la respuesta en la consola

        setState(() {
          listapersonas = (parsedJson as List)
              .map((item) => Persona(
                    item['ID_PERSONA'] as int,
                    item['NOMBRE'] as String,
                    item['APELLIDO_P'] as String,
                    item['APELLIDO_M'] as String,
                    item['DIRECCION'] as String,
                    item['ESTADO'] as String,
                    item['MUNICIPIO'] as String,
                    item['FECHA_NACIMIENTO'] as String,
                    item['EDAD'] as String,
                    item['TELEFONO'] as String,
                    item['EMAIL'] as String,
                    item['SEXO'] as String,
                    item['OCUPACION'] as String,
                    item['DETALLES'] as String,
                    item['FECHA_CREACION'] as String,
                    item['ACTIVO'] as bool,
                  ))
              .toList();
          isLoading = false;
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
}

class Usuario {
  final String user;
  final String nombre;
  final String pass;

  Usuario(this.nombre, this.user, this.pass);
}

class Persona {
  final int idPersona;
  final String nombre;
  final String apellidoP;
  final String apellidoM;
  final String direccion;
  final String estado;
  final String municipio;
  final String fechaNacimiento;
  final String edad;
  final String telefono;
  final String email;
  final String sexo;
  final String ocupacion;
  final String detalles;
  final String fechaCreacion;
  final bool activo;

  Persona(
      this.idPersona,
      this.nombre,
      this.apellidoP,
      this.apellidoM,
      this.direccion,
      this.estado,
      this.municipio,
      this.fechaNacimiento,
      this.edad,
      this.telefono,
      this.email,
      this.sexo,
      this.ocupacion,
      this.detalles,
      this.fechaCreacion,
      this.activo);
}
