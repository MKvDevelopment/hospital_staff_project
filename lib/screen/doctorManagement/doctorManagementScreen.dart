import 'package:flutter/material.dart';
import 'package:hospital_staff_project/common_code/custom_text_style.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../provider/doctor_provider.dart';
import 'doctorCardDesign.dart';
import 'doctorModel.dart';

class DoctorManagementScreen extends StatefulWidget {
  const DoctorManagementScreen({super.key});

  @override
  DoctorManagementScreenState createState() => DoctorManagementScreenState();
}

class DoctorManagementScreenState extends State<DoctorManagementScreen> {
  @override
  void initState() {
    super.initState();
    final doctorProvider = Provider.of<DoctorProvider>(context, listen: false);
    doctorProvider.fetchDoctors();
  }

  void _showAddDoctorDialog(BuildContext context) {
    final nameController = TextEditingController();
    final departmentController = TextEditingController();
    final contactController = TextEditingController();
    final timeController = TextEditingController();
    final experienceController = TextEditingController();
    String availabilityStatus = "false";

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Add Doctor',
          style: CustomTextStyles.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                style: CustomTextStyles.titleMedium,
                decoration: const InputDecoration(labelText: 'Doctor Name'),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: departmentController,
                textCapitalization: TextCapitalization.words,
                style: CustomTextStyles.titleMedium,
                decoration: const InputDecoration(labelText: 'Department'),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: contactController,
                style: CustomTextStyles.titleMedium,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: timeController,
                style: CustomTextStyles.titleMedium,
                decoration:
                    const InputDecoration(labelText: 'Availability Time'),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: experienceController,
                style: CustomTextStyles.titleMedium,
                decoration:
                    const InputDecoration(labelText: 'Experience (years)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 5,
              ),
              SwitchListTile(
                title: Text(
                  'Available',
                  style: CustomTextStyles.titleMedium,
                ),
                value: bool.parse(availabilityStatus),
                onChanged: (val) {
                  setState(() {
                    availabilityStatus = val.toString();
                  });
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: CustomTextStyles.titleMedium,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              var uuid = const Uuid().v4();
              final doctor = DoctorModel(
                id: uuid.replaceAll("-", ""),
                doctorName: nameController.text.trim(),
                imgUrl:'',
                department: departmentController.text.trim(),
                contactNumber: contactController.text.trim(),
                availabilityTime: timeController.text.trim(),
                availabilityStatus: availabilityStatus,
                experience: experienceController.text.trim(),
              );
              Provider.of<DoctorProvider>(context, listen: false)
                  .addDoctor(doctor);
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Add',
              style: CustomTextStyles.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Doctor Management',
          style: CustomTextStyles.titleMedium.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<DoctorProvider>(context, listen: false)
                  .fetchDoctors();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddDoctorDialog(context),
          ),
        ],
      ),
      body: Consumer<DoctorProvider>(
        builder: (ctx, doctorProvider, _) {
          final width = MediaQuery.of(context).size.width;
          return Stack(
            children: [
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                itemCount: doctorProvider.doctors.length,
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:  width > 500 ? (width / 250).toInt() : 3, // Number of columns

                  childAspectRatio: 0.6, // Adjust height and width
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),

                itemBuilder: (ctx, i) {
                  final doctor = doctorProvider.doctors[i];
                  return DoctorCard(
                    doctor: doctor,
                    onStatusToggle: (String? id, bool newStatus) {
                      Provider.of<DoctorProvider>(context, listen: false)
                          .updateDoctorStatus(
                        id!,
                        newStatus ? "true" : "false",
                      );
                    },
                  );

                },
              ),
              if (doctorProvider.isLoading)
                Container(
                  color: Colors.black54, // Optional dimmed background
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  ),
                ),
              if (doctorProvider.doctors.isEmpty)
                Center(
                    child: Text(
                  'No doctors found.',
                  style: CustomTextStyles.titleLarge,
                ))
            ],
          );
        },
      ),
    );
  }
}
