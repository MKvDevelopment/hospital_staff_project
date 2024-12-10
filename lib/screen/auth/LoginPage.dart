import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../common_code/custom_elevated_button.dart';
import '../../constants.dart';
import '../../provider/AuthProvider.dart';
import '../../route_constants.dart';
import 'login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
            child: Stack(
              children: [
                // Background Image
                Positioned.fill(
                  child: Image.asset(
                    campusImg, // Replace with your image path
                    fit: BoxFit.cover,
                  ),
                ),
                // Main Content
                LayoutBuilder(builder: (context, constraints) {
                  return Center(
                    child: Container(
                        width: 500,
                      height: 500,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Image.asset(
                            logoImg,
                            fit: BoxFit.cover,
                            height: height * 2 / 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  loginPageTitle,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: defaultPadding ),
                                Text(
                                  loginPageDesc,
                                  style: Theme.of(context).textTheme.titleSmall,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: defaultPadding),
                                LogInForm(
                                    formKey: _formKey,
                                    emailController: _emailController,
                                    passwordController: _passwordController,
                                    obscureTextNotifier: _obscureTextNotifier),
                                SizedBox(
                                  height: defaultPadding
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
                                      provider.isLoadingValue = true;

                                      FocusScope.of(context).unfocus();

                                      provider.signInWithEmailAndPassword(
                                          context,
                                          _emailController.text,
                                          _passwordController.text);
                                    }
                                  },
                                  labelText: provider.isLoading
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                      : const Text('Login'),
                                ),
                                const SizedBox(height: 10),
                                RichText(
                                    text: TextSpan(
                                        text: 'Don\'t have an account? ',
                                        style:
                                        Theme.of(context).textTheme.titleSmall,
                                        children: [
                                          TextSpan(
                                              text: 'Sign up',
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  //  Get.off(RegisterPage(),);
                                                  Navigator.pushNamed(
                                                      context, signUpScreenRoute);
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
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
