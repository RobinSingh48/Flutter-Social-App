import 'package:flutter/material.dart';
import 'package:flutter_social_app/component/my_list_tile.dart';
import 'package:flutter_social_app/firebase_auth/firebase_auth.dart';
import 'package:flutter_social_app/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({super.key});

  final FirebaseAuthDatabase firebaseAuthDatabase = FirebaseAuthDatabase();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey.shade300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(
                height: 80,
              ),
              const Icon(
                Icons.person,
                size: 80,
              ),
              const SizedBox(
                height: 100,
              ),
              MyListTile(
                iconName: Icons.home,
                text: "H O M E",
                onTap: () => Navigator.pop(context),
              ),
              MyListTile(
                iconName: Icons.home,
                text: "P R O F I L E",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ));
                },
              ),
            ],
          ),
          Column(
            children: [
              MyListTile(
                iconName: Icons.logout,
                text: "L O G O U T",
                onTap: firebaseAuthDatabase.signOut,
              )
            ],
          )
        ],
      ),
    );
  }
}
