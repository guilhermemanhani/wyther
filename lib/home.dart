import 'package:flutter/material.dart';
import 'package:Wyther/login.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class HomePage extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            semanticLabel: 'menu',
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
            print('Menu button');
          },
        ),
        title: Text('Wyther'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              print('search button');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.tune,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              print('filter button');
            },
          )
        ],
      ),
      body: new FlutterMap(
        options: MapOptions(
          center: new LatLng(-23.31656,-51.17082), 
          minZoom: 5.0,
        ),
        layers: [
          new TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],

            
          ),
          new MarkerLayerOptions(markers: [
            new Marker(
              width: 45.0,
              height: 45.0,
              point: LatLng(-23.31656,-51.17082),
              builder: (context) => new Container(
                child: new IconButton(
                  icon: Icon(Icons.local_library),
                  color: Colors.red,
                  iconSize: 45.0,
                  onPressed: (){

                  },
                ),
              )
            )]
          )     
        ],
      ),
      
      // GridView.count(
      //   crossAxisCount: 2,
      //   padding: EdgeInsets.all(16.0),
      //   childAspectRatio: 8.0 / 9.0,
      //   children: _buildGridCards(10),
      // ),
    );
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
