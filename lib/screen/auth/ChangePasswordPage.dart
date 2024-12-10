import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../common_code/custom_elevated_button.dart';
import '../../common_code/custome_text_form_field.dart';
import '../../provider/AuthProvider.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  var provider;
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    provider = Provider.of<AuthProviderr>(context, listen: false);
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      final oldPassword = _oldPasswordController.text.trim();
      final newPassword = _newPasswordController.text.trim();

      if (newPassword == _confirmPasswordController.text.trim()) {
        Provider.of<AuthProviderr>(context, listen: false)
            .changePassword(oldPassword, newPassword)
            .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password changed successfully')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Failed to change password ${error.message}')),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderr>(builder: (context, provider, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Change Password'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _oldPasswordController,
                  labelText: 'Old Password',
                  hintText: 'Please enter your old password',
                  obscureText: !_isOldPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(_isOldPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isOldPasswordVisible = !_isOldPasswordVisible;
                      });
                    },
                  ),
                  // Validator for old password
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Old password is required';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: _newPasswordController,
                  labelText: 'New Password',
                  hintText: 'Please enter a new password',
                  obscureText: !_isNewPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(_isNewPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'New password is required';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  hintText: 'Please confirm your new password',
                  obscureText: !_isConfirmPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(_isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm password is required';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                provider.isLoading
                    ? Center(
                      child: CircularProgressIndicator(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                        ),
                    )
                    : CustomElevatedButton(
                        labelText: const Text('Change Password'),
                        onPressed: _handleChangePassword,
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
