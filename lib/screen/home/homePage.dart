import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_project/constants.dart';
import 'package:hospital_staff_project/screen/Appoitment%20Accept/appoitmentAcceptScreen.dart';
import 'package:hospital_staff_project/screen/home/aboutUs.dart';

import '../ambulanceDriver/All_Driver.dart';
import '../dashboard/dashboardScreen.dart';
import '../doctorManagement/doctorManagementScreen.dart';
import '../patientManagementScreen/patientManagementScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  // List of screens for the side navigation
  final List<Widget> screens = [
    const DashboardScreen(),
    const DoctorManagementScreen(),
    const PatientManagementScreen(),
    const DriverManagementPage(),
    const AppoitmentAcceptScreen(),
    const AboutUsScreen(),
  ];

  // Titles for the screens
  final List<String> titles = [
    "My Dashboard Page",
    "Doctor Management",
    "Patient Management",
    "Ambulance Management",
    "Pending Appointments",
    "About Hospital"
  ];

  @override
  void initState() {
    super.initState();

    Constants().backButtonDisabled(context);

  }



  @override
  Widget build(BuildContext context) {
    var widthh=MediaQuery.of(context).size.width;

    return LayoutBuilder(
      builder: (context, constraints) {
        return  Scaffold(
            body: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    width:  250,
                    color: Colors.red[900],
                    child: Column(
                      children: [
                        // App Logo or Header

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            radius: 100,
                            backgroundColor: Colors.white,
                            child: Image.asset(logoImg2,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: ListView(

                              children: List.generate(
                                  screens.length,
                                      (index) => ListTile(
                                    leading: Icon(
                                      Icons.circle,
                                      color: selectedIndex == index
                                          ? Colors.green[700]
                                          : Colors.white,
                                    ),
                                    title: AutoSizeText(
                                      titles[index],
                                      minFontSize: 12,
                                      maxFontSize: 18,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: selectedIndex == index
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    selected: selectedIndex == index,
                                    selectedTileColor: Colors.red[700],
                                    onTap: () {
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                    },
                                  )),
                            ))
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child:  screens[selectedIndex],
                ),
              ],
            )
        );
      }
    );
  }
}
