import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/progress.dart';
import '../screens/first_page.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, isAppTitle: true),
      body: Center(
        child: RaisedButton(
          onPressed: () => googleSignIn.signOut(),
          child: Text('logout'),
        ),
      ),
    );
  }
}
