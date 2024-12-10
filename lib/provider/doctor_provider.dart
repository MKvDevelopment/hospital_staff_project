import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screen/doctorManagement/doctorModel.dart';

class DoctorProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DoctorModel> _doctors = [];
  bool _isLoading = false;

  List<DoctorModel> get doctors => _doctors;
  bool get isLoading => _isLoading;

  Future<void> fetchDoctors() async {
    _isLoading = true;
   // notifyListeners();
    try {
      final snapshot = await _firestore.collection('all_doctors').get();
      _doctors = snapshot.docs
          .map((doc) => DoctorModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching doctors: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDoctor(DoctorModel doctor) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firestore.collection('all_doctors').doc(doctor.id).set(doctor.toMap());
      fetchDoctors(); // Refresh after adding
    } catch (e) {
      print('Error adding doctor: $e');
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> updateDoctorStatus(String id, String newStatus) async {
    final doctorIndex = _doctors.indexWhere((doc) => doc.id == id);
    if (doctorIndex != -1) {
      _doctors[doctorIndex].availabilityStatus = newStatus;
      notifyListeners();

      try {
        // Update Firestore
        await _firestore.collection('all_doctors').doc(id).update({
          'availabilityStatus': newStatus,
        });
      } catch (e) {
        print('Error updating doctor status: $e');
      }
    }
  }

  Future<void> updateDoctor(DoctorModel updatedDoctor) async{
    // Update Firestore
    await _firestore.collection('all_doctors').doc(updatedDoctor.id).update(updatedDoctor.toMap());
    final index = _doctors.indexWhere((doc) => doc.id == updatedDoctor.id);
    if (index != -1) {
      _doctors[index] = updatedDoctor;
      notifyListeners();
    }
  }

}
