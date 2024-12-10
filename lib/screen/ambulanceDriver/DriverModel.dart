class DriverModel {
  String name;
  String experience;
  String? email;
  String mobileNo;
  String vehicleNo;
  String address;
  String status;
  String driverId;

  // Constructor
  DriverModel({
    required this.name,
    required this.experience,
    this.email,
    required this.mobileNo,
    required this.status,
    required this.vehicleNo,
    required this.address,
    required this.driverId,
  });

  // Factory method to create a DriverModel from a map (e.g., from Firestore)
  factory DriverModel.fromMap(Map<String, dynamic> map) {
    return DriverModel(
      name: map['name'] ?? '',
      status: map['status'] ?? '',
      experience: map['experience'] ?? '',
      email: map['email'],
      mobileNo: map['mobileNo'] ?? '',
      vehicleNo: map['vehicleNo'] ?? '',
      address: map['address'] ?? '',
      driverId: map['driverId'] ?? '',
    );
  }

  // Method to convert a DriverModel to a map (e.g., for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'experience': experience,
      'email': email,
      'mobileNo': mobileNo,
      'status': status,
      'vehicleNo': vehicleNo,
      'address': address,
      'driverId': driverId,
    };
  }
}
