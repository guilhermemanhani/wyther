import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../model/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Wyther/model/user.dart';
import 'package:Wyther/model/incidente.dart';
import 'package:flutter/foundation.dart';

// class ConnectedModel with ChangeNotifier {
//   List<IncidentesItem> _incidentes;
//   bool _isLoading = false;
//   User _authUser;

// }

// class IncidentesItem {
//   final String descricao;
//   final double latitude;
//   final double longitude;
//   final String userId;

//   IncidentesItem({
//     @required this.descricao,
//     @required this.latitude,
//     @required this.longitude,
//     @required this.userId
//   });
  
// }

class Validate extends ChangeNotifier{
  
  List<User> _user = [];

  List<User> get user{
    return [..._user];
  }

  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authTimer;

  bool get isValidate{
    return token != null;
  }

  // String get userId {
  //   return _userId;
  // }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
        
    final url =
    'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyCRoUw6Ya8D-JJJCx3IVuShFJD9ozU9Ad8';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      
      // print(responseData);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      // print(responseData);
      print(_token);
      print("login");
      print(_userId);
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      //print(error);
      throw error;
      
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, 'signupNewUser');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'verifyPassword');
  }
  

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
     final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
     _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
    //_authTimer = Timer(Duration(seconds: 10), logout);
  }
}

bool emailValid(myControllerEmail) {
  //_username = myControllerEmail.text;
  if (RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+[.a-zA-Z]")
      .hasMatch(myControllerEmail.text)) {
    return true;
  } else {
    return false;
  }
}

bool passwordValid(myControllerSenha) {
  //_password = myControllerSenha.text;
  if (myControllerSenha.text.length >= 6) {
    //RegExp(r"[a-zA-Z0-9]+^[a-z]+^[A-Z]+[a-zA-Z0-9]").hasMatch(myControllerSenha.text))
    return true;
  } else {
    return false;
  }
}

// String _email;

// emailReturn() {
//   return _email;
// }

// void changeEmail(String email) {
//   _email = email;
// }

// makePost(email, password) async {
//   changeEmail(email);
//   var url =
//       'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyCulBrEIsQvPP6GJXtuxU5ein-s8zeECMI';

//   var response = await http.post(url, body: {
//     "email": email,
//     "password": password,
//     //"email": 'test@test.co',
//     //"password": '123456',
//     "returnSecureToken": "true",
//   });

//   //final responseJson = json.decode(response.body);

//   // Post.fromJson(responseJson);

//    //print(responseJson);
//     // Map<String, dynamic> data = jsonDecode(response.body);
//     // var user = Post.fromJson(data['error']);
//     // print(response.body);
//     // print(user.code);
//     // print(user.code);
//     // print(user.message);
//     // print('${data['error']}');
//     // print(data['error']);

//   if(response.statusCode == 200){
//     return response.statusCode;
//   }else{
//     Map<String, dynamic> data = jsonDecode(response.body);
//     return Post.fromJson(data['error']);
//   }
// }



// class Post {
//   final int code;
//   final String message;
//   // final String title;
//   // final String body;

//   Post({this.code, this.message,});

//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       code: json['code'] as int,
//       message: json['message'] as String,
//     );
//   }
// }


