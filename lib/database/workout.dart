class Workout {
  int workoutID;
  DateTime datetime;
  int repeatEvery; 
  String workoutName;
  int reps;
  int sets;
  int duration;
  int isCompleted; 
  double caloriesBurned;
  String user;

  Workout({
    this.workoutID, 
    this.datetime, 
    this.repeatEvery, 
    this.workoutName, 
    this.reps, 
    this.sets, 
    this.duration, 
    this.isCompleted, 
    this.caloriesBurned,
    this.user,
  });

  Map<String,dynamic> toMap() {
    return {
      'workoutID': this.workoutID,
      'datetime': this.datetime.toString(),
      'repeatEvery': this.repeatEvery,
      'workoutName': this.workoutName,
      'reps': this.reps,
      'sets': this.sets,
      'duration': this.duration,
      'isCompleted': this.isCompleted,
      'caloriesBurned': this.caloriesBurned,
      'user': this.user,
    };
  }

  Workout.fromMap(Map<String,dynamic> map) {
    this.workoutID = map['workoutID'];
    this.datetime = DateTime.parse(map['datetime']);
    this.repeatEvery = map['repeatEvery'];
    this.workoutName = map['workoutName'];
    this.reps = map['reps'];
    this.sets = map['sets'];
    this.duration = map['duration'];
    this.isCompleted = map['isCompleted'];
    this.caloriesBurned = map['caloriesBurned'];
    this.user = map['user'];
  }

  @override 
  String toString() {
    return 'Todo{workoutID: $workoutID, datetime: $datetime, day: $repeatEvery, workout: $workoutName, reps: $reps, sets: $sets, duration: $duration, isCompleted: $isCompleted, caloriesBurned: $caloriesBurned}';
  }

  double calcCaloriesBurned(int sets, int reps, int duration) {
    if (sets != 0 && reps != 0 && duration != 0) {
      return (sets*reps*100)/duration;
    } 
    else if (sets != 0 && reps != 0) {
      return (sets*reps*4).toDouble();
    }
    else {
      return (duration*10).toDouble();
    }
  }
}