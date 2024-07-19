import 'package:chata/services/alert_services.dart';
import 'package:chata/services/auth_service.dart';
import 'package:chata/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt _getIt = GetIt.instance;
  late final AuthService _authService;
  late final NavigationService _navigationService;
    late final AlertServices _alertServices;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertServices = _getIt.get<AlertServices>();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOME'),
        actions: [
          IconButton(
            onPressed: () async {
              bool result  = await _authService.logOut();
              if(result)
              {
                _alertServices.showToast(text: "Logged Out!",icon: Icons.check);
                _navigationService.pushReplacementNamed("/login");
              }
            },
            icon: Icon(
              Icons.logout,
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
