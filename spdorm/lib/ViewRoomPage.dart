import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'ListCustumer.dart';
import 'PaymentNotification.dart';
import 'ViewDocument.dart';
import 'config.dart';
import 'dart:convert';
import 'package:sweetalert/sweetalert.dart';
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
  String roomNo, roomPrice, roomType, userFirstname, userLastname;

  _ViewRoomPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  List<String> _Status = [
    "ว่าง",
    "จอง",
    "ไม่ว่าง",
    "รายวัน",
    "ปิดปรับปรุง",
  ].toList();
  List<String> _Type = [
    "ห้องพัดลม",
    "ห้องแอร์",
  ].toList();

  // String _selectedMonth = null;
  bool check = false;
  String _selectedMonth, _selectedStatus, _selectType;
  List lst = new List();

  void onMonthChange(String item) {
    setState(() {
      _selectedMonth = item;
    });
  }

  void onStatusChange(String item) {
    setState(() {
      _selectedStatus = item;
      cardShow(1);
    });
  }

  void onTypeChange(String item) {
    setState(() {
      _selectType = item;
      cardShow(1);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedStatus = _Status.first;
    _selectType = _Type.first;

    http.post('${config.API_url}/room/listRoom', body: {
      "dormId": _dormId.toString(),
      "roomId": _roomId.toString()
    }).then((respone) async {
      print(respone.body);
      Map jsonData = jsonDecode(respone.body) as Map;
      Map<String, dynamic> listData = jsonData["data"];

      if (jsonData["status"] == 0) {
        roomNo = listData["roomNo"];
        roomPrice = listData["roomPrice"];
        roomType = listData["roomType"];
        _roomDoc = listData["customerId"];
        _selectedMonth = listData["roomFloor"];
        _selectedStatus = listData["roomStatus"];

        if (_roomDoc != 0) {
          var resUser = await http.post('${config.API_url}/user/list',
              body: {"userId": listData['customerId'].toString()});
          Map jsonDataUser = jsonDecode(resUser.body) as Map;

          if (jsonDataUser['status'] == 0) {
            Map<String, dynamic> dataUser = jsonDataUser['data'];
            userFirstname = dataUser["userFirstname"];
            userLastname = dataUser["userLastname"];
            check = true;
          } else {
            check = false;
          }
        }

        if (listData["roomStatus"] == "ว่าง") {
          _selectedStatus = _Status[0];
        } else if (listData["roomStatus"] == "จอง") {
          _selectedStatus = _Status[1];
        } else if (listData["roomStatus"] == "ไม่ว่าง") {
          _selectedStatus = _Status[2];
        } else if (listData["roomStatus"] == "รายวัน") {
          _selectedStatus = _Status[3];
        } else {
          _selectedStatus = _Status[4];
        }

        if (listData["roomType"] == "ห้องพัดลม") {
          _selectType = _Type[0];
        } else {
          _selectType = _Type[1];
        }
        cardShow(0);
      }
    });
  }

  void cardShow(int state) {
    Card show = Card(
      margin: EdgeInsets.all(0.5),
      child: new Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: new Row(
              children: <Widget>[
                new Text(
                  'รายละเอียดห้องพัก',
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
                  "หมายเลขห้องพัก :",
                  style: TextStyle(color: Colors.blueGrey[700]),
                ),
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
                child: Text(
                  "ราคาห้องพัก :",
                  style: TextStyle(color: Colors.blueGrey[700]),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.only(right: 10, top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          '${roomPrice} บาท',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )),
              ),
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
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                    padding: EdgeInsets.only(right: 10, top: 20.0),
                    child: Text(
                      '${roomType}',
                      style: TextStyle(color: Colors.grey),
                    )),
              ),
              // new DropdownButton<String>(
              //     value: _selectType,
              //     items: _Type.map((String dropdownValue) {
              //       return new DropdownMenuItem(
              //           value: dropdownValue,
              //           child: new Text(
              //             dropdownValue,
              //             style: TextStyle(color: Colors.black54),
              //           ));
              //     }).toList(),
              //     onChanged: (String value) {
              //       onTypeChange(value);
              //     }),
            ],
          ),
          Divider(
            color: Colors.grey,
            indent: 10.0,
            endIndent: 10.0,
          ),
          Row(
            children: <Widget>[
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
                          style: TextStyle(color: Colors.black54),
                        ));
                  }).toList(),
                  onChanged: (String value) {
                    onStatusChange(value);
                  }),
            ],
          ),
          check
              ? Row(
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                      child: Text(
                        "ชื่อลูกค้า :",
                        style: TextStyle(color: Colors.blueGrey[700]),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Container(
                          padding: EdgeInsets.only(right: 10, top: 20.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '${userFirstname} ${userLastname}',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          )),
                    ),
                  ],
                )
              : Padding(
                  padding: EdgeInsets.all(0),
                ),
          Row(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "ใบสัญญาเช่า :",
                  style: TextStyle(color: Colors.blueGrey[700]),
                ),
              ),
              Column(
                children: <Widget>[
                  _roomDoc != 0
                      ? FlatButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext) => vieWDocument(
                                          _dormId,
                                          _roomId,
                                        )));
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
                                    builder: (BuildContext) => listCustumerPage(
                                        _dormId, _userId, _roomId)));
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
          _roomDoc != 0
              ? Row(
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
              : Padding(
                  padding: EdgeInsets.all(0),
                ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                onPressed: onSumit,
                textColor: Colors.white,
                color: Colors.brown[400],
                child: new Row(
                  children: <Widget>[
                    new Text('ตกลง'),
                  ],
                ),
              ),
              _roomDoc == 0
                  ? Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: new RaisedButton(
                        onPressed: onDelete,
                        textColor: Colors.white,
                        color: Colors.brown[200],
                        child: new Row(
                          children: <Widget>[
                            new Text('ลบ'),
                          ],
                        ),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.all(0.0),
                    )
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
    );
    if (state == 1) {
      lst.removeLast();
      setState(() {
        lst.add(show);
      });
    } else {
      setState(() {
        lst.add(show);
      });
    }
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
      Map jsonData = jsonDecode(respone.body) as Map;
      int status = jsonData['status'];
      if (status == 0) {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext) => MainHomeFragment(_dormId, _userId)));
      }
    });
  }

  void onDelete() {
    return SweetAlert.show(context,
        subtitle: "คุณต้องการลบห้องใช่หรือไม่ ?",
        style: SweetAlertStyle.confirm,
        showCancelButton: true, onPress: (bool isConfirm) {
      if (isConfirm) {
        SweetAlert.show(context,
            subtitle: "กำลังลบ...", style: SweetAlertStyle.loading);
        new Future.delayed(new Duration(seconds: 1), () {
          http.post('${config.API_url}/room/deleteRoom', body: {
            "dormId": _dormId.toString(),
            "userId": _userId.toString(),
            "roomId": _roomId.toString()
          }).then((response) {
            Map jsonData = jsonDecode(response.body);
            int status = jsonData["status"];
            if (status == 0) {
              // Navigator.pop(context);
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext) => MainHomeFragment(_dormId, _userId)));
              SweetAlert.show(context,
                  subtitle: "สำเร็จ!",
                  style: SweetAlertStyle.success, onPress: (bool isConfirm) {
                if (isConfirm) {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext) =>
                              MainHomeFragment(_dormId, _userId)));
                }
                return false;
              });
            }
          });
        });
      } else {
        SweetAlert.show(context,
            subtitle: "ยกเลิก!", style: SweetAlertStyle.error);
      }
      // return false to keep dialog
      return false;
    });
  }

  Widget bodyBuild(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    //final screenSize = MediaQuery.of(context).size;
    return new Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text('รายละเอียดห้องพัก'),
      ),
      body: new ListView.builder(
        padding: EdgeInsets.all(8),
        itemBuilder: bodyBuild,
        itemCount: lst.length,
      ),
    );
  }
}
