import 'package:chata/Pages/chat_page.dart';
import 'package:chata/models/user_profile.dart';
import 'package:chata/services/alert_services.dart';
import 'package:chata/services/auth_service.dart';
import 'package:chata/services/database_service.dart';
import 'package:chata/services/navigation_service.dart';
import 'package:chata/widgets/chat_tile.dart';
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
  late final DatabaseService _databaseService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
    _alertServices = _getIt.get<AlertServices>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HOME'),
        actions: [
          IconButton(
            onPressed: () async {
              bool result = await _authService.logOut();
              if (result) {
                _alertServices.showToast(
                    text: "Logged Out!", icon: Icons.check);
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
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: _chatList(),
      ),
    );
  }

  Widget _chatList() {
    return StreamBuilder(
        stream: _databaseService.getUserProfiles(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to load data '),
            );
          }
          // print("hello");
          if (snapshot.hasData) {
            // print("hello");

            final users = snapshot.data!.docs;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                UserProfile user = users[index].data();
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ChatTile(
                    userProfile: user,
                    onTap: () async {
                      final bool checkChatExists = await _databaseService
                          .checkChatExists(_authService.user!.uid, user.uid!);
                      print(checkChatExists);
                      if (!checkChatExists) {
                        await _databaseService.createNewChatId(
                          _authService.user!.uid,
                          user.uid!,
                        );
                      }
                      _navigationService.push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ChatPage(
                              chatUser: user,
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
