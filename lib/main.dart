import 'package:chata/services/auth_service.dart';
import 'package:chata/services/navigation_service.dart';
import 'package:chata/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await setUp();
  runApp( MyApp());
}

Future<void> setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
   await setupFirebase();
   await registerServices();
}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  late final NavigationService _navigationService;
  late final AuthService _authService ;
   MyApp({super.key}){
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();

   }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      initialRoute: _authService.user!=null ? "/home" : "/login", // automatic relogging 
      routes: _navigationService.routes!,
    );
  }
}