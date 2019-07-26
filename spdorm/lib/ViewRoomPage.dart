import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:http/http.dart' as http;
import 'AddCharterDorm_fragment.dart';
import 'PaymentNotification.dart';
import 'ViewDocument.dart';
import 'config.dart';
import 'dart:convert';

import 'mainHomeFragment.dart';

class ViewRoomPage extends StatefulWidget {
  int _dormId, _userId, _roomId;

  ViewRoomPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  @override
  State<StatefulWidget> createState() {
    return new _ViewRoomPage(_dormId, _userId, _roomId);
  }
}

String dropdownStatusValue = 'ว่าง';
String dropdownValue = 'ห้องพัดลม';

class _ViewRoomPage extends State<ViewRoomPage> {
  int _dormId, _userId, _roomId, _roomDoc;
  String roomNo, roomPrice;

  _ViewRoomPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

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
    _selectedStatus = _Status.first;
    _selectType = _Type.first;

    http.post('${config.API_url}/room/listRoom', body: {
      "dormId": _dormId.toString(),
      "roomId": _roomId.toString()
    }).then((respone) {
      print(respone.body);
      Map jsonData = jsonDecode(respone.body) as Map;
      Map<String, dynamic> listData = jsonData["data"];

      if (jsonData["status"] == 0) {
        roomNo = listData["roomNo"];
        roomPrice = listData["roomPrice"];
        _roomDoc = listData["customerId"];
        _selectedMonth = listData["roomFloor"];
        _selectedStatus = listData["roomStatus"];
        if (listData["roomStatus"] == "ว่าง") {
          _selectedStatus = _Status[0];
        } else {
          _selectedStatus = _Status[1];
        }

        if (listData["roomType"] == "ห้องพัดลม") {
          _selectType = _Type[0];
        } else {
          _selectType = _Type[1];
        }
        setState(() {});
      }
    });
  }

  void onSumit() {
    http.post('${config.API_url}/room/updateRoom', body: {
      "roomId": _roomId.toString(),
      "doc": '',
      "floor": _selectedMonth,
      "no": roomNo.toString(),
      "price": roomPrice.toString(),
      "status": _selectedStatus,
      "type": _selectType
    }).then((respone) {
      print(respone.body);
      Map jsonData = jsonDecode(respone.body) as Map;
      int status = jsonData['status'];
      print(status);
      if (status == 0) {
        Navigator.pop(context);
      }
    });
  }

  void onDelete() {
    http.post('${config.API_url}/room/deleteRoom', body: {
      "dormId": _dormId.toString(),
      "userId": _userId.toString(),
      "roomId": _roomId.toString()
    }).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body);
      int status = jsonData["status"];
      if (status == 0) {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext)=>MainHomeFragment(_dormId, _userId)));
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
      appBar: AppBar(
        title: Text('รายละเอียดห้องพัก'),
      ),
      body: new ListView(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                      new Text('รายละเอียดห้องพัก'),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
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
                      padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                      child: Text("หมายเลขห้องพัก :"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                          padding: EdgeInsets.only(right: 10, top: 20.0),
                          child: Text(
                            '${roomNo}',
                            style: TextStyle(color: Colors.grey),
                          )),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                      child: Text("ราคาห้องพัก :"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                          padding: EdgeInsets.only(right: 10, top: 20.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '${roomPrice}',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text("    บาท"),
                            ],
                          )),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                      child: Text("สถานะ :"),
                    ),
                    new DropdownButton<String>(
                        value: _selectedStatus,
                        items: _Status.map((String dropdownStatusValue) {
                          return new DropdownMenuItem(
                              value: dropdownStatusValue,
                              child: new Text(
                                dropdownStatusValue,
                                style: TextStyle(color: Colors.black54),
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
                      child: Text("ประเภทห้องพัก :"),
                    ),
                    new DropdownButton<String>(
                        value: _selectType,
                        items: _Type.map((String dropdownValue) {
                          return new DropdownMenuItem(
                              value: dropdownValue,
                              child: new Text(
                                dropdownValue,
                                style: TextStyle(color: Colors.black54),
                              ));
                        }).toList(),
                        onChanged: (String value) {
                          onTypeChange(value);
                        }),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("ใบสัญญาเช่า :"),
                    ),
                    Column(
                      children: <Widget>[
                        _roomDoc != 0
                            ? FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext) =>
                                              vieWDocument(_dormId, _roomId)));
                                },
                                textColor: Colors.orangeAccent,
                                child: new Row(
                                  children: <Widget>[
                                    Icon(Icons.remove_red_eye),
                                    new Text(' ข้อมูลใบสัญญาเช่า'),
                                  ],
                                ),
                              )
                            : FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext) =>
                                              CharterDormFragment(
                                                  _roomId, roomNo)));
                                },
                                textColor: Colors.green,
                                child: new Row(
                                  children: <Widget>[
                                    Icon(Icons.add),
                                    new Text(' เพิ่มใบสัญญาเช่า'),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
                _roomDoc != 0?
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 20),
                      child: Text("ใบแจ้งชำระรายเดือน :"),
                    ),
                    FlatButton(
                      padding: EdgeInsets.only(left: 5),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext) => PaymentNotification(
                                    _dormId, _userId, _roomId)));
                      },
                      textColor: Colors.green,
                      child: new Row(
                        children: <Widget>[
                          Icon(Icons.add),
                          new Text(' เพิ่มใบแจ้งชำระเงิน'),
                        ],
                      ),
                    ),
                  ],
                )
                : Padding(padding: EdgeInsets.all(0),),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton(
                      onPressed: onSumit,
                      textColor: Colors.white,
                      color: Colors.lightGreen,
                      child: new Row(
                        children: <Widget>[
                          new Text('ตกลง'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                    ),
                    new RaisedButton(
                      onPressed: onDelete,
                      textColor: Colors.white,
                      color: Colors.redAccent,
                      child: new Row(
                        children: <Widget>[
                          new Text('ลบ'),
                        ],
                      ),
                    ),
                  ],
                ),
//                  Padding(
//                    padding: EdgeInsets.only(left: 100, top: 5, right: 110),
//                    child: new RaisedButton(
//                      onPressed: (){
//                        Navigator.pop(context);
//                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext) => HomeFragment(_dormId,_userId)));
//                      },
//                      textColor: Colors.white,
//                      color: Colors.blueGrey,
//                      child: new Row(
//                        children: <Widget>[
//                          new Text('กลับสู่หน้าหลัก'),
//                        ],
//                      ),
//                    ),
//                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
