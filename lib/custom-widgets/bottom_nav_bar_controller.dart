import 'package:flutter/material.dart';
import 'package:mobile_devices_project/pages/cardio.dart';
import 'package:mobile_devices_project/pages/reports.dart';
import 'package:mobile_devices_project/pages/workouts.dart';
import 'package:mobile_devices_project/pages/checkin.dart';
import 'package:mobile_devices_project/database/db_model.dart';
import 'package:mobile_devices_project/globals.dart' as globals;

/*
  This class implements a persistent bottom navigation bar, where only one navigation bar instance exists for the entire app.
  It stores page states using Flutter's PageStorage, and calls on it for navigation between pages.
*/

class BottomNavBarController extends StatefulWidget {

  _BottomNavBarControllerState createState() => _BottomNavBarControllerState();

}

class _BottomNavBarControllerState extends State<BottomNavBarController> {
  final _model = DBModel();
  int _selectedIndex = 0;
  final PageStorageBucket _bucket = PageStorageBucket(); //The bucket that flutter automatically uses to store page data

  //A stored list of the pages that map to each tab
  final List<Widget> pages = [
    Checkin(
      key: PageStorageKey('checkin'),
    ),
    Reports(
      key: PageStorageKey('reports'),
    ),
    Workouts(
      key: PageStorageKey('workouts'),
    ),
    Cardio(
      key: PageStorageKey('cardio'),
    ),
  ];

  Widget _getProfilePic(String url) {
    if (url != "") {
      return Padding(
        padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
        child: CircleAvatar(backgroundImage: NetworkImage(url)),
      );
    } else {
      return SizedBox(width: 0.0);
    }
  }

  Widget build(BuildContext context) {
    const List<String> options = ['Sign-in', 'Get cloud data', 'About'];

    return Scaffold(
      appBar: AppBar(
        title: Text("FitPal"),
        backgroundColor: Colors.black54,
        actions: <Widget>[
          _getProfilePic(globals.profilePic),
          // Allows user to select from options menu
          PopupMenuButton<String>(
            onSelected: (selection) async {
              switch (selection) {
                case 'Sign-in': {
                  await Navigator.pushNamed(context, '/signin');
                  Workouts workoutsPage = pages[2];
                  workoutsPage.workoutsPageState.setState(() {});
                  print(selection);
                }
                break;
                case 'Get cloud data': {
                  print(selection);
                  await _model.getDataFromCloud();
                  globals.isWorkoutsLoaded = false;
                }
                break;
                case 'About': {
                  showAboutDialog(
                    context: context,
                    applicationName: 'FitPal',
                    applicationVersion: '1.0',
                    children: [
                      Text('This app is a fitness tracker built for CSCI4100U. It helps you track your weight, diet, and workout schedule. It assumes your device is always online.'),
                    ]
                  );
                }
              }
            },
            itemBuilder: (BuildContext context) {
              return options.map((selection) {
                return PopupMenuItem<String>(
                  value: selection,
                  child: Text(selection),
                );
              }).toList();
            },
          ),
        ]
      ),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: _bucket,
      ),
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
    );
  }

  Widget _bottomNavigationBar(int selectedIndex) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Image(image: AssetImage('assets/checkin.png'), height: 22.0),
          title: Text('Checkin'),
        ),
        BottomNavigationBarItem(
          icon: Image(image: AssetImage('assets/reports.png'), height: 22.0),
          title: Text('Reports'),
        ),
        BottomNavigationBarItem(
          icon: Image(image: AssetImage('assets/workouts.png'), height: 22.0),
          title: Text('Workouts'),
        ),
        BottomNavigationBarItem(
          icon: Image(image: AssetImage('assets/cardio.png'), height: 22.0),
          title: Text('Cardio'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      globals.isWorkoutsLoaded = false;
      _selectedIndex = index;
    });
  }

}