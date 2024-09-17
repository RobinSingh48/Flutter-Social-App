import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseFirestoreDatabase {
  User? user = FirebaseAuth.instance.currentUser;

  CollectionReference firestoreDatabase =
      FirebaseFirestore.instance.collection("Posts");

  CollectionReference userDatabase =
      FirebaseFirestore.instance.collection("Users");

  Future<void> addPost({String? post, String? userEmail}) {
    return firestoreDatabase.add({
      "UserEmail": userEmail,
      "Post": post,
      "TimeStamp": Timestamp.now(),
      "Likes": [],
    });
  }

  Stream<QuerySnapshot> getPostStream() {
    final streamPost =
        firestoreDatabase.orderBy("TimeStamp", descending: true).snapshots();
    return streamPost;
  }

  Future<void> addUserDetials({String? userName, String? email}) async {
    try {
      userDatabase.doc(email).set({
        "username": "$userName",
        "bio": "empty bio",
      });
    } catch (e) {
      Text("Error adding user details: $e");
    }
  }

  Future<void> updateUserDetials({String? title, String? text}) {
    return userDatabase.doc(user!.email).update({
      "$title": text,
    });
  }
}
