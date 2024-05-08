import 'dart:convert';
import 'package:educame/screens/navigation_railCoordinacion.dart';
import 'package:educame/screens/navigation_railTutor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';
  bool _isLoading = false;
  late int _userId; // Agregamos una variable para almacenar el ID del usuario

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
    );
  }

  Widget content() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 28, 100, 163), Color(0xFF181F4B)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Center(
        child: Container(
          width: 500, // Ancho deseado del contenedor
          height: 600, // Alto deseado del contenedor
          color: Colors.white, // Color blanco para el contenedor
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SizedBox(
                  width: 150, // Ancho deseado del botón
                  height: 150, // Alto deseado del botón
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/logo_soc.png', // Ruta de tu imagen
                      width: 100, // Ancho de la imagen
                      height: 100, // Alto de la imagen
                      fit: BoxFit.cover, // Ajuste de la imagen
                    ),
                    onPressed: () {
                      const String url = 'https://www.institutosocrates.mx';
                      launchUrl(Uri.parse(url));
                    },
                  ),
                ),
              ),
              SizedBox(height: 50),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : _login, // Deshabilita el botón mientras se está cargando
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          // Muestra el círculo de progreso si se está cargando
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          'Iniciar sesión',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final usersUrl = Uri.parse('https://localhost:44364/api/usuarios');
    //final userDataUrl = Uri.parse('https://localhost:44364/api/datosusuario');
    final userTypeUrl = Uri.parse('https://localhost:44364/api/tipousuario');

    try {
      setState(() {
        _isLoading = true;
      });

      final usersResponse = await http.get(usersUrl);
      //final userDataResponse = await http.get(userDataUrl);
      final userTypeResponse = await http.get(userTypeUrl);

      if (usersResponse.statusCode == 200) {
        final List<dynamic> usuarios = jsonDecode(usersResponse.body);

        final List<dynamic> userTypes = jsonDecode(userTypeResponse.body);

        for (final usuario in usuarios) {
          final String usuarioNombre = usuario['USUARIO'];
          final String pass = usuario['PASSWORD'];
          final int userId = usuario['ID_USUARIO'];
          final String tipoUsuarioString = usuario['ID_TIPO_USUARIO'];
          final int userTypeId = int.tryParse(tipoUsuarioString) ?? 0;

          print('Tipo de usuario del usuario $usuarioNombre: $userTypeId');

          if (usuarioNombre == username && pass == password) {
            await Future.delayed(Duration(seconds: 1));

            // Almacenar el ID del usuario correspondiente
            _userId = userId;

            // Obteniendo el nombre del usuario según el tipo de usuario
            String nombre = await _getUserName(userId, userTypeId);

            // Buscar la descripción del tipo de usuario
            //Buscar coincidencia en id
            String userTypeDescription = '';
            for (final userType in userTypes) {
              final int typeId = userType['ID_TIPO_USUARIO'];
              if (typeId == userTypeId) {
                userTypeDescription = userType['DESCRIPCION'];
                break;
              }
            }

            /* // Buscar el nombre del usuario correspondiente al ID_USUARIO
            String nombre = '';
            for (final userDataItem in userData) {
              if (userDataItem['ID_USUARIO'] == userId) {
                nombre = userDataItem['NOMBRE'];
                break;
              }
            } */

            // Redirigir según el tipo de usuario
            if (userTypeId == 1) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationRailCScreen(
                    tipoUsuario: userTypeDescription,
                    idUsuario: _userId,
                    nombreUsuario: nombre, // Pasa el nombre del usuario aquí
                  ),
                ),
              );
            } else if (userTypeId == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationRailTScreen(
                    tipoUsuario: userTypeDescription,
                    idUsuario: _userId,
                    nombreUsuario: nombre, // Pasa el nombre del usuario aquí
                  ),
                ),
              );
            }

            setState(() {
              _errorMessage = 'Correcto';
            });
            return;
          }
        }

        // Si no se encuentra un usuario con las credenciales proporcionadas
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          _errorMessage = 'Credenciales incorrectas';
        });
      } else {
        setState(() {
          _errorMessage = 'Error en la solicitud';
        });
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      setState(() {
        _errorMessage = 'Error en la solicitud';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<String> _getUserName(int userId, int userTypeId) async {
    String endpoint = '';
    switch (userTypeId) {
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
        // Agrega un manejo para otros tipos de usuario si es necesario
        break;
    }

    final userDataUrl = Uri.parse('$endpoint/$userId');

    try {
      final userDataResponse = await http.get(userDataUrl);

      print('Respuesta recibida: ${userDataResponse.statusCode}');
      print('Cuerpo de la respuesta: ${userDataResponse.body}');

      if (userDataResponse.statusCode == 200) {
        final List<dynamic> userDataList = jsonDecode(userDataResponse.body);
        if (userDataList.isNotEmpty) {
          final userData = userDataList[0];
          return userData['NOMBRE'];
        }
      }
      return '';
    } catch (e) {
      print('Error al obtener el nombre del usuario: $e');
      return '';
    }
  }
}
