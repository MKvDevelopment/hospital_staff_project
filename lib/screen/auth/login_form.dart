import 'package:flutter/material.dart';
import '../../common_code/custome_text_form_field.dart';
import '../../constants.dart';


class LogInForm extends StatelessWidget {
  const LogInForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscureTextNotifier,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueNotifier<bool> obscureTextNotifier;  // Add this notifier


  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children:[
          CustomTextFormField(
            controller: emailController,
            hintText: "Email address",
            labelText: "Enter Email:",
            validator: emaildValidator.call,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            obscureText: false,
            prefixIcon:  Image.asset(
                'assets/icons/Message.png',
                width: 24.0,
                height: 24.0,
            ),
          ),

          const SizedBox(height: defaultPadding),
          ValueListenableBuilder<bool>(
            valueListenable: obscureTextNotifier,
            builder: (context, obscureText, child) {
              return
                CustomTextFormField(
                  controller: passwordController,
                  hintText: "Password",
                  labelText: "Enter Password:",
                  validator: passwordValidator.call,
                  textInputAction: TextInputAction.next,
                  obscureText: obscureTextNotifier.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      obscureTextNotifier.value = !obscureTextNotifier.value;
                    },
                  ),
                  prefixIcon: Image.asset(
                  'assets/icons/lock.png', // Icon path// Set width
                    width: 24.0,
                    height: 24.0,
                ),
                );
            },
          ),
        ],
      ),
    );
  }
}
