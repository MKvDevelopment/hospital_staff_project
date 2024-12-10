import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;  // Required callback for button press
  final IconData icon;  // Required icon for the button
  final Color? backgroundColor;  // Optional background color
  final Color? iconColor;  // Optional icon color
  final double? elevation;  // Optional elevation

  const CustomFloatingActionButton({
    Key? key,
    required this.onPressed,  // Required parameter for button press
    required this.icon,  // Required parameter for button icon
    this.backgroundColor,  // Optional background color
    this.iconColor,  // Optional icon color
    this.elevation,  // Optional elevation
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: 'heroTag',
      onPressed: onPressed,  // Passed onPressed callback
      backgroundColor: backgroundColor ?? Theme.of(context).floatingActionButtonTheme.backgroundColor,  // Use provided or default background color
      elevation: elevation ?? Theme.of(context).floatingActionButtonTheme.elevation,  // Use provided or default elevation
      child: Icon(
        icon, color: iconColor ?? Theme.of(context).floatingActionButtonTheme.foregroundColor,  // Use provided or default icon color
      ),
    );
  }
}
