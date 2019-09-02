import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
// import 'package:scoped_model/scoped_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:Wyther/model/user.dart';
import 'package:Wyther/model/incidente.dart';

// class ConnectedModel with ChangeNotifier {
//   List<Incidente> _incidentes;
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

class Incidentes extends ChangeNotifier {
  List<Incidente> _incidentes = [];
  final String token;
  final String userId;
  User _authUser;

  Incidentes(this.token, this.userId, this._incidentes);

  List<Incidente> get incidentes {
    return [..._incidentes];
  }

  Future<void> fetch(String _token) async {
    print('begin - IncidentesModel@fetch');
    // _isLoading = true;
    // notifyListeners();

    //final List<Incidente> fetchedIncidentList = [];

    try {

      http.Response response;
      response = await http.get(
        'https://wyther-app.firebaseio.com/incidentes.json?auth=${_token}',        
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // _isLoading = false;
        notifyListeners();
        print('#error: IncidentesModel@fetch - status code');
        print('#error: {error}');
        return;
      }

      // print(response.body);

      final Map<String, dynamic> incidenteListData = json.decode(response.body);
      if (incidenteListData == null) {
        // _isLoading = false;
        notifyListeners();
        return;
      }

      // print(incidenteListData);
      final List<Incidente> loadedIncidentes = [];
      incidenteListData.forEach((prodId, productData){
        loadedIncidentes.add(Incidente(
            descricao: productData['descricao'],
            latitude: productData['latitude'],
            longitude: productData['longitude'],
            userId: productData['userId'],
            token: productData['token']
        ));
      });
      // incidenteListData.forEach((String productId, dynamic productData) {
      //   final Incidente incidente = IncidentesItem(
      //       descricao: productData['descricao'],
      //       latitude: productData['latitude'],
      //       longitude: productData['longitude'],
      //       userId: productData['userId']);
      //   fetchedIncidentList.add(incidente);
      // });

      _incidentes = loadedIncidentes;
      // _isLoading = false;
      notifyListeners();
      return;

    } catch (error) {
      print('#error: IncidentesModel@fetch - catch');
      print(error);
      // _isLoading = false;
      notifyListeners();
      return;
    }
  }
  List<User> _user = [];
  
  List<User> get user{
    return [..._user];
  }

  Future<bool> store(Incidente incidente) async {
    // _isLoading = true;
    notifyListeners();
    // print(_user);
    // print(incidente.userId);
    // print(incidente.longitude);
    // print(incidente.latitude);
    // print(incidente.descricao);
    // print(incidente.token);
    final Map<String, dynamic> data = {
      'descricao': incidente.descricao,
      'latitude': incidente.latitude,
      'longitude': incidente.longitude,
      'userId': incidente.userId,
      'returnSecureToken': true
    };
print(data);
    try {
print("store");
      http.Response response;
      response = await http.post(
        'https://wyther-app.firebaseio.com/incidentes.json?auth=${incidente.token}',
        body: json.encode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // _isLoading = false;
        notifyListeners();
        // print('#error: IncidentesModel@store - status code');
        print(response.body);
        // print('era pra dar certo');
        return false;
      }

      final Map<String, dynamic> responseData = json.decode(response.body);

      print(response.body);
      Incidente aux = incidente;
      _incidentes.add(aux);

      // _isLoading = false;
      notifyListeners();
      print(responseData);
      print('antes do true');
      return true;

    } catch (error) {
      print('#error: IncidentesModel@store - catch');
      print(error);
      // _isLoading = false;
      notifyListeners();
      return false;
    }
  }

}

// class UtilitiesModel extends ConnectedModel {

//   bool get isLoading {
//     return _isLoading;
//   }

// }
