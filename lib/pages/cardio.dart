import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'dart:async';
import 'dart:math' as math;


class Cardio extends StatefulWidget {

  Cardio({Key key}) : super(key: key);

  @override 
  _CardioState createState() => _CardioState();
}

class _CardioState extends State<Cardio> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  var _locationInput;
  Position _currentPosition;
  LatLng _currentLatLong = LatLng(43.9457842,-78.895896);
  List<LatLng> latlongList = [];
  bool startWorkout = false;
  bool isDemo = false;
  double demoMoveX = 0.0;
  double demoMoveY = 0.0;
  int snackbarTime=25;
  MapController mapController;

  final centre = LatLng(43.9457842,-78.895896);

  //initializing map controller and getting initial location
  @override
  initState(){
    super.initState();
    mapController = MapController();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
        body: Stack(
          children: <Widget> [
            // Display the map 
            FlutterMap(
              options:MapOptions(
                center: _currentLatLong,
                minZoom: 16.0,
                maxZoom: 50.0, 
              ),
              mapController: mapController,
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
                    ),
                  ]
                ),
                PolylineLayerOptions(
                  polylines: [
                    Polyline(
                      points: latlongList,
                      strokeWidth: 2.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
            Column(
              children: <Widget>[
                RaisedButton (
                  onPressed: () {
                    //starting a 30 second workout. updates location every 5 seconds. 
                    //only issue is that user will actually need to run around to see results.
                    _repeat(30);
                    
                    snackbarTime = 31;
                    
                    new Timer.periodic(
                      Duration(seconds:2), 
                      (Timer timer) => setState(
                        () {
                          if(snackbarTime < 2){
                            timer.cancel();
                            final snackBar = SnackBar (
                              content: Text('Wow you jogged ' + _sumDistance(latlongList)+'kms!'),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          }else{
                            _getCurrentLocation();
                            snackbarTime = snackbarTime - 2;
                          }
                        }
                      )
                    ); 

                  },
                  child: Text('Begin 30 second jog!')
                ),
                RaisedButton(
                  onPressed: (){
                    isDemo = true;
                    latlongList = [];
                    _repeat(20);
                    snackbarTime = 21;
                    
                    new Timer.periodic(
                      Duration(seconds:2), 
                      (Timer timer) => setState(
                        () {
                          if(snackbarTime < 2){
                            timer.cancel();
                            final snackBar = SnackBar (
                              content: Text('Wow you jogged ' + _sumDistance(latlongList)+'kms!'),
                            );
                            Scaffold.of(context).showSnackBar(snackBar);
                          }else{
                            _getCurrentLocation();
                            snackbarTime = snackbarTime - 2;
                          }
                        }
                      )
                    ); 
                  },
                  child: Text('tester demo'),
                ),
              ],
            ),
          ]
        ),     
    );
  }

  //function to repeat acquiring and updating the walking path of user
  _repeat(int workoutTime){
    if(!startWorkout){
      startWorkout = true;
      new Timer.periodic(
        Duration(seconds:3), 
        (Timer t) => setState(
          () {
            if(workoutTime < 1){
              t.cancel();
              startWorkout = false;
              demoMoveX = 0.0;
              demoMoveY = 0.0;
              isDemo = false;
              
            }else{
              workoutTime = workoutTime - 3;
              _getCurrentLocation();
            }
          }
        )
      ); 
    }
  }

  //gets current location. adding the lat and long to a list 
  _getCurrentLocation(){
    math.Random _random = new math.Random();
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        if(isDemo){
          int nextX(int min, int max) => min + _random.nextInt(max - min);
          demoMoveX = demoMoveX + (nextX(0,30)/100000.0);
          demoMoveY = demoMoveY + (nextX(0,30)/100000.0);
        }
        _currentLatLong = LatLng(_currentPosition.latitude+demoMoveX,_currentPosition.longitude+demoMoveY);
        mapController.move(_currentLatLong,5.0);
        latlongList.add(_currentLatLong);
      });
    }).catchError((e) {
      print(e);
    });
  }

  //calculating the distance between two coordinates
  double _getDistance(double lat1, double long1, double lat2, double long2){
    int r = 6371;
    double radLat1 = lat1 * (math.pi/180);
    double radLat2 = lat2 * (math.pi/180);
    double deltaLat = (lat2 - lat1) * (math.pi/180);
    double deltaLong = (long2 - long1) * (math.pi/180);

    double haversine = math.sin(deltaLat/2) * math.sin(deltaLat/2) + 
                       math.cos(radLat1) * math.cos(radLat2) *
                       math.sin(deltaLong/2) * math.sin(deltaLong/2);
    
    double c = 2 * math.atan(math.sqrt(haversine)/math.sqrt(1-haversine));
    return (r * c);
  }

  //getting the sum of distances of a list of coordinates
  String _sumDistance(List<LatLng> coorList){
    double totDistance = 0;

    for(int i = 0; i<coorList.length-1; i++){
      totDistance = totDistance + _getDistance(
        coorList[i].latitude,
        coorList[i].longitude,
        coorList[i+1].latitude,
        coorList[i+1].longitude
      );
    }

    return totDistance.toStringAsPrecision(3);
  }
}

