import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import 'InfromAlert.dart';
import 'config.dart';
import 'dart:convert';

class InformCheckStatusPage extends StatefulWidget {
  int _dormId, _userId;
  String _userName, _roomNo;
  InformCheckStatusPage(
      int dormId, int userId, String userName, String roomNo) {
    this._dormId = dormId;
    this._userId = userId;
    this._userName = userName;
    this._roomNo = roomNo;
  }
  @override
  State<StatefulWidget> createState() {
    return new _InformCheckStatusPage(_dormId, _userId, _userName, _roomNo);
  }
}

class _InformCheckStatusPage extends State<InformCheckStatusPage> {
  int _dormId, _userId;
  String _userName, _roomNo;
  _InformCheckStatusPage(
      int dormId, int userId, String userName, String roomNo) {
    this._dormId = dormId;
    this._userId = userId;
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
  List lst = new List();

  @override
  void initState() {
    super.initState();
    _conApi();
  }

  void onSumit(String status) {
    http.post('${config.API_url}/fix/updateStatus', body: {
      "fixId": _fixId.toString(),
      "status": status.toLowerCase()
    }).then((respone) {
      Map jsonData = jsonDecode(respone.body) as Map;
      int status = jsonData['status'];
      if (status == 0) {
        lst.clear();
        _conApi();
        SweetAlert.show(context,
            subtitle: "สำเร็จ!",
            style: SweetAlertStyle.success, onPress: (bool isTrue) {
          if (isTrue) {
            Navigator.pop(context);
            Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        InformAlertPage(_dormId, _userId)));
            return false;
          }
        });
      }
    });
  }

  void onStatusChange(String item) {
    _selectedStatus = item;
    if (_selectedStatus == "กำลังดำเนินการ") {
      onSumit("active");
    } else {
      onSumit("success");
    }
  }

  void _conApi() {
    http.post('${config.API_url}/fix/listAll',
        body: {"dormId": _dormId.toString()}).then((response) {
      Map jsonData = jsonDecode(response.body);
      List temp = jsonData["data"];

      if (jsonData["status"] == 0) {
        for (int i = 0; i < temp.length; i++) {
          Map<String, dynamic> data = temp[i];
          setState(() {
            _fixId = data['fixId'];
            _date = data['dateTime'];
            _detail = data['fixDetail'];
            if (data['fixStatus'] == "active") {
              _selectedStatus = _Status.first;
            } else if (data['fixStatus'] == "success") {
              _selectedStatus = _Status[1];
            }
          });
          _body();
        }
      }
    });
  }

  void _body() {
    Container head = Container(
      child: new Row(
        children: <Widget>[
          new Icon(Icons.label_important),
          new Text('รายละเอียดการแจ้งซ่อม'),
        ],
      ),
    );

    Card body = Card(
      margin: EdgeInsets.all(0.5),
      child: new Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, top: 10),
            child: Row(
              children: <Widget>[
                new Container(
                  child: Text("ผู้เช่า :"),
                ),
                Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '${_userName}',
                      style: TextStyle(color: Colors.grey),
                    ))
              ],
            ),
          ),
          Row(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 20, right: 10, top: 10.0),
                child: Text("ห้อง :"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.only(right: 10, top: 10.0),
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
                padding: EdgeInsets.only(left: 20, right: 10, top: 10.0),
                child: Text("วันที่ :"),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.only(right: 10, top: 10.0),
                    child: Text(
                      '${_date.substring(0, 10)}',
                      style: TextStyle(color: Colors.grey),
                    )),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 20, right: 5, top: 10),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 20, right: 10, top: 10.0),
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
    );
    setState(() {
      lst.add(head);
      lst.add(body);
    });
  }

  Widget bodyBuild(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    //final screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('การแจ้งซ่อม'),
      ),
      body: new ListView.builder(
        padding: EdgeInsets.all(8),
        itemBuilder: bodyBuild,
        itemCount: lst.length,
      ),
    );
  }
}
