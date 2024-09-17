import 'package:flutter/material.dart';

class PostDeleteButton extends StatelessWidget {
  final void Function()? onTap;
  const PostDeleteButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: const Icon(Icons.cancel),
    );
  }
}
