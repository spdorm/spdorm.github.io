import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'package:sweetalert/sweetalert.dart';
import 'mainHomeFragment.dart';

class AddRoomPage extends StatefulWidget {
  int _dormId, _userId;
  String _floor;

  AddRoomPage(int dormId, int userId, String floor) {
    this._dormId = dormId;
    this._userId = userId;
    this._floor = floor;
    print(_floor);
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
  TextEditingController _pledge = TextEditingController();

  List<String> _Status = [
    "ว่าง",
    "จอง",
    "รายวัน",
    "ไม่ว่าง",
    "ปิดปรับปรุง",
  ].toList();
  List<String> _Type = [
    "ห้องพัดลม",
    "ห้องแอร์",
  ].toList();

  // String _selectedMonth = null;
  String _selectedMonth, _selectedStatus, _selectType, _errorMassage = "";

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
      "pledge": _pledge.text,
      "roomStatus": _selectedStatus,
      "roomType": _selectType,
    }).then((respone) {
      print(respone.body);
      Map jsonData = jsonDecode(respone.body) as Map;
      int status = jsonData['status'];
      if (status == 0) {
        _errorMassage = "";
        SweetAlert.show(context,
            title: "สำเร็จ!",
            subtitle: "เพิ่มห้องพักเรียบร้อยแล้ว",
            style: SweetAlertStyle.success, onPress: (isTrue) {
          if (isTrue) {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext) =>
                        MainHomeFragment(_dormId, _userId)));
          }
          return false;
        });
      } else {
        setState(() {
          _errorMassage = jsonData['message'];
        });
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
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.red[300],
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
                      new Text(
                        'รายละเอียดการเพิ่มห้องพัก',
                        style: TextStyle(color: Colors.blueGrey[700]),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                      child: Text(
                        "ชั้น :",
                        style: TextStyle(color: Colors.blueGrey[700]),
                      ),
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
                      padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                      child: Text(
                        "สถานะ :",
                        style: TextStyle(color: Colors.blueGrey[700]),
                      ),
                    ),
                    new DropdownButton<String>(
                        value: _selectedStatus,
                        items: _Status.map((String dropdownStatusValue) {
                          return new DropdownMenuItem(
                              value: dropdownStatusValue,
                              child: new Text(
                                dropdownStatusValue,
                                style: TextStyle(color: Colors.blueGrey[700]),
                              ));
                        }).toList(),
                        onChanged: (String value) {
                          onStatusChange(value);
                        }),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                      child: Text(
                        "ประเภทห้องพัก :",
                        style: TextStyle(color: Colors.blueGrey[700]),
                      ),
                    ),
                    new DropdownButton<String>(
                        value: _selectType,
                        items: _Type.map((String dropdownValue) {
                          return new DropdownMenuItem(
                              value: dropdownValue,
                              child: new Text(
                                dropdownValue,
                                style: TextStyle(color: Colors.blueGrey[700]),
                              ));
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
                _errorMassage != ""
                    ? Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Text(_errorMassage,
                            style: TextStyle(color: Colors.red)),
                      )
                    : Padding(
                        padding: EdgeInsets.all(0.0),
                      ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: _roomPrice,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.control_point),
                        labelText: 'ราคาห้องพัก :',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.number,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: _pledge,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.control_point),
                        labelText: 'ค่าประกัน :',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.number,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: onSumit,
                      textColor: Colors.white,
                      color: Colors.brown[400],
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
