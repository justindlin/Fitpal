import 'package:flutter/material.dart';
import 'package:mobile_devices_project/database/workout.dart';

class WorkoutInfoDialog extends StatelessWidget {
  Workout workout;
  WorkoutInfoDialog(this.workout);

  Text _getRepeatText(Workout workout) {
    if (workout.repeatEvery <= 0) {
      return Text('Never repeat');
    }
    else {
      return Text('Repeats every ${workout.repeatEvery} days');
    }
  }

  List<Widget> _getWorkoutInfo(Workout workout) {
    List<Widget> list = [];
    if (workout.reps != 0 || workout.sets != 0 ||
       (workout.reps == 0 && workout.sets == 0 && workout.duration == 0)) {
      list.add(
        Row(
          children: <Widget>[
            Text(
              'Reps: ${workout.reps}, Sets: ${workout.sets}',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      );
      list.add(SizedBox(height: 4.0));
    }
    if (workout.duration != 0) {
      list.add(
        Text(
          'Duration: ${workout.duration} min',
          style: TextStyle(fontSize: 16.0),
        ),
      );
      list.add(SizedBox(height: 4.0));
    }
    list.add(
      Text(
        'Estimated calories burned: ${workout.caloriesBurned.toInt()}',
        style: TextStyle(fontSize: 16.0),
      ),
    );
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 10.0),
          Text(
            workout.workoutName,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          _getRepeatText(workout),
          SizedBox(height: 30.0),
          Container(
            alignment: Alignment.centerLeft,
            width: 230.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _getWorkoutInfo(workout),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () { Navigator.pop(context, 'delete'); },
                child: Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () { Navigator.pop(context, 'completed'); },
                child: Text(
                  'Completed',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              FlatButton(
                onPressed: () { Navigator.pop(context, 'close'); },
                child: Text('Close'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}