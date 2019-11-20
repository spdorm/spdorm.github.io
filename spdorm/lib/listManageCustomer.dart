import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import 'dart:convert';
import 'config.dart';
import 'DepositManage.dart';
import 'ListCustumer.dart';

class listManageCustumerPage extends StatefulWidget {
  int _dormId, _userId, _roomId;

  listManageCustumerPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  @override
  State<StatefulWidget> createState() {
    return new _listManageCustumerPage(_dormId, _userId, _roomId);
  }
}

class _listManageCustumerPage extends State<listManageCustumerPage> {
  int _dormId, _userId, _roomId, _roomDoc;
  String roomNo, roomPrice;

  _listManageCustumerPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  List lst = new List();
  String _FullName;
  int balance = 0, _paymentAmount = 0;

  @override
  void initState() {
    super.initState();
    _createLayout();
  }

  void _createLayout() {
    http.post('${config.API_url}/user/listUserForPledge',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;

      if (jsonData['status'] == 0) {
        List temp = jsonData['data'];

        if (temp.isNotEmpty) {
          for (int i = 0; i < temp.length; i++) {
            List data = temp[i];

            http.post('${config.API_url}/room/findByCustomerId',
                body: {"userId": data[0].toString()}).then((response) {
              // print(response.body);
              Map jsonData = jsonDecode(response.body) as Map;

              if (jsonData['status'] == 1) {
                http.post("${config.API_url}/payment/sumAmount", body: {
                  "userId": data[0].toString(),
                  "dormId": _dormId.toString()
                }).then((response) {
                  print(response.body);
                  Map jsonData = jsonDecode(response.body) as Map;

                  if (jsonData['status'] == 0) {
                    double temp = jsonData['data'];
                    _paymentAmount = temp.toInt();
                    _body(data);
                  } else {
                    _paymentAmount = 0;
                    _body(data);
                  }
                });
                // Map<String, dynamic> dataFromRoom = jsonData['data'];

                // if (jsonData['status'] == 0 && temp != null) {
                //   String roomNo = dataFromRoom['roomNo'];
                //   _body(data, roomNo);
                // }
              }
            });
          }
        }
      } else {
        _alert();
      }
    });
  }

  void _body(List data) {
    Padding news = Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${data[1]} ${data[2]}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.brown[400],
                        fontWeight: FontWeight.bold),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext) => depositManagementPage(
                                _dormId, data[0], _roomId)));
                  },
                  textColor: Colors.blueGrey[700],
                  child: new Row(
                    children: <Widget>[
                      Icon(Icons.payment),
                      new Text(' ชำระค่ามัดจำ'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'หมายเลขห้อง : ไม่มีห้องพัก',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.brown[300],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'ยอดเงินมัดจำสะสม : ${_paymentAmount}',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.brown[300],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          // Row(
          //   children: <Widget>[
          //     Text(
          //       'วันโพสต์ : ${(data['dateTime'].toString().substring(0, 10))}',
          //       style: TextStyle(color: Colors.grey),
          //     )
          //   ],
          // ),
          Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
    setState(() {
      lst.add(news);
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
        subtitle: "ไม่พบรายการชำระค่ามัดจำ!",
        style: SweetAlertStyle.error, onPress: (isTrue) {
      if (isTrue) {
        Navigator.of(context).pop();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext) =>  listCustumerPage(_dormId, _userId, _roomId)));
      }
      return false;
    });
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    lst.clear();
    setState(() {
      _createLayout();
    });
    return null;
  }

  Widget buildBody(BuildContext context, int index) {
    return lst[index];
  }

  final TextEditingController _multiLineTextFieldcontroller =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text('จัดการค่ามัดจำ'),
      ),
      body: RefreshIndicator(
        child: ListView.builder(
          itemBuilder: buildBody,
          itemCount: lst.length,
        ),
        onRefresh: _onRefresh,
      ),
    );
  }
}
