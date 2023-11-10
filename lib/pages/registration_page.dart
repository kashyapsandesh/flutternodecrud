import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutternodecrud/pages/config.dart';
import 'package:flutternodecrud/pages/login_page.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool isNotValidate = false;
  register() async {
    if (_emailController.text.isNotEmpty && _passController.text.isNotEmpty) {
      var regBody = {
        "email": _emailController.text.trim(),
        "password": _passController.text.trim()
      };
      var response = await http.post(Uri.parse(registration),
          headers: {"content-type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);
      if (jsonResponse['status']) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("sucessful")));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("something wrong")));
      }
    } else {
      setState(() {
        isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              validator: (value) {},
              controller: _emailController,
              decoration: InputDecoration(
                  errorText: isNotValidate ? "Enter proper details" : null,
                  hintText: "Enter Your Email",
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            TextFormField(
              validator: (value) {},
              controller: _passController,
              decoration: InputDecoration(
                  hintText: "Enter Your password",
                  errorText: isNotValidate ? "Enter proper details" : null,
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            ElevatedButton(
                onPressed: () {
                  register();
                },
                child: Text("Registration")),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: Text("Already Have an Account"))
          ],
        ),
      ),
    );
  }
}
