import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:educame/screens/ngrupo.dart';
//import '../widgets/CardUserWidget.dart';
import 'dart:async';
import 'dart:io';

class GruposScreen extends StatefulWidget {
  final String username; // Agregar esta línea
  const GruposScreen({Key? key, required this.username}) : super(key: key);

  @override
  State<GruposScreen> createState() => _GruposScreenState();
}

class _GruposScreenState extends State<GruposScreen> {
  int selectedIndex = -1;
  //String selectedGroupType = 'Todos';

  late Timer timer;

  //LISTAS
  List<Usuario> listausuarios = [];
  List<Persona> listapersonas = [];
  List<GrupoPersona> listaGrupoPersona = [];
  List<GroupType> listaTipoGrupos = [];
  List<Grupo> listaGrupos = [];
  List<Grupo> filteredGrupos = []; // Lista filtrada que se muestra en la tabla
  bool isTodosSelected = false; // Nuevo estado para el botón "Todos"

  List<bool> isSelected = [];
  //bool _isSelected =   false; // Agregamos esta variable para controlar la selección

  //int _selectedIndex = -1; // Índice de la fila seleccionada

  //bool _isDraggableSheetOpen = false;

  bool isLoading = true;
  bool showErrorDialog = false;
  String username = '';
  String nombre = '';
  String formattedDate =
      DateFormat('EEEE, d MMMM yyyy', 'es').format(DateTime.now());
  String formattedDateTime = DateFormat('h:mm:ss a').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    obtenerusuarios();
    username = widget.username;
    obtenerTipoGrupos();
    obtenerGrupos();
    obtenerPersonas();
    obtenerGrupoPersona();
    isSelected = List<bool>.filled(listaTipoGrupos.length, true);
    isTodosSelected = true;
    _actualizarGruposFiltrados(); // Llamamos a la función para aplicar el filtro al inicio

    print('Tipo de Grupos: $listaTipoGrupos');
    print('Grupos: $listaGrupos');

    // Actualizar la fecha y la hora cada segundo
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        formattedDate =
            DateFormat('EEEE, d MMMM yyyy', 'es').format(DateTime.now());
        formattedDateTime = DateFormat('h:mm:ss a').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    // Cancelar el temporizador en el método dispose()
    timer.cancel();
    super.dispose();
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
    bool isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Color(0xFFEFEFEF),
      appBar: isMobile
          ? AppBar(
              automaticallyImplyLeading: false,
              title: Text(''),
              toolbarHeight: 0,
            )
          : null,
      body: Stack(
        children: [
          content(isMobile),
          if (isMobile) floatingActionButton(),
        ],
      ),
    );
  }

  // Función para actualizar la lista de grupos filtrados según el estado del botón "Todos" y botones de tipo de grupo seleccionados
  void _actualizarGruposFiltrados() {
    setState(() {
      if (isTodosSelected) {
        // Si se selecciona el botón "Todos", mostrar todos los grupos sin filtrar
        filteredGrupos = listaGrupos;
      } else {
        // Filtrar los grupos basados en el ID_TIPO_GRUPO seleccionado
        filteredGrupos = listaGrupos
            .where((grupo) => isSelected[grupo.idTipoGrupo - 1])
            .toList();
      }
    });
  }

  Widget floatingActionButton() {
    return Positioned(
      bottom: 16.0,
      right: 16.0,
      child: FloatingActionButton(
        onPressed: () {
          _mostrarFormulariogrupos(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget content(bool isMobile) {
    final isDesktop = MediaQuery.of(context).size.width >= 600;
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (!isLoading && showErrorDialog) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Error al obtener datos',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showErrorDialog = false;
                });
                obtenerusuarios();
              },
              child: const Text('Recargar', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              flex: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //color: Colors.green, // Cambia el color a tu preferencia
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        fechayHora(),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    /* child: CardUserWidget(
                      username: buscarNombreUsuario(username),
                    ), */
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 10,
              child: Container(
                //color: Colors.purple, // Cambia el color a tu preferencia
                child: textoyBoton(isMobile),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Container(
                  //color: Colors.orange, // Cambia el color a tu preferencia
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // En el botón 'Agregar tipo de grupo', llama al método para mostrar el diálogo
                      ElevatedButton(
                        style: ButtonStyle(
                          surfaceTintColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: const BorderSide(
                                color: Color(0xFF001D82),
                                width: 1,
                              ),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: _showAddGroupTypeDialog,
                        child: const Text(
                          'Agregar tipo de grupo',
                          style: TextStyle(
                            color: Color(0xFF001D82),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      // Llamar al método para borrar el tipo de grupo seleccionado en el botón 'X'
                      buildDynamicToggleButtons(),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 75,
              child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: isDesktop ? tabla() : tablaMobile()),
            ),
          ],
        ),
      );
    }
  }

  // Método para imprimir el índice seleccionado en consola
  void _printSelectedIndex(int index) {
    print("Índice seleccionado: $index");
  }

  // Método para cambiar el estado de los botones
  void _onToggle(int index) {
    _actualizarGruposFiltrados(); // Llamamos a la función para aplicar el filtro después de actualizar el estado

    setState(() {
      if (index == -1) {
        // Si se selecciona el botón "Todos", mostramos todos los grupos sin filtrar
        isTodosSelected = true;
        isSelected = List<bool>.filled(listaTipoGrupos.length, false);
        filteredGrupos = listaGrupos; // Mostrar todos los grupos sin filtrar
      } else {
        isTodosSelected = false;
        for (int buttonIndex = 0;
            buttonIndex < isSelected.length;
            buttonIndex++) {
          isSelected[buttonIndex] = buttonIndex == index;
        }
        // Filtramos los grupos basados en el ID_TIPO_GRUPO seleccionado
        filteredGrupos = listaGrupos
            .where((grupo) => isSelected[grupo.idTipoGrupo - 1])
            .toList();
      }
    });
    print('Grupos Filtrados: $filteredGrupos');
    _actualizarGruposFiltrados(); // Llamamos a la función para aplicar el filtro después de actualizar el estado
  }

  // Function to build dynamic ToggleButtons
  Widget buildDynamicToggleButtons() {
    return Expanded(
      child: Flex(
        direction: Axis.horizontal,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: ElevatedButton(
              onPressed: () =>
                  _onToggle(-1), // Usamos -1 para representar el botón "Todos"
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isTodosSelected ? Color(0xFF001D82) : Colors.white,
                foregroundColor:
                    isTodosSelected ? Colors.white : Color(0xFF001D82),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(
                    color: Color(0xFF001D82),
                    width: 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Text('Todos'),
              ),
            ),
          ),
          ...listaTipoGrupos.asMap().entries.map((entry) {
            final index = entry.key;
            final groupType = entry.value;
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    onPressed: () => _onToggle(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isTodosSelected
                          ? Colors.white
                          : isSelected[index]
                              ? Color(0xFF001D82)
                              : Colors.white,
                      foregroundColor: isTodosSelected
                          ? Color(0xFF001D82)
                          : isSelected[index]
                              ? Colors.white
                              : Color(0xFF001D82),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: BorderSide(
                          color: Color(0xFF001D82),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Text(groupType.nombre),
                    ),
                  ),
                ),
                if (isSelected[index])
                  Positioned(
                    top: -2,
                    right: -2,
                    child: GestureDetector(
                      onTap: () {
                        _deleteSelectedGroupType(index);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        padding: EdgeInsets.all(2),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showAddGroupTypeDialog() {
    String nombre = '';
    String descripcion = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 300, vertical: 100),
          child: AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Text('Agregar tipo de grupo'),
            content: Container(
              width: double
                  .maxFinite, // Establecer un ancho máximo para permitir el desplazamiento
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      nombre = value;
                    },
                    decoration: InputDecoration(labelText: 'Nombre'),
                  ),
                  TextField(
                    onChanged: (value) {
                      descripcion = value;
                    },
                    decoration: InputDecoration(labelText: 'Descripción'),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nombre.isNotEmpty && descripcion.isNotEmpty) {
                    // Realizar el POST a la API para agregar el nuevo tipo de grupo
                    final newGroupType = {
                      'NOMBRE': nombre,
                      'DESCRIPCION': descripcion,
                      'ACTIVO': true,
                    };
                    final response = await http.post(
                      Uri.parse('https://localhost:44305/api/tipogrupos'),
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode(newGroupType),
                    );

                    if (response.statusCode == 201) {
                      // Si el POST fue exitoso, recargar los tipos de grupos y reiniciar los estados
                      obtenerTipoGrupos();
                      Navigator.of(context).pop();
                      setState(() {
                        isSelected = List.generate(
                            listaTipoGrupos.length, (index) => false);
                      });
                    }
                  }
                },
                child: Text('Agregar'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteSelectedGroupType(int index) async {
    int selectedIndex = isSelected.indexOf(true);
    if (selectedIndex != -1) {
      final selectedGroupType = listaTipoGrupos[selectedIndex];

      if (filteredGrupos.isNotEmpty) {
        // Mostrar mensaje de advertencia porque hay grupos asociados al tipo seleccionado
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('No es posible eliminar'),
              content: Text(
                  'El tipo de grupo contiene datos relacionados y no puede ser eliminado.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else {
        // Puedes mantener el código de eliminación aquí si la lista de grupos filtrados está vacía
        // y ejecutar la eliminación lógica del tipo de grupo seleccionado.
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Confirmar eliminación'),
              content: Text('¿Realmente deseas eliminar este elemento?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () async {
                    // Realizar el PUT a la API para hacer el borrado lógico
                    final deletedGroupType = {
                      'ID_TIPO_GRUPO': selectedGroupType.id,
                      'NOMBRE': selectedGroupType.nombre,
                      'DESCRIPCION': selectedGroupType.descripcion,
                      'ACTIVO': false, // Cambiar el campo ACTIVO a 0
                    };

                    final response = await http.put(
                      Uri.parse(
                          'https://localhost:44305/api/tipogrupos/${selectedGroupType.id}'),
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode(deletedGroupType),
                    );

                    if (response.statusCode == 200) {
                      // Si el PUT fue exitoso, recargar los tipos de grupos y reiniciar los estados
                      obtenerTipoGrupos();
                      setState(() {
                        isSelected = List.generate(
                            listaTipoGrupos.length, (index) => false);
                      });
                    }

                    // Cerrar el cuadro de diálogo después de eliminar
                    Navigator.of(context).pop();
                  },
                  child: Text('Eliminar'),
                ),
              ],
            );
          },
        );
      }
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
        //print('Tipos de Grupos obtenidos: $listaTipoGrupos'); // Agrega este mensaje de depuración
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

  void obtenerGrupoPersona() async {
  setState(() {
    isLoading = true;
  });

  try {
    final response =
        await http.get(Uri.parse('https://localhost:44305/api/grupopersona'));
    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);

      setState(() {
        // Filtrar la lista de tipos de grupos que tengan el campo ACTIVO en 0
        listaGrupoPersona = (parsedJson as List)
            .map((item) => GrupoPersona(
                  item['ID_GRUPO_PERSONA'],
                  item['ID_PERSONA'],
                  item['ID_GRUPO'],
                  item['ACTIVO'],
                ))
            .where((GrupoPersona) => GrupoPersona.activo == true)
            .toList();

        isSelected = List.generate(listaGrupoPersona.length, (index) => false);
        isLoading = false;
      });

      // Agrega mensajes de depuración para verificar el contenido de la lista
      print('Lista de GrupoPersona: $listaGrupoPersona');
      print('Tamaño de la lista: ${listaGrupoPersona.length}');
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


  Widget cardUser() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(
                5, 5), // Cambia la dirección de la sombra según tus necesidades
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(right: 50),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.account_circle),
          SizedBox(width: 8),
          Text(
            buscarNombreUsuario(username),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget fechayHora() {
    String formattedDate =
        DateFormat('EEEE, d MMMM yyyy', 'es').format(DateTime.now());
    formattedDate =
        capitalizeFirstLetter(formattedDate); // Capitalizar la primera letra

    String formattedDateTime =
        DateFormat('h:mm:ss a', 'es').format(DateTime.now());

    return FittedBox(
      fit: BoxFit.contain,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            formattedDate,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 10),
          Text(
            formattedDateTime,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    return text.replaceFirst(text[0], text[0].toUpperCase());
  }

  Widget textoyBoton(bool isMobile) {
    if (isMobile) {
      return Container(
        alignment: Alignment.centerLeft,
        child: const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            'Grupos',
            style: TextStyle(
              //color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
                  'Grupos',
                  style: TextStyle(
                    //color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.only(right: 50),
                child: ElevatedButton(
                  onPressed: () {
                    _mostrarFormulariogrupos(context);
                  },
                  style: ButtonStyle(
                    surfaceTintColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Color(0xFF001D82),
                          width: 2,
                        ),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                    child: Text(
                      'Nuevo Grupo',
                      style: TextStyle(
                        color: Color(0xFF001D82),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget tablaMobile() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                columnSpacing: 40,
                dataRowHeight: 70,
                columns: [
                  DataColumn(
                      label: Text('Nombre',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Ocupación',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(
                      label: Text('Edad',
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: listapersonas.map((p) {
                  return DataRow(cells: [
                    DataCell(Text(p.nombre)),
                    DataCell(Text(p.ocupacion)),
                    DataCell(Text(p.edad)),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget tabla() {
    _actualizarGruposFiltrados();
    double fontsizecell = 12;

    // Verificar si hay grupos filtrados
    if (filteredGrupos.isEmpty) {
      return const Center(
        child: Text('No hay grupos disponibles para el tipo seleccionado.'),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                showCheckboxColumn: false,
                columnSpacing: 10,
                columns: const [
                  DataColumn(
                    label: Text('Tipo de Grupo',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Nombre',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Detalles',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  DataColumn(
                    label: Text('Fecha de Creación',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
                rows: filteredGrupos.map((lg) {
                  final fechaCreacion = DateTime.parse(lg.fechaCreacion);
                  final formattedFecha =
                      DateFormat.yMMMMd('es').format(fechaCreacion);
                  final formattedHora =
                      DateFormat('h:mm a', 'es').format(fechaCreacion);

                  // Buscar el nombre del tipo de grupo correspondiente al idTipoGrupo
                  final groupType = listaTipoGrupos.firstWhere(
                    (type) => type.id == lg.idTipoGrupo,
                    orElse: () => GroupType(-1, 'Desconocido', '', false),
                  );

                  return DataRow(
                    cells: [
                      DataCell(Text(
                        groupType.nombre.toString(),
                        style: TextStyle(fontSize: fontsizecell),
                      )),
                      DataCell(Text(
                        lg.nombre,
                        style: TextStyle(fontSize: fontsizecell),
                      )),
                      DataCell(Text(
                        lg.detalles,
                        style: TextStyle(fontSize: fontsizecell),
                      )),
                      DataCell(Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$formattedFecha, $formattedHora',
                            style: TextStyle(fontSize: fontsizecell),
                          ),
                        ],
                      )),
                    ],
                    // Agregar InkWell alrededor del DataRow
                    // Esto permitirá detectar los toques en la fila
                    onSelectChanged: (isSelected) {
                      _onRowTapped(
                          lg); // Llamamos a la función cuando se toque una fila
                    },
                    color: MaterialStateColor.resolveWith(
                      (states) {
                        if (states.contains(MaterialState.selected)) {
                          return Colors.blue.withOpacity(
                              0.1); // Color azul bajito cuando está seleccionada la fila
                        } else if (states.contains(MaterialState.hovered)) {
                          return Colors.blue.withOpacity(
                              0.2); // Color azul bajito cuando el mouse está encima
                        }
                        return Colors
                            .transparent; // Color transparente cuando no se cumple ninguna condición
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
  

  void _showGroupDetailsDialog(Grupo grupo) {
  double verticalSpacing = 10;
  final fechaCreacion = DateTime.parse(grupo.fechaCreacion);
  final formattedFecha = DateFormat.yMMMMd('es').format(fechaCreacion);
  final formattedHora = DateFormat('h:mm a', 'es').format(fechaCreacion);

  // Verificación adicional para asegurarse de que listaGrupoPersona tenga datos
  if (listaGrupoPersona.isEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sin detalles disponibles'),
          content: Text('No hay datos disponibles para mostrar los detalles del grupo.'),
          actions: [
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return;
  }

  final groupType = listaTipoGrupos.firstWhere(
    (type) => type.id == grupo.idTipoGrupo,
    orElse: () => GroupType(-1, 'Desconocido', '', false),
  );

  final integrantesGrupo = listaGrupoPersona
      .where(
        (integrante) => integrante.idGrupo == grupo.idGrupo,
      )
      .toList();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          'Detalles del Grupo',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.3,
                maxHeight: MediaQuery.of(context).size.height * 0.3,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 50),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                text: 'Tipo de Grupo: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '${groupType.nombre}'),
                            ],
                          ),
                        ),
                        SizedBox(height: verticalSpacing),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                text: 'Nombre: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '${grupo.nombre}'),
                            ],
                          ),
                        ),
                        SizedBox(height: verticalSpacing),
                        RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: [
                              TextSpan(
                                text: 'Detalles: ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: '${grupo.detalles}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 100),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 50),
                        Text(
                          'Integrantes del Grupo:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        if (integrantesGrupo.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: integrantesGrupo.map((integrante) {
                              final persona = listapersonas.firstWhere(
                                (p) => p.idPersona == integrante.idPersona,
                                orElse: () => Persona(
                                  -1,
                                  'Persona desconocida',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  '',
                                  false,
                                ),
                              );
                              return Text(
                                  '• ${persona.nombre} ${persona.apellidoP} ${persona.apellidoM}');
                            }).toList(),
                          ),
                        if (integrantesGrupo.isEmpty)
                          Text('Este grupo no tiene integrantes.'),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Row(
            children: [
              SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Container(
                  child: RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style,
                      children: [
                        TextSpan(
                          text: 'Fecha de Creación: ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '$formattedFecha, $formattedHora'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            child: Text('Cerrar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}



// Modificar el método _onRowTapped para mostrar la ventana emergente
  void _onRowTapped(Grupo grupo) {
    // Aquí puedes hacer cualquier acción adicional que necesites al seleccionar una fila
    // Por ejemplo, puedes resaltar la fila o realizar otra acción específica.

    // Luego, mostrar la ventana emergente con los detalles del grupo
    print('Grupo seleccionado: ${grupo.idGrupo}');
    _showGroupDetailsDialog(grupo);
  }

  void obtenerusuarios() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('https://localhost:44305/api/usuarios'));
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

  void _mostrarFormulariogrupos(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      PageRouteBuilder(
        transitionDuration:
            Duration.zero, // Establece la duración de transición como cero
        pageBuilder: (context, animation, secondaryAnimation) =>
            NGrupo(nombre: buscarNombreUsuario(username)),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child, // Establece una transición nula
      ),
    );

    if (result == true) {
      obtenerusuarios();
    obtenerTipoGrupos();
    obtenerGrupos();
    obtenerPersonas();
    obtenerGrupoPersona();
    isSelected = List<bool>.filled(listaTipoGrupos.length, true);
    isTodosSelected = true;
    _actualizarGruposFiltrados(); // Llamamos a la función para aplicar el filtro al inicio
    }
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

        // Agrega un mensaje de depuración para verificar los datos obtenidos
        print('Datos obtenidos de PERSONAS: $listapersonas');
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

class GroupType {
  final int id;
  final String nombre;
  final String descripcion;
  bool activo;

  GroupType(this.id, this.nombre, this.descripcion, this.activo);
}

class GrupoPersona {
  final int id;
  final int idPersona;
  final int idGrupo;
  bool activo;

  GrupoPersona(this.id, this.idPersona, this.idGrupo, this.activo);
}
