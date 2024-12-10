import 'package:flutter/material.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed; // Required callback for button press
  final String label; // Required text for the button
  final Color? textColor; // Optional text color
  final Color? backgroundColor; // Optional background color
  final double? fontSize; // Optional font size
  final EdgeInsetsGeometry? padding; // Optional padding
  final TextStyle? textStyle; // Optional text style for custom designs

  const CustomTextButton({
    Key? key,
    required this.onPressed, // Required parameter for button press
    required this.label, // Required parameter for button text
    this.textColor, // Optional text color
    this.backgroundColor, // Optional background color
    this.fontSize, // Optional font size
    this.padding, // Optional padding
    this.textStyle, // Optional custom text style
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, // Passed onPressed callback
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor, // Set background color
        padding: padding, // Apply custom padding
      ),
      child: Text(
        label,
        style: textStyle ??
            TextStyle(
              color: textColor ?? Theme.of(context).primaryColorDark, // Use provided or default text color
              fontSize: fontSize ?? 16.0, // Use provided or default font size
            ),
      ),
    );
  }
}
