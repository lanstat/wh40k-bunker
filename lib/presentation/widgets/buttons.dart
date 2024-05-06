import 'package:flutter/material.dart';

import 'labels.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.circular(10)
        ),
        padding: const EdgeInsets.all(15.0),
        child: Label(
          text,
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}