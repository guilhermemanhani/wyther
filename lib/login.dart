// import 'package:flutter/material.dart';
// import 'package:Wyther/register.dart';

// import 'package:Wyther/scope-models/validate.dart';

// import 'package:provider/provider.dart';
// import 'package:scoped_model/scoped_model.dart';
// import 'package:Wyther/scope-models/main.dart';
// import '../model/http_exception.dart';

// enum AuthMode { Signup, Login }

// class LoginPage extends StatefulWidget {
//   @override
//   static const routeName = '/';

//   Widget build(BuildContext context){
//     final deviceSize = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 //stops: <double>[0.5, 0.8],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [Colors.grey[300], Colors.grey[900]],
//               ),
//             ),
//           ),
//           //SingleChildScrollView(
//             Flexible(
//                     child: LoginPageState(),
//                   ),
//           //)
//         ],
//       ),
//     );
//   }
// }

// class LoginPageState extends StatefulWidget{
//   const LoginPageState({
//     Key key,
//   }): super(key: key);
  
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPageState> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: ListView(
//           padding: EdgeInsets.symmetric(horizontal: 24.0),
//           children: <Widget>[
//             SizedBox(height: 20.0),
//             Column(
//               children: <Widget>[
//                 Image.asset('assets/images/wyther.png',
//                     width: 140.0, height: 140.0),
//                 SizedBox(height: 16.0),
//                 Text(
//                   'Wyther',
//                   style: TextStyle(fontSize: 36.0, fontFamily: 'Pacifico'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20.0),
//             // RaisedButton(
//             //   child: Text(
//             //     'Acessar com Facebook',
//             //     style: TextStyle(color: Colors.white),
//             //   ),
//             //   color: Colors.blueGrey,
//             //   onPressed: () {

//             //   }
//             // ),
//             RaisedButton(
//               child: Text(
//                 'Acessar com e-mail',
//                 style: TextStyle(color: Colors.white),
//               ),
//               color: Colors.blue,
//               onPressed: () {
//                 Navigator.pushNamed(context, '/email');
//               },
//             ),
//             FlatButton(
//               child: Text('Cadastrar-se.'),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => RegisterPage()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
