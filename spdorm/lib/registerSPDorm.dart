import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RegisterSPDorm(),
  ));
}

class RegisterSPDorm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RegisterSPDorm();
  }
}

class _RegisterSPDorm extends State {
  TextEditingController userUsername = TextEditingController();
  TextEditingController userPassword = TextEditingController();
  TextEditingController userPassword2 = TextEditingController();
  TextEditingController userFirstname = TextEditingController();
  TextEditingController userLastname = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  TextEditingController userTelephone = TextEditingController();
  TextEditingController userEmail = TextEditingController();

  void onRegisterSPDorm() {
    Map<String, dynamic> param = Map();
    param["userUsername"] = userUsername.text;
    param["userPassword"] = userPassword.text;
    param["userFirstname"] = userFirstname.text;
    param["userLastname"] = userLastname.text;
    param["userAddress"] = userAddress.text;
    param["userTelephone"] = userTelephone.text;
    param["userEmail"] = userEmail.text;
    param["userType"] = 'host';
    param["userStatus"] = 'active';
    http
        .post('${config.API_url}/user/register', body: param)
        .then((response) {
      print(response.body);
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap["status"];
      String message = jsonMap["message"];
      print("status ${status}");
      if (status == 0) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('สมัครสมาชิก')),
      body: new ListView(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(top: 5),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.date_range),
                new Text('รายละเอียดการสมัคร:'),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: userUsername,
              decoration: InputDecoration(
                  icon: const Icon(Icons.person),
                  hintText: 'กรอกบัญชีผู้ใช้',
                  labelText: 'บัญชีผู้ใช้:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: userFirstname,
              decoration: InputDecoration(
                  icon: const Icon(Icons.perm_contact_calendar),
                  hintText: 'กรอกชื่อ',
                  labelText: 'ชื่อ:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: userLastname,
              decoration: InputDecoration(
                  icon: const Icon(Icons.perm_contact_calendar),
                  hintText: 'กรอกนามสุกล',
                  labelText: 'นามสกุล:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: userAddress,
              decoration: InputDecoration(
                  icon: const Icon(Icons.add_location),
                  hintText: 'กรอกที่อยู่',
                  labelText: 'ที่อยู่:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: userEmail,
              decoration: InputDecoration(
                  icon: const Icon(Icons.email),
                  hintText: 'กรอกอีเมล์',
                  labelText: 'อีเมล์:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: userTelephone,
              decoration: InputDecoration(
                  icon: const Icon(Icons.local_phone),
                  hintText: 'กรอกเบอร์โทรศัพท์',
                  labelText: 'เบอร์โทรศัพท์:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.phone,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: userPassword,
              decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  hintText: 'กรอกรหัสผ่าน',
                  labelText: 'รหัสผ่าน:',
                  labelStyle: TextStyle(fontSize: 15)),
              obscureText: true,
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: userPassword2,
              decoration: InputDecoration(
                  icon: const Icon(Icons.lock),
                  hintText: 'Enter a Re-Password',
                  labelText: 'Re-Password:',
                  labelStyle: TextStyle(fontSize: 15)),
              obscureText: true,
              keyboardType: TextInputType.text,
            ),
          ),
          Container(
            child: Center(
              child: new RaisedButton(
              onPressed: onRegisterSPDorm,
              textColor: Colors.white,
              color: Colors.blue,
              child: new Text('Register')
            ),
            ),
          ),
        ],
      ),
    );
  }
}
