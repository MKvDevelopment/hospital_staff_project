import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hospital_staff_project/provider/AppoitmentProvider.dart';
import 'package:hospital_staff_project/provider/AuthProvider.dart';
import 'package:hospital_staff_project/provider/DriverProvider.dart';
import 'package:hospital_staff_project/provider/StudentProvider.dart';
import 'package:hospital_staff_project/provider/doctor_provider.dart';
import 'package:hospital_staff_project/route_constants.dart';
import 'package:hospital_staff_project/screen/Appoitment%20Accept/appoitmentAcceptScreen.dart';
import 'package:hospital_staff_project/screen/SplashScreen.dart';
import 'package:hospital_staff_project/screen/ambulanceDriver/All_Driver.dart';
import 'package:hospital_staff_project/screen/auth/ChangePasswordPage.dart';
import 'package:hospital_staff_project/screen/auth/LoginPage.dart';
import 'package:hospital_staff_project/screen/auth/RegisterPage.dart';
import 'package:hospital_staff_project/screen/home/homePage.dart';
import 'package:hospital_staff_project/screen/patientManagementScreen/patientDetailPage.dart';
import 'package:provider/provider.dart';
import 'common_code/custom_text_style.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProviderr()),
      ChangeNotifierProvider(create: (_) => DriverProvider()),
      ChangeNotifierProvider(create: (_) => StudentProvider()),
      ChangeNotifierProvider(create: (_) => AppointmentProvider()),
      ChangeNotifierProvider(create: (_) => DoctorProvider()),
    ],
    child: const MyApp(),
  ));
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
          scaffoldBackgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.black,
            size: 24.0,
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            labelStyle: const TextStyle(
              color: Colors.grey,
            ),
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            // Add more customization as needed
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(
                color: Colors.white, fontSize: 20, fontFamily: 'Poppins'),
            bodyMedium: TextStyle(color: Colors.white, fontSize: 14),
            bodySmall: TextStyle(color: Colors.white, fontSize: 12),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            elevation: 5,
            iconTheme: const IconThemeData(color: Colors.white),
            titleTextStyle:
                CustomTextStyles.titleMedium.copyWith(color: Colors.white),
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            elevation: 10,
          ),
          listTileTheme: const ListTileThemeData(
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
              subtitleTextStyle: TextStyle(color: Colors.white, fontSize: 14),
              iconColor: Colors.white,
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
              textColor: Colors.white),
          dialogTheme: const DialogTheme(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
            contentTextStyle: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        // Dark theme is inclided in the Full template
        themeMode: ThemeMode.light,
        initialRoute: logInScreenRoute,
        routes:{
          logInScreenRoute: (context) =>const LoginScreen(),
          homeScreenRoute: (context) =>const HomePage(),
          signUpScreenRoute: (context) =>const RegisterPage(),
          studentDetailScreenRoute: (context) => PatientDetailPage(),
          changePasswordScreenRoute: (context) =>const ChangePasswordPage(),
          driverListScreenRoute: (context) => const DriverManagementPage(),
          appoitmentAcceptScreenRout: (context) => const AppoitmentAcceptScreen(),
        }

    );
  }
}
