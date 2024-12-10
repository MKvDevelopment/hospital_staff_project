import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_project/screen/auth/StudentModel.dart';
import '../constants.dart';
import '../screen/auth/EmployeModel.dart';
import '../screen/patientManagementScreen/AppointmentModel.dart';

class AppointmentProvider with ChangeNotifier {
  final List<AppointmenModel> _pendingAppointments = [];
  final List<AppointmenModel> _canceledAppointments = [];
  final List<AppointmenModel> _completedAppointments = [];
  final List<AppointmenModel> _upcomingAppointments = [];
  List<AppointmenModel> get canceledAppointments => _canceledAppointments;
  List<AppointmenModel> get completedAppointments => _completedAppointments;
  List<AppointmenModel> get upcomingAppointments => _upcomingAppointments;
  List<AppointmenModel> get pendingAppointments => _pendingAppointments;

  bool isLoading = false;

  final CollectionReference appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments');

  // Fetch appointments from Firestore
  Future<void> fetchAppointments() async {
    isLoading = true;
    //notifyListeners();

    final querySnapshot = await appointmentsCollection.get();
    _pendingAppointments.clear();
    _canceledAppointments.clear();
    _completedAppointments.clear();
    _upcomingAppointments.clear();

    for (var doc in querySnapshot.docs) {
     // Create an appointment from Firestore document
      AppointmenModel appointment = AppointmenModel.fromFirestore(doc);

      // Check the status of the appointment
      if (appointment.status == 'canceled') {
        // If the status is 'canceled', add it to the _canceledAppointments list
        _canceledAppointments.add(appointment);
      } else  if (appointment.status == 'completed') {
        // If the status is 'canceled', add it to the _canceledAppointments list
        _completedAppointments.add(appointment);
      } else  if (appointment.status == 'upcoming') {
        // If the status is 'canceled', add it to the _canceledAppointments list
        _upcomingAppointments.add(appointment);
      }else if (appointment.status == 'Pending') {
        _pendingAppointments.add(appointment);
      }
    }

    isLoading = false;
    notifyListeners();
  }

  // Add a new appointment to Firestore
  Future<void> addAppointment(AppointmenModel appointment) async {
    await appointmentsCollection.doc(appointment.id).set(appointment.toMap());
   // _appointments.add(appointment);
    notifyListeners();
  }

  // Delete an appointment from Firestore
  Future<void> deleteAppointment(String id) async {
    await appointmentsCollection.doc(id).delete();
   // _appointments.removeWhere((appointment) => appointment.id == id);
    notifyListeners();
  }

  Future<void> cancelAppointment(String id, BuildContext context) async {
    // Set loading state
    isLoading = true;
    notifyListeners();

    try {
      // Update the appointment status in Firestore
      var map = {'status': 'canceled'};
      await appointmentsCollection.doc(id).update(map);

      // Find the appointment in the local list (upcoming appointments)
      int index = _upcomingAppointments.indexWhere((appointment) => appointment.id == id);
      if (index != -1) {
        // Remove from the upcoming list
        AppointmenModel canceledAppointment = _upcomingAppointments.removeAt(index);

        // Update status to canceled
        canceledAppointment.status = 'canceled';

        // Add to the canceled list
        _canceledAppointments.add(canceledAppointment);

        // Notify listeners to update the UI
        notifyListeners();

        // Display success message
        flushBarSuccessMsg(context, "Success!", "Appointment Cancelled Successfully.");
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error cancelling appointment: $e');
      flushBarSuccessMsg(context, "Error!", "Error: $e");
    }finally{
      // Reset loading state
      isLoading = false;
      notifyListeners();
    }


  }
  Future<void> acceptPendingAppointment(String id, BuildContext context) async {
    // Set loading state
    isLoading = true;
    notifyListeners();

    try {
      // Update the appointment status in Firestore
      var map = {'status': 'upcoming'};
      await appointmentsCollection.doc(id).update(map);

      // Find the appointment in the local list (upcoming appointments)
      int index = _pendingAppointments.indexWhere((appointment) => appointment.id == id);
      if (index != -1) {
        // Remove from the upcoming list
        AppointmenModel acceptAppointment = _pendingAppointments.removeAt(index);
        // Update status to canceled
        acceptAppointment.status = 'upcoming';
        // Add to the canceled list
        _upcomingAppointments.add(acceptAppointment);
        // Notify listeners to update the UI
        notifyListeners();
        // Display success message
        flushBarSuccessMsg(context, "Success!", "Appointment Accepted Successfully.");
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error Accepting appointment: $e');
      flushBarSuccessMsg(context, "Error!", "Error: $e");
    }finally{
      // Reset loading state
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelPendingAppointment(String id, BuildContext context) async {
    // Set loading state
    isLoading = true;
    notifyListeners();

    try {
      // Update the appointment status in Firestore
      var map = {'status': 'canceled'};
      await appointmentsCollection.doc(id).update(map);

      // Find the appointment in the local list (upcoming appointments)
      int index = _pendingAppointments.indexWhere((appointment) => appointment.id == id);
      if (index != -1) {
        // Remove from the upcoming list
        AppointmenModel canceledAppointment = _pendingAppointments.removeAt(index);

        // Update status to canceled
        canceledAppointment.status = 'canceled';

        // Add to the canceled list
        _canceledAppointments.add(canceledAppointment);

        // Notify listeners to update the UI
        notifyListeners();

        // Display success message
        flushBarSuccessMsg(context, "Success!", "Appointment Cancelled Successfully.");
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error cancelling appointment: $e');
      flushBarSuccessMsg(context, "Error!", "Error: $e");
    }finally{
      // Reset loading state
      isLoading = false;
      notifyListeners();
    }
  }


  // Add this method to reschedule an appointment
  Future<void> rescheduleAppointment(String id, DateTime newDate, String newTime) async {
    isLoading = true;
    notifyListeners();
    try {
      // Format the date to a consistent string format
    //  String formattedDate = DateFormat('yyyy-MM-dd').format(newDate);

      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(id)
          .update({
        'date': formatDate(newDate),
        'time': newTime,
      });
    } catch (e) {
      print("Failed to reschedule appointment: $e");
    }finally{
      // Reset loading state
      isLoading = false;
      notifyListeners();
    }
  }
  String formatDate(DateTime date) {
    // Format the date to ensure two digits for day and month
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Future<StudentModel?> fetchStudentById(String? studentId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .get();

      if (snapshot.exists) {
        return StudentModel.fromFirestore(snapshot.data()!); // Assuming StudentModel has fromMap
      }
    } catch (e) {
      print('Error fetching student: $e');
    }
    return null;
  }

}
