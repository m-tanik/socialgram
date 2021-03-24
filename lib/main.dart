import 'package:flutter/material.dart';
import 'screens/first_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.blueGrey[900], accentColor: Colors.purple[300]),
      home: FirstScreen(),
    );
  }
}
