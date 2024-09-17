import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/firebase_auth/login_or_register.dart';
import 'package:flutter_social_app/pages/homepage.dart';

class CheckUserLoginOrnot extends StatefulWidget {
  const CheckUserLoginOrnot({super.key});

  @override
  State<CheckUserLoginOrnot> createState() => _CheckUserLoginOrnotState();
}

class _CheckUserLoginOrnotState extends State<CheckUserLoginOrnot> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        }
        return const LoginOrRegister();
      },
    );
  }
}
