import 'package:flutter/material.dart';
import 'package:hospital_staff_project/common_code/custom_text_style.dart';

import '../../constants.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              campusImg, // Replace with your background image path
              fit: BoxFit.cover,
            ),
          ),
          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'About Us',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        // Card 1: Key Features
                        _buildCard(
                          context,
                          title: 'Key Features',
                          content:
                          '➥ Electronic Patient Records: Securely store and manage patient health \n    records.\n'
                              '➥ Appointment Scheduling: Easily book, view, and manage appointments.\n'
                              '➥ Prescription Management: Access and manage prescriptions.\n'
                              '➥ Emergency Services: Quick access to emergency services.\n'
                              '➥ Data Security & Privacy: Robust security for patient data.\n'
                              '➥ Medical Certificates & Referrals: Generate and track documents.',
                        ),
                        const SizedBox(height: 16),
                        // Card 2: Vision
                        _buildCard(
                          context,
                          title: 'Our Vision',
                          content:
                          'We aim to create a seamless healthcare experience for students, faculty, and staff. '
                              'IntelliMed is committed to providing reliable, scalable, and user-friendly solutions that empower users to take control of their health and well-being.',
                        ),
                        const SizedBox(height: 16),
                        // Card 3: Future Plans
                        _buildCard(
                          context,
                          title: 'Future Plans',
                          content:
                          '➥ Telemedicine Integration: Enable remote consultations.\n'
                              '➥ Enhanced Machine Learning Models: Provide accurate disease predictions \n    and medication recommendations.',
                        ),
                        const SizedBox(height: 16),
                        // Card 3: Future Plans
                        _buildCard(
                          context,
                          title: 'Health Center Timing',
                          content:
                          '➥ Monday to Friday \n     (8:30 AM to 07:00 PM).\n'
                              '➥ Saturday to Sunday \n     (Morning - 10:00 AM to 02:00 PM) \n     (Evening - 03:00 PM to 07:00 PM)\n'
                          '➥ Night Timing \n    Monday to Saturday \n     (10:00 PM to 06:00 AM)\n'
                          '➥ Sunday Closed',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required String title, required String content}) {
    return Card(
      color: Colors.white.withOpacity(0.9), // Semi-transparent card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: CustomTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: CustomTextStyles.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
