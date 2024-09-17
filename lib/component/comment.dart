import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String userEmail;
  final String commentTime;
  final String comment;
  const Comment(
      {super.key,
      required this.userEmail,
      required this.commentTime,
      required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                userEmail,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade400),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                commentTime,
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                    fontSize: 12),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(comment),
        ],
      ),
    );
  }
}
