import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:mobile_devices_project/database/db_model.dart';
import 'package:mobile_devices_project/database/workout.dart';
import 'package:mobile_devices_project/pages/workouts.dart';
import 'package:mobile_devices_project/notifications.dart';
import 'package:mobile_devices_project/globals.dart' as globals;

class AddWorkoutBtn extends StatefulWidget {
  Workouts workoutsPage;

  @override
  _AddWorkoutBtnState createState() => _AddWorkoutBtnState();
}

class _AddWorkoutBtnState extends State<AddWorkoutBtn> {
  Color addWorkoutColor = Colors.black54;
  double addBtnPadding = 14.0;
  var _notifications = Notifications();
  final _model = DBModel();

  Future<void> _addWorkout(BuildContext context) async {
    var event = await Navigator.pushNamed(context, '/workoutform');
    if (event != null) {
      //List data = event;
      Workout newWorkout = event;//data[0];
      await _model.insertWorkout(newWorkout);
      await _notificationLater(newWorkout);
      widget.workoutsPage.workoutsPageState.setState(() {
        globals.isWorkoutsLoaded = false;
      });
    }
  }

  Future<void> _notificationLater(Workout workout) async {
    //just made it send notifications now because no one has time to wait for a notification for days
    //_notifications.sendNotificationNow('Workout Reminder', 'Don\'t forget to complete your workout: '+workout.workoutName, 'payload');
    
    //this following line will be the correct line of code
    await _notifications.sendNotificationLater('Workout Reminder', 'Don\'t forget to complete your workout: '+workout.workoutName, workout.datetime, 'payload');
  }

  @override
  Widget build(BuildContext context) {
    _notifications.init();
    return GestureDetector(
      onTapDown: (tap) {
        setState(() {
          addWorkoutColor = Colors.black87;
        });
      },
      onTapUp: (tap) {
        _addWorkout(context);
        setState(() {
          addWorkoutColor = Colors.black54;
        });
      },
      onTapCancel: () {
        setState(() {
          addWorkoutColor = Colors.black54;
        });
      },
      child: Container(
        padding: EdgeInsets.all(addBtnPadding),
        decoration: BoxDecoration(
          color:  addWorkoutColor,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            SizedBox(width: addBtnPadding),
            Text(
              FlutterI18n.translate(context, 'workouts.addWorkout'),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}