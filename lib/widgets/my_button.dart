import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color textColor;
  final Color backgroundColor;

  const MyButton(
      {required this.text,
      required this.onPressed,
      required this.textColor,
      required this.backgroundColor,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
        ),
      );
}
