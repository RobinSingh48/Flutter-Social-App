import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/component/text_box.dart';

import 'package:flutter_social_app/firestore_data/firebase_firestore_database.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestoreDatabase firebaseFirestoreDatabase =
      FirebaseFirestoreDatabase();

  String newValue = "";
  void editText(String textValue) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Change $textValue"),
        content: TextField(
          onChanged: (value) {
            newValue = value;
          },
          decoration: InputDecoration(hintText: "Enter new $textValue"),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.grey.shade800),
              )),
          TextButton(
              onPressed: () {
                firebaseFirestoreDatabase.updateUserDetials(
                    text: newValue, title: textValue);
                Navigator.pop(context);
              },
              child: Text(
                "Save",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.grey.shade800),
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream:
          firebaseFirestoreDatabase.userDatabase.doc(user!.email).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              const Center(
                child: Icon(
                  Icons.person,
                  size: 80,
                ),
              ),
              Text(
                user!.email.toString(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      "My Details",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700),
                    ),
                  ),
                ],
              ),
              MyTextBox(
                title: "username",
                titleText: userData["username"],
                onTap: () => editText("username"),
              ),
              const SizedBox(
                height: 10,
              ),
              MyTextBox(
                  title: "bio",
                  titleText: userData["bio"],
                  onTap: () => editText("bio")),
            ],
          );
        } else {
          return const Text("");
        }
      },
    ));
  }
}
