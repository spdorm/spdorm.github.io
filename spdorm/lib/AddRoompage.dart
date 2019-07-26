import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';

import 'mainHomeFragment.dart';

class AddRoomPage extends StatefulWidget {
  int _dormId, _userId;
  String _floor;

  AddRoomPage(int dormId, int userId, String floor) {
    this._dormId = dormId;
    this._userId = userId;
    this._floor = floor;
  }
  @override
  State<StatefulWidget> createState() {
    return new _AddRoomPage(_dormId, _userId, _floor);
  }
}

String dropdownStatusValue = 'ว่าง';
String dropdownValue = 'ห้องพัดลม';

class _AddRoomPage extends State<AddRoomPage> {
  int _dormId, _userId;
  String _floor, roomNo = "", roomPrice;
  _AddRoomPage(int dormId, int userId, String floor) {
    this._dormId = dormId;
    this._userId = userId;
    this._floor = floor;
  }
  TextEditingController _roomNo = TextEditingController();
  TextEditingController _roomPrice = TextEditingController();

  List<String> _Status = [
    "ว่าง",
    "ไม่ว่าง",
  ].toList();
  List<String> _Type = [
    "ห้องพัดลม",
    "ห้องแอร์",
  ].toList();

  // String _selectedMonth = null;
  String _selectedMonth, _selectedStatus, _selectType;

  @override
  void initState() {
    super.initState();
    _selectedMonth = _floor;
    _selectedStatus = _Status.first;
    _selectType = _Type.first;
  }

  void onSumit() {
    http.post('${config.API_url}/room/add', body: {
      "dormId": _dormId.toString(),
      "userId": _userId.toString(),
      "roomDocument": '',
      "roomFloor": _selectedMonth,
      "roomNo": _roomNo.text,
      "roomPrice": _roomPrice.text,
      "roomStatus": "ว่าง",
      "roomType": _selectType
    }).then((respone) {
      print(respone.body);
      Map jsonData = jsonDecode(respone.body) as Map;
      int status = jsonData['status'];
      if (status == 0) {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext) => MainHomeFragment(_dormId, _userId)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //final screenSize = MediaQuery.of(context).size;

    void onMonthChange(String item) {
      setState(() {
        _selectedMonth = item;
        print(_selectedMonth);
      });
    }

    void onStatusChange(String item) {
      setState(() {
        _selectedStatus = item;
        print(_selectedStatus);
      });
    }

    void onTypeChange(String item) {
      setState(() {
        _selectType = item;
        print(_selectType);
      });
    }

    return new Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
          title: Text('เพิ่มห้องพัก'),
        ),
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
                  Row(
                    children: <Widget>[
                      new Container(
                        padding:
                            EdgeInsets.only(left: 20, right: 10, top: 20.0),
                        child: Text("ชั้น :"),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Container(
                            padding: EdgeInsets.only(right: 10, top: 20.0),
                            child: Text(
                              '${_selectedMonth}',
                              style: TextStyle(color: Colors.grey),
                            )),
                      ),
                      new Container(
                        padding:
                            EdgeInsets.only(left: 20, right: 10, top: 20.0),
                        child: Text("สถานะ :"),
                      ),
                      new DropdownButton<String>(
                          value: _selectedStatus,
                          items: _Status.map((String dropdownStatusValue) {
                            return new DropdownMenuItem(
                                value: dropdownStatusValue,
                                child: new Text(dropdownStatusValue));
                          }).toList(),
                          onChanged: (String value) {
                            onStatusChange(value);
                          }),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      new Container(
                        padding:
                            EdgeInsets.only(left: 20, right: 10, top: 20.0),
                        child: Text("ประเภทห้องพัก :"),
                      ),
                      new DropdownButton<String>(
                          value: _selectType,
                          items: _Type.map((String dropdownValue) {
                            return new DropdownMenuItem(
                                value: dropdownValue,
                                child: new Text(dropdownValue));
                          }).toList(),
                          onChanged: (String value) {
                            onTypeChange(value);
                          }),
                    ],
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      controller: _roomNo,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: '${roomNo}',
                          labelText: 'หมายเลขห้อง :',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      controller: _roomPrice,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: '${roomPrice}',
                          labelText: 'ราคาห้องพัก :',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new RaisedButton(
                        onPressed: onSumit,
                        textColor: Colors.white,
                        color: Colors.green,
                        child: new Row(
                          children: <Widget>[
                            new Text('บันทึก'),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      );
  }
}
