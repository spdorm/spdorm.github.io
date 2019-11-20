import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import 'DataDepositManagement.dart';
import 'config.dart';
import 'dart:convert';
import 'DepositManage.dart';
import 'mainHomeFragment.dart';

class listManageCustumerAllPage extends StatefulWidget {
  int _dormId, _userId;
  listManageCustumerAllPage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _listManageCustumerAllPage(_dormId, _userId);
  }
}

class _listManageCustumerAllPage extends State {
  int _dormId, _userId;
  _listManageCustumerAllPage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }

  List lst = new List();
  String _FullName;
  int balance = 0, _paymentAmount = 0, _pledge = 0;
  bool check = false;

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
                body: {"userId": data[0].toString()}).then((response) async {
              // print(response.body);
              Map jsonData = jsonDecode(response.body) as Map;

              if (jsonData['status'] == 0) {
                Map<String, dynamic> dataFromRoom = jsonData['data'];

                var responsePayment = await http
                    .post("${config.API_url}/payment/sumAmount", body: {
                  "userId": dataFromRoom['customerId'].toString(),
                  "dormId": _dormId.toString()
                });
                // print(responsePayment.body);
                Map jsonDataPayment = jsonDecode(responsePayment.body) as Map;

                if (jsonDataPayment['status'] == 0) {
                  double temp = jsonDataPayment['data'];

                  _pledge = dataFromRoom['pledge'].toString().isEmpty
                      ? 0
                      : int.parse(dataFromRoom['pledge']);

                  _paymentAmount = temp.toInt();
                  check = false;
                  // roomNo = dataFromRoom['roomNo'];
                  // roomId = dataFromRoom['roomId'];
                  _body(data, dataFromRoom['roomNo'], dataFromRoom['roomId'],
                      _paymentAmount);
                }
              } else {
                var responsePayment = await http
                    .post("${config.API_url}/payment/sumAmount", body: {
                  "userId": data[0].toString(),
                  "dormId": _dormId.toString()
                });
                print(responsePayment.body);
                Map jsonDataPayment = jsonDecode(responsePayment.body) as Map;

                if (jsonDataPayment['status'] == 0) {
                  double temp = jsonDataPayment['data'];
                  int _total = temp.toInt();
                  check = true;
                  _body(data, "ไม่มีห้อง", 0, _total);
                } else {
                  check = true;
                  _body(data, "ไม่มีห้อง", 0, 0);
                }
              }
            });
          }
        }
      } else {
        _alert();
      }
    });
  }

  void _body(List data, String roomNo, int roomId, int amountTotal) {
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
                _pledge != _paymentAmount || check
                    ? FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => depositManagementPage(
                                      _dormId, data[0], roomId)));
                        },
                        textColor: Colors.blueGrey,
                        child: new Row(
                          children: <Widget>[
                            Icon(Icons.payment),
                            new Text(' ชำระค่ามัดจำ'),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(0),
                      ),
                _pledge == _paymentAmount && !check
                    ? FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => dataDepositManagePage(
                                      _dormId, data[0], roomId)));
                        },
                        textColor: Colors.red[300],
                        child: new Row(
                          children: <Widget>[
                            Icon(Icons.open_in_new),
                            new Text(' ออกหอพัก'),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(0),
                      )
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'หมายเลขห้อง : ${roomNo}',
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
                  'ยอดเงินมัดจำสะสม : ${amountTotal}',
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
                builder: (BuildContext) => MainHomeFragment(_dormId, _userId)));
      }
      return false;
    });
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    lst.clear();
    // _paymentAmount = 0;
    balance = 0;
    // _check = 0;
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
