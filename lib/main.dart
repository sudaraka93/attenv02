import 'package:attenv02/login_page.dart';
import 'package:attenv02/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home:HomeView(),
    );
  }
}
class HomeView extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}
class _MainPageState extends State<HomeView> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:(LoginPage()),
    );
  }
}

