import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmailLoginPage extends StatefulWidget {
  @override
  _EmailLoginPageState createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<EmailLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acessar com e-mail'),
      ),
      body: SafeArea(
          minimum: EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'E-mail',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Preencha o e-mail';
                        }
                      },
                      onSaved: (value) => _email = value,
                    ),
                    // spacer
                    SizedBox(height: 12.0),
                    // [Password]
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        filled: true,
                        labelText: 'Senha',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Preencha o senha';
                        }
                      },
                      onSaved: (value) => _password = value,
                      obscureText: true,
                    ),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          child: Text('ACESSAR'),
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              try {
                                FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                        email: _email.trim(), password: _password);

                                if (user != null) {
                                  Navigator.of(context).pop();
                                }
                              } catch (e) {
                                print(e);
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
