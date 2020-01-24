import 'package:flutter/material.dart';
import 'package:mobile_devices_project/custom-widgets/weight_chart.dart';
import 'package:mobile_devices_project/custom-widgets/food_graph.dart';
import 'package:mobile_devices_project/database/db_model.dart';


class Reports extends StatefulWidget {

  Reports({Key key}) : super(key: key);

  @override
  _ReportsState createState() => _ReportsState();

}

class _ReportsState extends State<Reports> {

  String _lastWeight = '';

  _ReportsState() {
    getLastWeight().then((val) => setState(() {
          _lastWeight = val;
        }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/weightdisplay');
            },
            child: Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child:Text("Weight Loss Progress", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 30,
                          width: 30,
                          padding: EdgeInsets.only(left: 20),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/weightdisplay');
                            },
                            child:Icon(Icons.arrow_forward,),
                          ),
                        ),
                      ],
                    ),
                    WeightChart(),
                    Divider(),
                    Text('Last Check-In', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    Text('${_lastWeight} lbs', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/caloriechart');
            },
            child: Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child:Text("Calories Consumed", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          height: 30,
                          width: 30,
                          padding: EdgeInsets.only(left: 46),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/caloriechart');
                            },
                            child:Icon(Icons.arrow_forward,),
                          ),
                        ),
                      ],
                    ),
                    FoodGraph(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}