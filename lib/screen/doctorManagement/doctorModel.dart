class DoctorModel {
  String? id;
  String doctorName;
  String imgUrl;
  String department;
  String availabilityStatus;
  String availabilityTime;
  String experience; // In years
  String contactNumber;

  DoctorModel({
    required this.id,
    required this.doctorName,
    required this.imgUrl,
    required this.department,
    required this.availabilityStatus,
    required this.availabilityTime,
    required this.experience,
    required this.contactNumber,
  });

  factory DoctorModel.fromMap(Map<String, dynamic> data, String documentId) {
    return DoctorModel(
      id: documentId,
      doctorName: data['doctorName'] ?? '',
      imgUrl: data['imgUrl'] ?? '',
      department: data['department'] ?? '',
      availabilityStatus: data['availabilityStatus'] ?? "false",
      availabilityTime: data['availabilityTime'] ?? '',
      experience: data['experience'] ?? "0",
      contactNumber: data['contactNumber'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'doctorName': doctorName,
      'imgUrl': imgUrl,
      'department': department,
      'availabilityStatus': availabilityStatus,
      'availabilityTime': availabilityTime,
      'experience': experience,
      'contactNumber': contactNumber,
    };
  }
}
