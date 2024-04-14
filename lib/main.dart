import 'package:flutter/material.dart';
import 'package:educame/BNavigation/bottom_nav.dart';
import 'package:educame/BNavigation/routes.dart';
import 'package:educame/screens/home.dart';
import 'package:educame/screens/login.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting('es'); // Inicializar la localización en español
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        const Locale('es'),
      ],
      // locale: const Locale('es'), // Establecer el idioma en español (opcional)
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff6750a4),
        useMaterial3: true,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Scaffold(
          bottomNavigationBar: constraints.maxWidth >= 600
              ? null
              : BNavigator(
                  selectedIndex: index,
                  updateIndex: (int i) {
                    setState(() {
                      index = i;
                    });
                  },
                ),
          body: Row(
            children: [
              if (constraints.maxWidth >= 600)
                NavigationRail(
                  elevation: 5,
                  minWidth: 150,
                  labelType: NavigationRailLabelType.all,
                  selectedLabelTextStyle: TextStyle(color: Colors.white),
                  unselectedLabelTextStyle: TextStyle(color: Colors.white),
                  backgroundColor: Color(0xFF001D82),
                  indicatorColor: Color(0xFF3858DF),
                  useIndicator: true,
                  selectedIndex: index,
                  onDestinationSelected: (int i) {
                    setState(() {
                      index = i;
                    });
                  },
                  destinations: const <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.home,
                        color: Colors.white,
                      ),
                      label: Text('Inicio',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.library_books, color: Colors.white),
                      label: Text('Usuarios',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.message, color: Colors.white),
                      label: Text('Comunicación',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person, color: Colors.white),
                      label: Text('Perfil',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              Expanded(
                child: Routes(index: index, username: widget.username),
              ),
            ],
          ),
        );
      },
    );
  }
}
