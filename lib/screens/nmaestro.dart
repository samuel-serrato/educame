import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class nMaestro extends StatefulWidget {
  @override
  State<nMaestro> createState() => _nMaestroState();
}

class _nMaestroState extends State<nMaestro> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nombreController = TextEditingController();
  TextEditingController _sexoController = TextEditingController();
  TextEditingController _seccionController = TextEditingController();
  TextEditingController _fechanacimientoController = TextEditingController();

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
        title: Text(
          'Agregar Maestro',
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
      child: Column(
        children: [
          //Menú principal
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white,
            ),
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            child: Column(
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
                          labelText: 'Nombre del maestro',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa el nombre del alumno';
                          }
                          return null;
                        },
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
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: TextButton(
                          onPressed: () => _selectFechaNacimiento(context),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print('Nombre: ${_nombreController.text}');
                              print('Sexo: ${_sexoController.text}');
                              print(
                                  'Fecha de Nacimiento: ${_fechanacimientoController.text}');
                              _agregarMaestro();
                            }
                          },
                          child: Text('Agregar Maestro'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _agregarMaestro() async {
    try {
      final Map<String, dynamic> data = {
        'ID_USUARIO': 4014,
        'NOMBRE': _nombreController.text,
        'SEXO': _sexoController.text,
        'SECCION': _seccionController.text,
        'FECHA_NACIMIENTO': _fechanacimientoController.text,
      };

      final response = await http.post(
        Uri.parse('https://localhost:44364/api/maestros'),
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        print('Maestro agregado exitosamente');
        _nombreController.clear();
        _sexoController.clear();
        _seccionController.clear();
        _fechanacimientoController.clear();

        // Mostrar un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text('Maestro agregado exitosamente'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop(true); // Indica que se agregó correctamente

        /* setState(() {
          _nombreTutor = _tutorController.text;
        }); */
      } else {
        print('Error al agregar Maestro: ${response.statusCode}');
        print('Cuerpo de la respuesta: ${response.body}');
        throw Exception('Failed to add maestro');
      }
    } catch (error) {
      print('Error: $error');
    }
  }
}
