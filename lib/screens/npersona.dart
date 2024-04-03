import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

//import '../widgets/CardUserWidget.dart';

class NPersona extends StatefulWidget {
  final String nombre;
  const NPersona({Key? key, required this.nombre}) : super(key: key);

  @override
  State<NPersona> createState() => _NPersonaState();
}

class _NPersonaState extends State<NPersona> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoMaternoController =
      TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _ocupacionController = TextEditingController();
  final TextEditingController _apellidoPaternoController =
      TextEditingController();
  final TextEditingController _ciudadController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final TextEditingController _detallesController = TextEditingController();

  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();

  DateTime? _selectedDate; // Cambio en la declaración de la variable

  String? _selectedSexo;

  //String? _selectedEstado;
  String? _selectedEstado = '13';
  String? _selectedMunicipio;

  List<Map<String, dynamic>> _estados = [];
  List<Map<String, dynamic>> _municipios = [];

  @override
  void dispose() {
    _nombreController.dispose();
    _apellidoMaternoController.dispose();
    _estadoController.dispose();
    _direccionController.dispose();
    _ocupacionController.dispose();
    _apellidoPaternoController.dispose();
    _ciudadController.dispose();
    _fechaNacimientoController.dispose();
    _edadController.dispose();
    _detallesController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchEstados();
    _fetchMunicipios();
  }

  Future<void> _fetchEstados() async {
    final response =
        await http.get(Uri.parse('https://localhost:44305/api/estados'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _estados = List<Map<String, dynamic>>.from(data);
      });
    } else {
      // Manejar el error de la solicitud HTTP
      print(
          'Error al obtener los estados. Código de error: ${response.statusCode}');
    }
  }

  Future<void> _fetchMunicipios() async {
    final response =
        await http.get(Uri.parse('https://localhost:44305/api/municipios'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final municipios = List<Map<String, dynamic>>.from(data);

      // Filtrar duplicados basados en el ID del municipio
      final uniqueMunicipios = municipios.toSet().toList();

      setState(() {
        _municipios = uniqueMunicipios;
      });
    } else {
      // Manejar el error de la solicitud HTTP
      print(
          'Error al obtener los municipios. Código de error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;

    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      appBar: AppBar(
        title: Text('Formulario'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      height: 50,
                      child: textoyBoton(!isDesktop),
                    ),
                    isDesktop ? _buildDesktopForm() : _buildMobileForm(),
                    const SizedBox(height: 16.0),
                    Row(
                      // Utilizar una fila en lugar de una columna
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isDesktop
                            ? SizedBox(
                                width: 300,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                      Color(0xFF001D82),
                                    ),
                                    overlayColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 0, 104, 190),
                                    ),
                                  ),
                                  onPressed: () {
                                    enviarDatos();
                                    print(_nombreController.text);
                                    print(_apellidoPaternoController.text);
                                    print(_apellidoMaternoController.text);
                                    final estadoSeleccionado =
                                        _estados.firstWhere((estado) =>
                                            estado['ID_ESTADO'] ==
                                            int.parse(_selectedEstado!));
                                    print(estadoSeleccionado['NOMBRE']);
                                    // Acción a realizar al presionar el botón "Aceptar"
                                    final municipioSeleccionado =
                                        _municipios.firstWhere((municipio) =>
                                            municipio['ID_MUNICIPIO'] ==
                                            int.parse(_selectedMunicipio!));
                                    print(municipioSeleccionado['NOMBRE']);
                                    print(_direccionController.text);
                                    print(_selectedDate);
                                    print(_edadController.text);
                                    print(_selectedSexo);
                                    print(_ocupacionController.text);
                                    print(_detallesController.text);
                                    print(_telefonoController.text);
                                    print(_emailController.text);
                                    print(_nombreController.text);
                                    // Acción a realizar al presionar el botón "Aceptar"
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Aceptar',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                      Color(0xFF001D82),
                                    ),
                                    overlayColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 0, 104, 190),
                                    ),
                                  ),
                                  onPressed: () {
                                    // Acción a realizar al presionar el botón "Aceptar"
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Aceptar',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        const SizedBox(
                            width: 8.0), // Agregar un espacio entre los botones
                        isDesktop
                            ? SizedBox(
                                width: 300,
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Acción a realizar al presionar el botón "Cancelar"
                                    Navigator.of(context)
                                        .pop(false); // Indica que se canceló
                                    _limpiarFecha();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Cancelar',
                                      style:
                                          TextStyle(color: Color(0xFF001D82)),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                      Colors.white,
                                    ),
                                    overlayColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 215, 224, 255),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // Acción a realizar al presionar el botón "Cancelar"
                                    Navigator.of(context)
                                        .pop(false); // Indica que se canceló
                                    _limpiarFecha();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      'Cancelar',
                                      style:
                                          TextStyle(color: Color(0xFF001D82)),
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                      Colors.white,
                                    ),
                                    overlayColor: MaterialStateProperty.all(
                                      Color.fromARGB(255, 215, 224, 255),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget textoyBoton(bool isMobile) {
    if (isMobile) {
      return Container(
        alignment: Alignment.centerLeft,
        child: Text(
          'Agregar Persona',
          style: TextStyle(
            //color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
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
                  'Agregar Persona',
                  style: TextStyle(
                    //color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildMobileForm() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            _buildTextFormField('Nombre', _nombreController),
            _buildTextFormField('Apellido Paterno', _apellidoPaternoController),
            _buildTextFormField('Apellido Materno', _apellidoMaternoController),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedEstado,
                items: _estados.map((estado) {
                  final id = estado['ID_ESTADO'];
                  final nombre = estado['NOMBRE'];
                  return DropdownMenuItem<String>(
                    value: id.toString(),
                    child: Text(nombre),
                  );
                }).toList(),
                onChanged: null,
                /* onChanged: (value) {
                        setState(() {
                          final selectedEstado = value;
                          _selectedEstado = selectedEstado;
                          _selectedMunicipio = null;
                        });
                      }, */
                decoration: InputDecoration(
                  labelText: 'Estado',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 2,
                      color: Color(0xFF001D82), // Color de borde personalizado
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: _selectedMunicipio,
                items: _municipios
                    .where((municipio) =>
                        municipio['ID_ESTADO'].toString() == _selectedEstado)
                    .map((municipio) {
                  final id = municipio['ID_MUNICIPIO'];
                  final nombre = municipio['NOMBRE'];
                  return DropdownMenuItem<String>(
                    value: id.toString(),
                    child: Text(nombre),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMunicipio = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Municipio',
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 2,
                      color: Color(0xFF001D82), // Color de borde personalizado
                    ),
                  ),
                ),
              ),
            ),
            _buildTextFormField('Dirección', _direccionController),
            SizedBox(
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.zero,
                    ),
                  ),
                  onPressed: _selectDate, // Mostrar DatePicker
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        width: 0.5,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _selectedDate != null
                              ? 'Fecha de Nacimiento: ${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year.toString()}'
                              : 'Seleccionar Fecha de Nacimiento',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                        Icon(
                          Icons.calendar_today,
                          color: Color(0xFF001D82),
                        ), // Icono del calendario
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildTextFormField('Edad', _edadController),
            Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: _buildSexoSelection()),
            Container(
              //margin: EdgeInsets.symmetric(vertical: 8.0),
              child: _buildTextFormField('Teléfono', _telefonoController),
            ),
            Container(
              //margin: EdgeInsets.symmetric(vertical: 8.0),
              child:
                  _buildTextFormField('Correo Electrónico', _emailController),
            ),
            _buildTextFormField('Ocupación', _ocupacionController),
            Container(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                maxLines: 2,
                controller: _detallesController,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 0.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      width: 2,
                      color: Color(0xFF001D82), // Color de borde personalizado
                    ),
                  ),
                  labelText: 'Detalles',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopForm() {
    double verticalSpacing = 20.0; // Ajusta el valor según tus necesidades
    double horizontalSpacing = 10.0; // Ajusta el valor según tus necesidades

    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _buildTextFormField('Nombre', _nombreController),
                ),
                SizedBox(width: horizontalSpacing),
                Flexible(
                  child: _buildTextFormField(
                      'Apellido Paterno', _apellidoPaternoController),
                ),
                SizedBox(width: horizontalSpacing),
                Flexible(
                  child: _buildTextFormField(
                      'Apellido Materno', _apellidoMaternoController),
                ),
              ],
            ),
            SizedBox(height: verticalSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _buildTextFormField('Dirección', _direccionController),
                ),
                SizedBox(width: horizontalSpacing),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedEstado,
                      items: _estados.map((estado) {
                        final id = estado['ID_ESTADO'];
                        final nombre = estado['NOMBRE'];
                        return DropdownMenuItem<String>(
                          value: id.toString(),
                          child: Text(nombre),
                        );
                      }).toList(),
                      onChanged: null,
                      /* onChanged: (value) {
                        setState(() {
                          final selectedEstado = value;
                          _selectedEstado = selectedEstado;
                          _selectedMunicipio = null;
                        });
                      }, */
                      decoration: InputDecoration(
                        labelText: 'Estado',
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(
                                0xFF001D82), // Color de borde personalizado
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: horizontalSpacing),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: _selectedMunicipio,
                      items: _municipios
                          .where((municipio) =>
                              municipio['ID_ESTADO'].toString() ==
                              _selectedEstado)
                          .map((municipio) {
                        final id = municipio['ID_MUNICIPIO'];
                        final nombre = municipio['NOMBRE'];
                        return DropdownMenuItem<String>(
                          value: id.toString(),
                          child: Text(nombre),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMunicipio = value!;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Municipio',
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(
                                0xFF001D82), // Color de borde personalizado
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: verticalSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.zero,
                        ),
                      ),
                      onPressed: _selectDate, // Mostrar DatePicker
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 0.5,
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _selectedDate != null
                                  ? 'Fecha de Nacimiento: ${_selectedDate!.day.toString().padLeft(2, '0')}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.year.toString()}'
                                  : 'Seleccionar Fecha de Nacimiento',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: Color(0xFF001D82),
                            ), // Icono del calendario
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: horizontalSpacing),
                Flexible(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildTextFormField('Edad', _edadController),
                      ),
                      SizedBox(width: horizontalSpacing),
                      Expanded(
                        flex: 2,
                        child: _buildSexoSelection(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: verticalSpacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _buildTextFormField('Teléfono', _telefonoController),
                ),
                SizedBox(width: horizontalSpacing),
                Flexible(
                  child: _buildTextFormField(
                      'Correo Electrónico', _emailController),
                ),
              ],
            ),
            SizedBox(height: verticalSpacing),
            Row(
              children: [
                Flexible(
                  child: _buildTextFormField('Ocupación', _ocupacionController),
                ),
                SizedBox(width: horizontalSpacing),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: TextFormField(
                      maxLines: 1,
                      controller: _detallesController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 2,
                            color: Color(
                                0xFF001D82), // Color de borde personalizado
                          ),
                        ),
                        labelText: 'Detalles',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSexoSelection() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Sexo',
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 2,
            color: Color(0xFF001D82), // Color de borde personalizado
          ),
        ),
      ),
      value: _selectedSexo,
      onChanged: (newValue) {
        setState(() {
          _selectedSexo = newValue;
        });
      },
      items: const [
        DropdownMenuItem(
          value: 'Masculino',
          child: Text('Masculino'),
        ),
        DropdownMenuItem(
          value: 'Femenino',
          child: Text('Femenino'),
        ),
        DropdownMenuItem(
          value: 'Otro',
          child: Text('Otro'),
        ),
      ].toList(),
    );
  }

  void _limpiarFecha() {
    setState(() {
      _selectedDate = null;
      _fechaNacimientoController.clear();
    });
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _fechaNacimientoController.text = _selectedDate!.toString();
      });

      print('Fecha seleccionada: $_selectedDate');

      _calcularEdad(); // Calcular y mostrar la edad
    }
  }

  void _calcularEdad() {
    if (_selectedDate != null) {
      final today = DateTime.now();
      int age = today.year - _selectedDate!.year;

      // Verificar si aún no se ha celebrado el cumpleaños este año
      if (today.month < _selectedDate!.month ||
          (today.month == _selectedDate!.month &&
              today.day < _selectedDate!.day)) {
        age--;
      }

      setState(() {
        _edadController.text = age.toString();
      });
    }
  }

  Widget _buildTextFormField(
    String labelText,
    TextEditingController controller,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 0.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 2,
              color: Color(0xFF001D82), // Color de borde personalizado
            ),
          ),
          labelText: labelText,
        ),
      ),
    );
  }

  void enviarDatos() {
    final nombre = _nombreController.text;
    final apellidoP = _apellidoPaternoController.text;
    final apellidoM = _apellidoMaternoController.text;
    final direccion = _direccionController.text;
    //ESTADO
    final estadoSeleccionado = _estados.firstWhere(
    (estado) => estado['ID_ESTADO'] == int.parse(_selectedEstado!));
    final estado = estadoSeleccionado['NOMBRE'];
    //MUNICIPIO
    final municipioSeleccionado = _municipios.firstWhere((municipio) =>
    municipio['ID_MUNICIPIO'] == int.parse(_selectedMunicipio!));
    final municipio = municipioSeleccionado['NOMBRE'];
    final fechaNacimiento = _selectedDate.toString();
    final edad = _edadController.text;
    final telefono = _telefonoController.text;
    final email = _emailController.text;
    final ocupacion = _ocupacionController.text;
    //SEXO
      final sexo = _selectedSexo == 'Masculino'
      ? 'M'
      : _selectedSexo == 'Femenino'
          ? 'F'
          : 'Otro';
    final detalles = _detallesController.text;
    final fechaCreacion = DateTime.now().toString();

    final personas = {
      "NOMBRE": nombre,
      "APELLIDO_P": apellidoP,
      "APELLIDO_M": apellidoM,
      "DIRECCION": direccion,
      "ESTADO": estado,
      "MUNICIPIO": municipio,
      "FECHA_NACIMIENTO": fechaNacimiento,
      "EDAD": edad,
      "TELEFONO": telefono,
      "EMAIL": email,
      "OCUPACION": ocupacion,
      "SEXO": sexo,
      "DETALLES": detalles,
      "FECHA_CREACION": fechaCreacion,
      "ACTIVO": true
    };

    http.post(
      Uri.parse('https://localhost:44305/api/personas'),
      body: jsonEncode(personas),
      headers: {'Content-Type': 'application/json'},
    ).then((response) {
      if (response.statusCode == 201) {
        Navigator.of(context).pop(true); // Indica que se agregó correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Persona agregado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al agregar persona'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al agregar persona'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }
}
