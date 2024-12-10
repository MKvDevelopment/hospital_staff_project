import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';

import 'common_code/custom_text_style.dart';
import 'dart:html' as html;
class Constants {
  static  String userSearchId='';



  void backButtonDisabled(BuildContext context) {
    // Listen to browser back/forward button presses
    html.window.onPopState.listen((event) {
      // Intercept the back/forward navigation
      html.window.history.pushState(null, 'title', '/'); // Prevent navigation
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Navigation Disabled',style: CustomTextStyles.titleLarge,),
          content: Text('Browser navigation buttons are disabled.',style: CustomTextStyles.titleMedium,),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK',style: CustomTextStyles.titleMedium,),
            ),
          ],
        ),
      );
    });
  }
}

const String campusImg="assets/images/view_M.jpg";
const String logoImg="assets/images/logo_ti.png";
const String logoImg2="assets/images/logoo.png";
const String loginPageTitle="IntelliMed";
const String loginPageDesc="Enter your Registered Email and Password.";

const String registerPageImg="assets/images/signup.png";
const String registerPageTitle="Create Your Account!";
const String registerPageDesc="Enter your details below to create a new account.";



const Color cardBackgroundColor = Color(0xFFF4F3F6);
const Color purpleColor = Color(0xFF7B61FF);
const Color successColor = Color(0xFF2ED573);
const Color warningColor = Color(0xFFFFBE21);
const Color errorColor = Color(0xFFEA5B5B);
const Color whiteColor = Colors.white;

const double defaultPadding = 16.0;
const double defaultBorderRadious = 12.0;
const Duration defaultDuration = Duration(milliseconds: 300);

var doctorList=["Dr.Ajay Gupta","Dr.Ritu Bassi","Dr.Jeevanjot Singh","Dr.Gaganpreet Singh","Dr.Sarabjeet Kaur"];
var doctorCategory=["General Physican","Dentist","Ent Specialist (Otolaryngologist)","Ophthalmologis","Neurologist"];

var hostalList = [
  'Agira Hall',
  'Ambaram Hall',
  'Amritam Hall',
  'Ananta Hall',
  'Anantam Hall',
  'Hostel FR-F',
  'Hostel PG',
  'Neeram Hall',
  'Prithvi Hall',
  'Streat Cafe (Admin Block)',
  'Tejas Hall',
  'Vahni Hall',
  'Viyat Hall',
  'Vyan Hall',
  'Vyom Hall',
  'Waterbody Cafe (Library)'
];

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'Password is required'),
  MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
  // PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
]);

final emaildValidator = MultiValidator([
  RequiredValidator(errorText: 'Email is required'),
  EmailValidator(errorText: "Enter a valid email address"),
]);

const pasNotMatchErrorText = "passwords do not match";

// String generateRandomString() {
//   const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
//   Random random = Random();
//   return List.generate(30, (index) => characters[random.nextInt(characters.length)]).join();
// }

/*Future<void> checkPermissions() async {
  PermissionStatus storageStatus = await Permission.storage.status;

  if (!storageStatus.isGranted) {
    await Permission.storage.request();
    print(await Permission.storage.status);
  }

  if (await Permission.storage.isPermanentlyDenied) {
    // If permission is permanently denied, guide the user to the app settings.
    openAppSettings();
  }
}*/


void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

void showErrorSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
      backgroundColor: errorColor,
    ),
  );
}

void flushBarErrorMsg(BuildContext context, String title, String msg) {
  Flushbar(
    title: title,
    message: msg,
    flushbarPosition: FlushbarPosition.TOP,
    forwardAnimationCurve: Curves.decelerate,
    reverseAnimationCurve: Curves.decelerate,
    isDismissible: false,
    boxShadows: const [BoxShadow(color: Colors.red, offset: Offset(0.0, 2.0), blurRadius: 5.0)],
    duration:  const Duration(seconds: 3),
    margin:const  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    borderRadius: BorderRadius.circular(8),
    padding:const  EdgeInsets.all(10),
    backgroundGradient: LinearGradient(colors: [Colors.red.shade100, Colors.red]),
    icon:const  Icon(Icons.error_outline, color: whiteColor),
    backgroundColor: errorColor,
  ).show(context);
}

void flushBarSuccessMsg(BuildContext context, String title, String msg) {
  Flushbar(
    title: title,
    message: msg,
    flushbarPosition: FlushbarPosition.BOTTOM,
    forwardAnimationCurve: Curves.decelerate,
    reverseAnimationCurve: Curves.decelerate,
    isDismissible: false,
    boxShadows:const  [BoxShadow(color: Colors.green, offset: Offset(0.0, 2.0), blurRadius: 5.0)],
    duration: const  Duration(seconds: 3),
    margin:const  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    borderRadius: BorderRadius.circular(8),
    padding:const  EdgeInsets.all(10),
    icon:const  Icon(Icons.check, color: whiteColor),
    backgroundGradient:const  LinearGradient(colors: [Colors.lightGreen, Colors.green]),
  ).show(context);
}

void showToastMsg(BuildContext context, String text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
