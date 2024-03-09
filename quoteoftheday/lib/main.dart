import 'package:flutter/material.dart';
import 'package:quoteoftheday/screens/favourite_screen.dart';

import 'screens/home_screen.dart';

List<Widget> _widgetOptions = <Widget>[
  HomeScreen(),
  FavouriteScreen(),
];
int _selectedIndex = 0;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().init();
  NotificationService().scheduleDailyNotification();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quote of the Day',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.blueGrey,
            currentIndex: _selectedIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorite',
              ),
            ],
            onTap: (value) {
              setState(() {
                _selectedIndex = value;
              });
            }),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
