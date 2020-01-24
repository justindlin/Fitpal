import 'package:flutter/material.dart';
import 'package:mobile_devices_project/database/db_model.dart';
import 'package:mobile_devices_project/globals.dart' as globals;

class TrackCaloriesBtn extends StatefulWidget {
  @override
  _TrackCaloriesBtnState createState() => _TrackCaloriesBtnState();
}

class _TrackCaloriesBtnState extends State<TrackCaloriesBtn> {
  final _model = DBModel();
  Color _btnColor = Colors.white;
  int _dailyIntake = 0;

  Future<void> _setDailyIntake() async {
    List<Map<String,dynamic>> foods = await _model.getFoodsToday();
    double intake = 0;
    for (Map<String, dynamic> food in foods) {
      intake += food['calorieIntake'];
    }
    setState(() {
      _dailyIntake = intake.toInt();
      globals.isFoodLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!globals.isFoodLoaded) _setDailyIntake();

    return GestureDetector(
      onTapDown: (tap) {
        setState(() {
          _btnColor = Colors.grey[200];
        });
      },
      onTapUp: (tap) async {
        await Navigator.pushNamed(context, '/foodform');
        setState(() {
          globals.isFoodLoaded = false;
          _btnColor = Colors.white;
        });
      },
      onTapCancel: () {
        setState(() {
          _btnColor = Colors.white;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: _btnColor,
          border: Border.all(color: Colors.black54),
        ),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.check_circle_outline, 
                  color: Colors.yellow[700],
                ),
                SizedBox(width: 3.0,),
                Text('Track calories'),
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              children: <Widget>[
                 Text('$_dailyIntake / 2200 cal'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}