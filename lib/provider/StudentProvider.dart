import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_project/screen/patientManagementScreen/AppointmentModel.dart';

import '../constants.dart';
import '../screen/auth/EmployeModel.dart';
import '../screen/auth/StudentModel.dart';

class StudentProvider extends ChangeNotifier {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool _isLoading = false;
  StudentModel? _student;

  StudentModel? get student => _student; // Getter for accessing the student data
  final List<StudentModel> _studentList = [];
  List<AppointmenModel> _appointments = [];

  List<AppointmenModel> get allAppointments => [..._appointments];
  List<AppointmenModel> _upcomingAppointments = [];
  List<AppointmenModel> _completedAppointments = [];
  List<AppointmenModel> _canceledAppointments = [];

  List<StudentModel> get studentList => [..._studentList];

  List<AppointmenModel> get upcomingAppointments => _upcomingAppointments;

  List<AppointmenModel> get completedAppointments => _completedAppointments;

  List<AppointmenModel> get canceledAppointments => _canceledAppointments;

  bool get isLoading => _isLoading;

  // Method to add a student to Firestore
/*  Future<void> addStudent(Employee student, BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      // Add the student to the 'students' collection in Firestore
      await _firebaseFirestore
          .collection('students')
          .doc(student.id)
          .set(student.toJson())
          .then((onValue) {
        flushBarSuccessMsg(context, "Success", "Student added successfully");
      }).onError((error, stackTrace) {
        flushBarErrorMsg(context, "Error", "Failed to add student");
      });
    } catch (error) {
      print("Error adding student: $error");
      flushBarErrorMsg(context, "Error", "$error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }*/

  // Method to fetch students from Firestore
  Future<void> fetchStudent() async {
    _isLoading = true;
    notifyListeners();
    try {
      DocumentSnapshot snapshot = await _firebaseFirestore
          .collection('students')
          .doc(auth.currentUser?.uid)
          .get();
      if (snapshot.exists) {
        // Convert the document data to a StudentModel object
        _student = StudentModel.fromFirestore(snapshot.data() as Map<String, dynamic>);
        notifyListeners(); // Notify listeners so that the UI updates
      } else {
        // If the document does not exist
        print("No student data found for the current user.");
      }
    } catch (error) {
      print("Error fetching students: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<StudentModel> searchStudentsByMobile(String query) {
    return _studentList.where((student) {
      return student.mobileNo.contains(query);
    }).toList();
  }

  Future<void> fetchAllStudents() async {
    _isLoading = true;
  //  notifyListeners();
    try {
      _studentList.clear();
      final snapshot = await _firebaseFirestore.collection('students').get();

      _studentList.addAll(
          snapshot.docs.map((doc) => StudentModel.fromFirestore(doc.data())).toList());

    } catch (e) {
      print("Error fetching students: $e");

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Fetch booked appointments for the selected patient
  Future<void> fetchPatientAppointments(String studentId) async {
    try {
      _isLoading = true;
     // notifyListeners();
      _upcomingAppointments.clear();
      _completedAppointments.clear();
      _canceledAppointments.clear();

      QuerySnapshot snapshot = await _firebaseFirestore
          .collection('appointments')
          .where('userId', isEqualTo: studentId)
          .get();

      for (var doc in snapshot.docs) {
        final appointment = AppointmenModel.fromFirestore(doc);
        if (appointment.status == 'upcoming') {
          _upcomingAppointments.add(appointment);
        } else if (appointment.status == 'completed') {
          _completedAppointments.add(appointment);
        } else if (appointment.status == 'canceled') {
          _canceledAppointments.add(appointment);
        }
      }
      _appointments =
          snapshot.docs.map((doc) => doc.data() as AppointmenModel).toList();
    } catch (error) {
      print("Error fetching appointments: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void fetchPatientDetails(String studentId) {
    _isLoading = true;
    notifyListeners();
    try {
      // Find the specific student in the _studentList
      final student = _studentList.firstWhere(
        (student) => student.studentId == studentId,
      );

      if (student != null) {
        _student = student; // Update the selected student
        notifyListeners();
      } else {
        print("Student with ID $studentId not found.");
      }
    } catch (error) {
      print("Error fetching patient details: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
