import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  String _dialogTitle = '';
  ConfirmDialog(this._dialogTitle);

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
            _dialogTitle,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 30.0),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                onPressed: () { Navigator.pop(context, true); },
                child: Text(
                  'Confirm',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              FlatButton(
                onPressed: () { Navigator.pop(context, false); },
                child: Text('Deny'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}