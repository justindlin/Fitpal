import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'db_utils.dart';
import 'weight.dart';
import 'workout.dart';
import 'food.dart';
import 'package:mobile_devices_project/globals.dart' as globals;

class DBModel {
  Future<List<Map<String,dynamic>>> getWeights() async {
    final db = await DBUtils.init();
    List<Map<String,dynamic>> maps = await db.query(
      'Weight',
      where: 'user = ? ORDER BY date(datetime)',
      whereArgs: [globals.userEmail],
    );
    return maps;
  }

  Future<void> getWeightsFromCloud() async {
    if (!globals.isLoggedIn) return;

    CollectionReference cloudWeight = Firestore.instance.collection('Weight');
    Query query = cloudWeight.where('user', isEqualTo: globals.userEmail);
    QuerySnapshot collectionSnapshot = await query.getDocuments();
    List<DocumentSnapshot> cloudWeightsList = collectionSnapshot.documents.toList();
    for (DocumentSnapshot document in cloudWeightsList) {
      Weight weight = Weight.fromMap(document.data);
      await localInsertWeight(weight);
    }
  }

  Future<int> localInsertWeight(Weight newWeight) async {
    final db = await DBUtils.init();
    return await db.insert(
      'Weight',
      newWeight.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertWeight(Weight weight) async {
    int newWeightID = await localInsertWeight(weight);
    weight.weightID = newWeightID;
    if (globals.isLoggedIn) {
      CollectionReference cloudWorkout = Firestore.instance.collection('Weight');
      await cloudWorkout.document('Weight$newWeightID${globals.userEmail}').setData(weight.toMap());
    }
    return newWeightID;
  }

  Future<int> deleteWeight(int id) async {
    final db = await DBUtils.init();
    return await db.delete(
      'Weight',
      where: 'weightID = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String,dynamic>>> getFoods() async {
    final db = await DBUtils.init();
    List<Map<String,dynamic>> maps = await db.query(
      'Food',
      where: 'user = ? ORDER BY date(datetime)',
      whereArgs: [globals.userEmail],
    );
    return maps;
  }

  Future<List<Map<String,dynamic>>> getFoodsToday() async {
    final db = await DBUtils.init();
    DateTime now = DateTime.now();
    DateTime later = now.add(Duration(days: 1));
    String nowMonth = (now.month < 10) ? '0${now.month}' : '${now.month}';
    String nowDay = (now.day < 10) ? '0${now.day}' : '${now.day}';
    String laterMonth = (later.month < 10) ? '0${later.month}' : '${later.month}';
    String laterDay = (later.day < 10) ? '0${later.day}' : '${later.day}';
    String today = '${now.year}-$nowMonth-$nowDay';
    String tomorrow = '${later.year}-$laterMonth-$laterDay';
    List<Map<String,dynamic>> maps = await db.query(
      'Food',
      where: 'user = ? AND datetime BETWEEN "$today" AND "$tomorrow" ORDER BY date(datetime)',
      whereArgs: [globals.userEmail],
    );
    return maps;
  }

  Future<List<Map<String,dynamic>>> getFoodsDaysAgo(int days) async {
    final db = await DBUtils.init();
    DateTime now = DateTime.now();
    DateTime later = now.add(Duration(days: 1));
    DateTime past = now.subtract(Duration(days: days));
    String pastMonth = (past.month < 10) ? '0${past.month}' : '${past.month}';
    String pastDay = (past.day < 10) ? '0${past.day}' : '${past.day}';
    String laterMonth = (later.month < 10) ? '0${later.month}' : '${later.month}';
    String laterDay = (later.day < 10) ? '0${later.day}' : '${later.day}';
    String today = '${past.year}-$pastMonth-$pastDay';
    String tomorrow = '${later.year}-$laterMonth-$laterDay';
    List<Map<String,dynamic>> maps = await db.query(
      'Food',
      where: 'user = ? AND datetime BETWEEN "$today" AND "$tomorrow" ORDER BY date(datetime)',
      whereArgs: [globals.userEmail],
    );
    return maps;
  }

  Future<void> getFoodsFromCloud() async {
    CollectionReference cloudWeight = Firestore.instance.collection('Food');
    Query query = cloudWeight.where('user', isEqualTo: globals.userEmail);
    QuerySnapshot collectionSnapshot = await query.getDocuments();
    List<DocumentSnapshot> cloudFoodList = collectionSnapshot.documents.toList();
    for (DocumentSnapshot document in cloudFoodList) {
      Food food = Food.fromMap(document.data);
      await localInsertFood(food);
    }
  }

  Future<int> localInsertFood(Food newFood) async {
    final db = await DBUtils.init();
    return await db.insert(
      'Food',
      newFood.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertFood(Food food) async {
    int newFoodID = await localInsertFood(food);
    food.calorieID = newFoodID;
    if (globals.isLoggedIn) {
      CollectionReference cloudFood = Firestore.instance.collection('Food');
      await cloudFood.document('Food$newFoodID${globals.userEmail}').setData(food.toMap());
    }
    return newFoodID;
  }

  Future<List<Workout>> getWorkouts() async {
    final db = await DBUtils.init();
    List<Map<String, dynamic>> maps = await db.query(
      'Workout',
      where: 'user = ? AND isCompleted = ? ORDER BY date(datetime)',
      whereArgs: [globals.userEmail, 0],
    );
    List<Workout> workouts = [];
    for (int i = 0; i < maps.length; i++) {
      workouts.add(Workout.fromMap(maps[i]));
    }
    return workouts;
  }

  Future<void> getWorkoutsFromCloud() async {
    if (!globals.isLoggedIn) return;

    CollectionReference cloudWorkout = Firestore.instance.collection('Workout');
    Query query = cloudWorkout.where('user', isEqualTo: globals.userEmail);
    QuerySnapshot collectionSnapshot = await query.getDocuments();
    List<DocumentSnapshot> cloudWorkoutsList = collectionSnapshot.documents.toList();
    for (DocumentSnapshot document in cloudWorkoutsList) {
      Workout workout = Workout.fromMap(document.data);
      await localInsertWorkout(workout);
    }
  }

  Future<int> localInsertWorkout(Workout workout) async {
    final db = await DBUtils.init();
    return await db.insert(
      'Workout',
      workout.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertWorkout(Workout workout) async {
    workout.caloriesBurned = workout.calcCaloriesBurned(workout.sets, workout.reps, workout.duration);
    int newWorkoutID = await localInsertWorkout(workout);
    workout.workoutID = newWorkoutID;
    if (globals.isLoggedIn) {
      CollectionReference cloudWorkout = Firestore.instance.collection('Workout');
      await cloudWorkout.document('Workout$newWorkoutID${globals.userEmail}').setData(workout.toMap());
    }
    return newWorkoutID;
  }

  Future<int> deleteWorkout(int id) async {
    final db = await DBUtils.init();
    if (globals.isLoggedIn) {
      CollectionReference cloudWorkout = Firestore.instance.collection('Workout');
      cloudWorkout.document('Workout$id${globals.userEmail}').delete();
    }
    return await db.delete(
      'Workout',
      where: 'workoutID = ?',
      whereArgs: [id],
    );
  } 
 

  Future<void> setWorkoutCompleted(Workout workout) async {
    final db = await DBUtils.init();
    workout.isCompleted = 1;
    if (globals.isLoggedIn) {
      CollectionReference cloudWorkout = Firestore.instance.collection('Workout');
      cloudWorkout.document('Workout${workout.workoutID}${globals.userEmail}').updateData(workout.toMap());
    }
    await db.update(
      'Workout', 
      workout.toMap(),
      where: 'workoutID = ?', 
      whereArgs: [workout.workoutID]
    );
    if (workout.repeatEvery > 0) {
      Workout newWorkout = new Workout.fromMap(workout.toMap());
      newWorkout.workoutID = null;
      newWorkout.datetime = newWorkout.datetime.add(Duration(days: workout.repeatEvery));
      newWorkout.isCompleted = 0;
      await insertWorkout(newWorkout);
    }
  }

  // This method helps sync data between devices
  Future<void> getDataFromCloud() async {
    if (!globals.isLoggedIn) return;

    await getWeightsFromCloud();
    await getFoodsFromCloud();
    await getWorkoutsFromCloud();
  }

  Future<double> getWeightToday() async {
    DateTime now = DateTime.now().subtract(Duration(days: 1));

    Query q = Firestore.instance.collection('Weight')
    .where("datetime", isGreaterThan: now.toString());

    QuerySnapshot snapshot = await q.getDocuments();
    List<DocumentSnapshot> docs = snapshot.documents;

    List<Weight> l = [];

    for(int i = 0;i < docs.length;i++) {
      if(docs[i].data['datetime'] != null && docs[i].data['user'] == globals.userEmail) 
        l.add(Weight.fromMap(docs[i].data));
    }

    l.sort((a, b) => a.datetime.compareTo(b.datetime));

    if(l.length > 0) return l[l.length-1].weight;
    else return 0;
  }

  Future<List<Weight>> getWeightDays(int days) async {
    DateTime past = DateTime.now().subtract(Duration(days: days));

    Query q = Firestore.instance.collection('Weight')
    .where("datetime", isGreaterThan: past.toString());

    QuerySnapshot snapshot = await q.getDocuments();
    List<DocumentSnapshot> docs = snapshot.documents;

    List<Weight> l = [];

    for(int i = 0;i < docs.length;i++) {
      if(docs[i].data['datetime'] != null && docs[i].data['user'] == globals.userEmail) 
        l.add(Weight.fromMap(docs[i].data));
    }

    l.sort((a, b) => a.datetime.compareTo(b.datetime));
    return l;
  }

}
// gets the last weight in the database
Future<String> getLastWeight() async {
  Query q = Firestore.instance.collection('Weight');
  QuerySnapshot snapshot = await q.getDocuments();
  List<DocumentSnapshot> docs = snapshot.documents;
  
  String lastWeight = docs[docs.length - 1].data['weight'].toString();
    
  return lastWeight;
 }

//gets weights data from storage 
Future<List<Weight>> getWeights() async {

  Query q = Firestore.instance.collection('Weight');
  QuerySnapshot snapshot = await q.getDocuments();
  List<DocumentSnapshot> docs = snapshot.documents;

  List<Weight> l = [];

  for(int i = 0;i < docs.length;i++) {
    if(docs[i].data['datetime'] != null && docs[i].data['user'] == globals.userEmail) 
      l.add(Weight.fromMap(docs[i].data));
  }

  l.sort((a, b) => a.datetime.compareTo(b.datetime));
  return l;

  }

// gets the food data from storage
Future<List<Food>> getCalories() async {
  Query q = Firestore.instance.collection('Food');
  QuerySnapshot snapshot = await q.getDocuments();
  List<DocumentSnapshot> docs = snapshot.documents;

  List<Food> l = [];

  for(int i = 0; i < docs.length; i++) {
    if(docs[i].data['datetime'] != null && docs[i].data['user'] == globals.userEmail) 
    l.add(Food.fromMap(docs[i].data));
  }

   l.sort((a, b) => a.datetime.compareTo(b.datetime));
    return l;
  }