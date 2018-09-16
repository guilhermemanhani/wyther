import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:Wyther/model/user.dart';

class ConnectedModel extends Model {
  bool _isLoading = false;
  User _authUser;

}

class UserModel extends ConnectedModel {

  Future<Map<String, dynamic>> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    response = await http.post(
      'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyCRoUw6Ya8D-JJJCx3IVuShFJD9ozU9Ad8',
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
      _authUser = User(email: email, password: password, id: responseData['localId'], token: responseData['idToken']);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Este e-mail não possui cadastro.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Senha incorreta.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

}

class UtilitiesModel extends ConnectedModel {

  bool get isLoading {
    return _isLoading;
  }

}
