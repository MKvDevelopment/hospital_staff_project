import 'package:flutter/material.dart';

import 'custom_text_style.dart';

class EditableRow extends StatelessWidget {
  final String labelText; // Label for the text field
  final String hintText;  // Hint text for the text field
  final bool enabled;  // Hint text for the text field
  final TextInputType inputType;  // Keyboard type (e.g., TextInputType.text, TextInputType.number)
  final TextEditingController controller; // Text editing controller
  final FormFieldValidator<String>? validator; // Validator for the input field

  const EditableRow({
    Key? key,
    required this.labelText,
    required this.enabled,
    required this.hintText,
    required this.inputType,
    required this.controller,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  '$labelText :',
                  style: CustomTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold,color: Colors.blue),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 4,
                child: TextFormField(
                  style: CustomTextStyles.titleSmall,
                  controller: controller,
                  keyboardType: inputType,
                  enabled: enabled,
                  decoration: InputDecoration(
                    hintText: hintText,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, ),
                  ),
                  validator: validator,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
