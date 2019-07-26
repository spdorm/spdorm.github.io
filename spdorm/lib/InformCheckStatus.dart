import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';

class InformCheckStatusPage extends StatefulWidget {
  int _dormId;
  String _userName, _roomNo;
  InformCheckStatusPage(int dormId, String userName, String roomNo) {
    this._dormId = dormId;
    this._userName = userName;
    this._roomNo = roomNo;
  }
  @override
  State<StatefulWidget> createState() {
    return new _InformCheckStatusPage(_dormId, _userName, _roomNo);
  }
}

class _InformCheckStatusPage extends State<InformCheckStatusPage> {
  int _dormId;
  String _userName, _roomNo;
  _InformCheckStatusPage(int dormId, String userName, String roomNo) {
    this._dormId = dormId;
    this._userName = userName;
    this._roomNo = roomNo;
  }
  //TextEditingController _roomNo = TextEditingController();
  //TextEditingController _roomPrice = TextEditingController();
  var _image;

  String dropdownStatusValue;
  String dropdownValue;

  List<String> _Status = ["กำลังดำเนินการ", "ดำเนินการแล้ว"].toList();

  // String _selectedStatus = null;
  String _selectedStatus;
  String _date, _detail;
  int _fixId;

  @override
  void initState() {
    super.initState();
    http.post('${config.API_url}/fix/listAll',
        body: {"dormId": _dormId.toString()}).then((response) {
      Map jsonData = jsonDecode(response.body);
      List temp = jsonData["data"];

      if (jsonData["status"] == 0) {
        for (int i = 0; i < temp.length; i++) {
          List data = temp[i];
          setState(() {
            _fixId = data[0];
            _date = data[1];
            _detail = data[3];
            if (data[4] == "active") {
              _selectedStatus = _Status.first;
            } else if (data[4] == "success") {
              _selectedStatus = _Status[1];
            }
          });
        }
      }
    });
  }

  void onSumit(String status) {
    http.post('${config.API_url}/fix/updateStatus', body: {
      "fixId": _fixId.toString(),
      "status": status.toLowerCase()
    }).then((respone) {
      print(respone.body);
      Map jsonData = jsonDecode(respone.body) as Map;
      int status = jsonData['status'];
      if (status == 0) {
        print("OK");
      }
    });
  }

  void onStatusChange(String item) {
      setState(() {
        _selectedStatus = item;        
      });
      if (_selectedStatus == "กำลังดำเนินการ") {
          onSumit("active");
          
        } else {
          onSumit("success");
          print("OK");
        }
    }

  @override
  Widget build(BuildContext context) {
    //final screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('การแจ้งซ่อม'),
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
                      new Text('รายละเอียดการแจ้งซ่อม'),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                      child: Text("ผู้เช่า :"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                          padding: EdgeInsets.only(right: 10, top: 20.0),
                          child: Text(
                            '${_userName}',
                            style: TextStyle(color: Colors.grey),
                          )),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                      child: Text("ห้อง :"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                          padding: EdgeInsets.only(right: 10, top: 20.0),
                          child: Text(
                            '${_roomNo}',
                            style: TextStyle(color: Colors.grey),
                          )),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                      child: Text("วันที่ :"),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                          padding: EdgeInsets.only(right: 10, top: 20.0),
                          child: Text(
                            '${_date}',
                            style: TextStyle(color: Colors.grey),
                          )),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 20, right: 5),
                      child: Text("รายละเอียดรายการ :"),
                    ),
                    Container(
                      //padding: EdgeInsets.only(right: 10, top: 20.0),
                      child: Expanded(
                        child: Text(
                          '${_detail}',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
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
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: <Widget>[
                //     new RaisedButton(
                //       onPressed: onSumit,
                //       textColor: Colors.white,
                //       color: Colors.green,
                //       child: new Row(
                //         children: <Widget>[
                //           new Text('บันทึก'),
                //         ],
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
