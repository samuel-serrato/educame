import 'package:flutter/material.dart';

class BNavigator extends StatefulWidget {
  final int selectedIndex;
  final Function(int) updateIndex;

  const BNavigator({
    Key? key,
    required this.selectedIndex,
    required this.updateIndex,
  }) : super(key: key);

  @override
  _BNavigatorState createState() => _BNavigatorState();
}

class _BNavigatorState extends State<BNavigator> {
  late int index;
  bool isDesktop = false;

  @override
  void initState() {
    super.initState();
    index = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    isDesktop = mediaQuery.size.width >= 600;

    if (isDesktop) {
      return NavigationRail(
        selectedIndex: index,
        onDestinationSelected: (int i) {
          if (i >= 0 && i < 4) {
            setState(() {
              index = i;
              widget.updateIndex(i);
            });
          }
        },
        // Destinos del NavigationRail...
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
            icon: Icon(Icons.groups, color: Colors.white),
            label: Text('Comunicación',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text('Perfil',
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      );
    } else {
      return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF001D82),
        unselectedItemColor: Colors.black,
        currentIndex: index,
        onTap: (int i) {
          if (i >= 0 && i < 4) {
            setState(() {
              index = i;
              widget.updateIndex(i);
            });
          }
        },
        // Ítems del BottomNavigationBar...
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Usuarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Comunicación',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      );
    }
  }
}
