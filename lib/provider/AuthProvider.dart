import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';
import '../route_constants.dart';
import '../screen/auth/EmployeModel.dart';

class AuthProviderr with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? _user;
  bool isLoading = false;

  bool get isLoadingValue => isLoading;

  set isLoadingValue(bool value) {
    isLoading = value;
    notifyListeners();
  }

  bool get isAuthenticated => _user != null;

  User? get user => _user;

  AuthProviderr() {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  Future<void> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async => {
                if (value.user != null)
                  {
                    isLoadingValue = false,
                    flushBarSuccessMsg(context, "Success", "Login Successful"),
                    fetchStudent(context),
                  }
                else
                  {
                    flushBarErrorMsg(context, "Error", "Login Failed"),
                    isLoadingValue = false
                  }
              });
    } catch (e) {
      isLoadingValue = false;
      flushBarErrorMsg(context, "Error", "Login Failed");
      throw e.toString();
    }
  }

  // Method to fetch students from Firestore
  Future<void> fetchStudent(BuildContext context) async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      DocumentSnapshot snapshot = await _firebaseFirestore
          .collection('staff_data')
          .doc(auth.currentUser?.uid)
          .get();
      if (snapshot.exists) {
        // Convert the document data to a StudentModel object
        Employee.fromJson(snapshot.data() as Map<String, dynamic>);
        Navigator.of(context).pushNamedAndRemoveUntil(homeScreenRoute, (route) => false);
        notifyListeners(); // Notify listeners so that the UI updates
      } else {
        // If the document does not exist
        flushBarErrorMsg(context, "Errrrrrror", "Login Failed");
        print("No student data found for the current user.");
      }
    } catch (error) {
      flushBarErrorMsg(context, "Errdddddor", "Login Failed");
      print("Error fetching students: $error");
    }
  }

  Future<void> fetchSingleStudent(BuildContext context, String studentId) async {
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      DocumentSnapshot snapshot = await _firebaseFirestore
          .collection('students')
          .doc(auth.currentUser?.uid)
          .get();
      if (snapshot.exists) {
        // Convert the document data to a StudentModel object
        Employee student =
        Employee.fromJson(snapshot.data() as Map<String, dynamic>);
        //Navigator.pushReplacementNamed(context, homeScreenRoute);
        Navigator.of(context).pushNamedAndRemoveUntil(homeScreenRoute, (route) => false);
        notifyListeners(); // Notify listeners so that the UI updates
      } else {
        // If the document does not exist
        print("No student data found for the current user.");
      }
    } catch (error) {
      print("Error fetching students: $error");
    }
  }

  // Modify createUserWithEmailAndPassword method
  Future<void> createUserWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        if (value.user != null) {
          isLoadingValue = false;

          // Create the student object
          Employee student = Employee(
            email: email,
            id: value.user!.uid,
            name: '',
            contact: '',
            education: '',
            imageUrl: '',
            experience: '',
            role: '',

          );

          // Add student to Firestore
          addStudent(student, context);

        } else {
          flushBarErrorMsg(context, "Errorr", "Registration Failed");
          isLoadingValue = false;
        }
      });
    } catch (e) {
      isLoadingValue = false;
      flushBarErrorMsg(context, "Error", "Registration Failed, $e");
      throw e.toString();
    }
  }

  Future<void> signOut(BuildContext context, String logInScreenRoute) async {
    await _auth.signOut();
    _user = null;
    notifyListeners();

   // Get.offAll(LoginScreen());
    Navigator.pushNamedAndRemoveUntil(context, logInScreenRoute, (route) => false);
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    _user = firebaseUser;
    notifyListeners();
  }

  // Method to add a student to Firestore
  Future<void> addStudent(Employee student, BuildContext context) async {
    try {
      isLoadingValue = true;

      // Add the student to the 'students' collection in Firestore
      await firebaseFirestore
          .collection('staff_data')
          .doc(student.id)
          .set(student.toJson())
          .then((onValue) {

        flushBarSuccessMsg(context, "Success", "Staff added successfully");
      //  Get.off(HomePage());
        Navigator.pushNamedAndRemoveUntil(context, homeScreenRoute,(route) => false);
      }).onError((error, stackTrace) {
        flushBarErrorMsg(context, "Error", "Failed to add Staff");
      });
    } catch (error) {
      print("Error adding student: $error");
      flushBarErrorMsg(context, "Error", "$error");
    } finally {
      isLoadingValue = false;
      notifyListeners();
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    isLoadingValue = true;
    notifyListeners();

    final user = _auth.currentUser;

    if (user == null) {
      isLoadingValue = false;
      notifyListeners();
      throw FirebaseAuthException(
          code: 'no-user', message: 'No user is signed in.');
    }

    // Re-authenticate the user
    final email = user.email!;
    final credential =
        EmailAuthProvider.credential(email: email, password: oldPassword);

    try {
      // Re-authenticate
      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } finally {
      isLoadingValue = false;
      notifyListeners();
    }
  }
}
