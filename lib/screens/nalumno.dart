import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class nAlumno extends StatefulWidget {
  @override
  State<nAlumno> createState() => _nAlumnoState();
}

class _nAlumnoState extends State<nAlumno> {
  late final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _apellidopController = TextEditingController();
  TextEditingController _apellidomController = TextEditingController();
  TextEditingController _fechanacimientoController = TextEditingController();
  TextEditingController _sexoController = TextEditingController();
  TextEditingController _direccionController = TextEditingController();
  TextEditingController _seccionController = TextEditingController();
  TextEditingController _gradoController = TextEditingController();
  TextEditingController _tutorController = TextEditingController();

  Future<void> _selectFechaNacimiento(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fechanacimientoController.text) {
      setState(() {
        _fechanacimientoController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          'Agregar Alumno',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: content(),
    );
  }

  Widget content() {
    return Container(
      color: Color(0xFFE5E5E5),
      child: Column(children: [
        //Menú principal
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
          ),
          margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: _nombreController,
                          decoration: InputDecoration(
                            labelText: 'Nombre del alumno',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa la información';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _apellidopController,
                          decoration: InputDecoration(
                            labelText: 'Apellido Paterno',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa la información';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _apellidomController,
                          decoration: InputDecoration(
                            labelText: 'Apellido Materno',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa la información';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: TextButton(
                            onPressed: () => _selectFechaNacimiento(context),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                      EdgeInsets.zero),
                              side: MaterialStateProperty.all<BorderSide>(
                                  BorderSide(color: Colors.grey)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Fecha de Nacimiento: ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                Text(
                                  _fechanacimientoController.text.isNotEmpty
                                      ? _fechanacimientoController.text
                                      : 'Seleccionar fecha',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextFormField(
                          controller: _sexoController,
                          decoration: InputDecoration(
                            labelText: 'Sexo',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa la información';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _direccionController,
                          decoration: InputDecoration(
                            labelText: 'Dirección',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa la información';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _seccionController,
                          decoration: InputDecoration(
                            labelText: 'Sección',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa la información';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _gradoController,
                          decoration: InputDecoration(
                            labelText: 'Grado',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa la información';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _tutorController,
                          decoration: InputDecoration(
                            labelText: 'Tutor',
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Por favor ingresa la información';
                            }
                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _agregarAlumno();
                            },
                            child: Text('Agregar Alumno'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void _agregarAlumno() async {
    try {
      final Map<String, dynamic> data = {
        'NOMBRE': _nombreController.text,
        'APELLIDO_PATERNO': _apellidopController.text,
        'APELLIDO_MATERNO': _apellidomController.text,
        'FECHA_NACIMIENTO': _fechanacimientoController.text,
        'SEXO': _sexoController.text,
        'DIRECCION': _direccionController.text,
        'SECCION': _seccionController.text,
        'GRADO': _gradoController.text,
        'ID_TUTOR': _tutorController.text,
      };

      final response = await http.post(
        Uri.parse('https://localhost:44364/api/alumnos'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        print('Alumno agregado exitosamente');
        _nombreController.clear();
        _apellidopController.clear();
        _apellidomController.clear();
        _fechanacimientoController.clear();
        _sexoController.clear();
        _direccionController.clear();
        _seccionController.clear();
        _gradoController.clear();
        _tutorController.clear();

        // Mostrar un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Alumno agregado exitosamente'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true); // Indica que se agregó correctamente
      } else {
        print('Error al agregar expediente: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
        throw Exception('Failed to add student');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: nAlumno(),
  ));
}
