import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_gram/screens/first_page.dart';
import '../models/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/progress.dart';

class EditProfile extends StatefulWidget {
  final String currentUserId;

  EditProfile({this.currentUserId});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  bool _diaplayNameValid = true;
  bool _bioValid = true;

  User user;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    setState(() {
      isLoading = true;
    });
    DocumentSnapshot doc = await usersRef.doc(widget.currentUserId).get();
    user = User.fromDocument(doc);
    displayNameController.text = user.displayName;
    bioController.text = user.bio;
    setState(() {
      isLoading = false;
    });
  }

  Column buildDisplayNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Display Name',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: displayNameController,
          decoration: InputDecoration(
            hintText: "Update Display Name",
            errorText: _diaplayNameValid ? null : "Display Name is too short",
          ),
        ),
      ],
    );
  }

  Column buildBioField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.0),
          child: Text(
            'Bio',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextField(
          controller: bioController,
          decoration: InputDecoration(
            hintText: "Update Bio",
            errorText: _bioValid ? null : "Bio is too long",
          ),
        ),
      ],
    );
  }

  updateProfileData() {
    setState(() {
      displayNameController.text.trim().length < 3 ||
              displayNameController.text.isEmpty
          ? _diaplayNameValid = false
          : _diaplayNameValid = true;
      bioController.text.length > 100 ? _bioValid = false : _bioValid = true;
    });
    if (_diaplayNameValid && _bioValid) {
      usersRef.doc(widget.currentUserId).update({
        "displayName": displayNameController.text,
        "bio": bioController.text
      });
      SnackBar snackbar = SnackBar(content: Text("Profile Updated!"));
      _scaffoldKey.currentState.showSnackBar(snackbar);
    }
  }

  logout() async {
    googleSignIn.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FirstScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.done,
              size: 30.0,
              color: Colors.green,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: isLoading
          ? circularProgress()
          : ListView(
              children: [
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 16.0, bottom: 8.0),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 50.0,
                          backgroundImage:
                              CachedNetworkImageProvider(user.photoUrl),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            buildDisplayNameField(),
                            buildBioField(),
                          ],
                        ),
                      ),
                      RaisedButton(
                        onPressed: updateProfileData,
                        child: Text(
                          "Update Profile",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: FlatButton.icon(
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                          label: Text(
                            'Logout',
                            style: TextStyle(color: Colors.red, fontSize: 20.0),
                          ),
                          onPressed: logout,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
