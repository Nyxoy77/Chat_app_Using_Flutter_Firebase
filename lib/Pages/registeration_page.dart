import 'dart:io';

import 'package:chata/const.dart';
import 'package:chata/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class RegisterationPage extends StatefulWidget {
  const RegisterationPage({super.key});

  @override
  State<RegisterationPage> createState() => _RegisterationPageState();
}

class _RegisterationPageState extends State<RegisterationPage> {
  final GlobalKey _loginFormKey = GlobalKey<FormState>();
  String? name , email , password;
  File? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildUi(),
    );
  }

  Widget _buildUi() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(children: [
          _headerUi(),
          _registerForm(),
          _loginButton(),
        ],),
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
      height: MediaQuery.sizeOf(context).height * 0.40,
      margin: EdgeInsets.symmetric(
        vertical: MediaQuery.sizeOf(context).height * 0.05,
      ),
      child: Form(
        key: _loginFormKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _pfpSelectionField(),
              CustomFormField(
                validationRegEx: emailRegExp,
                height: MediaQuery.sizeOf(context).height * 0.1,
                hintText: "Name",
                onSaved: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              CustomFormField(
                validationRegEx: passwordRegExp,
                height: MediaQuery.sizeOf(context).height * 0.1,
                hintText: "Email",
                obscure: true,
                onSaved: (value) {
                  setState(() {
                    password = value;
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
             
            ],
          ),
        ),
      ),
    );
  }
  Widget _pfpSelectionField(){
   return GestureDetector(
    onTap: ()async{
      ImagePicker _imagePicker = ImagePicker();
      XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if(image!=null)
      {
        selectedImage = image as File?;
      }
    },
     child: CircleAvatar(
      radius: MediaQuery.sizeOf(context).width*0.15,
      backgroundImage: selectedImage !=null ? FileImage(selectedImage!):NetworkImage(imageUrl) as ImageProvider,
     
     ),
   );
  }

   Widget _loginButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        onPressed: () async {
          // if (_loginFormKey.currentState?.validate() ?? false) {
          //   _loginFormKey.currentState?.save();
          //   bool result = await _authService.login(email!, password!);
          //   if (result) {
          //     _alertServices.showToast(text: "Login Successful!");
          //     _navigationService.pushReplacementNamed("/home");
          //   } else {
          //     _alertServices.showToast(text: "Failed to loging . Please try again ",icon: Icons.error);
          //   }
          // }
        },
        child: const Text("Submit"),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  
}
