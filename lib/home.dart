import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart' as geoloc;
import 'package:scoped_model/scoped_model.dart';
import 'package:Wyther/scope-models/main.dart';
import 'package:Wyther/model/incidente.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, double> _currentLocation;
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();

  final Map<String, dynamic> _formData = {'descricao': null};

  void _submitForm(MainModel model) async {
    _getCurrentLocation();
    _formKey.currentState.save();

    if (await model.store(new Incidente(
        descricao: _formData['descricao'],
        latitute: _currentLocation['latitude'],
        longitude: _currentLocation['longitude'],
        userId: model.userId))) {
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
                      'ok!',
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
                  },
                ),
              ],
            );
          });
    }
  }

  void _getCurrentLocation() async {
    final location = new geoloc.Location();

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final currentLocation = await location.getLocation();
      _currentLocation = currentLocation;
      print(_currentLocation);
    } on Exception catch (e) {
      print('Could not describe object: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    _getCurrentLocation();
    
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Scaffold(
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Text('Opções'),
                ),
                ListTile(
                  title: Text('Pontos de alagamento'),
                  onTap: () {},
                ),
                ListTile(
                  title: Text('Sobre'),
                  onTap: () {},
                ),
                ListTile(
                  title: Text('Sair'),
                  onTap: () {
                    Navigator.pop(context);
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
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            Center(
                              child: Text('Reportar alagamento',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            new Padding(
                              padding: new EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: _descricaoController,
                                decoration:
                                    InputDecoration(labelText: 'Descrição'),
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
                                _submitForm(model);
                                // print('Incidente reportado!');
                              },
                            ),
                          ],
                        ));
                  });
            },
          ),
          body: _buildMapBody(model),

          // GridView.count(
          //   crossAxisCount: 2,
          //   padding: EdgeInsets.all(16.0),
          //   childAspectRatio: 8.0 / 9.0,
          //   children: _buildGridCards(10),
          // ),
        );
      },
    );
  }

  Widget _buildMapBody(MainModel model) {
    model.fetch();

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
        new MarkerLayerOptions(markers: _buildMarkersList(model))
      ],
    );
  }

  List<Marker> _buildMarkersList(MainModel model){
    final incidentes = model.incidentes;

    List<Marker> markers = [];

    print('before');
    incidentes.forEach((Incidente incidente) {
      print(incidente.descricao);
      markers.add(new Marker(
              width: 42.0,
              height: 42.0,
              point: LatLng(incidente.latitute, incidente.longitude),
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
                  )
                )
              );
    });
    print('after');
    return markers;
    return [new Marker(
              width: 42.0,
              height: 42.0,
              point: LatLng(-23.31656, -51.17082),
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
                  )
                )];
  }

  List<Card> _buildGridCards(int count) {
    List<Card> cards = List.generate(
      count,
      (int index) => Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                AspectRatio(
                  aspectRatio: 18.0 / 11.0,
                  child: Image.asset('images/assets/wyther.png'),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Title'),
                      SizedBox(height: 8.0),
                      Text('Secondary Text'),
                    ],
                  ),
                ),
              ],
            ),
          ),
    );

    return cards;
  }
}
