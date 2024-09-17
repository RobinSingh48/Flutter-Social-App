import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/component/my_drawer.dart';
import 'package:flutter_social_app/component/my_error_message.dart';
import 'package:flutter_social_app/component/my_textfield.dart';
import 'package:flutter_social_app/component/post.dart';

import 'package:flutter_social_app/firestore_data/firebase_firestore_database.dart';
import 'package:flutter_social_app/helper/date_time_converter.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TextEditingController postController = TextEditingController();
  final FirebaseFirestoreDatabase firebaseFirestoreDatabase =
      FirebaseFirestoreDatabase();

  final User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Posts",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: [
          StreamBuilder(
            stream: firebaseFirestoreDatabase.getPostStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                myErrorMessage(
                    context, "Something wrong in firestore posts stream");
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Text("Error in getPostStream"),
                );
              }
              final posts = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    final String userEmail = post["UserEmail"];
                    final String postText = post["Post"];
                    final String time = formatDate(post["TimeStamp"]);
                    final String postId = post.id;
                    return Post(
                      userName: userEmail,
                      post: postText,
                      time: time,
                      likes: List<String>.from(post["Likes"] ?? []),
                      postId: postId,
                    );
                  },
                ),
              );
            },
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: MyTextfield(
                      controller: postController,
                      hintText: "post something here...",
                      obscureText: false),
                ),
              ),
              IconButton(
                onPressed: () {
                  if (postController.text.isNotEmpty) {
                    firebaseFirestoreDatabase.addPost(
                        post: postController.text, userEmail: user!.email);
                    postController.clear();
                  }
                },
                icon: const Icon(Icons.arrow_circle_right_outlined),
                iconSize: 50,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
