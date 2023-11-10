import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutternodecrud/pages/config.dart';
import 'package:flutternodecrud/pages/dashboard_page.dart';
import 'package:flutternodecrud/pages/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool isNotValidate = false;
  late SharedPreferences _prefs;
  login() async {
    if (_emailController.text.isNotEmpty && _passController.text.isNotEmpty) {
      var regBody = {
        "email": _emailController.text.trim(),
        "password": _passController.text.trim()
      };
      var response = await http.post(Uri.parse(loginuser),
          headers: {"content-type": "application/json"},
          body: jsonEncode(regBody));

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);
      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        _prefs.setString("token", myToken);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("sucessful")));
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardPage(
                      token: myToken,
                    )));
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

  initsharedPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    // TODO: implement initState
    initsharedPref();
    super.initState();
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
                  login();
                },
                child: Text("Login"))
          ],
        ),
      ),
    );
  }
}
