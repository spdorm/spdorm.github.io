import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'PaymentNotificationPage.dart';

class ListPaymentPage extends StatefulWidget {
  int _dormId, _userId, _roomId;
  ListPaymentPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _ListPaymentPage(_dormId, _userId, _roomId);
  }
}

class _ListPaymentPage extends State<ListPaymentPage> {
  int _dormId, _userId, _roomId;
  _ListPaymentPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  List<String> _Month = [
    "มกราคม",
    "กุมภาพันธุ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฏาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤษจิกายน",
    "ธันวาคม",
  ].toList();

  List lst = new List();

  var now = new DateTime.now();

  @override
  void initState() {
    super.initState();
    _head();
    AddCard();
  }

  void _head() {
    Container head = Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.label_important),
          new Text('รายการใบแจ้งชำระทั้งหมด'),
        ],
      ),
    );
    setState(() {
      lst.add(head);
    });
  }

  void AddCard() {
    http.post('${config.API_url}/invoice/list', body: {
      "dormId": _dormId.toString(),
      "userId": _userId.toString(),
      "roomId": _roomId.toString()
    }).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body);
      List temp = jsonData["data"];
      Color color;

      if (jsonData["status"] == 0) {
        for (int i = 0; i < temp.length; i++) {
          List data = temp[i];
          int _machineId = data[0];
          String _month = data[3];

          if (data[1].toString().substring(5, 6) == "0") {
            for (int j = 0; j < _Month.length; j++) {
              if (data[1].toString().substring(6, 7) == '${j}') {
                _month = _Month[j - 1];
              }
            }
          } else if (data[1].toString().substring(5, 6) == "1") {
            for (int i = 0; i < _Month.length; i++) {
              if ('${int.parse(data[1].toString().substring(5, 7)) - 1}' ==
                  '${i}') {
                _month = _Month[i];
              }
            }
          }
          String _dataShow =
              '${data[1].toString().substring(8, 10)} ${_month} ${data[1].toString().substring(0, 4)}';
              
          if (data[4] == "ยังไม่จ่าย") {
            color = Colors.red[200];
          } else {
            color = Colors.green[200];
          }

          Card cardNew = Card(
              color: color,
              child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => PaymentmultiLine(
                                _dormId,
                                _userId,
                                _roomId,
                                data[1],
                                _dataShow)));
                  },
                  padding: EdgeInsets.all(5),
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                    leading: Container(
                      padding: EdgeInsets.only(right: 12.0),
                      decoration: new BoxDecoration(
                          border: new Border(
                              right: new BorderSide(
                                  width: 1.0, color: Colors.black))),
                      child: Icon(Icons.monetization_on, color: Colors.black),
                    ),
                    title: Text(
                      '${data[1].toString().substring(8, 10)} ${_month} ${data[1].toString().substring(0, 4)}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    // subtitle: Row(
                    //   children: <Widget>[
                    //     Icon(Icons.linear_scale, color: Colors.yellowAccent),
                    //     Text(" Intermediate", style: TextStyle(color: Colors.black))
                    //   ],
                    // ),
                    // trailing: IconButton(
                    //     icon: Icon(Icons.clear, color: Colors.black),
                    //     onPressed: () {
                    //       SweetAlert.show(context,
                    //           subtitle: "คุณต้องการลบข้อมูล ?",
                    //           style: SweetAlertStyle.confirm,
                    //           showCancelButton: true,
                    //           onPress: (bool isConfirm) {
                    //         if (isConfirm) {
                    //           SweetAlert.show(context,
                    //               subtitle: "กำลังลบ...",
                    //               style: SweetAlertStyle.loading);
                    //           new Future.delayed(new Duration(seconds: 1), () {
                    //             http.post('${config.API_url}/machine/delete',
                    //                 body: {
                    //                   "dormId": _dormId.toString(),
                    //                   "machineId": '${_machineId}'
                    //                 }).then((respone) {
                    //               print(respone.body);
                    //               Map jsonData =
                    //                   jsonDecode(respone.body) as Map;
                    //               int status = jsonData["status"];
                    //               if (status == 0) {
                    //                 setState(() {
                    //                   lst.clear();
                    //                   _head();
                    //                   AddCard();
                    //                 });
                    //                 return SweetAlert.show(context,
                    //                     subtitle: "สำเร็จ!",
                    //                     style: SweetAlertStyle.success);
                    //               }
                    //             });
                    //           });
                    //         } else {
                    //           SweetAlert.show(context,
                    //               subtitle: "ยกเลิก!",
                    //               style: SweetAlertStyle.error);
                    //         }
                    //         // return false to keep dialog
                    //         return false;
                    //       });
                    //     }),
                  )));
          lst.add(cardNew);
          setState(() {});
        }
      }else{
       return  SweetAlert.show(context,
                      subtitle: "ไม่พบข้อมูลใบแจ้งชำระ",
                      style: SweetAlertStyle.error);
      }
    });
  }

  Future<Null> _onRefresh() async {
    //_key.currentState.show();
    await Future.delayed(Duration(seconds: 1));
    lst.clear();
    setState(() {
      _head();
      AddCard();
    });
    return null;
  }

  Widget widgetBuilder(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text('ใบแจ้งชำระทั้งหมด'),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
            itemBuilder: widgetBuilder,
            itemCount: lst.length,
          ),
        ));
  }
}
