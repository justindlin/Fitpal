import 'package:flutter/material.dart';
import 'package:mobile_devices_project/database/db_model.dart';
import 'package:mobile_devices_project/database/workout.dart';
import 'package:mobile_devices_project/custom-widgets/workout_tile.dart';
import 'package:mobile_devices_project/custom-widgets/add_workout_btn.dart';
import 'package:mobile_devices_project/globals.dart' as globals;

class Workouts extends StatefulWidget {
  List<Widget> workoutTiles = [];
  _WorkoutsState workoutsPageState;

  Workouts({Key key}) : super(key: key);

  @override
  _WorkoutsState createState() => _WorkoutsState();

}

class _WorkoutsState extends State<Workouts> {
  final _model = DBModel();
  AddWorkoutBtn addWorkoutButton = AddWorkoutBtn();

  @override
  Widget build(BuildContext context) {
    widget.workoutsPageState = this;
    addWorkoutButton.workoutsPage = widget;
    if (!globals.isWorkoutsLoaded) listWorkouts();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: ListView.builder(
          itemCount: widget.workoutTiles.length,
          itemBuilder: (context, i) {
            return widget.workoutTiles[i];
          },
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
        ),
      ),
    );
  }

  Future<void> listWorkouts() async {
    List<Workout> workouts = await _model.getWorkouts();
    List<Widget> workoutTiles = [addWorkoutButton, SizedBox(height: 10.0),];
    for (Workout workout in workouts) {
      workoutTiles.add(WorkoutTile(workout: workout, workoutsPage: widget));
    }
    widget.workoutTiles = workoutTiles;
    setState(() {
      globals.isWorkoutsLoaded = true;
    });
  }
}