import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String title;
  final String titleText;
  final void Function()? onTap;
  const MyTextBox(
      {super.key,
      required this.title,
      required this.titleText,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              IconButton(onPressed: onTap, icon: const Icon(Icons.settings))
            ],
          ),
          Text(
            titleText,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          )
        ],
      ),
    );
  }
}
