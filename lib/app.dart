// import 'package:Wyther/scope-models/connected_models.dart';
import 'package:Wyther/scope-models/connected_models.dart';
import 'package:Wyther/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:Wyther/about.dart';
import 'package:Wyther/home.dart';
import 'package:Wyther/login/email.dart';
import 'package:provider/provider.dart';
import 'package:Wyther/scope-models/validate.dart';

import 'model/incidente.dart';
//import 'package:scoped_model/scoped_model.dart';

class WytherApp extends StatelessWidget {
   //Validate _model = Validate();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Validate(),
          ),
        ChangeNotifierProxyProvider<Validate, Incidentes>(
          builder: (context, auth, previusOrders) => Incidentes(
            auth.token,
            auth.userId,
            
            previusOrders == null ? [] : previusOrders.incidentes,
          ),
          ), 
      ],
      child: Consumer<Validate>(
        builder: (context, auth, _)=> MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Wyther',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: auth.isValidate
          //HomePage(_model)
          ? HomePage()
          : FutureBuilder(
            future: auth.tryAutoLogin(),
            builder: (context, authResultSnapshot) =>
                authResultSnapshot.connectionState == 
                ConnectionState.waiting
                ? SplashScreen()
                : EmailLoginPage(),
                ),
          routes: {
            //LoginPage.routeName: (ctx) => LoginPage(),
            HomePage.routeName: (ctx) => HomePage(),
            EmailLoginPage.routeName: (ctx) => EmailLoginPage(),
            AboutPage.routeName: (ctx) => AboutPage(),
            // '/': (BuildContext context) => LoginPage(),
            // '/home': (BuildContext context) => HomePage(_model),
            // '/email': (BuildContext context) => EmailLoginPage(),
            // '/info': (BuildContext context) => AboutPage(),
          },
          //initialRoute: '/login',
          //onGenerateRoute: _getRoute,
        ),
      )
    );
    
    // ScopedModel<MainModel>(
    //     model: _model,
    //     child: MaterialApp(
    //       title: 'Wyther',
    //       theme: ThemeData(
    //         primarySwatch: Colors.blue,
    //       ),
    //       // home: HomePage(),
    //       routes: {
    //         '/': (BuildContext context) => LoginPage(),
    //         '/home': (BuildContext context) => HomePage(_model),
    //         '/email': (BuildContext context) => EmailLoginPage(),
    //         '/info': (BuildContext context) => AboutPage(),
    //       },
    //       initialRoute: '/login',
    //       onGenerateRoute: _getRoute,
    //     ));
  }

  // Route<dynamic> _getRoute(RouteSettings settings) {
  //   if (settings.name != '/login') {
  //     return null;
  //   }

  //   return MaterialPageRoute<void>(
  //     settings: settings,
  //     builder: (BuildContext context) => LoginPage(),
  //     fullscreenDialog: true,
  //   );
  // }
}
