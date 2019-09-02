import 'package:flutter/material.dart';
import 'DataInform.dart';
import 'InformCheckStatus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

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
          icon: Icon(Icons.remove_red_eye),
          label: Text('ประวัติรายการทั้งหมด'),
          color: Colors.pink[50],
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
          new Icon(Icons.label_important),
          new Text('รายการแจ้งเตือนอัพเดตล่าสุด'),
        ],
      ),
    );
    setState(() {
      lst.add(head);
    });

//###################################################################################
    http.post('${config.API_url}/fix/listAll',
        body: {"dormId": _dormId.toString()}).then((response) {
      Map jsonData = jsonDecode(response.body);
      List temp = jsonData["data"];
      print(temp.length);

      if (jsonData["status"] == 0) {
        for (int i = 0; i < temp.length; i++) {
          Map<String, dynamic> data = temp[i];
          Color color;
          Icon icon;
          String status;

          if (data['fixStatus'] == "active") {
            color = Colors.yellow[600];
            status = "รอดำเนินการ";
            icon = Icon(Icons.hourglass_empty);
          } else if (data['fixStatus'] == "success") {
            color = Colors.green[600];
            status = "ดำเนินการแล้ว";
            icon = Icon(Icons.check);
          }

          http.post('${config.API_url}/user/list',
              body: {"userId": data['userId'].toString()}).then((response) {
            Map jsonData = jsonDecode(response.body);
            Map<String, dynamic> userDataMap = jsonData['data'];

            if (jsonData['status'] == 0) {
              http.post('${config.API_url}/room/listRoom', body: {
                "dormId": data['dormId'].toString(),
                "roomId": data['roomId'].toString()
              }).then((response) {
                Map jsonData = jsonDecode(response.body);
                Map<String, dynamic> roomDataMap = jsonData['data'];

                if (jsonData['status'] == 0) {
                  Card cardShow = Card(
                    child: Padding(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              'ห้อง : ${roomDataMap['roomNo']}',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                    '\nผู้แจ้ง : ${userDataMap['userUsername']} \n\nหัวข้อ : ${data['fixTopic']}\n\n'),
                              ),
                              Container(
                                child: Center(
                                  child: RaisedButton.icon(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  InformCheckStatusPage(
                                                      _dormId,
                                                      _userId,
                                                      userDataMap[
                                                          'userUsername'],
                                                      roomDataMap['roomNo'])));
                                    },
                                    icon: icon,
                                    label: Text('${status}'),
                                    color: color,
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
      }
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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('แจ้งซ่อม'),
      ),
      body: RefreshIndicator(
        child: Scaffold(
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
