import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final double height ;
  final RegExp validationRegEx;
  final bool obscure ;
  final void Function(String?) onSaved;
  const CustomFormField({
    super.key,
     required this.hintText,
     required this.height, 
     required this.validationRegEx,
     this.obscure = false, required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        onSaved: onSaved,
        obscureText: obscure,
        validator: (value){
           if(value != null && validationRegEx.hasMatch(value))
           {
              return null;
           }
           return "Enter a valid ${hintText.toLowerCase()}";
        },
        decoration:  InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
