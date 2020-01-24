import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:mobile_devices_project/weight_display.dart';
import 'package:mobile_devices_project/custom-widgets/bottom_nav_bar_controller.dart';
import 'package:mobile_devices_project/pages/food_form.dart';
import 'package:mobile_devices_project/pages/workout_form.dart';
import 'package:mobile_devices_project/pages/sign_in_page.dart';
import 'package:mobile_devices_project/custom-widgets/calorie_chart.dart';
import 'package:mobile_devices_project/pages/workouts_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitPal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blueAccent,
      ),
      home: BottomNavBarController(),
      routes: <String, WidgetBuilder> {
        '/foodform': (BuildContext context) => FoodForm(),
        '/workoutform': (BuildContext context) => WorkoutForm(),
        '/signin': (BuildContext context) => SignInPage(),
        '/weightdisplay': (BuildContext context) => WeightDisplay(),
        '/caloriechart': (BuildContext context) => CalorieChart(),
        '/workoutslist': (BuildContext context) => WorkoutsList(),
      },
      localizationsDelegates: [
        FlutterI18nDelegate(
          useCountryCode: false,
          fallbackFile: 'en',
          path: 'assets/i18n',
        ),
      ],
    );
  }
}
