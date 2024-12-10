import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller; // Controller for the input field
  final String? hintText; // Placeholder text
  final String labelText; // Label for the field
  final Widget? prefixIcon; // Path for the SVG icon
  final String? Function(String?)? validator; // Optional validation function
  final TextInputType? keyboardType; // Optional input type (email, text, etc.)
  final TextInputAction?textInputAction; // Action for the keyboard (next, done, etc.)
  final bool obscureText; // To hide text for password fields (default: false)
  final EdgeInsetsGeometry? padding; // Optional padding for the icon
  final double? iconHeight; // Optional height for the icon
  final double? iconWidth; // Optional width for the icon
  final int? maxLines; // Optional width for the icon
  final int? minLines; // Optional width for the icon
  final int? maxLength; // Optional width for the icon
  final Widget? suffixIcon; // Optional suffix icon (like visibility toggle)

  const CustomTextFormField({
    Key? key,
    required this.controller, // Required controller for TextFormField
    required this.labelText, // Required label text
    this.hintText,
    this.maxLength,
    this.prefixIcon, // Required SVG icon path
    this.validator, // Optional validator function
    this.keyboardType = TextInputType.text, // Default: Text input
    this.textInputAction = TextInputAction.done, // Default: Done action
    this.obscureText = false, // Default: Not password field
    this.padding =
        const EdgeInsets.symmetric(vertical: 8.0), // Optional padding
    this.iconHeight = 24.0, // Default icon height
    this.iconWidth = 24.0, // Default icon width
    this.maxLines = 1,
    this.minLines = 1,
    this.suffixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        maxLength: maxLength,
        // Use passed validator or null
        textInputAction: textInputAction,
        // Keyboard action (next, done, etc.)
        keyboardType: keyboardType,
        // Keyboard type (email, text, etc.)
        obscureText: obscureText,
        maxLines: maxLines,
        minLines: minLines,
        style: TextStyle(color:  Theme.of(context).primaryColorDark), // Set text color to black
        cursorColor:  Theme.of(context).primaryColorDark,
        // Toggle obscure text for password fields
        decoration: InputDecoration(
          hintText: hintText, // Placeholder text
          labelText: labelText, // Field label
          prefixIcon:prefixIcon??null,
          suffixIcon: suffixIcon??null, // Optional suffix icon
          labelStyle: TextStyle(fontSize: 14.0,color: Theme.of(context).primaryColorDark),
          contentPadding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 12.0), // Adjust top and bottom padding

        ),
      ),
    );
  }
}
