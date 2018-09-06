import 'package:flutter/material.dart';
import 'package:Wyther/home.dart';
import 'package:Wyther/login.dart';
import 'package:Wyther/register.dart';

final routes = {
  '/login':       (BuildContext context) => new LoginPage(),
  '/home':        (BuildContext context) => new HomePage(),
  '/' :           (BuildContext context) => new LoginPage(),
  '/register' :   (BuildContext context) => new RegisterPage(),
};
