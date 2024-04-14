import 'package:flutter/material.dart';

class ComunicacionScreen extends StatefulWidget {
  final String username;

  const ComunicacionScreen({Key? key, required this.username})
      : super(key: key);

  @override
  _ComunicacionScreenState createState() => _ComunicacionScreenState();
}

class _ComunicacionScreenState extends State<ComunicacionScreen> {
  String _selectedMenu = 'Avisos';

  List<Aviso> _avisos = [
    Aviso(
      tipo: 'General',
      descripcion: 'Recordatorio de reunión de padres de familia',
      autor: 'Coordinación',
      destinatario: 'Padres de familia',
      fechaCreacion: '10/04/2024',
    ),
    Aviso(
      tipo: 'Personal',
      descripcion: 'Cambio de horario de clases el próximo viernes',
      autor: 'Emiliano Cruz',
      destinatario: 'Alumnos',
      fechaCreacion: '08/04/2024',
    ),
    Aviso(
      tipo: 'Personal',
      descripcion: 'Cambio de horario de clases el próximo viernes',
      autor: 'Emiliano Cruz',
      destinatario: 'Alumnos',
      fechaCreacion: '08/04/2024',
    ),
    Aviso(
      tipo: 'Personal',
      descripcion: 'Cambio de horario de clases el próximo viernes',
      autor: 'Emiliano Cruz',
      destinatario: 'Alumnos',
      fechaCreacion: '08/04/2024',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
        title: Center(
          child: Text(
            'Comunicación',
            style: TextStyle(color: Colors.white),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Color(0xFFE5E5E5),
        child: Column(
          children: [
            // Menú principal
            Container(
              margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
              ),
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMenu = 'Avisos';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: _selectedMenu == 'Avisos'
                            ? Color.fromARGB(255, 14, 47, 117)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Avisos',
                        style: TextStyle(
                            color: _selectedMenu == 'Avisos'
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMenu = 'Citas';
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      decoration: BoxDecoration(
                        color: _selectedMenu == 'Citas'
                            ? Color.fromARGB(255, 14, 47, 117)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Text(
                        'Citas',
                        style: TextStyle(
                            color: _selectedMenu == 'Citas'
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Recuadro botones filtros
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    //color: Colors.red,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 14, 47, 117))),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Tipo',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    //color: Colors.red,
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color.fromARGB(255, 14, 47, 117))),
                      onPressed: () {},
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          'Fecha',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Tabla de Avisos
            _selectedMenu == 'Avisos'
                ? Expanded(
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: SingleChildScrollView(
                        child: DataTable(
                          columnSpacing: 10,
                          dataRowMaxHeight: 100,
                          dataRowMinHeight: 50,
                          horizontalMargin: 20,
                          columns: [
                            DataColumn(
                                label: SizedBox(
                              width: screenWidth * 0.1,
                              child: Text(
                                'Tipo',
                                style: TextStyle(fontSize: 12),
                              ),
                            )),
                            DataColumn(
                                label: SizedBox(
                              width: screenWidth * 0.18,
                              child: Text(
                                'Detalles',
                                style: TextStyle(fontSize: 12),
                              ),
                            )),
                            DataColumn(
                                label: SizedBox(
                              width: screenWidth * 0.1,
                              child: Text(
                                'Autor',
                                style: TextStyle(fontSize: 12),
                              ),
                            )),
                            DataColumn(
                                label: SizedBox(
                              width: screenWidth * 0.15,
                              child: Text(
                                'Receptor',
                                style: TextStyle(fontSize: 12),
                              ),
                            )),
                            DataColumn(
                                label: SizedBox(
                              width: screenWidth * 0.15,
                              child: Text(
                                'Fecha',
                                style: TextStyle(fontSize: 12),
                              ),
                            )),
                          ],
                          rows: _avisos
                              .map(
                                (aviso) => DataRow(cells: [
                                  DataCell(Text(aviso.tipo,
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text(aviso.descripcion,
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text(aviso.autor,
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text(aviso.destinatario,
                                      style: TextStyle(fontSize: 10))),
                                  DataCell(Text(aviso.fechaCreacion,
                                      style: TextStyle(fontSize: 10))),
                                ]),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                  )
                : SizedBox(), // Espacio vacío si no está seleccionado Avisos
            // Botones Inferiores
            Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(color: Colors.white),
              padding: EdgeInsets.symmetric(vertical: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 10.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFFB80000),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Nuevo Aviso General',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 10.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Color(0xFFB80000),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        'Nuevo Aviso Personal',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Barra de búsqueda
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: const TextField(
                // controller: ,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Buscar alumno',
                  hintStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors
                          .black, // Cambia el color del borde según sea necesario
                      width:
                          2.0, // Cambia el grosor del borde según sea necesario
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Aviso {
  final String tipo;
  final String descripcion;
  final String autor;
  final String destinatario;
  final String fechaCreacion;

  Aviso({
    required this.tipo,
    required this.descripcion,
    required this.autor,
    required this.destinatario,
    required this.fechaCreacion,
  });
}

void main() {
  runApp(MaterialApp(
    home: ComunicacionScreen(username: 'example_username'),
  ));
}
