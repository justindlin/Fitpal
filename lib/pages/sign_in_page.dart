import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_devices_project/database/db_model.dart';
import 'package:mobile_devices_project/globals.dart' as globals;

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _model = DBModel();
  String _buttonText = globals.isLoggedIn ? 'Sign out' : 'Sign in with Google';
  String _pageTitle = 'Sign in';
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  bool _isLoading = false;

  _login() async {
    try {
      _isLoading = true;
      await _googleSignIn.signIn();
      globals.userEmail = _googleSignIn.currentUser.email;
      globals.profilePic = _googleSignIn.currentUser.photoUrl;
      globals.isLoggedIn = true;
      await _model.getDataFromCloud();
      globals.setLoadedFalse();
      setState(() {
        _buttonText = 'Sign out';
        _pageTitle = 'Signed in as';
      });
    } catch(error) {
      print(error);
      _isLoading = false;
      setState(() {
        _pageTitle = 'Sign in';                        
      });

    }
  }

  _logout() {
    _googleSignIn.signOut();
    globals.userEmail = '';
    globals.profilePic = '';
    globals.isLoggedIn = false;
    globals.setLoadedFalse();
    setState(() {
      _buttonText = 'Sign in with Google';
      _pageTitle = 'Sign in';
      _isLoading = false;
    });
  }

  Widget _getProfilePic(String url) {
    if (url != "") {
      return CircleAvatar(
        radius: 45.0,
        backgroundImage: NetworkImage(url),
      );
    }
    else {
      return SizedBox(height: 0.0);
    }
  }

  List<Widget> _getButtonChildren(String buttonText) {
    List<Widget> widgetList = [];
    if (!globals.isLoggedIn) {
      widgetList.add(Image(image: AssetImage("assets/google_logo.png"), height: 20.0));
      widgetList.add(SizedBox(width: 10.0));
    }
    widgetList.add(Text(buttonText));
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign-in'),
        backgroundColor: Colors.black54,
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _pageTitle,
                style: TextStyle(fontSize: 24.0),
              ),
              Text(globals.userEmail),
              SizedBox(height: 20.0),
              _getProfilePic(globals.profilePic),
              SizedBox(height: 10.0),
              ButtonTheme(
                minWidth: 130.0,
                child: OutlineButton(
                  splashColor: Colors.grey,
                  onPressed: () {
                    if (!globals.isLoggedIn && !_isLoading) {
                      print('logging in');
                      setState(() {
                        _pageTitle = 'Signing in...';                        
                      });
                      _login();
                    } else {
                      _logout();
                    }
                  },
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                  borderSide: BorderSide(color: Colors.grey),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: _getButtonChildren(_buttonText),
                    ),
                  ),
                ),
              ),
            ],  
          ),
        ),
      ),
    );
  }
}