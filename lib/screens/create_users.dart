import 'package:flutter/material.dart';
import '../widgets/header.dart';

class CreateUsers extends StatefulWidget {
  @override
  _CreateUsersState createState() => _CreateUsersState();
}

class _CreateUsersState extends State<CreateUsers> {
  String username;

  final _formKey = GlobalKey<FormState>();

  submit() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      Navigator.pop(context, username);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: 'Set up your profile'),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 25.0),
                  child: Center(
                    child: Text(
                      'Create a username',
                      style: TextStyle(fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: TextFormField(
                        validator: (value) {
                          if (value.trim().length < 3 || value.isEmpty) {
                            return "Username is too short...";
                          } else if (value.trim().length > 12) {
                            return "Username is too long...";
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => username = value,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Username',
                            labelStyle: TextStyle(fontSize: 15.0),
                            hintText: 'Must be atleast 3 characters'),
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: submit,
                  color: Colors.teal,
                  // child: Container(
                  //   decoration: BoxDecoration(
                  //     color: Colors.teal,
                  //     borderRadius: BorderRadius.circular(7.0),
                  //   ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
