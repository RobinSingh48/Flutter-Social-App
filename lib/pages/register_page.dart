import 'package:flutter/material.dart';
import 'package:flutter_social_app/component/my_button.dart';
import 'package:flutter_social_app/component/my_textfield.dart';
import 'package:flutter_social_app/firebase_auth/firebase_auth.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

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
                "Join the Flutter Family",
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
              MyTextfield(
                controller: confirmPassController,
                hintText: "Confirm Password",
                obscureText: true,
              ),
              const SizedBox(
                height: 10,
              ),
              MyButton(
                text: "R E G I S T E R",
                onTap: () {
                  authDatabase.registerUser(emailController, passController,
                      confirmPassController, context);
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have a Account?",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: const Text(
                      " Login Here",
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
