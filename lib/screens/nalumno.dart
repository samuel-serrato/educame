import 'dart:convert';

import 'package:educame/screens/agregarTutor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class nAlumno extends StatefulWidget {
  @override
  State<nAlumno> createState() => _nAlumnoState();
}

class _nAlumnoState extends State<nAlumno> {
  int? tutorId; // Variable para almacenar el ID del tutor seleccionado
  bool _tutorAgregado =
      false; // Variable para controlar el estado del botón "Agregar Tutor"

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
  bool _isTutorAdded =
      false; // Variable para verificar si se ha agregado un tutor
  String? _nombreTutor; // Variable para almacenar el nombre del tutor

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
    return SingleChildScrollView(
      child: Container(
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
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                padding: MaterialStateProperty.all<
                                    EdgeInsetsGeometry>(EdgeInsets.zero),
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
                          DropdownButtonFormField<String>(
                            value: _sexoController.text.isNotEmpty
                                ? _sexoController.text
                                : '',
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
                          DropdownButtonFormField<String>(
                            value: _seccionController.text.isNotEmpty
                                ? _seccionController.text
                                : '',
                            onChanged: (newValue) {
                              setState(() {
                                _seccionController.text = newValue!;
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                value: '',
                                child: Text('Selecciona una opción'),
                              ),
                              DropdownMenuItem(
                                value: 'Secundaria',
                                child: Text('Secundaria'),
                              ),
                              DropdownMenuItem(
                                value: 'Preparatoria',
                                child: Text('Preparatoria'),
                              ),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Sección',
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
                          DropdownButtonFormField<String>(
                            value: _gradoController.text.isNotEmpty
                                ? _gradoController.text
                                : '',
                            onChanged: (newValue) {
                              setState(() {
                                _gradoController.text = newValue!;
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                value: '',
                                child: Text('Selecciona una opción'),
                              ),
                              DropdownMenuItem(
                                value: '1',
                                child: Text('1'),
                              ),
                              DropdownMenuItem(
                                value: '2',
                                child: Text('2'),
                              ),
                              DropdownMenuItem(
                                value: '3',
                                child: Text('3'),
                              ),
                            ],
                            decoration: InputDecoration(
                              labelText: 'Grado',
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
                          _nombreTutor != null
                              ? Text(
                                  'Nombre del Tutor: $_nombreTutor',
                                  style: TextStyle(fontSize: 16),
                                )
                              : SizedBox(height: 20),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _tutorAgregado
                                ? null
                                : () async {
                                    // Desactiva el botón si ya se ha agregado un tutor
                                    final tutorData =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddTutorScreen()),
                                    );

                                    if (tutorData != null) {
                                      setState(() {
                                        _tutorAgregado =
                                            true; // Actualiza el estado del botón
                                        _isTutorAdded = true;
                                        _isTutorAdded = true;
                                        _tutorController.text =
                                            tutorData['id'].toString();
                                        _nombreTutor = tutorData['nombre'];
                                      });
                                    }
                                  },
                            child: Text('Agregar Tutor'),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ElevatedButton(
                              onPressed: _isTutorAdded ? _agregarAlumno : null,
                              // Deshabilitar el botón si no se ha agregado un tutor
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
      ),
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
        'ID_TUTOR': tutorId.toString(),
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

        setState(() {
          _nombreTutor = _tutorController.text;
        });
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
