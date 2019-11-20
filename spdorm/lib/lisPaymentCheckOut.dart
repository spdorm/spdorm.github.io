import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'payMentNotiCheckOut.dart';
import 'ConvertDateTime.dart';

class ListPaymentCheckOutPage extends StatefulWidget {
  int _dormId, _roomId, _customerId;
  ListPaymentCheckOutPage(int dormId, int customerId, int roomId) {
    this._dormId = dormId;
    this._roomId = roomId;
    this._customerId = customerId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _ListPaymentCheckOutPage(_dormId, _customerId, _roomId);
  }
}

class _ListPaymentCheckOutPage extends State<ListPaymentCheckOutPage> {
  int _dormId, _roomId, _customerId;
  _ListPaymentCheckOutPage(int dormId, int customerId, int roomId) {
    this._dormId = dormId;
    this._roomId = roomId;
    this._customerId = customerId;
  }

  List<String> _Month = [
    "มกราคม",
    "กุมภาพันธ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฎาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤศจิกายน",
    "ธันวาคม",
  ].toList();

  List lst = new List();
  String _dataShow = "";

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
          new Text(' รายการล่าสุด',style: TextStyle(color: Colors.grey[500]),),
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
      "userId": _customerId.toString(),
      "roomId": _roomId.toString()
    }).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body);
      List temp = jsonData["data"];
      Color color;

      if (jsonData["status"] == 0 && temp.isNotEmpty) {
        for (int i = 0; i < temp.length; i++) {
          List data = temp[i];
          convertDateTime _dateTimeToThai = convertDateTime();
          // String _month = "";

          // if (data[1].toString().substring(5, 6) == "0") {
          //   for (int j = 0; j < _Month.length; j++) {
          //     if (data[1].toString().substring(6, 7) == '${j}') {
          //       _month = _Month[j - 1];
          //     }
          //   }
          // } else if (data[1].toString().substring(5, 6) == "1") {
          //   for (int i = 0; i < _Month.length; i++) {
          //     if ('${int.parse(data[1].toString().substring(5, 7)) - 1}' ==
          //         '${i}') {
          //       _month = _Month[i];
          //     }
          //   }
          // }
          // String _dataShow =
          //     '${data[1].toString().substring(8, 10)} ${_month} ${data[1].toString().substring(0, 4)}';
          _dataShow = _dateTimeToThai.convertToThai(data[1]);

          if (data[3] == "ยังไม่จ่าย") {
            color = Colors.red[200];
          } else {
            color = Colors.grey[350];
          }

          Card cardNew = Card(
              color: color,
              child: FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PaymentNotiCheckOutPage(
                                    data[0], '${data[13]} ${data[14]}')));
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
                      child: Icon(Icons.monetization_on, color: Colors.white),
                    ),
                    title: Text(
                      _dataShow,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                    // subtitle: Row(
                    //   children: <Widget>[
                    //     Icon(Icons.linear_scale, color: Colors.yellowAccent),
                    //     Text(" Intermediate", style: TextStyle(color: Colors.black))
                    //   ],
                    // ),

                    trailing: IconButton(
                        icon: Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          SweetAlert.show(context,
                              title: "คำเตือน",
                              subtitle: "หากลบแล้วไม่สามารถกู้คืนได้",
                              style: SweetAlertStyle.confirm,
                              showCancelButton: true,
                              onPress: (bool isConfirm) {
                            if (isConfirm) {
                              SweetAlert.show(context,
                                  subtitle: "กำลังลบ...",
                                  style: SweetAlertStyle.loading);
                              new Future.delayed(new Duration(seconds: 1), () {
                                http.post(
                                    '${config.API_url}/invoice/deleteInvoice',
                                    body: {
                                      "invoiceId": data[0].toString()
                                    }).then((respone) {
                                  Map jsonData =
                                      jsonDecode(respone.body) as Map;
                                  int status = jsonData["status"];
                                  if (status == 0) {
                                    setState(() {
                                      lst.clear();
                                      _head();
                                      AddCard();
                                    });
                                    return SweetAlert.show(context,
                                        subtitle: "สำเร็จ!",
                                        style: SweetAlertStyle.success);
                                  }
                                });
                              });
                            } else {
                              SweetAlert.show(context,
                                  subtitle: "ยกเลิก!",
                                  style: SweetAlertStyle.error);
                            }
                            // return false to keep dialog
                            return false;
                          });
                        }),
                  )));
          lst.add(cardNew);
          setState(() {});
        }
      } else {
        _alert();
      }
    });
  }

  void _alert() {
    // Container alert = Container(
    //   margin: EdgeInsets.only(top: 500),
    //   child: Text('ไม่พบข้อมูลผู้ขอเข้าพัก'),
    // );
    // setState(() {
    //   lst.add(alert);
    // });

    SweetAlert.show(context,
        subtitle: "ไม่พบข้อมูลใบแจ้งชำระ!", style: SweetAlertStyle.error);
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
        backgroundColor: Colors.grey[300],
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.red[300],
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
