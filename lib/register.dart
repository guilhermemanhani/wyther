import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<Map<String, dynamic>> _register(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyCRoUw6Ya8D-JJJCx3IVuShFJD9ozU9Ad8',
      body: json.encode(authData),
      headers: {'Content-Type': 'application/json'},
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Ops, alguma coisa deu errado!';
    print(responseData);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Cadastro realizado com sucesso!';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Este e-mail já esta cadastrado em nossa base de dados.';
    } else if (responseData['error']['message'] ==
        'TOO_MANY_ATTEMPTS_TRY_LATER') {
      message =
          'Desculpe, devido ao excesso de tentativas você foi bloquado. Tente mais tarde.';
    }
    return {'success': !hasError, 'message': message};
  }

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
                                final Map<String, dynamic> response =
                                    await _register(_email, _password);

                                if (response['success']) {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Cadastro'),
                                          content: new SingleChildScrollView(
                                            child: new ListBody(
                                              children: <Widget>[
                                                new Icon(
                                                  Icons.check,
                                                  semanticLabel: 'menu',
                                                  color: Colors.green,
                                                  size: 52.0,
                                                ),
                                                new Text(
                                                  response['message'],
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            new FlatButton(
                                              child: new Text(
                                                'Ok',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.pushNamed(
                                                    context, '/home');
                                              },
                                            ),
                                          ],
                                        );
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Cadastro'),
                                          content: new SingleChildScrollView(
                                            child: new ListBody(
                                              children: <Widget>[
                                                new Icon(
                                                  Icons.error,
                                                  semanticLabel: 'error',
                                                  color: Colors.red,
                                                  size: 52.0,
                                                ),
                                                new Text(
                                                  response['message'],
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            new FlatButton(
                                              child: new Text(
                                                'Ok',
                                                style: TextStyle(
                                                  fontSize: 20.0,
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      });
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
