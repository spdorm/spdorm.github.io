import 'package:flutter/material.dart';
import 'InformCheckStatus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'DataInform.dart';

class listStatusInformPage extends StatefulWidget {
  int _dormId, _userId, _roomId;
  String _userName;
  listStatusInformPage(int dormId, int userId, int roomId, String userName) {
    this._dormId = dormId;
    this._roomId = roomId;
    this._userId = userId;
    this._userName = userName;
  }
  @override
  State<StatefulWidget> createState() {
    return new _listStatusInformPage(_dormId, _userId, _roomId, _userName);
  }
}

class _listStatusInformPage extends State<listStatusInformPage> {
  int _dormId, _userId, _roomId;
  String _userName;
  _listStatusInformPage(int dormId, int userId, int roomId, String userName) {
    this._dormId = dormId;
    this._roomId = roomId;
    this._userId = userId;
    this._userName = userName;
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
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          label: Text(
            'ประวัติรายการทั้งหมด',
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blueGrey[300],
        ),
      ),
    );
    setState(() {
      lst.add(button);
    });
  }

  void _createLayout() {
    Container head = Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: new Row(
        children: <Widget>[
          new Text(' รายการล่าสุด',style: TextStyle(color: Colors.grey[600]),),
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

      if (jsonData["status"] == 0) {
        for (int i = 0; i < temp.length; i++) {
          Map<String, dynamic> data = temp[i];
          Color color;
          Icon icon;
          int fixId = data['fixId'];

          if (data['fixStatus'] == "active") {
            color = Colors.grey[200];
            icon = Icon(Icons.hourglass_empty);
          } else if (data['fixStatus'] == "success") {
            color = Colors.grey[200];
            icon = Icon(Icons.check,color: Colors.green[300],);
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
                    margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                                '\nผู้แจ้ง : ${userDataMap['userUsername']} \n\nหัวข้อ : ${data['fixTopic']}\n\n' +
                                    'ห้อง : ${roomDataMap['roomNo']}\n'),
                          ),
                          Container(
                            // color: color,
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(10)
                            // ),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            InformCheckStatusPage(
                                                _dormId,
                                                _userName,
                                                roomDataMap['roomNo'],
                                                fixId)));
                              },
                              child: CircleAvatar(
                                child: icon,
                                backgroundColor: color,
                              ),
                              //backgroundColor: color,
                            ),
                          ),
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
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
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
