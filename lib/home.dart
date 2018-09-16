import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
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
        actions: <Widget>[
          
        ],
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
             return new Column(
              children: <Widget>[
                Text('Reportar alagamento',
                style: TextStyle(
                  fontWeight: FontWeight.bold
                ),)
              ],
            );
          }  
        ); 
      },
      ),
      body: new FlutterMap(
        options: MapOptions(
          center: new LatLng(-23.31656, -51.17082),
          zoom: 13.0,
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
                point: LatLng(-23.31656, -51.17082),
                builder: (context) => new Container(
                      child: new IconButton(
                        icon: Icon(Icons.near_me),
                        color: Colors.red,
                        iconSize: 45.0,
                        onPressed: () {},
                      ),
                    ))
          ])
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
