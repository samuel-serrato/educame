import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//import '../widgets/CardUserWidget.dart';

class NGrupo extends StatefulWidget {
  final String nombre;
  const NGrupo({Key? key, required this.nombre}) : super(key: key);

  @override
  State<NGrupo> createState() => _NGrupoState();
}

class _NGrupoState extends State<NGrupo> {
  final TextEditingController _nombrePrestamoController = TextEditingController();
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

  double verticalSpacing = 20.0; // Ajusta el valor según tus necesidades

  List<Persona> listapersonas = [];
  List<Grupo> listaGrupos = [];
  bool isLoading = true;
  bool showErrorDialog = false;

  List<String> detallesOptions = ['Opción 1', 'Opción 2', 'Opción 3'];
  String? selectedGroupType;

  List<String> prestamoOptions = ['Préstamo 1', 'Préstamo 2', 'Préstamo 3'];
  String? selectedPrestamoOption;

  List<String?> selectedIntegrantes = [];
  int numIntegrantes = 1; // Número inicial de integrantes

  List<GroupType> listaTipoGrupos = [];
  List<bool> isSelected = [];
  // Agrega esta función para obtener una lista de nombres de los objetos GroupType
  List<String> obtenerNombresGrupos(List<GroupType> groupTypes) {
    return groupTypes.map((groupType) => groupType.nombre).toList();
  }

  @override
  void initState() {
    super.initState();
    obtenerPersonas();
    obtenerTipoGrupos();
  }

  @override
  void dispose() {
    _nombrePrestamoController.dispose();
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
                                    // Acción a realizar al presionar el botón "Aceptar"
                                    crearGrupo();
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
                                    crearGrupo();
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

  // Método para obtener el ID del integrante a partir del nombre
int obtenerIdIntegrantePorNombre(String nombreIntegrante) {
  final integranteEncontrado =
      listapersonas.firstWhere((persona) => persona.nombre == nombreIntegrante);
  return integranteEncontrado.idPersona;
}

  // Método para obtener el nombre del integrante a partir del ID
String obtenerNombreIntegrantePorId(int idIntegrante) {
  final integranteEncontrado =
      listapersonas.firstWhere((persona) => persona.idPersona == idIntegrante);
  return integranteEncontrado.nombre;
}

  // Actualiza el método _buildIntegranteFormField para obtener el ID del integrante a partir del nombre
Widget _buildIntegranteFormField(int index) {
  return _buildDropdownFormField(
    'Integrante ${index + 1}',
    listapersonas.map((persona) => persona.nombre).toList(),
    selectedIntegrantes.length > index ? selectedIntegrantes[index] : null,
    (newValue) {
      setState(() {
        if (newValue != null) {
          if (selectedIntegrantes.length > index) {
            selectedIntegrantes[index] = newValue;
          } else {
            selectedIntegrantes.add(newValue);
          }
        }
      });
    },
  );
}


  Widget textoyBoton(bool isMobile) {
    if (isMobile) {
      return Container(
        alignment: Alignment.centerLeft,
        child: Text(
          'Agregar Grupo',
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
                  'Agregar Grupo',
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topCenter,
              child: CircleAvatar(
                maxRadius: 70,
                backgroundColor: Color(0xFF001D82),
                child: Icon(
                  Icons.groups,
                  size: 70,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildDropdownFormField(
              'Grupo',
              detallesOptions,
              selectedGroupType,
              (newValue) {
                setState(() {
                  selectedGroupType = newValue;
                });
              },
            ),
            SizedBox(height: 10),
            _buildTextFormField('Nombre del Préstamo', _direccionController),
            SizedBox(height: 50),
            _buildDropdownFormField(
              'Integrante 1',
              prestamoOptions,
              selectedPrestamoOption,
              (newValue) {
                setState(() {
                  selectedPrestamoOption = newValue;
                });
              },
            ),
            SizedBox(height: verticalSpacing),
            _buildDropdownFormField(
              'Integrante 2',
              prestamoOptions,
              selectedPrestamoOption,
              (newValue) {
                setState(() {
                  selectedPrestamoOption = newValue;
                });
              },
            ),
            SizedBox(height: verticalSpacing),
            _buildDropdownFormField(
              'Integrante 3',
              prestamoOptions,
              selectedPrestamoOption,
              (newValue) {
                setState(() {
                  selectedPrestamoOption = newValue;
                });
              },
            ),
            SizedBox(height: verticalSpacing),
            TextFormField(
              //controller: controller,
              maxLines: 2,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 1.2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    width: 2.5,
                    color: Color(0xFF001D82), // Color de borde personalizado
                  ),
                ),
                labelText: 'Detalles',
              ),
            ),
            SizedBox(height: verticalSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopForm() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
        child: Row(
          children: [
            //IZQUIERDA
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //SizedBox(height: verticalSpacing),
                    // Generar campos para los integrantes existentes
                    for (int i = 0; i < numIntegrantes; i++)
                      _buildIntegranteFormField(i),
                    SizedBox(height: verticalSpacing),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          numIntegrantes++; // Aumentar el número de integrantes
                        });
                      },
                      child: Text('Agregar Integrante'),
                    ),
                    SizedBox(height: verticalSpacing),
                    TextFormField(
                      controller: _detallesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            width: 2.5,
                            color: Color(
                                0xFF001D82), // Color de borde personalizado
                          ),
                        ),
                        labelText: 'Detalles',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //DERECHA
            SizedBox(width: 20),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Align(
                      alignment: Alignment.topCenter,
                      child: CircleAvatar(
                        maxRadius: 70,
                        backgroundColor: Color(0xFF001D82),
                        child: Icon(
                          Icons.groups,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    _buildDropdownFormField(
                      'Grupo',
                      obtenerNombresGrupos(listaTipoGrupos),
                      selectedGroupType,
                      (newValue) {
                        setState(() {
                          selectedGroupType = newValue;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    _buildTextFormField(
                        'Nombre del Préstamo', _nombrePrestamoController),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              width: 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              width: 2.5,
              color: Color(0xFF001D82), // Color de borde personalizado
            ),
          ),
          labelText: labelText,
        ),
      ),
    );
  }

  // Actualiza el método _buildDropdownFormField para obtener el nombre del integrante en lugar del ID
Widget _buildDropdownFormField(
  String labelText,
  List<String> options,
  String? selectedOption,
  ValueChanged<String?> onChanged,
) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8.0),
    child: DropdownButtonFormField<String>(
      value: selectedOption,
      onChanged: onChanged,
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            width: 2.5,
            color: Color(0xFF001D82),
          ),
        ),
        labelText: labelText,
      ),
      hint: Text('Seleccionar $labelText'),
    ),
  );
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

  void obtenerTipoGrupos() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('https://localhost:44305/api/tipogrupos'));
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);

        setState(() {
          // Filtrar la lista de tipos de grupos que tengan el campo ACTIVO en 0
          listaTipoGrupos = (parsedJson as List)
              .map((item) => GroupType(
                    item['ID_TIPO_GRUPO'],
                    item['NOMBRE'],
                    item['DESCRIPCION'],
                    item['ACTIVO'],
                  ))
              .where((groupType) =>
                  groupType.activo ==
                  true) // Solo los que tengan el campo ACTIVO en 1
              .toList();

          isSelected = List.generate(listaTipoGrupos.length, (index) => false);
          isLoading = false;
        });
        print(
            'Tipos de Grupos obtenidos: $listaTipoGrupos'); // Agrega este mensaje de depuración
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

  // Método para obtener el ID del grupo a partir del nombre seleccionado
int obtenerIdGrupoPorNombre(List<GroupType> groupTypes, String nombreGrupo) {
  final grupoEncontrado =
      groupTypes.firstWhere((groupType) => groupType.nombre == nombreGrupo);
  return grupoEncontrado.id;
}




  void crearGrupo() async {
    print('Iniciando creación del grupo...');
  if (selectedGroupType == null) {
    // Asegurarse de que se haya seleccionado un grupo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selecciona un grupo antes de crear el grupo.'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  final tipoGrupoId =
      obtenerIdGrupoPorNombre(listaTipoGrupos, selectedGroupType!);

  final nombre = _nombrePrestamoController.text;
  final detalles = _detallesController.text;
  final fechaCreacion = DateTime.now().toString();
  print(tipoGrupoId);
    print(nombre);
    print(detalles);
    print(fechaCreacion);
  setState(() {
    isLoading = true;
  });

  try {
    final newGroup = {
      "ID_TIPO_GRUPO": tipoGrupoId,
      "NOMBRE": nombre,
      "DETALLES": detalles,
      "FECHA_CREACION": fechaCreacion,
      "ACTIVO": true, // Cambiar el campo ACTIVO a 1
    };
    final response = await http.post(
      Uri.parse('https://localhost:44305/api/grupos'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(newGroup),
    );
    print('Respuesta del servidor: ${response.body}');

    if (response.statusCode == 201) {
      print('Grupo creado correctamente.');
      Navigator.of(context).pop(true); // Indica que se agregó correctamente
      // El grupo se creó correctamente
      final groupId = json.decode(response.body)['ID_GRUPO'];
      asignarIntegrantesAlGrupo(groupId); // No usamos await aquí
      setState(() {
        isLoading = false;
      });

        // Llamar a obtenerGrupos() para actualizar la lista de grupos
    obtenerGrupos();

    } else {
      print('Error al crear el grupo.');
      // Error en la solicitud POST para crear el grupo
      setState(() {
        showErrorDialog = true;
        isLoading = false;
      });
      // Mostrar Snackbar de error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al crear el grupo.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    print('Excepción al crear el grupo: $e');
    setState(() {
      showErrorDialog = true;
      isLoading = false;
    });
    // Mostrar Snackbar de error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al crear el grupo.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}


void asignarIntegrantesAlGrupo(int groupId) async {
  try {
    for (var integrante in selectedIntegrantes) {
      final idPersona = obtenerIdPersonaPorNombre(integrante!);
      print('ID Persona para $integrante: $idPersona');

      final response = await http.post(
        Uri.parse('https://localhost:44305/api/grupopersona'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "ID_PERSONA": idPersona,
          "ID_GRUPO": groupId,
          "ACTIVO": true,
        }),
      );

      if (response.statusCode != 201) {
        print('Error al asignar $integrante al grupo.');
        // Error en la solicitud POST para asignar el integrante al grupo
        setState(() {
          showErrorDialog = true;
          isLoading = false;
        });
        // Mostrar Snackbar de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al asignar integrantes al grupo.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    // Todos los integrantes se asignaron correctamente al grupo
    // Realizar cualquier otra acción necesaria después de asignar los integrantes.
    print('Todos los integrantes asignados correctamente al grupo.');

    // Mostrar Snackbar de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Grupo creado exitosamente.'),
        backgroundColor: Colors.green,
      ),
    );
  } catch (e) {
    print('Excepción al asignar integrantes al grupo: $e');
    setState(() {
      showErrorDialog = true;
      isLoading = false;
    });
    // Mostrar Snackbar de error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error al asignar integrantes al grupo.'),
        backgroundColor: Colors.red,
      ),
    );
  }
}




// Agrega esta función al estado _NGrupoState
// Agrega esta función al estado _NGrupoState
int obtenerIdPersonaPorNombre(String nombrePersona) {
  final persona = listapersonas.firstWhere(
    (persona) => persona.nombre == nombrePersona,
    orElse: () => Persona(
      -1, // O cualquier otro valor inválido para el ID de la persona
      '', // O cualquier otro valor ficticio para el nombre de la persona
      '', // O cualquier otro valor ficticio para el apellido paterno de la persona
      '', // O cualquier otro valor ficticio para el apellido materno de la persona
      '', // O cualquier otro valor ficticio para la dirección de la persona
      '', // O cualquier otro valor ficticio para el estado de la persona
      '', // O cualquier otro valor ficticio para el municipio de la persona
      '', // O cualquier otro valor ficticio para la fecha de nacimiento de la persona
      '', // O cualquier otro valor ficticio para la edad de la persona
      '', // O cualquier otro valor ficticio para el teléfono de la persona
      '', // O cualquier otro valor ficticio para el email de la persona
      '', // O cualquier otro valor ficticio para el sexo de la persona
      '', // O cualquier otro valor ficticio para la ocupación de la persona
      '', // O cualquier otro valor ficticio para los detalles de la persona
      '', // O cualquier otro valor ficticio para la fecha de creación de la persona
      false, // O cualquier otro valor ficticio para el campo activo de la persona
    ),
  );

  return persona.idPersona;
}

void obtenerGrupos() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('https://localhost:44305/api/grupos'));
      if (response.statusCode == 200) {
        final parsedJson = json.decode(response.body);

        setState(() {
          listaGrupos = (parsedJson as List)
              .map((item) => Grupo(
                    item['ID_GRUPO'],
                    item['ID_TIPO_GRUPO'],
                    item['NOMBRE'],
                    item['DETALLES'],
                    item['FECHA_CREACION'],
                    item['ACTIVO'],
                  ))
              .toList();
          isLoading = false;
        });
        //print('Grupos obtenidos: $listaGrupos'); // Agrega este mensaje de depuración
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

class GroupType {
  final int id;
  final String nombre;
  final String descripcion;
  bool activo;

  GroupType(this.id, this.nombre, this.descripcion, this.activo);
}


class Grupo {
  final int idGrupo;
  final int idTipoGrupo;
  final String nombre;
  final String detalles;
  final String fechaCreacion;
  final bool activo;

  Grupo(this.idGrupo, this.idTipoGrupo, this.nombre, this.detalles,
      this.fechaCreacion, this.activo);
}




  /* void enviarDatos() {
    final usuario = _usuarioController.text;
    final nombre = _nombreController.text;
    final pass = _passController.text;

    final usuarios = {
      'USUARIO': usuario,
      'NOMBRE': nombre,
      'PASSWORD': pass,
    };

    http.post(
      Uri.parse('https://localhost:44305/api/usuarios'),
      body: jsonEncode(usuarios),
      headers: {'Content-Type': 'application/json'},
    ).then((response) {
      if (response.statusCode == 201) {
        Navigator.of(context).pop(true); // Indica que se agregó correctamente
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario agregado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al agregar el usuario'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al agregar el usuario'),
          backgroundColor: Colors.red,
        ),
      );
    });
  } */

