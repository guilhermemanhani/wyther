import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _email;
  String _password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrar'),
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
                          child: Text('CADASTRAR'),
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              _formKey.currentState.save();

                              try {
                                FirebaseUser user = await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _email, password: _password);
                                        
                                AlertDialog dialog = new AlertDialog(
                                  title: new Text('Rewind and remember'),
                                  content: new SingleChildScrollView(
                                    child: new ListBody(
                                      children: <Widget>[
                                        new Text(
                                            'You will never be satisfied.'),
                                        new Text(
                                            'You\’re like me. I’m never satisfied.'),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    new FlatButton(
                                      child: new Text('Regret'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );

                                showDialog(context: context, child: dialog);
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
