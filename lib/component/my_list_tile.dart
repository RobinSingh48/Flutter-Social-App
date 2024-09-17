import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData iconName;
  final String text;
  final void Function()? onTap;
  const MyListTile(
      {super.key,
      required this.iconName,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListTile(
        leading: Icon(iconName),
        title: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}
