import 'package:cloud_firestore/cloud_firestore.dart';

class AppointmenModel {
  final String id;
  final String? userId;
  final String doctorName;
  final String category;
  final String date;
  final String time;
  final String verification;
   String status;

  AppointmenModel(
      {required this.id,
      required this.userId,
      required this.verification,
      required this.doctorName,
      required this.category,
      required this.date,
      required this.time,
      required this.status});


  factory AppointmenModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmenModel(
      id: doc.id,
      doctorName: data['doctorName'] ?? '',
      userId: data['userId'] ?? '',
      date: data['date'] ?? '',
      verification: data['verification'] ?? '',
      time: data['time'] ?? '',
      category: data['category'] ?? '',
      status: data['status'] ?? 'Pending',
    );
  }
  // Convert Appointment instance to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'doctorName': doctorName,
      'verification': verification,
      'date': date,
      'time': time,
      'category': category,
      'status': status,
    };
  }
}
