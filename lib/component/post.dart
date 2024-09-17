import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/component/comment.dart';
import 'package:flutter_social_app/component/comment_button.dart';
import 'package:flutter_social_app/component/like_button.dart';
import 'package:flutter_social_app/component/post_delete_button.dart';
import 'package:flutter_social_app/firestore_data/firebase_firestore_database.dart';
import 'package:flutter_social_app/helper/date_time_converter.dart';

class Post extends StatefulWidget {
  final String userName;
  final String post;
  final String time;
  final String postId;
  final List<String> likes;

  const Post(
      {super.key,
      required this.userName,
      required this.post,
      required this.time,
      required this.likes,
      required this.postId});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isLiked = false;

  FirebaseFirestoreDatabase firebaseFirestoreDatabase =
      FirebaseFirestoreDatabase();
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    isLiked = widget.likes.contains(user!.email);
    super.initState();
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    final prefs =
        FirebaseFirestore.instance.collection("Posts").doc(widget.postId);
    if (isLiked) {
      prefs.update({
        "Likes": FieldValue.arrayUnion([user!.email])
      });
    } else {
      prefs.update({
        "Likes": FieldValue.arrayRemove([user!.email])
      });
    }
  }

  void addComment(String comment) async {
    await FirebaseFirestore.instance
        .collection("Posts")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "UserEmail": user!.email,
      "Comment": comment,
      "TimeStamp": Timestamp.now(),
    });
  }

  void openCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: "comment something...",
          ),
        ),
        actions: [
          TextButton(
              onPressed: () {
                commentController.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel")),
          TextButton(
              onPressed: () {
                if (commentController.text.isNotEmpty) {
                  addComment(commentController.text);
                  commentController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text("Comment")),
        ],
      ),
    );
  }

  Widget countCommentLength() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Posts")
          .doc(widget.postId)
          .collection("Comments")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("0");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        int commentLength = snapshot.data!.docs.length;
        return Text(commentLength.toString());
      },
    );
  }

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Post"),
        content: const Text(
          "Are You Sure to Delete this Post?",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(
                    color: Colors.grey.shade800, fontWeight: FontWeight.w600),
              )),
          TextButton(
              onPressed: () async {
                final commentData = await FirebaseFirestore.instance
                    .collection("Posts")
                    .doc(widget.postId)
                    .collection("Comments")
                    .get();
                for (var comment in commentData.docs) {
                  await FirebaseFirestore.instance
                      .collection("Posts")
                      .doc(widget.postId)
                      .collection("Comments")
                      .doc(comment.id)
                      .delete();
                }
                FirebaseFirestore.instance
                    .collection("Posts")
                    .doc(widget.postId)
                    .delete();
                Navigator.pop(context);
              },
              child: Text("Delete",
                  style: TextStyle(
                      color: Colors.grey.shade800,
                      fontWeight: FontWeight.w600)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_circle,
                size: 40,
                color: Colors.grey.shade700,
              ),
              Text(
                widget.userName,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade500),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                widget.time,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.grey.shade700),
              ),
              const Spacer(),
              if (widget.userName == user!.email)
                PostDeleteButton(onTap: () => deletePost())
            ],
          ),
          Text(
            widget.post,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  LikeButton(
                    isLiked: isLiked,
                    onTap: toggleLike,
                  ),
                  Text(widget.likes.length.toString()),
                ],
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                children: [
                  CommentButton(onTap: openCommentDialog),
                  countCommentLength(),
                ],
              ),
            ],
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Posts")
                .doc(widget.postId)
                .collection("Comments")
                .orderBy("TimeStamp", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data();

                  return Comment(
                      userEmail: commentData["UserEmail"],
                      commentTime: formatDate(commentData["TimeStamp"]),
                      comment: commentData["Comment"]);
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
