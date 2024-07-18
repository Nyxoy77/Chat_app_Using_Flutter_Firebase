import 'package:chata/Pages/login_page.dart';
import 'package:chata/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await setUp();
  runApp(const MyApp());
}

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
   await registerServices();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const LoginPage(),
    );
  }
}
