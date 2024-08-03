
import 'package:flutter/material.dart';
import 'package:livotj/pages/book.dart';
import 'package:livotj/pages/category.dart';
import 'package:livotj/pages/profile.dart';




class NavigatorPage extends StatefulWidget {
  const NavigatorPage({super.key});

  @override
  State<NavigatorPage> createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int _pagenumberselect = 0;

  void pageselect(int index) {
    setState(() {
      _pagenumberselect = index;
    });
  }

  List<Widget> pageslist = [
CategoryPage(),
BookPage(),
ProfilePage()

  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: pageslist[_pagenumberselect],
        bottomNavigationBar: BottomNavigationBar(fixedColor: Color.fromRGBO(238, 111, 66, 1),
          type: BottomNavigationBarType.fixed,
          currentIndex: _pagenumberselect,
          onTap: pageselect,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.window_outlined), label: "Категории"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: "Записи"),
            BottomNavigationBarItem(icon: Icon(Icons.person_2_outlined), label: "Профиль"),
          ],
        ),
      ),
    );
  }
}
