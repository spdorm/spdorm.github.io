import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';


class AddRoomPage extends StatefulWidget {
  int _dormId,_userId;
  String _numberRoom;
  AddRoomPage(int dormId,int userId, String numberRoom){
    this._dormId = dormId;
    this._userId = userId;
    this._numberRoom = numberRoom;
  }
  @override
  State<StatefulWidget> createState() {
    return new _AddRoomPage(_dormId,_userId,_numberRoom);
  }
}

class _AddRoomPage extends State<AddRoomPage> {
  int _dormId,_userId;
  String _numberRoom,roomNo,roomPrice;
  _AddRoomPage(int dormId,int userId, String numberRoom){
    this._dormId = dormId;
    this._userId = userId;
    this._numberRoom = numberRoom;
  }

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: new ListView(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20),
          children: <Widget>[
            new Card(
              margin: EdgeInsets.all(0.5),
              child: new Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: new Row(
                      children: <Widget>[
                        new Icon(Icons.label_important),
                        new Text('รายละเอียดการเพิ่มห้องพัก'),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
  }
}
