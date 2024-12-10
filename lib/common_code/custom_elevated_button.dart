import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final Widget labelText;  // Button text
  final VoidCallback onPressed;  // Callback when button is pressed
  final ButtonStyle? buttonStyle;  // Optional button style
  final TextStyle? textStyle;  // Optional text style for the label
  final Icon? icon;  // Optional icon for the button

  const CustomElevatedButton({
    Key? key,
    required this.labelText,  // Required parameter
    required this.onPressed,  // Required parameter
    this.buttonStyle,  // Optional parameter for styling the button
    this.textStyle,  // Optional parameter for styling the text
    this.icon,  // Optional icon
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,  // Passed callback
      style: buttonStyle ?? Theme.of(context).elevatedButtonTheme.style,  // Use provided style or default theme style
      child: labelText,

    );
  }
}
