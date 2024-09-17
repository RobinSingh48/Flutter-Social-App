import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/component/my_error_message.dart';
import 'package:flutter_social_app/firestore_data/firebase_firestore_database.dart';

class FirebaseAuthDatabase {
  final FirebaseFirestoreDatabase firebaseFirestoreDatabase =
      FirebaseFirestoreDatabase();
  Future<UserCredential?> registerUser(
      TextEditingController email,
      TextEditingController password,
      TextEditingController confirmPassword,
      BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    if (password.text != confirmPassword.text) {
      Navigator.pop(context);
      myErrorMessage(context, "Password not matched");
      return null;
    }

    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email.text)) {
      Navigator.pop(context);
      myErrorMessage(context, "Invalid email");
      return null;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text);

      await firebaseFirestoreDatabase.addUserDetials(
          email: userCredential.user!.email,
          userName: email.text.split("@")[0]);

      if (context.mounted) Navigator.pop(context);

      email.clear();
      password.clear();
      confirmPassword.clear();

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (context.mounted) Navigator.pop(context);
      myErrorMessage(context, e.code);
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      myErrorMessage(context, "Registration failed: ${e.toString()}");
    }

    return null;
  }

  Future<void> loginUser(BuildContext context, TextEditingController email,
      TextEditingController password) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Validate email
      if (!RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$').hasMatch(email.text)) {
        Navigator.pop(context);
        myErrorMessage(context, "Invalid Email");
        return;
      }

      // Validate password
      if (password.text.isEmpty) {
        Navigator.pop(context);
        myErrorMessage(context, "Error: password not entered");
        return;
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      myErrorMessage(context, "Login Failed: ${e.toString()}");
    }
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }
}
