import 'package:flutter/material.dart';


class LoginField extends StatelessWidget {
  const LoginField({super.key, required this.controller, required this.text, required this.isObscureText});
  final String text;
  final TextEditingController controller;
  final bool isObscureText;


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextFormField(
        obscureText: isObscureText,
        style: const TextStyle(fontSize: 15),
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(15.0), // Adjust curvature here
            ),
            fillColor: Colors.black26,
            hintText: text,
            hintStyle: const TextStyle(fontWeight: FontWeight.w300)),
        controller: controller,
      ),
    );
  }
}
