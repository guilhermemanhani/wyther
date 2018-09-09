import 'package:flutter/material.dart';

import 'package:Wyther/home.dart';
import 'package:Wyther/login.dart';
import 'package:Wyther/login/email.dart';


// TODO: Convert ShrineApp to stateful widget (104)
class WytherApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wyther',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),      
      // home: HomePage(),
      routes: {
        '/': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => HomePage(),
        '/email': (BuildContext context) => EmailLoginPage(),
      },
      initialRoute: '/login',
      onGenerateRoute: _getRoute,
      
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}

// TODO: Build a Shrine Theme (103)
// TODO: Build a Shrine Text Theme (103)
