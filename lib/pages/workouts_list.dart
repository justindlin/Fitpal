import 'package:flutter/material.dart';
import 'package:mobile_devices_project/database/workout.dart';
import 'package:mobile_devices_project/database/built-in-workouts/crunches.dart';
import 'package:mobile_devices_project/database/built-in-workouts/jogging.dart';
import 'package:mobile_devices_project/database/built-in-workouts/jump_rope.dart';
import 'package:mobile_devices_project/database/built-in-workouts/pushups.dart';
import 'package:mobile_devices_project/database/built-in-workouts/situps.dart';
import 'package:mobile_devices_project/database/built-in-workouts/squats.dart';
import 'package:mobile_devices_project/database/built-in-workouts/wall_sitting.dart';

class WorkoutsList extends StatelessWidget {
  String _workoutName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select workout'),
        backgroundColor: Colors.black54,
      ),
      body: ListView(
        children: _getExercises(context),
      ),
    );
  }

  List<Widget> _getExercises(BuildContext context) {
    List<Workout> exerciseList = [
      Crunches(),
      Jogging(),
      JumpRope(),
      Pushups(),
      Situps(),
      Squats(),
      WallSitting(),
    ];
    exerciseList.sort((a, b) => a.workoutName.compareTo(b.workoutName));

    List<Widget> exerciseTileList = [];
    for (Workout w in exerciseList) {
      exerciseTileList.add(_workoutToContainer(context, w));
    }

    Container customExercise = Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        child: TextField(
          decoration: InputDecoration(
            labelText: 'Custom workout',
          ),
          onChanged: (String newValue) {
            _workoutName = newValue;
          },
          onSubmitted: (value) {
            Navigator.of(context).pop(
              Workout(workoutName: _workoutName),
            );
          },
        ),
      ),
    );
    exerciseTileList.insert(0, customExercise);
    return exerciseTileList;
  }

  GestureDetector _workoutToContainer(BuildContext context, Workout workout) {
    return GestureDetector(
      onTap: () {
        _workoutName = workout.workoutName;
        Navigator.of(context).pop(
          workout,
        );
      },
      child: Container(
        padding: EdgeInsets.all(20.0),
        height: 70.0,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[400]),
        ),
        child: Text(
          workout.workoutName,
          style: TextStyle(fontSize: 18.0),
        ),
      ),
    );
  }
}