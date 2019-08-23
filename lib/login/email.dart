import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';

import 'package:Wyther/scope-models/validate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/http_exception.dart';

enum AuthMode { Signup, Login }

class EmailLoginPage extends StatelessWidget {
  @override
  static const routeName = '/email';

  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //SizedBox(height: 20.0),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                //stops: <double>[0.5, 0.8],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[900], Colors.white],
              ),
            ),
          ),
          Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            child: Center(
              child: Column(
                children: <Widget>[
                  Image.asset('assets/images/wyther.png',
                      width: 140.0, height: 140.0),
                  //SizedBox(height: 16.0),
                  Text(
                    'Wyther',
                    style: TextStyle(fontSize: 36.0, fontFamily: 'Pacifico'),
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.06),
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: LoginPageEmail(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LoginPageEmail extends StatefulWidget {
  const LoginPageEmail({
    Key key,
  }) : super(key: key);

  @override
  _EmailLoginPageState createState() => _EmailLoginPageState();
}

class _EmailLoginPageState extends State<LoginPageEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // String _email;
  // String _password;
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  final myControllerEmail = TextEditingController();
  final myControllerSenha = TextEditingController();
  bool _showPassword = false;
  bool valEmail = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myControllerEmail.dispose();
    myControllerSenha.dispose();
    super.dispose();
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
        child: new Form(
          key: _formKey,
          child: Column(children: <Widget>[
            email(),
            password(),
            // if (_authMode == AuthMode.Signup)
            // confPassword(),
            //if (_authMode != AuthMode.Signup)
            login(),
            register(),
          ]),
        ),
      );
    } else {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.4,
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
        child: Column(
          children: <Widget>[
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black,
              ),
            ),
            Text(
              'Aguarde...',
              style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Pacifico'),
            ),
          ],
        ),
      );
    }
  }

  email() {
    return TextFormField(
      validator: (val) {
        if (emailValid(myControllerEmail) == false) {
          return 'Email invalido';
        } else {
          return null;
        }
      },
      cursorColor: Colors.black,
      // style: TextStyle(
      //   color: Colors.white,
      // ),
      controller: myControllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        filled: true,
        labelText: 'E-mail',
        labelStyle: TextStyle(color: Colors.black),
      ),
      onSaved: (value) {
        _authData['email'] = value;
      },
    );
  }

  password() {
    return TextFormField(
      validator: (val) {
        if (val == '') {
          return 'Campo vazio';
        } else if (val.length < 6) {
          return 'Senha incorreta';
        } else {
          return null;
        }
      },
      cursorColor: Colors.black,
      controller: _passwordController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          filled: true,
          labelText: 'Senha',
          labelStyle: TextStyle(color: Colors.black),
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _showPassword = !_showPassword;
              });
            },
            child: Icon(
              _showPassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.black,
            ),
          )),
      onSaved: (value) {
        _authData['password'] = value;
      },
      obscureText: !_showPassword,
    );
  }

  confPassword() {
    return TextFormField(
      enabled: _authMode == AuthMode.Signup,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        filled: true,
        labelText: 'Senha',
      ),
      validator: (value) {
        if (_passwordController.text != value) {
          return 'senhas diferentes';
        } else {
          return null;
        }
      },
      obscureText: true,
    );
  }

  login() {
    return RaisedButton(
        // child: _showPassword
        //     ? Center(
        //         child: CircularProgressIndicator(
        //             strokeWidth: 3.0,
        //             valueColor:
        //                 new AlwaysStoppedAnimation<Color>(Colors.white)))
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(50.0)),
        child: Text(
          _authMode == AuthMode.Login ? 'Entrar' : 'Registrar',
          style: TextStyle(color: Colors.white),
        ),
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: _submit);
  }

  register() {
    return RaisedButton(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
      child: Text(
        '${_authMode == AuthMode.Login ? 'Registar' : 'Entrar'}',
        style: TextStyle(color: Colors.white),
      ),
      // onPressed: () {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => Register()),
      //   );
      // },
      onPressed: _switchAuthMode,
      color: Colors.grey,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }

    try {setState(() {
      _isLoading = true;
    });
    
    _formKey.currentState.save();

    
      //  if(_authData['email'] == "" || _authData['password'] == ""){
      //   const errorMessage =
      //     'INVALID EMAIL OR INVALID EMAIL';
      //     _showErrorDialog(errorMessage);
      // }else
      print(_authData['email']);
      print(_authData['password']);

      //add execao aqui
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Validate>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Validate>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }
}
// return Scaffold(
//         appBar: AppBar(
//           title: Text('Acessar com e-mail'),
//         ),
//         body: SafeArea(
//             minimum: EdgeInsets.all(15.0),
//             child: Column(
//               children: <Widget>[
//                 Form(
//                   key: _formKey,
//                   child: Column(
//                     children: <Widget>[
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           labelText: 'E-mail',
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'Preencha o e-mail';
//                           }
//                         },
//                         onSaved: (value) => _email = value,
//                       ),
//                       // spacer
//                       SizedBox(height: 12.0),
//                       // [Password]
//                       TextFormField(
//                         controller: _passwordController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           labelText: 'Senha',
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return 'Preencha o senha';
//                           }
//                         },
//                         onSaved: (value) => _password = value,
//                         obscureText: true,
//                       ),
//                       ButtonBar(
//                         alignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           RaisedButton(
//                               child: _showPassword
//                                   ? Center(
//                                       child: CircularProgressIndicator(
//                                           strokeWidth: 3.0,
//                                           valueColor:
//                                               new AlwaysStoppedAnimation<Color>(
//                                                   Colors.white)))
//                                   : Text('ACESSAR'),
//                               color: Colors.blue,
//                               textColor: Colors.white,
//                               onPressed: _submit
//                               // () async {
//                               //   if (_formKey.currentState.validate()) {
//                               //     _formKey.currentState.save();

//                               //     try {
//                               //       final Map<String, dynamic> response =
//                               //           await model.login(
//                               //               _email, _password);
//                               //       //  _logIn(_email, _password);

//                               //       if (response['success']) {
//                               //         Navigator.pushNamed(context, '/home');
//                               //       } else {
//                               //         showDialog(
//                               //             context: context,
//                               //             builder: (BuildContext context) {
//                               //               return AlertDialog(
//                               //                 title: Text('Acesso'),
//                               //                 content:
//                               //                     new SingleChildScrollView(
//                               //                   child: new ListBody(
//                               //                     children: <Widget>[
//                               //                       new Icon(
//                               //                         Icons.error,
//                               //                         semanticLabel:
//                               //                             'error',
//                               //                         color: Colors.red,
//                               //                         size: 52.0,
//                               //                       ),
//                               //                       new Text(
//                               //                         response['message'],
//                               //                         style: TextStyle(
//                               //                           fontSize: 14.0,
//                               //                         ),
//                               //                       ),
//                               //                     ],
//                               //                   ),
//                               //                 ),
//                               //                 actions: <Widget>[
//                               //                   new FlatButton(
//                               //                     child: new Text(
//                               //                       'Ok',
//                               //                       style: TextStyle(
//                               //                         fontSize: 20.0,
//                               //                       ),
//                               //                     ),
//                               //                     onPressed: () {
//                               //                       Navigator.of(context)
//                               //                           .pop();
//                               //                     },
//                               //                   ),
//                               //                 ],
//                               //               );
//                               //             });
//                               //       }
//                               //     } catch (e) {
//                               //       print(e);
//                               //     }
//                               //   }
//                               // },
//                               ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             )),
//       );
//     });
