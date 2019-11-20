import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import 'dart:convert';
import 'config.dart';


class viewPaymentCheckOutPage extends StatefulWidget {
  int _dormId, _userId, _roomId;
  String _date, _dateShow;
  viewPaymentCheckOutPage(
      int dormId, int userId, int roomId, String date, String dateShow) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
    this._date = date;
    this._dateShow = dateShow;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _viewPaymentCheckOutPage(_dormId, _userId, _roomId, _date, _dateShow);
  }
}

class _viewPaymentCheckOutPage extends State {
  int _dormId, _userId, _roomId;
  String _date, _dateShow;
  _viewPaymentCheckOutPage(
      int dormId, int userId, int roomId, String date, String dateShow) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
    this._date = date;
    this._dateShow = dateShow;
  }

  final TextEditingController _multiLineTextFieldcontroller =
      TextEditingController();

  String _name, _roomNo, _price;
  List lst = new List();

  @override
  void initState() {
    http.post('${config.API_url}/invoice/list', body: {
      "dormId": _dormId.toString(),
      "userId": _userId.toString(),
      "roomId": _roomId.toString()
    }).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      List temp = jsonData['data'];
      if (jsonData['status'] == 0) {
        for (int i = 0; i < temp.length; i++) {
          List dataPay = temp[i];
          Color color;

          if (_date == dataPay[1]) {
            if (dataPay[3] == "ยังไม่จ่าย") {
              color = Colors.red;
            } else {
              color = Colors.green;
            }
            _name = dataPay[13] + "  " + dataPay[14];

            Container head = Container(
              padding: EdgeInsets.only(left: 5, right: 5, top: 5),
              child: new Row(
                children: <Widget>[
                  new Icon(
                    Icons.layers,
                    color: Colors.pink,
                  ),
                  new Text(' รายละเอียดใบแจ้งชำออกหอพัก'),
                ],
              ),
            );
            setState(() {
              lst.add(head);
            });

            Container detil = Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text('ชื่อ : ${null}'),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text('ห้อง : ${null}'),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text('วันที่ : ${null}'),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text('ค่าประกัน : ${null}  บาท'),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text('ค่าน้ำ : ${null}  บาท'),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text('ค่าไฟฟ้า : ${null} บาท'),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text('ค่าซ่อม : ${null}  บาท'),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text('ค่าอื่น ๆ : ${null}  บาท'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text('รวมทั้งหมด : ${null}  บาท'),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          'สถานะ :',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          '${null}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: color),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
            setState(() {
              lst.add(detil);
            });
          }
        }
      }
    });
    super.initState();
  }

  Widget bodyBuild(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {  
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[300],
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text('ใบแจ้งชำระออกหอพัก'),
        ),
        body: ListView.builder(
          itemBuilder: bodyBuild,
          itemCount: lst.length,
        ));
  }
}
