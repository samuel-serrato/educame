import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:educame/screens/miCuenta.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Importa el paquete de internacionalización para formatear la fecha
import 'package:intl/date_symbol_data_local.dart'; // Importa este paquete para inicializar los símbolos de fecha localmente

// Antes de usar DateFormat, asegúrate de inicializar los símbolos de fecha localmente

//import 'nexp_screen.dart';

class HomeScreen extends StatefulWidget {
  //String user;

  final String username; // Agregar esta línea
  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _selectedIndex = 0;

  String username = '';
//  String nombre = '';
  List<Usuario> listausuarios = [];
  bool isLoading = true;
  bool showErrorDialog = false;

  /*  Future<String> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //user = prefs.getString('user') ?? '';
      user = prefs.getString('user') ?? '';
    });
    return user;
  } */

  @override
  void initState() {
    super.initState();
    obtenerusuarios();
    username = widget.username;
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
              child: qActions(),
            ),
          ],
        ),
      ),
    );
  }

  /* Widget content1() {
    
  } */

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buenas Tardes, ${buscarNombreUsuario(username)}',
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
            child: const Icon(
              Icons.person,
              color: Color(0xFF063B5D),
              size: 40,
            ),
            onPressed: () {
              /* Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (BuildContext context) {
                return const MiCuentaScreen();
              })); */
            },
          ),
        ),
        /* const Padding(
          padding: EdgeInsets.only(right: 20),
          child: CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              color: Color(0xFF52C88F),
              size: 45,
            ),
          ),
        ), */
      ],
    );
  }

  Widget carrouselContainer(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double carouselWidth = screenWidth * 0.9;
    int currentCarouselIndex = 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        height: 180,
        width: carouselWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 150,
              viewportFraction: 0.33,
              enableInfiniteScroll: false,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: false,
              padEnds: false,
              initialPage: 0,
            ),
            items: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  surfaceTintColor: Colors.white,
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.school,
                        size: 30.0,
                        color: Color.fromARGB(255, 14, 47, 117),
                      ),
                      const Text('Alumnos', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 10.0),
                      Container(
                        height: 2.0,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                      const SizedBox(height: 10.0),
                      const Text('9', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  surfaceTintColor: Colors.white,
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.person,
                        size: 30.0,
                        color: Color.fromARGB(255, 14, 47, 117),
                      ),
                      const Text('Maestros', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 10.0),
                      Container(
                        height: 2.0,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                      const SizedBox(height: 10.0),
                      const Text('3', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
              // Contenedor para mostrar la fecha actual
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Card(
                  surfaceTintColor: Colors.white,
                  elevation: 10,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 2.0,
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                      ),
                      const SizedBox(height: 2),
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
                      const SizedBox(height: 2),
                      // Número del día en grande
                      Text(
                        DateFormat('dd').format(DateTime.now()),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
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
            ],
          ),
        ),
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
            "Acciones Rapidas",
            style: TextStyle(
              fontSize: 24,
              color: Color(0xFF444444),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 80,
            child: ElevatedButton(
              onPressed: () {
                /* Navigator.of(context).push(MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                return const NExpScreen();
              })); */
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
                          child: Icon(Icons.person_add, size: 40, color: Color.fromARGB(255, 14, 47, 117))
                        ),
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
                          child: Icon(Icons.co_present_rounded, size: 40, color: Color.fromARGB(255, 14, 47, 117))
                        ),
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
                          child: Icon(Icons.message, size: 40, color: Color.fromARGB(255, 14, 47, 117))
                        ),
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
    setState(() {
      isLoading = true;
    });
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.190/API_MF/api/usuarios'));
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
}

class Usuario {
  final String user;
  final String nombre;
  final String pass;

  Usuario(this.nombre, this.user, this.pass);
}
