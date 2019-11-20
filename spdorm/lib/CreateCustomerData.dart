import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'ListCustumer.dart';
import 'config.dart';
import 'dart:convert';

class CreateCustomerDataPage extends StatefulWidget {
  int _dormId, _userId, _roomId;
  CreateCustomerDataPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }
  @override
  State<StatefulWidget> createState() {
    return _CreateCustomerDataPage(_dormId, _userId, _roomId);
  }
}

class _CreateCustomerDataPage extends State {
  int _dormId, _userId, _roomId;
  _CreateCustomerDataPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // TextEditingController _username = TextEditingController();
  // TextEditingController _password = TextEditingController();
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _telephone = TextEditingController();
  TextEditingController _email = TextEditingController();

  void onAddCustomer() {
    bool _check = _formKey.currentState.validate();

    if (_check) {
      Alert(
        context: context,
        type: AlertType.info,
        title: "คุณต้องการลงทะเบียนเข้าหอพัก??",
        buttons: [
          DialogButton(
            child: Text(
              "ตกลง",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.brown[300],
            onPressed: () {
              Map<String, dynamic> param = Map();
              var _random = randomAlphaNumeric(6);
              param["userUsername"] = _random.toString();
              param["userPassword"] = _random.toString();
              param["userFirstname"] = _firstname.text;
              param["userLastname"] = _lastname.text;
              param["userAddress"] = _address.text;
              param["userTelephone"] = _telephone.text;
              param["userEmail"] = _email.text;
              param["userType"] = "customer";
              param["userStatus"] = "active";

              http
                  .post('${config.API_url}/user/register', body: param)
                  .then((response) {
                print(response.body);
                Map jsonMap = jsonDecode(response.body) as Map;
                int status = jsonMap['status'];

                if (status == 0) {
                  int _customerId = jsonMap['data'];

                  http.post('${config.API_url}/history/add', body: {
                    "dormId": _dormId.toString(),
                    "userId": _customerId.toString(),
                    "historyStatus": "รออนุมัติ"
                  }).then((response) {
                    print(response.body);
                    Map jsonMap = jsonDecode(response.body) as Map;
                    int status = jsonMap['status'];

                    if (status == 0) {
                      Alert(
                        context: context,
                        type: AlertType.success,
                        title: "สำเร็จ!",
                        desc: "ลงทะเบียนผู้ขอเข้าพักเรียบร้อยแล้ว",
                        buttons: [
                          DialogButton(
                            child: Text(
                              "ตกลง",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Colors.brown[200],
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          listCustumerPage(
                                              _dormId, _userId, _roomId)));
                            },
                            width: 120,
                          )
                        ],
                      ).show();
                    }
                  });
                }
              });
            },
            width: 120,
          ),
          DialogButton(
            child: Text(
              "ยกเลิก",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.grey[300],
            onPressed: () {
              Navigator.pop(context);
            },
            width: 120,
          )
        ],
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text('ลงทะเบียนเข้าหอพัก'),
      ),
      body: new ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          new Card(
            margin: EdgeInsets.all(5),
            child: new Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      new Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 40),
                        child: new Row(
                          children: <Widget>[
                            new Icon(
                              Icons.layers,
                              color: Colors.red[300],
                            ),
                            new Text(
                              ' ชื่อ:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: TextFormField(
                          controller: _firstname,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.control_point),
                              hintText: 'ระบุชื่อจริง',
                              labelText: 'ระบุชื่อจริง',
                              labelStyle: TextStyle(fontSize: 15)),
                          keyboardType: TextInputType.text,
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return "กรุณาระบุชื่อจริง";
                            }
                          },
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 40),
                        child: new Row(
                          children: <Widget>[
                            new Icon(
                              Icons.layers,
                              color: Colors.red[300],
                            ),
                            new Text(
                              ' นามสกุล:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: TextFormField(
                          controller: _lastname,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.control_point),
                              hintText: 'ระบุนามสกุล',
                              labelText: 'ระบุนามสกุล',
                              labelStyle: TextStyle(fontSize: 15)),
                          keyboardType: TextInputType.text,
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return "กรุณาระบุนามสุกล";
                            }
                          },
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 40),
                        child: new Row(
                          children: <Widget>[
                            new Icon(
                              Icons.person_pin_circle,
                              color: Colors.red[300],
                            ),
                            new Text(
                              ' ที่อยู่:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: TextFormField(
                          controller: _address,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.control_point),
                              hintText: 'ระบุที่อยู่',
                              labelText: 'ระบุที่อยู่',
                              labelStyle: TextStyle(fontSize: 15)),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 40),
                        child: new Row(
                          children: <Widget>[
                            new Icon(
                              Icons.email,
                              color: Colors.red[300],
                            ),
                            new Text(
                              ' อีเมล:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.control_point),
                              hintText: 'ระบุอีเมล',
                              labelText: 'ระบุอีเมล',
                              labelStyle: TextStyle(fontSize: 15)),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      new Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 40),
                        child: new Row(
                          children: <Widget>[
                            new Icon(
                              Icons.phone,
                              color: Colors.red[300],
                            ),
                            new Text(
                              ' เบอร์โทรศัพท์:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                      new Container(
                        padding:
                            EdgeInsets.only(left: 15, right: 15, bottom: 15),
                        child: TextFormField(
                          controller: _telephone,
                          decoration: InputDecoration(
                              icon: const Icon(Icons.control_point),
                              hintText: 'ระบุเบอร์โทรศัพท์',
                              labelText: 'ระบุเบอร์โทรศัพท์',
                              labelStyle: TextStyle(fontSize: 15)),
                          keyboardType: TextInputType.phone,
                          validator: (String value) {
                            if (value.trim().isEmpty) {
                              return "กรุณาระบุเบอร์โทรศัพท์";
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton.icon(
                      onPressed: onAddCustomer,
                      textColor: Colors.white,
                      color: Colors.brown[400],
                      icon: Icon(Icons.save),
                      label: new Text('ลงทะเบียน'),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
