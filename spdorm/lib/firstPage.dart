import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spdorm/registerSPDorm.dart';
import 'dart:convert';
import 'AddDormpage.dart';
import 'config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: Login(),
//   ));
// }

Future<void> _login(int id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('id', id);
}

Future<int> _getId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('id');
}

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _Login();
  }
}

class _Login extends State {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  String _userError = "";

  // @override
  // void initState() {
  //   super.initState();
  //   _checkLogin().then((bool res) => {
  //         if (res)
  //           {
  //             _getId().then((int id) {
  //               Navigator.pop(context);
  //               Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(
  //                       builder: (BuildContext) => AddDormPage(id)));
  //             })
  //           }
  //       });
  // }

  void onLogin() {
    Map reqData = Map();
    reqData["userUsername"] = userName.text;
    reqData["userPassword"] = password.text;
    http.post('${config.API_url}/user/login', body: reqData).then((response) {
      print(response.body);
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap["status"];

      if (status == 0) {
        Map<String, dynamic> dataMap = jsonMap["data"] as Map;
        int userId = dataMap['userId'];
        if (dataMap['userType'] == "host" &&
            dataMap['userStatus'] == "active") {
          _userError = "";
          _login(userId);
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext) => AddDormPage(userId)));
        }
      } else {
        setState(() {
          _userError = "บัญชีผู้ใช้หรือรหัสผ่านไม่ถูกต้อง";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('เข้าสู่ระบบ')),
      body: ListView(
        padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 60.0),
        children: <Widget>[
          Image.asset("images/sp.png",height: 150,),
          new Container(
            margin: new EdgeInsets.only(left: 0.05, right: 0.05, top: 20.0),
            decoration: new BoxDecoration(
              color: Color.fromARGB(255, 240, 240, 240),
              border: new Border.all(
                  width: 1.2,
                  color: _userError == "" ? Colors.black12 : Colors.red),
              borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
            ),
            child: TextField(
              controller: userName,
              decoration: InputDecoration(
                  contentPadding: new EdgeInsets.all(10.0),
                  border: InputBorder.none,
                  hintText: ': ชื่อผู้ใช้'),
            ),
          ),
          new Container(
            margin: new EdgeInsets.only(left: 1.0, right: 1.0, top: 20),
            decoration: new BoxDecoration(
              color: Color.fromARGB(255, 240, 240, 240),
              border: new Border.all(
                  width: 1.2,
                  color: _userError == "" ? Colors.black12 : Colors.red),
              borderRadius: new BorderRadius.all(const Radius.circular(25.0)),
            ),
            child: TextField(
              controller: password,
              decoration: InputDecoration(
                  contentPadding: new EdgeInsets.all(10.0),
                  border: InputBorder.none,
                  hintText: ': รหัสผ่าน'),
              obscureText: true,
            ),
          ),
          _userError == ""
              ? Padding(
                  padding: EdgeInsets.all(0),
                )
              : Padding(
                padding: EdgeInsets.all(3),
                  child: Column(
                    children: <Widget>[
                      Text(
                        _userError,
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
          new Container(
            margin: new EdgeInsets.only(top: 20),
            child: RaisedButton(
              onPressed: onLogin,
              child: Text('เข้าสู่ระบบ'),
              textColor: Colors.white,
              color: Colors.blue,
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext) => RegisterSPDorm()));
            },
            child: Text("ลงทะเบียน"),
          ),
        ],
      ),
    );
  }
}
