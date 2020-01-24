import 'package:flutter/material.dart';
import 'package:mobile_devices_project/database/built-in-workouts/duration_workout.dart';
import 'package:mobile_devices_project/database/built-in-workouts/reps_workout.dart';
import 'package:mobile_devices_project/database/workout.dart';
import 'package:mobile_devices_project/custom-widgets/workout_field_btn.dart';
import 'package:mobile_devices_project/globals.dart' as globals;

class WorkoutForm extends StatefulWidget {
  @override
  _WorkoutFormState createState() => _WorkoutFormState();
}

class _WorkoutFormState extends State<WorkoutForm> {
  WorkoutFieldBtn _repsBtn = WorkoutFieldBtn(fieldName: 'Reps');
  WorkoutFieldBtn _setsBtn = WorkoutFieldBtn(fieldName: 'Sets');
  WorkoutFieldBtn _durationBtn = WorkoutFieldBtn(fieldName: 'Duration');
  WorkoutFieldBtn _dueDateBtn = WorkoutFieldBtn(fieldName: 'Due date');
  bool _isWorkoutSelected = false;
  String _workoutName = 'Select workout';
  String _repeatText;
  int _repeatEvery = 0;
  Workout chosenWorkout;

  @override
  Widget build(BuildContext context) {
    globals.isWorkoutsLoaded = false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add a workout...'),
        backgroundColor: Colors.black54,
        actions: <Widget>[
          Builder(
            builder: (BuildContext context) {
              return FlatButton(
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16.0,
                  ),
                ),
                onPressed: () {
                  if (_isWorkoutSelected) { 
                    Navigator.of(context).pop(
                      Workout(
                        datetime: _dueDateBtn.datetime,
                        repeatEvery: _repeatEvery,
                        workoutName: _workoutName,
                        reps: _repsBtn.reps,
                        sets: _setsBtn.sets,
                        duration: _durationBtn.duration,
                        isCompleted: 0,
                        user: globals.userEmail, 
                      ),
                    );
                  }
                  else {
                    var snackbar = SnackBar(content: Text('ERROR: You have not selected a workout yet!'));
                    Scaffold.of(context).showSnackBar(snackbar);
                  }
                },
              );
            },
          )
        ],
      ),
      body: ListView(
        children: _formWidgets(chosenWorkout),
      ),
    );
  }

  List<Widget> _formWidgets(Workout selectedWorkout) {
    return [
      Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 60.0,
              child: FlatButton(
                onPressed: () async {
                  var event = await Navigator.pushNamed(context, '/workoutslist');
                  if (event != null) {
                    selectedWorkout = event;
                    _workoutName = selectedWorkout.workoutName;
                    _isWorkoutSelected = true;
                    setState(() {
                      chosenWorkout = selectedWorkout;
                    });
                  }
                },
                color: Colors.green[50],
                child: Text(
                  _workoutName,
                  style: TextStyle(fontSize: 22.0, color: Colors.grey[700]),
                ),
              ),
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration (
                labelText: 'Repeat every...',
              ),
              value: _repeatText,
              items: <String> ['Never repeat', 'Every day', 'Every week', 'Every month']
                .map<DropdownMenuItem<String>>((String item) {
                  return DropdownMenuItem<String> (
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              onChanged: (String newValue) {
                switch(newValue) {
                  case 'Every day': {
                    _repeatEvery = 1;
                  }
                  break;
                  case 'Every week': {
                    _repeatEvery = 7;
                  }
                  break;
                  case 'Every month': {
                    _repeatEvery = 30;
                  }
                  break;
                  default: {
                    _repeatEvery = 0;
                  }
                  break;
                }
                setState(() {
                  _repeatText = newValue;
                });
              },
            ),
          ],
        ),
      ),
      // Some components of the form only appear if certain workouts are selected
      _getRepsBtn(chosenWorkout),
      SizedBox(height: 2.0),
      _getSetsBtn(chosenWorkout),
      SizedBox(height: 2.0),
      _getDurationBtn(chosenWorkout),
      SizedBox(height: 2.0),
      _dueDateBtn,
    ];
  }

  Widget _getRepsBtn(Workout selectedWorkout) {
    if (selectedWorkout is RepsWorkout || 
       (selectedWorkout is! DurationWorkout && selectedWorkout != null)) {
      return _repsBtn;
    }
    else {
      return SizedBox(height: 0.0);
    }
  }

  Widget _getSetsBtn(Workout selectedWorkout) {
    if (selectedWorkout is RepsWorkout ||
       (selectedWorkout is! DurationWorkout && selectedWorkout != null)) {
      return _setsBtn;
    }
    else {
      return SizedBox(height: 0.0);
    }
  }

  Widget _getDurationBtn(Workout selectedWorkout) {
    if (selectedWorkout is DurationWorkout ||
       (selectedWorkout is! RepsWorkout && selectedWorkout != null)) {
      return _durationBtn;
    }
    else {
      return SizedBox(height: 0.0);
    }
  }
}