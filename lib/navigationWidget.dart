import 'package:flutter/material.dart';
import 'package:jchatapp/profile/profileWidget.dart';

class NavigationScreen extends StatefulWidget {
  late Map<dynamic, dynamic> data;

  NavigationScreen(Map<dynamic, dynamic> given_data) {
    data = given_data;
  }

  @override
  NavigationHome createState() => NavigationHome(data);
}


class NavigationHome extends State<NavigationScreen> {
  late Map<dynamic, dynamic> data;
  int currentPageIndex = 4;


  NavigationHome(Map<dynamic, dynamic> given_data) {
    data = given_data;
  }

  @override
  void dispose() {
    super.dispose();
  }

  static Widget getTitle() {
    return Container(
        height: 80,
        width: double.infinity,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(64, 64, 64, 1)
        ),
        child: const Column(children: [
          SizedBox(height: 40.0),
          Row(children: [
          Text("  JChat", style: TextStyle(color: Colors.purpleAccent, fontWeight: FontWeight.bold, fontSize: 25))
        ])])
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          navigationBarTheme: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.resolveWith((state) {
              if (state.contains(MaterialState.selected)) {
                return const TextStyle(color: Color.fromRGBO(207, 207, 207, 1));
              }
              return const TextStyle(color: Color.fromRGBO(143, 143, 143, 1));
            })
          )),
      home: Scaffold(
      bottomNavigationBar: NavigationBar(destinations: const [
        NavigationDestination(icon: Icon(Icons.people_alt, color: Color.fromRGBO(163, 163, 163, 1)), label: 'Groups'),
        NavigationDestination(icon: Icon(Icons.people_outline, color: Color.fromRGBO(163, 163, 163, 1)), label: 'Friends'),
        NavigationDestination(icon: Icon(Icons.newspaper, color: Color.fromRGBO(163, 163, 163, 1)), label: 'Posts'),
        NavigationDestination(icon: Icon(Icons.shopping_bag_sharp, color: Color.fromRGBO(163, 163, 163, 1)), label: 'Shop'),
        NavigationDestination(icon: Icon(Icons.person_sharp, color: Color.fromRGBO(163, 163, 163, 1)), label: 'Profile'),
      ],
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: const Color.fromRGBO(64, 64, 64, 1),
        shadowColor: const Color.fromRGBO(64, 64, 64, 1),
        indicatorColor: const Color.fromRGBO(237, 237, 237, 1),
        indicatorShape: const CircleBorder()
      ),
        body: [Text("Groups"), Text("Friends"), Text("Posts"), Text("Shop"), ProfileScreen(data)][currentPageIndex]
    ));
  }
}
