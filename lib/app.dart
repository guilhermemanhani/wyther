import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:Wyther/home.dart';
import 'package:Wyther/login.dart';
import 'package:Wyther/login/email.dart';
import 'package:Wyther/scope-models/main.dart';

class WytherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: MainModel(),
        child: MaterialApp(
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
        ));
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
