import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hospital_staff_project/common_code/custom_text_style.dart';

class ProfileUpdateDialog extends StatefulWidget {
  @override
  _ProfileUpdateDialogState createState() => _ProfileUpdateDialogState();
}

class _ProfileUpdateDialogState extends State<ProfileUpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _contact;
  String? _role;
  String? _experience;
  String? _education;
  bool _isLoading = false;

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isLoading = true;
      });

      try {
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await FirebaseFirestore.instance
              .collection('staff_data') // Replace with your collection name
              .doc(currentUser.uid)
              .update({
            'name': _name,
            'contact': _contact,
            'experience': _experience,
            'role': _role,
            'education': _education,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );

          Navigator.of(context).pop();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title:  Text('Update Profile',style:CustomTextStyles.titleLarge,),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: _name,
              style: CustomTextStyles.titleMedium,
              decoration: const InputDecoration(
                  labelText: 'Name',
               contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onSaved: (value) => _name = value,
            ),
            const SizedBox(height: 5,),
            TextFormField(
              initialValue: _contact,
              style: CustomTextStyles.titleMedium,
              decoration: const InputDecoration(labelText: 'Contact',  contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your contact number';
                }
                return null;
              },
              onSaved: (value) => _contact = value,
            ),
            const SizedBox(height: 5,),
            TextFormField(
              initialValue: _education,
              style: CustomTextStyles.titleMedium,
              decoration: const InputDecoration(labelText: 'Education',  contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Education Details';
                }
                return null;
              },
              onSaved: (value) => _education = value,
            ),
            const SizedBox(height: 5,),
            TextFormField(
              initialValue: _role,
              style: CustomTextStyles.titleMedium,
              decoration: const InputDecoration(labelText: 'Job Role',  contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Job Role';
                }
                return null;
              },
              onSaved: (value) => _role = value,
            ),
            const SizedBox(height: 5,),
            TextFormField(
              initialValue: _experience,
              style: CustomTextStyles.titleMedium,
              decoration: const InputDecoration(labelText: 'Work Experience',  contentPadding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Work Experience';
                }
                return null;
              },
              onSaved: (value) => _experience = value,
            ),
          ],
        ),
      ),
      actions: [
        if (_isLoading) const CircularProgressIndicator(),
        if (!_isLoading) ...[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _updateProfile,
            child: const Text('Update'),
          ),
        ]
      ],
    );
  }
}

