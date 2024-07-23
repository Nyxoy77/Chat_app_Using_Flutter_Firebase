import 'dart:io';
import 'package:chata/const.dart';
import 'package:chata/models/user_profile.dart';
import 'package:chata/services/alert_services.dart';
import 'package:chata/services/auth_service.dart';
import 'package:chata/services/database_service.dart';
import 'package:chata/services/media_service.dart';
import 'package:chata/services/navigation_service.dart';
import 'package:chata/services/storage_service.dart';
import 'package:chata/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

class RegisterationPage extends StatefulWidget {
  const RegisterationPage({super.key});

  @override
  State<RegisterationPage> createState() => _RegisterationPageState();
}

class _RegisterationPageState extends State<RegisterationPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey();
  final GetIt _getIt = GetIt.instance;
  late final MediaService _mediaService;
  late final NavigationService _navigationService;
  late final AuthService _authService;
  late final AlertServices _alertServices;
  late final StorageService _storageService;
  late final DatabaseService _databaseService;
  String? name, email, password;
  File? selectedImage;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _storageService = _getIt.get<StorageService>();
    _alertServices = _getIt.get<AlertServices>();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: [
            _headerUi(),
            if (isLoading == false) _registerForm(),
            if (isLoading == false) _loginAccountLink(),
            if (isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _headerUi() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            "Lets Get Going !",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          Text(
            "Register an account using the form below",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.60,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.04,
      ),
      child: Form(
        key: _registerFormKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _pfpSelectionField(),
              const SizedBox(height: 10),
              CustomFormField(
                validationRegEx: nameRegExp,
                height: MediaQuery.sizeOf(context).height * 0.1,
                hintText: "Name",
                onSaved: (value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
              CustomFormField(
                validationRegEx: emailRegExp,
                height: MediaQuery.sizeOf(context).height * 0.1,
                hintText: "Email",
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              CustomFormField(
                validationRegEx: passwordRegExp,
                height: MediaQuery.sizeOf(context).height * 0.1,
                hintText: "Password",
                obscure: true,
                onSaved: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              _registerButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImage();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.sizeOf(context).width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(imageUrl) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async {
          setState(() {
            isLoading = true;
          });
          try {
            if ((_registerFormKey.currentState?.validate() ?? false) &&
                selectedImage != null) {
              _registerFormKey.currentState!.save();
              final result =
                  await _authService.signUp(email: email!, password: password!);
              if (result) {
                _alertServices.showToast(text: "Regisetered Successfully!");
                String pfpURL = await _storageService.uploadUserPfp(
                    file: selectedImage!, uId: _authService.user!.uid);
                if (pfpURL != null) {
                  await _databaseService.createUserProfile(
                    userProfile: UserProfile(
                        uid: _authService.user!.uid,
                        name: name,
                        pfpURL: pfpURL),
                  );
                  _navigationService.goBack();
                  _navigationService.pushReplacementNamed("/home");
                } else {
                  // setState(() {
                  //   isLoading = false;
                  // });
                  throw Exception("Unable to upload the profile picture");
                }
              }
            } else {
              // setState(() {
              //   isLoading = false;
              // });
              throw Exception("Unable to register the user");
            }
          } catch (e) {
            // setState(() {
            //   isLoading = true;
            // });
            _alertServices.showToast(
                text: "Could not register ,an error occured ");
            print(e);
          }
          setState(() {
            isLoading = false;
          });
        },
        child: const Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _loginAccountLink() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text('Already have an account ?'),
          GestureDetector(
              onTap: () {
                _navigationService.goBack();
              },
              child: const Text(
                'Login',
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
