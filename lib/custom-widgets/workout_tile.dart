import 'package:flutter/material.dart';
import 'package:mobile_devices_project/database/workout.dart';
import 'package:mobile_devices_project/database/db_model.dart';
import 'package:mobile_devices_project/pages/workouts.dart';
import 'package:mobile_devices_project/custom-widgets/confirm_dialog.dart';
import 'package:mobile_devices_project/custom-widgets/workout_info_dialog.dart';
import 'package:mobile_devices_project/globals.dart' as globals;

class WorkoutTile extends StatefulWidget {
  Workout workout;
  Workouts workoutsPage;

  WorkoutTile({this.workout, this.workoutsPage});

  @override
  _WorkoutTileState createState() => _WorkoutTileState();
}

class _WorkoutTileState extends State<WorkoutTile> {
  bool _checked = false;
  Color _tileColor = Colors.white;
  final _model = DBModel();

  Color _getTextColor(Workout workout) {
    return (DateTime.now().difference(widget.workout.datetime).inDays <= 0) ? Colors.black : Colors.red;
  }

  Widget _getRepeatIcon(Workout workout) {
    if (workout.repeatEvery > 0) {
      return Icon(
        Icons.loop,
        color: _getTextColor(workout),
        size: 16.0,
      );
    }
    return SizedBox(width: 0.0);
  }

  Future<void> _deleteWorkout() async {
    await _model.deleteWorkout(widget.workout.workoutID); 
    widget.workoutsPage.workoutsPageState.setState(() { 
      globals.isWorkoutsLoaded = false;
    });
  }

  Future<void> _setWorkoutCompleted() async {
    await _model.setWorkoutCompleted(widget.workout);
    widget.workoutsPage.workoutsPageState.setState(() { 
      globals.isWorkoutsLoaded = false;
    });
  }

  List<Widget> _getWorkoutInfo(Workout workout) {
    List<Widget> repsAndSetsInfo = [
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text('Reps'),
          ),
          Text(
            '${workout.reps}',
            textScaleFactor: 1.2,
          ),
        ],
      ),
      SizedBox(width: 10.0,),
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text('Sets'),
          ),
          Text(
            '${workout.sets}',
            textScaleFactor: 1.2,
          ),
        ],
      ),
    ];
    List<Widget> durationInfo = [
      Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(2.0),
            child: Text('Duration'),
          ),
          Text(
            '${workout.duration} min',
            textScaleFactor: 1.2,
          ),
        ],
      ),
    ];
    if (workout.reps != 0) {
      return repsAndSetsInfo;
    }
    else if (workout.duration != 0) {
      return durationInfo;
    }
    return repsAndSetsInfo;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (tap) {
        setState(() {
          _tileColor = Colors.grey[200];
        });
      },
      onTapUp: (tap) async {
        setState(() {
          _tileColor = Colors.white;
        });
        String action = await showDialog<String>(
          context: context,
          builder: (BuildContext context) {
            return WorkoutInfoDialog(widget.workout);
          },
        );
        switch(action) {
          case 'delete': {
            await _deleteWorkout();
          }
          break;
          case 'completed': {
            await _setWorkoutCompleted();
          }
        }
      },
      onTapCancel: () {
        setState(() {
          _tileColor = Colors.white;
        });
      },
      onLongPress: () async {
        bool confirm = await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmDialog('Delete this workout?\n(${widget.workout.workoutName})');
          }
        );
        if (confirm != null && confirm) {
          await _deleteWorkout();
        }
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 10.0),
        decoration: BoxDecoration(
          color: _tileColor,
          border: Border.all(color: Colors.grey[200]),
        ),
        child: Row(
          children: <Widget>[
            Checkbox(
              onChanged: (bool) async {
                setState(() { _checked = !_checked; });
                await Future.delayed(const Duration(milliseconds: 300), () {});
                if (_checked) {
                  setState(() { _checked = false; });
                  await Future.delayed(const Duration(milliseconds: 30), () {});
                  await _setWorkoutCompleted();
                }
              },
              value: _checked,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.workout.workoutName,
                  textScaleFactor: 1.2,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '${widget.workout.datetime.year}-${widget.workout.datetime.month}-${widget.workout.datetime.day}',
                        style: TextStyle(color: _getTextColor(widget.workout)),
                      ),
                      SizedBox(width: 4.0),
                      _getRepeatIcon(widget.workout),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: _getWorkoutInfo(widget.workout),
              ),
            ),
          ],
        ),
      ),
    );
  }
}