class Employee {
  String id;
  String name;
  String email;
  String imageUrl;
  String experience;
  String contact;
  String education;
  String role;

  Employee({
    required this.id,
    required this.name,
    required this.experience,
    required this.imageUrl,
    required this.email,
    required this.contact,
    required this.education,
    required this.role,
  });

  // Factory method to create an Employee object from JSON
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      name: json['name'],
      experience: json['experience'],
      imageUrl: json['imageUrl'],
      email: json['email'],
      contact: json['contact'],
      education: json['education'],
      role: json['role'],
    );
  }

  // Method to convert an Employee object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'experience': experience,
      'name': name,
      'imageUrl': imageUrl,
      'email': email,
      'contact': contact,
      'education': education,
      'role': role,
    };
  }
}
