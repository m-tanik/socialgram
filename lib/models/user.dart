import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  String username;
  String email;
  String photoUrl;
  String displayName;
  String bio;

  User({
    this.email,
    this.username,
    this.id,
    this.bio,
    this.displayName,
    this.photoUrl,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      email: doc['email'],
      displayName: doc['displayName'],
      bio: doc['bio'],
      username: doc['username'],
      photoUrl: doc['photoUrl'],
    );
  }
}
