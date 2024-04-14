import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:educame/main.dart';
import 'package:educame/screens/home.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _errorMessage = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content(),
    );
  }

  Widget content() {
    return Container(
      color: Color(0xFF001D82),
      child: Center(
        child: Container(
          width: 500, // Ancho deseado del contenedor
          height: 500, // Alto deseado del contenedor
          color: Colors.white, // Color blanco para el contenedor
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlutterLogo(
                size: 150,
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
                    : _LoginScreen, // Deshabilita el botón mientras se está cargando
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

  Future<void> _LoginScreen() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final url = Uri.parse('https://localhost:44364/api/usuarios');
    //final url = Uri.parse('http://192.168.1.190/API_MF/api/usuarios');

    try {
      setState(() {
        _isLoading = true; // Cambia el estado a "cargando"
      });

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> usuarios = jsonDecode(response.body);

        for (final usuario in usuarios) {
          final String usuarioNombre = usuario['USUARIO'];
          final String pass = usuario['PASSWORD'];

          if (usuarioNombre == username && pass == password) {
            // Credenciales válidas, realizar la acción deseada (navegar a una nueva pantalla, etc.)
            await Future.delayed(
                Duration(seconds: 1)); // Agrega un retraso de 2 segundos
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(username: username),
              ),
            );
            setState(() {
              _errorMessage = 'Correcto';
            });
            return;
          }
        }

        // Si no se encuentra un usuario con las credenciales proporcionadas
        await Future.delayed(
            Duration(seconds: 1)); // Agrega un retraso de 2 segundos
        setState(() {
          _errorMessage = 'Credenciales incorrectas';
        });
      } else {
        // Si la solicitud a la API falla
        setState(() {
          _errorMessage = 'Error en la solicitud';
        });
      }
    } catch (e) {
      // Error al realizar la solicitud HTTP
      setState(() {
        _errorMessage = 'Error en la solicitud';
      });
    } finally {
      setState(() {
        _isLoading = false; // Cambia el estado a "no cargando"
      });
    }
  }
  /* Future<void> _LoginScreen() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    // Verificar si el usuario y la contraseña son '1'
    if (username == '1' && password == '1') {
      // Credenciales válidas, realizar la acción deseada (navegar a una nueva pantalla, etc.)
      await Future.delayed(
          Duration(seconds: 1)); // Agrega un retraso de 1 segundo
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(username: username),
        ),
      );
      setState(() {
        _errorMessage = 'Correcto';
      });
    } else {
      // Si no coinciden las credenciales
      await Future.delayed(
          Duration(seconds: 1)); // Agrega un retraso de 1 segundo
      setState(() {
        _errorMessage = 'Credenciales incorrectas';
      });
    }

    // Cambia el estado a "no cargando"
    setState(() {
      _isLoading = false;
    });
  } */
}
