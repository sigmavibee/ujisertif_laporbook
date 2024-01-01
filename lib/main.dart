import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lapor_book/firebase_options.dart';
import 'package:lapor_book/pages/addform_page.dart';
import 'package:lapor_book/pages/dashboard/dashboard_page.dart';
import 'package:lapor_book/pages/splash_page.dart';
import 'package:lapor_book/pages/register.dart';
import 'package:lapor_book/pages/dashboard/login_page.dart';
// import 'package:firebase_app_check/firebase_app_check.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseAppCheck.instance.activate(webRecaptchaSiteKey: 'YOUR_RECAPTCHA_SITE_KEY');

  runApp(MaterialApp(
    title: 'Lapor Book',
    initialRoute: '/',
    routes: {
      '/': (context) => const SplashPage(),
      '/login': (context) => const LoginPage(),
      '/register': (context) => const RegisterPage(),
      '/dashboard': (context) => const DashboardPage(),
      '/add': (context) => const AddFormPage(),
      // '/detail': (context) => DetailPage(),
    },
  ));
}
