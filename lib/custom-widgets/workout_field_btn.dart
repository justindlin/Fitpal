import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';  // To create a picker to set workout data
import 'dart:convert';                                // So flutter_picker can convert strings

class WorkoutFieldBtn extends StatefulWidget {
  String fieldName;
  int reps = 0;
  int sets = 0;
  int duration = 0;
  DateTime datetime = new DateTime.now();
  WorkoutFieldBtn({this.fieldName});

  @override
  _WorkoutFieldBtnState createState() => _WorkoutFieldBtnState();
}

class _WorkoutFieldBtnState extends State<WorkoutFieldBtn> {
  Color _btnColor = Colors.white;
  DateTime _today = new DateTime.now();
  String numReps = '''
  [[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100]]
  ''';
  String numSets = '''
  [[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]]
  ''';
  String numMinutes = '''
  [
    [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180],
    ["min"]
  ]
  ''';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (tap) {
        setState(() {
          _btnColor = Colors.grey[200];
        });
      },
      onTapUp: (tap) {
        _showSelectedPicker(widget.fieldName);
        setState(() {
          _btnColor = Colors.white;
        });
      },
      onTapCancel: () {
        setState(() {
          _btnColor = Colors.white;
        });
      },
      child: Container(
        padding: EdgeInsets.all(14.0),
        decoration: BoxDecoration(
          color: _btnColor,
          border: Border.all(color: Colors.grey[200]),
        ),
        child: Row(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.fieldName,
                  textScaleFactor: 1.15,
                ),
              ],
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _quantityLabel(widget.fieldName),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text _quantityLabel(String fieldName) {
    String text = '';
    switch(fieldName) {
      case 'Reps': {
        text = '${widget.reps} reps';
      }
      break;
      case 'Sets': {
        text = '${widget.sets} sets';
      }
      break;
      case 'Duration': {
        if (widget.duration <= 60) {
          text = '${widget.duration} min';
        } else {
          int hours = (widget.duration/60.0).floor();
          int minutes = (widget.duration % 60.0).floor();
          text = '${hours}h $minutes min';
        }
      }
      break;
      case 'Due date': {
        text = '${widget.datetime.year}-${widget.datetime.month}-${widget.datetime.day}';
      }
      break;
    }
    return Text(
      text,
      style: TextStyle(
        color: Colors.grey[600],
      ),
    );
  }

  void _showSelectedPicker(String fieldName) {
    switch(fieldName) {
      case 'Reps': {
        _repsPicker();
      }
      break;
      case 'Sets': {
        _setsPicker();
      }
      break;
      case 'Duration': {
        _durationPicker();
      }
      break;
      case 'Due date': {
        _selectDate(context);
      }
      break;
    }
  }

  void _repsPicker() {
    Picker(
      adapter: PickerDataAdapter<String>(pickerdata: new JsonDecoder().convert(numReps), isArray: true),
      hideHeader: true,
      title: Text('Number of Reps'),
      onConfirm: (Picker picker, List value) {
        setState(() {
          widget.reps = int.parse(picker.adapter.text.substring(1,picker.adapter.text.length-1));
        });
      }
    ).showDialog(context);
  }

  void _setsPicker() {
    Picker(
      adapter: PickerDataAdapter<String>(pickerdata: new JsonDecoder().convert(numSets), isArray: true),
      hideHeader: true,
      title: Text('Number of Sets'),
      onConfirm: (Picker picker, List value) {
        setState(() {
          widget.sets = int.parse(picker.adapter.text.substring(1,picker.adapter.text.length-1));
        });
      }
    ).showDialog(context);
  }

  void _durationPicker() {
    Picker(
      adapter: PickerDataAdapter<String>(pickerdata: new JsonDecoder().convert(numMinutes), isArray: true),
      hideHeader: true,
      title: Text('Duration'),
      onConfirm: (Picker picker, List value) {
        setState(() {
          widget.duration = int.parse(picker.getSelectedValues()[0]);
        });
      }
    ).showDialog(context);
  }

  //workout due date picker
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.datetime,
      firstDate: DateTime(_today.year, _today.month, _today.day),
      lastDate: widget.datetime.add(Duration(days: 365))
    );
    if (picked != null && picked != widget.datetime) {
      setState(() {
        widget.datetime = picked;
      });
    }
  }
}