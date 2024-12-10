import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common_code/custom_elevated_button.dart';
import '../../constants.dart';
import '../../provider/AuthProvider.dart';
import '../../route_constants.dart';
import 'login_form.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> _obscureTextNotifier =
      ValueNotifier<bool>(true); // For password visibility toggle

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Consumer<AuthProviderr>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Stack(children: [
              // Background Image
              Positioned.fill(
                child: Image.asset(
                  'assets/images/view_M.jpg',
                  // Replace with your image path
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Container(
                  width: 500,
                  height: 500,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Image.asset(
                        logoImg,
                        fit: BoxFit.cover,
                        height: height * 2 / 8,
                      ),
                      Padding(
                        padding:const EdgeInsets.all(defaultPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              registerPageTitle,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: defaultPadding),
                            Text(
                              registerPageDesc,
                              style: Theme.of(context).textTheme.titleSmall,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: defaultPadding),
                            LogInForm(
                                formKey: _formKey,
                                emailController: _emailController,
                                passwordController: _passwordController,
                                obscureTextNotifier: _obscureTextNotifier),
                            const SizedBox(
                              height: defaultPadding,
                            ),
                            provider.isLoading
                                ? CircularProgressIndicator(
                                    color: Theme.of(context)
                                        .appBarTheme
                                        .backgroundColor,
                                  )
                                : CustomElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        FocusScope.of(context).unfocus();
                                        provider.isLoadingValue = true;
                                        provider.createUserWithEmailAndPassword(
                                            context,
                                            _emailController.text,
                                            _passwordController.text);
                                      }
                                    },
                                    labelText: provider.isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text('Sign Up'),
                                  ),
                            SizedBox(height: defaultPadding),
                            RichText(
                                text: TextSpan(
                                    text: 'Already have an account? ',
                                    style: Theme.of(context).textTheme.titleSmall,
                                    children: [
                                  TextSpan(
                                      text: 'LogIn here',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushNamed(
                                              context, logInScreenRoute);
                                        },
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall!
                                          .copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.bold,
                                          ))
                                ]))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ),
        );
      },
    );
  }
}
