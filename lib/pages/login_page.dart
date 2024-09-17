import 'package:flutter/material.dart';
import 'package:flutter_social_app/component/my_button.dart';
import 'package:flutter_social_app/component/my_textfield.dart';
import 'package:flutter_social_app/firebase_auth/firebase_auth.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;
  LoginPage({super.key, required this.onTap});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final FirebaseAuthDatabase authDatabase = FirebaseAuthDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person,
                size: 100,
              ),
              const Text(
                "Welcome to Flutter Family",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 15,
              ),
              MyTextfield(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextfield(
                controller: passController,
                hintText: "Password",
                obscureText: true,
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                text: "L O G I N",
                onTap: () => authDatabase.loginUser(
                    context, emailController, passController),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have a Account?",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      " Register Here",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
