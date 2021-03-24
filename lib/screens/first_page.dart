import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/timeline.dart';
import '../screens/activity_feed.dart';
import '../screens/search.dart';
import '../screens/upload.dart';
import '../screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../screens/create_users.dart';
import '../models/user.dart';
import 'package:firebase_storage/firebase_storage.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
final Reference storageRef = FirebaseStorage.instance.ref();

final usersRef = FirebaseFirestore.instance.collection('users');
final postsRef = FirebaseFirestore.instance.collection('posts');
final commentsRef = FirebaseFirestore.instance.collection('comments');
final activityFeedRef = FirebaseFirestore.instance.collection('feed');

final DateTime timestamp = DateTime.now();
User currentUser;

class FirstScreen extends StatefulWidget {
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  bool isAuth = false;
  PageController pageController;
  int pageIndex = 0;
  bool isSelected = false;

  @override
  void initState() {
    pageController = PageController();

    // Detect when user signed in
    super.initState();
    googleSignIn.onCurrentUserChanged.listen((account) {
      handleSignIn(account);
    }, onError: (err) {
      print('Error Signing in : $err');
    });

    // Reauthenticate user when app restart
    googleSignIn
        .signInSilently(suppressErrors: false)
        .then((account) => handleSignIn(account))
        .catchError((err) {
      print('Error Signing in : $err');
    });
  }

  handleSignIn(GoogleSignInAccount account) {
    if (account != null) {
      createUsersInFirestore();
      setState(() {
        isAuth = true;
      });
    } else {
      setState(() {
        isAuth = false;
      });
    }
  }

  createUsersInFirestore() async {
    // 1) check if users exists in database (according to id)

    final GoogleSignInAccount user = googleSignIn.currentUser;
    DocumentSnapshot doc = await usersRef.doc(user.id).get();
    // 2) if not then take the user to create account page
    if (!doc.exists) {
      final username = await Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateUsers()));

      // 3) get username from create account , use it to make new user document in database
      usersRef.doc(user.id).set({
        "id": user.id,
        "username": username,
        "photoUrl": user.photoUrl,
        "email": user.email,
        "displayName": user.displayName,
        "bio": '',
        "timeStamp": timestamp,
      });

      doc = await usersRef.doc(user.id).get();
    }
    currentUser = User.fromDocument(doc);
    print(currentUser);
    print(currentUser.username);
  }

  login() {
    googleSignIn.signIn();
  }

  logout() {
    googleSignIn.signOut();
  }

  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController.animateToPage(pageIndex,
        duration: Duration(milliseconds: 300), curve: Curves.bounceInOut);
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: [
          Timeline(),
          ActivityFeed(),
          Upload(currentUser: currentUser),
          Search(),
          Profile(profileId: currentUser?.id),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        // physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.blueGrey[900],
        currentIndex: pageIndex,
        onTap: onTap,
        activeColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_a_photo,
              size: 35.0,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
  }

  Scaffold buildUnAuthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.teal[300], Theme.of(context).accentColor],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/logo_gram.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              'SocialGram',
              style: TextStyle(
                  fontSize: 70.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'KaushanScript'),
            ),
            SizedBox(
              width: double.infinity,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: GestureDetector(
                onTap: () => login(),
                child: Container(
                  height: 50.0,
                  width: 240,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                        image: AssetImage('images/googlesignin.png'),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            // SizedBox(
            //   width: double.infinity,
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isAuth ? buildAuthScreen() : buildUnAuthScreen();
  }
}
