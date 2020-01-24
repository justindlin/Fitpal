import 'package:flutter/material.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'pages/cardio.dart';
// import 'location.dart';

class Map extends StatelessWidget {
  final centre = LatLng(43.9457842,-78.895896);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options:MapOptions(
          center: centre,
          minZoom: 16.0,
          maxZoom: 50.0, 
        ),
        layers: [
          TileLayerOptions(
          urlTemplate: "https://api.tiles.mapbox.com/v4/"
              "{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}",
          additionalOptions: {
            'accessToken': 'pk.eyJ1Ijoic2NoZXJlIiwiYSI6ImNrM2Z5Y2tmdzAwNDgzbmxvNHNibjR5YmoifQ.wzTwzLrrp19Yuqh96yo6gw',
            'id': 'mapbox.streets',
          },
        ),
         MarkerLayerOptions(
           markers:[
             Marker(
               width: 45.0,
               height: 45.0,
               point: centre,
               builder: (context) => Container(
                 child: IconButton(
                   icon: Icon(Icons.location_on),
                   color: Colors.grey,
                   iconSize: 45.0, 
                   onPressed: () {},
                 ),
               )
             )
           ]) 
        ]
      )
      );
  }

}