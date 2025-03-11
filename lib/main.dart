import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:presensi/ui/pages.dart';
import 'package:presensi/ui/ui/attendance/attendance/attendance_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      // data ambil dari file google-services.json
        apiKey: 'AIzaSyDJYbSJWnd4V7fXKqIjzfFKS4mIXn5V-DY', // current_key
        appId: '1:981464828391:android:e7ea5330662a6df9265542', // mobilesdk_app_id
        messagingSenderId: '243811762198', // project_number
        projectId: 'presensi-ed3e7' // project_id
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/sign-in': (context) => SignInPage(),
        '/sign-up': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/note' : (context) => NotePage(),
        '/profile' : (context) => OnboardingScreen(),
        '/change-password' : (context) => ChangePasswordPage(),
        '/attendance-page' : (context)=> AttendancePage(),
        '/home-attendance' : (context)=> HomeAttendence(),
        '/leave-page' : (context)=> LeavePage(),
        '/history-page' : (context)=> HistoryPage(),

      },
      home: SplashScreen(),
    );
  }
}