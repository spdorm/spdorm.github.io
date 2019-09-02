import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firstPage.dart';
import 'listDorm.dart';
import 'mainHomDorm.dart';

void main() {
  runApp(new MaterialApp(
    theme: ThemeData(fontFamily: 'Kanit'),
    debugShowCheckedModeBanner: false,
    home: new SplashScreen(),
  ));
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

Future<bool> _checkLogin() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int temp = prefs.getInt('id');
  if (temp == null) {
    return false;
  } else {
    return true;
  }
}

Future<int> _getId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getInt('id'));
  return prefs.getInt('id');
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    await Future.delayed(Duration(seconds: 2));
    _checkLogin().then((bool res) {
      if (res) {
        _getId().then((userId) {
          http.post('${config.API_url}/room/findByCustomerId',
                body: {"userId": userId.toString()}).then((response) {
              Map jsonData = jsonDecode(response.body) as Map;
              Map<String, dynamic> dataMap = jsonData['data'];
              if (jsonData['status'] == 0) {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext) => mainHomDorm(
                            dataMap['dormId'], userId, dataMap['roomId'])));
              } else {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext) => ListDormPage()));
              }
            });
        });
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (BuildContext) => Login()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Center(
        child: new Image.asset(
          'images/sp.png',
          width: 80,
        ),
      ),
    );
  }
}
