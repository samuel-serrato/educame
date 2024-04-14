import 'package:flutter/material.dart';

class nAlumno extends StatefulWidget {
  @override
  State<nAlumno> createState() => _nAlumnoState();
}

class _nAlumnoState extends State<nAlumno> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _gradeController = TextEditingController();

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
      child: Column(
        children: [
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
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del alumno',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa el nombre del alumno';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText: 'Fecha de Nacimiento',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa la edad del alumno';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _ageController,
                        decoration: InputDecoration(
                          labelText: 'Edad',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa la edad del alumno';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _gradeController,
                        decoration: InputDecoration(
                          labelText: 'CURP',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa la nota del alumno';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _gradeController,
                        decoration: InputDecoration(
                          labelText: 'Dirección',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa la nota del alumno';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _gradeController,
                        decoration: InputDecoration(
                          labelText: 'Sección',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa la nota del alumno';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _gradeController,
                        decoration: InputDecoration(
                          labelText: 'Grado',
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingresa la nota del alumno';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              print('Nombre: ${_nameController.text}');
                              print('Edad: ${_ageController.text}');
                              print('Nota: ${_gradeController.text}');
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text('Agregar Alumno'),
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
}
