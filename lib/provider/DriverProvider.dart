import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hospital_staff_project/screen/ambulanceDriver/DriverModel.dart';

class DriverProvider with ChangeNotifier {
  final List<DriverModel> _drivers = [];

  List<DriverModel> get drivers => [..._drivers];
  bool isLoading = false;


  Future<void> fetchDrivers() async {
    isLoading = true;
   // notifyListeners();
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('driverList').get();
      _drivers.clear();
      _drivers.addAll(
          snapshot.docs.map((doc) => DriverModel.fromMap(doc.data())).toList());
    } catch (e) {
      print("Error fetching drivers: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDriver(DriverModel driver) async {
    isLoading = true;
    notifyListeners();
    try {
      final doc = await FirebaseFirestore.instance
          .collection('driverList')
          .add(driver.toMap());
      _drivers.add(DriverModel(
          driverId: doc.id,
          name: driver.name,
          experience: driver.experience,
          email: driver.email,
          mobileNo: driver.mobileNo,
          vehicleNo: driver.vehicleNo,
          address: driver.address,
          status: driver.status));
      notifyListeners();
    } catch (e) {
      print("Error adding driver: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateDriver(String id, DriverModel updatedDriver) async {
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance
          .collection('driverList')
          .doc(id)
          .update(updatedDriver.toMap());
      final index = _drivers.indexWhere((driver) => driver.driverId == id);
      if (index != -1) {
        _drivers[index] = updatedDriver;
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("Error updating driver: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteDriver(String id) async {
    isLoading = true;
    notifyListeners();
    try {
      await FirebaseFirestore.instance.collection('driverList').doc(id).delete();
      _drivers.removeWhere((driver) => driver.driverId == id);

    }catch(e){
      print("Error deleting driver: $e");
    }finally {
      isLoading = false;
      notifyListeners();
    }

  }
}
