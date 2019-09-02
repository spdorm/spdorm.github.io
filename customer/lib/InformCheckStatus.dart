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

  List<String> _Status = ["รอดำเนินการ", "ดำเนินการแล้ว"].toList();

  // String _selectedStatus = null;
  String _selectedStatus;
  String _date, _detail;
  int _fixId;
  Color color;
  List lst = List();

  @override
  void initState() {
    super.initState();
    http.post('${config.API_url}/fix/listAll',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body);
      List temp = jsonData["data"];

      if (jsonData["status"] == 0 && jsonData["data"].isNotEmpty) {
        Map<String, dynamic> data = temp[0];
        setState(() {
          _fixId = data['fixId'];
          _date = data['dateTime'].toString().substring(8, 10) +
              data['dateTime'].toString().substring(4, 7) +
              "-" +
              data['dateTime'].toString().substring(0, 4);
          _detail = data['fixDetail'];

          if (data['fixStatus'] == "active") {
            _selectedStatus = _Status.first;
            color = Colors.red;
          } else if (data['fixStatus'] == "success") {
            _selectedStatus = _Status[1];
            color = Colors.green;
          }

          _body();
        });
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
    lst.add(head);
    Card body = Card(
      child: new Column(
        children: <Widget>[
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
                padding:
                    EdgeInsets.only(left: 20, right: 5, bottom: 20, top: 20),
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
        ],
      ),
    );
    lst.add(body);
    Container status = Container(
      margin: EdgeInsets.only(top: 5),
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'สถานะ : ',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              ' ${_selectedStatus}',
              style: TextStyle(fontSize: 20, color: color),
            ),
          ],
        ),
      ),
    );
    lst.add(status);
    setState(() {});
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
        ));
  }
}
