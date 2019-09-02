import 'package:Wyther/scope-models/connected_models.dart';
import 'package:Wyther/scope-models/validate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart' as geoloc;
import 'package:provider/provider.dart';
//import 'package:scoped_model/scoped_model.dart';
//import 'package:Wyther/scope-models/main.dart';
import 'package:Wyther/model/incidente.dart';

class HomePage extends StatefulWidget {
  //final Validate _model;
  static const routeName = '/home';
  //HomePage(this._model);
  final List<Incidente> loadedIncidente = [];

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, double> _currentLocation;
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();
  Incidentes dataIncidentes;

  final Map<String, dynamic> _formData = {'descricao': null};

  void _submitForm(Incidentes model) async {
    _getCurrentLocation();

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      print(_currentLocation);
      if (await model.store(new Incidente(
          descricao: _formData['descricao'],
          latitude: _currentLocation['latitude'],
          longitude: _currentLocation['longitude'],
          userId: model.userId,
          
          token: model.token))) {
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
                        'Ponto de enchente cadastrado com sucesso!',
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
                      Navigator.pop(context);
                      Navigator.pop(context);
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
                        'Erro',
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
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      }
    }
  }

  void _getCurrentLocation() async {
    final location = new geoloc.Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final currentLocation = await location.getLocation();
      _currentLocation = currentLocation;
      // print(_currentLocation);
    } on Exception catch (e) {
      print('Could not describe object: $e');
    }
  }

// void _loadData() async {

//   final _incidentes = Provider.of<Incidentes>(
//     context,
//     listen: false,
//   );

//     await _incidentes.fetch(_incidentes.token);

//     this.dataIncidentes = _incidentes;

//     print('#tamanho:' + _incidentes.incidentes.toString());
//   }

  Future<List<Incidente>> _loadIncidentes() async {

  final _incidentes = Provider.of<Incidentes>(
    context,
    listen: false,
  );

    await _incidentes.fetch(_incidentes.token);

    return _incidentes.incidentes;
  }
  // void _loadData() async {
  //   await widget._incidentes.fetch();

  //   print('#tamanho:' + widget._incidentes.incidentes.toString());
  // }

  @override
  void initState() {
    _getCurrentLocation();

   // _loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //print(Validade._userId);
    // final productId = ModalRoute.of(context).settings.arguments as String;
    final incidente = Provider.of<Incidentes>(
      context,
      listen: false,
    );
    //return ScopedModelDescendant(
    //builder: (BuildContext context, Widget child, Validate model) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Opções'),
            ),
            ListTile(
              leading: Icon(IconData(0xe802, fontFamily: 'MyFlutterApp')),
              title: Text('Pontos de alagamento'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('Sobre'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/info');
              },
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Sair'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Validate>(context, listen: false).logout();
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Wyther'),
        actions: <Widget>[],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add_location,
          semanticLabel: 'menu',
          color: Colors.white,
          size: 36.0,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return new Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SizedBox(height: 16.0),
                        Center(
                          child: Text('Reportar alagamento',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0)),
                        ),
                        new Padding(
                          padding: new EdgeInsets.all(10.0),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: _descricaoController,
                            decoration: InputDecoration(labelText: 'Descrição'),
                            maxLines: 4,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Escreva alguma descrição';
                              }
                            },
                            onSaved: (String value) {
                              _formData['descricao'] = value;
                            },
                          ),
                        ),
                        new RaisedButton(
                          child: Text('Reportar'),
                          onPressed: () {
                            _submitForm(incidente);
                            // print('Incidente reportado!');
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      body: _buildMapBody(),

      // GridView.count(
      //   crossAxisCount: 2,
      //   padding: EdgeInsets.all(16.0),
      //   childAspectRatio: 8.0 / 9.0,
      //   children: _buildGridCards(10),
      // ),
    );
    //},
    //);
  }

  Widget _buildMapBody() {
    return new FlutterMap(
      options: MapOptions(
        center: _currentLocation != null
            ? new LatLng(
                _currentLocation['latitude'], _currentLocation['longitude'])
            : LatLng(-23.31656, -51.17082),
        zoom: 13.0,
      ),
      layers: [
        new TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(markers: _buildMarkersList())
      ],
    );
  }

  List<Marker> _buildMarkersList(){
    
    var incidentes = _loadIncidentes();

    List<Marker> markers = [];

    incidentes.then((lista) { 
      // print(value); 
      lista.forEach((incidente) {
        markers.add(new Marker(
          width: 42.0,
          height: 42.0,
          point: LatLng(incidente.latitude, incidente.longitude),
          builder: (context) => new Container(
                child: new IconButton(
                  icon: Icon(IconData(0xe802, fontFamily: 'MyFlutterApp')),
                  // icon: new Image.asset("assets/images/flood32x32.png"),
                  color: Colors.blue,
                  iconSize: 45.0,
                  onPressed: () {
                    print('click no ponto!');
                  },
                ),
              )));    
      });
      print('@after lista.forEach ' + markers.length.toString());      
    },
      onError: (e) { print('error'); 
    });  
    
    print('@markers ' + markers.length.toString());
    
    return markers;
  }
}
