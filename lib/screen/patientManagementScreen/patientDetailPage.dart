import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_project/common_code/custom_text_style.dart';
import 'package:hospital_staff_project/constants.dart';
import 'package:hospital_staff_project/screen/patientManagementScreen/AppointmentModel.dart';
import 'package:provider/provider.dart';
import 'package:hospital_staff_project/provider/StudentProvider.dart';

import '../../common_code/custom_elevated_button.dart';

class PatientDetailPage extends StatefulWidget {
  @override
  _PatientDetailPageState createState() => _PatientDetailPageState();
}

class _PatientDetailPageState extends State<PatientDetailPage> {
  late String studentId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safely access arguments and handle null cases
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['studentId'] != null) {
      studentId = args['studentId'];
    } else {
      // Fallback if no argument passed, e.g., use a default or previously stored value
      studentId = Constants.userSearchId;
    }

    // Fetch data using Provider
    final studentProvider =
        Provider.of<StudentProvider>(context, listen: false);
    studentProvider.fetchPatientDetails(studentId);
    studentProvider.fetchPatientAppointments(studentId);
  }
  @override
  void initState() {
    super.initState();
    Constants().backButtonDisabled(context);

  }

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text('Details',
              style: CustomTextStyles.titleMedium.copyWith(
                  color: Theme.of(context).appBarTheme.foregroundColor)),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20), // Adjust this height for the TabBar
            child: TabBar(
              labelColor: Colors.orange,
              unselectedLabelColor: Colors.white,
              labelStyle: CustomTextStyles.titleSmall,
              indicatorColor: Colors.orange,
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Completed'),
                Tab(text: 'Canceled'),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            // Patient Profile Section
            Consumer<StudentProvider>(
              builder: (context, studentProvider, child) {
                if (studentProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                final patient = studentProvider.student;
                final appointments = studentProvider.allAppointments;

                if (patient == null) {
                  return Center(
                      child: Text(
                    "Patient details not found.",
                    style: CustomTextStyles.titleLarge,
                  ));
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Patient Profile
                        Text(
                          "Profile",
                          style: CustomTextStyles.titleMedium,
                        ),
                        ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              patient.name.isNotEmpty ? patient.name[0] : 'A',
                              style: CustomTextStyles.titleMedium,
                            ),
                          ),
                          title: Text(
                            patient.name,
                            style: CustomTextStyles.titleMedium,
                          ),
                          subtitle: Text(
                            "Mobile: ${patient.mobileNo}",
                            style: CustomTextStyles.titleMedium,
                          ),
                        ),
                        const Divider(),
                        // Appointments Section
                        Text(
                          "My Booked Appointments",
                          style: CustomTextStyles.titleMedium,
                        ),
                        ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: appointments.length,
                                itemBuilder: (context, index) {
                                  final appointment = appointments[index];
                                  return ListTile(
                                    title: Text(
                                      "Date: ${appointment.date ?? 'N/A'}",
                                      style: CustomTextStyles.titleMedium,
                                    ),
                                    subtitle: Text(
                                      "Doctor: ${appointment.doctorName ?? 'N/A'}",
                                      style: CustomTextStyles.titleMedium,
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const Expanded(
              // TabBarView for displaying appointments
              child: TabBarView(
                children: [
                  UpcomingAppointmentsTab(),
                  CompletedAppointmentsTab(),
                  CanceledAppointmentsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// Widget for displaying upcoming appointments
class UpcomingAppointmentsTab extends StatelessWidget {
  const UpcomingAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, appointmentProvider, child) {
        final upcomingAppointments = appointmentProvider.upcomingAppointments;
        return AppointmentListView(
          appointments: upcomingAppointments,
          emptyMessage: 'No Upcoming Appointments',
          btnShow: 'yes',
        );
      },
    );
  }
}

// Widget for displaying completed appointments
class CompletedAppointmentsTab extends StatelessWidget {
  const CompletedAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, appointmentProvider, child) {
        final completedAppointments = appointmentProvider.completedAppointments;
        return AppointmentListView(
          appointments: completedAppointments,
          emptyMessage: 'No Completed Appointments',
          btnShow: 'no',
        );
      },
    );
  }
}

// Widget for displaying canceled appointments
class CanceledAppointmentsTab extends StatelessWidget {
  const CanceledAppointmentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StudentProvider>(
      builder: (context, appointmentProvider, child) {
        final canceledAppointments = appointmentProvider.canceledAppointments;
        return AppointmentListView(
          appointments: canceledAppointments,
          emptyMessage: 'No Canceled Appointments',
          btnShow: 'no',
        );
      },
    );
  }
}

// Reusable widget for displaying a list of appointments
class AppointmentListView extends StatelessWidget {
  final List<AppointmenModel> appointments;
  final String emptyMessage;
  final String btnShow;

  const AppointmentListView(
      {super.key,
        required this.appointments,
        required this.emptyMessage,
        required this.btnShow});

  @override
  Widget build(BuildContext context) {
    double width=MediaQuery.of(context).size.width;
    double height=MediaQuery.of(context).size.height;
    if (appointments.isEmpty) {
      return Center(
          child: Text(emptyMessage, style: CustomTextStyles.titleMedium));
    }

   /* return width>=900?

    GridView.builder(
      gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // Number of columns in the grid
        crossAxisSpacing: 10.0, // Spacing between columns
        mainAxisSpacing: 10.0, // Spacing between rows
        childAspectRatio: 2/(width/4), // Adjust based on the card's height/width ratio
      ),
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
       return getCardDesing(context,appointment,btnShow);
      },
    ):*/
   return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return getCardDesing(context,appointment,btnShow);
      },
    );
  }

  // // Show dialog to select new date and time
  // Future<void> _showRescheduleDialog(BuildContext context, String id) async {
  //   final result = await showDialog<Map<String, dynamic>>(
  //     context: context,
  //     builder: (context){
  //       return null
  //   //    return RescheduleDialog();
  //     },
  //   );
  //
  //   if (result != null && result['date'] != null && result['time'] != null) {
  //     DateTime newDate = result['date'];
  //     String newTime = result['time'].format(context);
  //
  //     Provider.of<AppointmentProvider>(context, listen: false)
  //         .rescheduleAppointment(id, newDate, newTime);
  //   }
  // }
  //
  // void showConfirmDialog(BuildContext context, String id) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(
  //             'Alert!',
  //             style: CustomTextStyles.titleMedium,
  //           ),
  //           content: Text(
  //             'Are you Sure? You want to cancel this Appoitment?',
  //             style: CustomTextStyles.titleMedium,
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Close the dialog
  //               },
  //               child: Text(
  //                 'No',
  //                 style: CustomTextStyles.titleSmall,
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop(); // Close the dialog
  //                 Provider.of<AppointmentProvider>(context, listen: false)
  //                     .cancelAppointment(id, context);
  //                 //  AppointmentProvider().cancelAppointment(id, context);
  //               },
  //               child: Text(
  //                 'Yes',
  //                 style: CustomTextStyles.titleSmall,
  //               ),
  //             ),
  //           ],
  //         );
  //       });
  // }

  String getDayOfWeek(String date) {
    // Parse the date string to a DateTime object
    DateTime parsedDate = DateTime.parse(date);

    // Get the day of the week as an integer (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
    int dayOfWeek = parsedDate.weekday;

    // Convert the day of the week to a string
    switch (dayOfWeek) {
      case DateTime.monday:
        return 'Monday';
      case DateTime.tuesday:
        return 'Tuesday';
      case DateTime.wednesday:
        return 'Wednesday';
      case DateTime.thursday:
        return 'Thursday';
      case DateTime.friday:
        return 'Friday';
      case DateTime.saturday:
        return 'Saturday';
      case DateTime.sunday:
        return 'Sunday';
      default:
        return 'Invalid date';
    }
  }

  Widget getCardDesing(BuildContext context, AppointmenModel appointment, String btnShow) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Card(
        elevation: 6, // Adds depth to the card
        color: Colors.blue.shade50,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.black)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  // Image on the left side
                  Container(
                    margin: const EdgeInsets.only(left: 10.0),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Image.asset(
                          height: 30,
                          width: 30,
                          'assets/icons/doctorIcon.png'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          AutoSizeText(
                            appointment.doctorName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            minFontSize: 12,
                            maxFontSize: 20,
                            style: CustomTextStyles.titleMedium
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          // Subtitle
                          AutoSizeText(
                            appointment.category,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            minFontSize: 12,
                            maxFontSize: 20,
                            style: CustomTextStyles.titleSmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width ,

                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                margin: const EdgeInsets.symmetric(horizontal: 10.0,),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Date:-  ${appointment.date}',
                      maxFontSize: 20,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: CustomTextStyles.titleSmall.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AutoSizeText(
                      maxFontSize: 20,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      'Day:- ${getDayOfWeek(appointment.date)}',
                      style: CustomTextStyles.titleSmall,
                    ),
                    AutoSizeText(
                      maxFontSize: 20,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      'Time:- ${appointment.time}',
                      style: CustomTextStyles.titleSmall,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              btnShow == 'no'
                  ? Container()
                  : Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 5.0, vertical: 5.0),
                child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: CustomElevatedButton(
                            buttonStyle: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Colors.black, width: 1),
                                // Border color and width
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      50), // Rounded corners (optional)
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 1,
                                ),
                                // Padding inside the button
                                backgroundColor:
                                ThemeData().cardColor),
                            labelText: Text(
                              'Cancel',
                              style: CustomTextStyles.titleSmall,
                            ),
                            onPressed: () {
                              // showConfirmDialog(context, appointment.id);
                            })),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        flex: 1,
                        child: CustomElevatedButton(
                            buttonStyle: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Colors.black, width: 1),
                                // Border color and width
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      50), // Rounded corners (optional)
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 1),
                                // Padding inside the button
                                backgroundColor:
                                ThemeData().primaryColorDark),
                            labelText: const Text('Reschedule'),
                            onPressed: () {
                              //  _showRescheduleDialog(context, appointment.id);
                            })),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );

  }
}
