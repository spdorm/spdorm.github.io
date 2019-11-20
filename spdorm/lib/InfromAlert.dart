import 'package:flutter/material.dart';
import 'DataInform.dart';
import 'InformCheckStatus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'package:sweetalert/sweetalert.dart';
import 'mainHomeFragment.dart';

class InformAlertPage extends StatefulWidget {
  int _dormId, _userId;
  InformAlertPage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _InformAlertPage(_dormId, _userId);
  }
}

class _InformAlertPage extends State<InformAlertPage> {
  int _dormId, _userId;
  _InformAlertPage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }

  List lst = new List();
  var now = new DateTime.now();

  @override
  void initState() {
    super.initState();
    btHistory();
    _createLayout();
  }

  void btHistory() {
    Container button = Container(
      margin: EdgeInsets.only(top: 10),
      child: Center(
        child: RaisedButton.icon(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DataInfromPage(_dormId)));
          },
          icon: Icon(Icons.remove_red_eye, color: Colors.white),
          label: Text(
            'ประวัติรายการทั้งหมด',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.brown[400],
        ),
      ),
    );
    setState(() {
      lst.add(button);
    });
  }

  void _createLayout() {
    Container head = Container(
      child: new Row(
        children: <Widget>[
          new Text(
            ' รายการล่าสุด',
            style: TextStyle(color: Colors.blueGrey[700]),
          ),
        ],
      ),
    );
    lst.add(head);

//###################################################################################
    http.post('${config.API_url}/fix/listAll',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body);

      if (jsonData["status"] == 0) {
        List temp = jsonData["data"];

        if (temp.isNotEmpty) {
          for (int i = 0; i < temp.length; i++) {
            Map<String, dynamic> data = temp[i];
            Color color;
            Icon icon;
            // String status;
            int fixId = data['fixId'];

            if (data['fixStatus'] == "active") {
              color = Colors.grey[200];
              // status = "รอดำเนินการ";
              icon = Icon(Icons.hourglass_empty);
            } else if (data['fixStatus'] == "success") {
              color = Colors.grey[200];
              // status = "ดำเนินการแล้ว";
              icon = Icon(
                Icons.check,
                color: Colors.green[300],
              );
            }

            http.post('${config.API_url}/user/list', body: {
              "userId": data['userId'].toString()
            }).then((response) async {
              // print(response.body);
              Map jsonData = jsonDecode(response.body);
              Map<String, dynamic> userDataMap = jsonData['data'];

              if (jsonData['status'] == 0) {
                await http.post('${config.API_url}/room/listRoom', body: {
                  "dormId": data['dormId'].toString(),
                  "roomId": data['roomId'].toString()
                }).then((response) {
                  // print(response.body);
                  Map jsonData = jsonDecode(response.body);

                  if (jsonData['status'] == 0) {
                    Map<String, dynamic> roomDataMap = jsonData['data'];

                    Card cardShow = Card(
                      child: Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                'ห้อง : ${roomDataMap['roomNo']}',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.brown[400],
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                      '\nผู้แจ้ง : ${userDataMap['userUsername']} \n\nหัวข้อ : ${data['fixTopic']}\n\n'),
                                ),
                                Container(
                                  child: Center(
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (BuildContext
                                                        context) =>
                                                    InformCheckStatusPage(
                                                        _dormId,
                                                        _userId,
                                                        userDataMap[
                                                            'userUsername'],
                                                        roomDataMap['roomNo'],
                                                        fixId)));
                                      },
                                      child: CircleAvatar(
                                        child: icon,
                                        backgroundColor: color,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                    setState(() {
                      lst.add(cardShow);
                    });
                  }
                });
              }
            });
          }
        } else {
          _alert();
        }
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
        subtitle: "ไม่พบรายการแจ้งซ่อม!",
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
    setState(() {
      btHistory();
      _createLayout();
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
        title: Text('แจ้งซ่อม'),
      ),
      body: RefreshIndicator(
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          body: ListView.builder(
            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
            itemBuilder: widgetBuilder,
            itemCount: lst.length,
          ),
        ),
        onRefresh: _onRefresh,
      ),
    );
  }
}
