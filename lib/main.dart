// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutternodecrud/pages/dashboard_page.dart';
import 'package:flutternodecrud/pages/login_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutternodecrud/pages/registration_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    token: _prefs.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  var token;
  MyApp({
    Key? key,
    required this.token,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: (JwtDecoder.isExpired(token) == false)
            ? DashboardPage(token: token)
            : RegistrationPage());
  }
}
