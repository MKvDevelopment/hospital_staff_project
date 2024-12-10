import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_project/common_code/custom_text_style.dart';
import 'package:hospital_staff_project/provider/AppoitmentProvider.dart';
import 'package:provider/provider.dart';

import '../../common_code/custom_elevated_button.dart';
import '../patientManagementScreen/AppointmentModel.dart';

class AppoitmentAcceptScreen extends StatefulWidget {
  const AppoitmentAcceptScreen({super.key});

  @override
  State<AppoitmentAcceptScreen> createState() => _AppoitmentAcceptScreenState();
}

class _AppoitmentAcceptScreenState extends State<AppoitmentAcceptScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Safely access arguments and handle null cases
    fetchAllAppoitment();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        title: Text(
          'My Pending Appoitment',
          style: CustomTextStyles.titleMedium.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                fetchAllAppoitment();
              },
              icon: const Icon(Icons.refresh)),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Consumer<AppointmentProvider>(
        builder: (context, appointmentProvider, child) {
          final appointments = appointmentProvider.pendingAppointments;
          return Stack(
            children: [
              AppointmentListView(
                appointments: appointments,
                emptyMessage: 'No Upcoming Appointments',
                btnShow: 'yes',
              ),
              if (appointmentProvider.isLoading)
                Container(
                  color: Colors.black54, // Optional dimmed background
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.red,),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void fetchAllAppoitment() {
    // Fetch data using Provider
    final studentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);
    studentProvider.fetchAppointments();
  }
}

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
    if (appointments.isEmpty) {
      return Center(
          child: Text(emptyMessage, style: CustomTextStyles.titleMedium));
    }

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return getCardDesing(context, appointment, btnShow);
      },
    );
  }

  // Show dialog to select new date and time
  Future<void> _showRescheduleDialog(BuildContext context, String id) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        //    return null
        return const RescheduleDialog();
      },
    );

    if (result != null && result['date'] != null && result['time'] != null) {
      DateTime newDate = result['date'];
      String newTime = result['time'].format(context);

      Provider.of<AppointmentProvider>(context, listen: false)
          .rescheduleAppointment(id, newDate, newTime);
    }
  }

  void showConfirmDialog(BuildContext context, String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Alert!',
              style: CustomTextStyles.titleMedium,
            ),
            content: Text(
              'Are you Sure? You want to cancel this Appoitment?',
              style: CustomTextStyles.titleMedium,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                  'No',
                  style: CustomTextStyles.titleSmall,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Provider.of<AppointmentProvider>(context, listen: false)
                      .cancelPendingAppointment(id, context);
                },
                child: Text(
                  'Yes',
                  style: CustomTextStyles.titleSmall,
                ),
              ),
            ],
          );
        });
  }

  void showAcceptConfirmDialog(BuildContext context, String id) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Alert!',
              style: CustomTextStyles.titleMedium,
            ),
            content: Text(
              'Are you Sure? You want to Accept this Appoitment?',
              style: CustomTextStyles.titleMedium,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text(
                  'No',
                  style: CustomTextStyles.titleSmall,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Provider.of<AppointmentProvider>(context, listen: false)
                      .acceptPendingAppointment(id, context);
                },
                child: Text(
                  'Yes',
                  style: CustomTextStyles.titleSmall,
                ),
              ),
            ],
          );
        });
  }

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

  Widget getCardDesing(
      BuildContext context, AppointmenModel appointment, String btnShow) {
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
                          height: 30, width: 30, 'assets/icons/doctorIcon.png'),
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
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                margin: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Date:-  ${appointment.date}',
                      maxFontSize: 20,
                      minFontSize: 12,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: CustomTextStyles.titleSmall
                          .copyWith(fontWeight: FontWeight.bold),
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
              const SizedBox(
                height: 10,
              ),
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
                                      backgroundColor: ThemeData().cardColor),
                                  labelText: Text(
                                    'Cancel',
                                    style: CustomTextStyles.titleSmall,
                                  ),
                                  onPressed: () {
                                    showConfirmDialog(context, appointment.id);
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
                                    _showRescheduleDialog(
                                        context, appointment.id);
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
                                      backgroundColor: Colors.green),
                                  labelText: const Text('Accept'),
                                  onPressed: () {
                                    showAcceptConfirmDialog(
                                        context, appointment.id);
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

class RescheduleDialog extends StatefulWidget {
  const RescheduleDialog({super.key});

  @override
  _RescheduleDialogState createState() => _RescheduleDialogState();
}

class _RescheduleDialogState extends State<RescheduleDialog> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  var dateController = TextEditingController();
  var timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeData().cardColor,
      title: Text(
        'Reschedule Appointment',
        style: CustomTextStyles.titleMedium,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: dateController,
            style: CustomTextStyles.titleSmall,
            decoration: InputDecoration(
              labelStyle: CustomTextStyles.titleSmall,
              labelText: "New Date",
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 1.0,
                  horizontal: 12.0), // Adjust top and bottom padding
            ),
            readOnly: true,
            // Prevents manual text input
            onTap: () async {
              // Show date picker when tapped
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (pickedDate != null) {
                setState(() {
                  _selectedDate = pickedDate;
                  dateController.text =
                      "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                });
              }
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: timeController,
            style: CustomTextStyles.titleSmall,
            decoration: InputDecoration(
              labelStyle: CustomTextStyles.titleSmall,

              labelText: "New Time",
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 1.0,
                  horizontal: 12.0), // Adjust top and bottom padding
            ),
            readOnly: true,
            // Prevents manual text input
            onTap: () async {
              // Show date picker when tapped

              TimeOfDay? time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time != null) {
                setState(() {
                  _selectedTime = time;
                  timeController.text = time.format(context);
                });
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          // Close dialog without saving
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _confirmReschedule,
          child: const Text('Save'),
        ),
      ],
    );
  }

  // Confirm reschedule and pass selected DateTime back
  void _confirmReschedule() {
    if (_selectedDate != null && _selectedTime != null) {
      Navigator.pop(context, {'date': _selectedDate, 'time': _selectedTime});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both date and time.')),
      );
    }
  }
}
