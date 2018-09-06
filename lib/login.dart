import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:Wyther/register.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // TODO: Add text editing controllers (101)
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            Column(
              children: <Widget>[
                Image.asset('assets/images/wyther.png',
                    width: 140.0, height: 140.0),
                SizedBox(height: 16.0),
                Text(
                  'Wyther',
                  style: TextStyle(fontSize: 36.0, fontFamily: 'Pacifico'),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            RaisedButton(
              child: Text(
                'Acessar com Facebook',
                style: TextStyle(),
              ),
              color: Colors.blue,              
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            // [Name]
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'E-mail',
              ),
            ),
            // spacer
            SizedBox(height: 12.0),
            // [Password]
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                filled: true,
                labelText: 'Senha',
              ),
              obscureText: true,
            ),
            // TODO: Add buttons (101)
            ButtonBar(
              // TODO: Add a beveled rectangular border to CANCEL (103)
              children: <Widget>[
                // TODO: Add buttons (101)
                FlatButton(
                  child: Text('CANCELAR'),
                  onPressed: () {
                    _usernameController.clear();
                    _passwordController.clear();
                  },
                ),
                RaisedButton(
                  child: Text('ACESSAR'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            FlatButton(
                  child: Text('Cadastrar-se.'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                  },
                ),
          ],
        ),
      ),
    );
  }
}

