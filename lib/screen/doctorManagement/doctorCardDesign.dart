import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_project/common_code/custom_text_style.dart';
import 'package:provider/provider.dart';

import '../../provider/doctor_provider.dart';
import 'doctorModel.dart';

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final Function(String? id, bool newStatus)
      onStatusToggle; // Callback to toggle status

  const DoctorCard({
    required this.doctor,
    required this.onStatusToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bool isAvailable = doctor.availabilityStatus == "true";

    return GestureDetector(
      onTap: () {
        // Navigate to doctor detail page
        showDialog(
          context: context,
          builder: (context) => _buildDoctorDialog(context, doctor),
        );
      },
      child: Card(
        elevation: 5,
        color: isAvailable ? Colors.green[100] : Colors.red[100],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.red,
                    child: doctor.imgUrl != '' && doctor.imgUrl.isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: doctor.imgUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => Text(
                                doctor.doctorName.isNotEmpty &&
                                        doctor.doctorName.length > 3
                                    ? doctor.doctorName[3].toUpperCase()
                                    : '',
                                style: CustomTextStyles.titleLarge,
                              ),
                            ),
                          )
                        : Text(
                            doctor.doctorName.isNotEmpty &&
                                    doctor.doctorName.length > 3
                                ? doctor.doctorName[3].toUpperCase()
                                : '',
                            style: CustomTextStyles.titleLarge,
                          ),
                  ),
                  if (isAvailable)
                    // Show green tick if available
                    const Icon(
                      Icons.circle,
                      color: Colors.green,
                      size: 24,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                doctor.doctorName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: CustomTextStyles.titleMedium,
              ),
              const SizedBox(height: 5),
              Text(
                'Dept: ${doctor.department}',
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.center,
                style: CustomTextStyles.titleSmall,
              ),
              const SizedBox(height: 5),
              Text(
                'Available: ${isAvailable ? "Yes" : "No"}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: CustomTextStyles.titleSmall,
              ),
              const SizedBox(height: 5),
              Text(
                'Time:\n  ${doctor.availabilityTime}',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: CustomTextStyles.titleSmall,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Exp: ${doctor.experience} yrs',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: CustomTextStyles.titleSmall,
                  ),
                  IconButton(
                    icon: Icon(
                      isAvailable ? Icons.toggle_on : Icons.toggle_off,
                      color: isAvailable ? Colors.green : Colors.grey,
                      size: 25,
                    ),
                    onPressed: () {
                      // Toggle status callback
                      onStatusToggle(
                        doctor.id,
                        !isAvailable,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorDialog(BuildContext parentContext, DoctorModel doctor) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Container(
        width: 650,
        height: 250,
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 100,
                  backgroundColor: Colors.blue,
                  child: Image.asset(
                    "assets/images/gents.png",
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          doctor.doctorName,
                          style: CustomTextStyles.titleLarge,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Dept: ${doctor.department}',
                          style: CustomTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Mobile No.: ${doctor.contactNumber}',
                          style: CustomTextStyles.titleMedium,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Experience: ${doctor.experience} years',
                          style: CustomTextStyles.titleMedium,
                        ),
                        Text(
                          'Available: ${doctor.availabilityStatus}',
                          style: CustomTextStyles.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                onPressed: () {
                  Navigator.of(parentContext).pop(); // Close the current dialog
                  _showEditDoctorDialog(parentContext, doctor);
                },
                icon: const Icon(Icons.edit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDoctorDialog(BuildContext context, DoctorModel doctor) {
    TextEditingController nameController =
        TextEditingController(text: doctor.doctorName);
    TextEditingController departmentController =
        TextEditingController(text: doctor.department);
    TextEditingController contactController =
        TextEditingController(text: doctor.contactNumber);
    TextEditingController timeController =
        TextEditingController(text: doctor.availabilityTime);
    TextEditingController experienceController =
        TextEditingController(text: doctor.experience);
    bool availabilityStatus =
        doctor.availabilityStatus == "true"; // Convert String to bool

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Update Doctor Details:-',
          style: CustomTextStyles.titleLarge,
        ),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    style: CustomTextStyles.titleMedium,
                    decoration: const InputDecoration(labelText: 'Doctor Name'),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: departmentController,
                    textCapitalization: TextCapitalization.words,
                    style: CustomTextStyles.titleMedium,
                    decoration: const InputDecoration(labelText: 'Department'),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: contactController,
                    style: CustomTextStyles.titleMedium,
                    decoration:
                        const InputDecoration(labelText: 'Contact Number'),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: timeController,
                    style: CustomTextStyles.titleMedium,
                    decoration:
                        const InputDecoration(labelText: 'Availability Time'),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: experienceController,
                    style: CustomTextStyles.titleMedium,
                    decoration:
                        const InputDecoration(labelText: 'Experience (years)'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 5),
                  SwitchListTile(
                    title: Text(
                      'Available',
                      style: CustomTextStyles.titleMedium,
                    ),
                    value: availabilityStatus,
                    onChanged: (val) {
                      setState(() {
                        availabilityStatus = val;
                      });
                    },
                  ),
                ],
              ),
            );
          },
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
            onPressed: () async {
              // Update doctor data
              final updatedDoctor = DoctorModel(
                id: doctor.id,
                // Keep the existing ID
                doctorName: nameController.text.trim(),
                imgUrl: doctor.imgUrl,
                department: departmentController.text.trim(),
                contactNumber: contactController.text.trim(),
                availabilityTime: timeController.text.trim(),
                availabilityStatus: availabilityStatus ? "true" : "false",
                // Convert bool to String
                experience: experienceController.text.trim(),
              );

              // Update doctor in the provider
              await Provider.of<DoctorProvider>(ctx, listen: false)
                  .updateDoctor(updatedDoctor);

              // Close all dialogs
              Navigator.of(ctx).pop(); // Close the edit dialog
            },
            child: Text(
              'Update',
              style: CustomTextStyles.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
