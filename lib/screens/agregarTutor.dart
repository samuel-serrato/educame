import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class AddTutorScreen extends StatefulWidget {
  @override
  _AddTutorScreenState createState() => _AddTutorScreenState();
}

class _AddTutorScreenState extends State<AddTutorScreen> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _usuarioController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _tipoUsuarioController = TextEditingController();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidopController = TextEditingController();
  TextEditingController _apellidomController = TextEditingController();
  TextEditingController _ocupacionController = TextEditingController();
  TextEditingController _telefonoController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _fechanacimientoController = TextEditingController();
  TextEditingController _sexoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Tutor'),
      ),
      body: content(),
    );
  }

  Widget content() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Text(
              'Datos de Usuario',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _usuarioController,
              decoration: InputDecoration(labelText: 'Usuario'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingresa el usuario';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingresa la contraseña';
                }
                return null;
              },
            ),
            SizedBox(height: 50),
            Text(
              'Datos del Tutor',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextFormField(
              controller: _nombreController,
              decoration: InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingresa el nombre';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _apellidopController,
              decoration: InputDecoration(labelText: 'Apellido Paterno'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingresa el apellido paterno';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _apellidomController,
              decoration: InputDecoration(labelText: 'Apellido Materno'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingresa el apellido materno';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _ocupacionController,
              decoration: InputDecoration(labelText: 'Ocupación'),
            ),
            TextFormField(
              controller: _telefonoController,
              decoration: InputDecoration(labelText: 'Teléfono'),
            ),
            TextFormField(
              controller: _direccionController,
              decoration: InputDecoration(labelText: 'Dirección'),
            ),
            TextFormField(
              controller: _fechanacimientoController,
              decoration: InputDecoration(labelText: 'Fecha de Nacimiento'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingresa la fecha de nacimiento';
                }
                return null;
              },
              onTap: () => _selectFechaNacimiento(context),
            ),
            DropdownButtonFormField<String>(
              value:
                  _sexoController.text.isNotEmpty ? _sexoController.text : '',
              onChanged: (newValue) {
                setState(() {
                  _sexoController.text = newValue!;
                });
              },
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text('Selecciona una opción'),
                ),
                DropdownMenuItem(
                  value: 'M',
                  child: Text('Masculino'),
                ),
                DropdownMenuItem(
                  value: 'F',
                  child: Text('Femenino'),
                ),
              ],
              decoration: InputDecoration(
                labelText: 'Sexo',
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value == 'Selecciona una opción') {
                  return 'Por favor selecciona una opción';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submitForm();
              },
              child: Text('Agregar Tutor'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectFechaNacimiento(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _fechanacimientoController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Primero crea el usuario
      final userId = await _crearUsuario();
      if (userId != null) {
        // Si se crea el usuario correctamente, crea el tutor asociado
        await _crearTutor(userId);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tutor agregado exitosamente'),
          ),
        );
        //Navigator.of(context).pop(true); // Indica que se agregó correctamente
      }
    }
  }

  Future<int?> _crearUsuario() async {
    try {
      final Map<String, dynamic> userData = {
        'USUARIO': _usuarioController.text,
        'PASSWORD': _passwordController.text,
        'TIPO_USUARIO': 2,
      };

      final response = await http.post(
        Uri.parse('https://localhost:44364/api/usuarios'),
        body: json.encode(userData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        return responseData['ID_USUARIO'];
      } else {
        print('Error al crear usuario: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      print('Error al crear usuario: $error');
      return null;
    }
  }

  Future<void> _crearTutor(int userId) async {
    try {
      final Map<String, dynamic> tutorData = {
        'ID_USUARIO': userId,
        'NOMBRE': _nombreController.text,
        'APELLIDO_PATERNO': _apellidopController.text,
        'APELLIDO_MATERNO': _apellidomController.text,
        'OCUPACION': _ocupacionController.text,
        'TELEFONO': _telefonoController.text,
        'DIRECCION': _direccionController.text,
        'FECHA_NACIMIENTO': _fechanacimientoController.text,
        'SEXO': _sexoController.text,
        "TIPO_USUARIO": 2.toString(),
      };

      final response = await http.post(
        Uri.parse('https://localhost:44364/api/tutor'),
        body: json.encode(tutorData),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final responseData = json.decode(response.body);
        final tutorId = responseData['ID_TUTOR'];
        print('Tutor agregado exitosamente con ID: $tutorId');
        // Retornar el ID del tutor agregado y regresar a la pantalla anterior
        Navigator.of(context)
            .pop({'id': tutorId, 'nombre': _nombreController.text});

        print('Tutor agregado exitosamente');
      } else {
        print('Error al crear tutor: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
      }
    } catch (error) {
      print('Error al crear tutor: $error');
    }
  }
}
