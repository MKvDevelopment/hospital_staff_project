class StudentModel {
  String name;
  String rollNo;
  String branch;
  String year;
  String? email;
  String mobileNo;
  String bloodGroup;
  String gender;
  String imgUrl;
  String address;
  String studentId;


  // Constructor
  StudentModel({
    required this.studentId,
    required this.name,
    required this.rollNo,
    required this.branch,
    required this.imgUrl,
    required this.year,
    required this.email,
    required this.mobileNo,
    required this.bloodGroup,
    required this.gender,
    required this.address,
  });

  // Convert Firestore document into a Student object
  factory StudentModel.fromFirestore(Map<String, dynamic> firestoreDoc) {
    return StudentModel(
      name: firestoreDoc['name'] ?? '',
      imgUrl: firestoreDoc['imgUrl'] ?? '',
      studentId: firestoreDoc['studentId'] ?? '',
      rollNo: firestoreDoc['rollNo'] ?? '',
      branch: firestoreDoc['branch'] ?? '',
      year: firestoreDoc['year'] ?? '',
      email: firestoreDoc['email'] ?? '',
      mobileNo: firestoreDoc['mobileNo'] ?? '',
      bloodGroup: firestoreDoc['bloodGroup'] ?? '',
      gender: firestoreDoc['gender'] ?? '',
      address: firestoreDoc['address'] ?? '',
    );
  }

  // Convert Student object to a map to save in Firestore
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'name': name,
      'rollNo': rollNo,
      'imgUrl': imgUrl,
      'branch': branch,
      'year': year,
      'email': email,
      'mobileNo': mobileNo,
      'bloodGroup': bloodGroup,
      'gender': gender,
      'address': address,
    };
  }
}
