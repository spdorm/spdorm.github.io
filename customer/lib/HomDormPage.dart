import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';

class HomDormPage extends StatefulWidget {
  int _dormId, _userId;
  HomDormPage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }

  @override
  State<StatefulWidget> createState() {
    return new HomDormPageState(_dormId, _userId);
  }
}

class HomDormPageState extends State<HomDormPage> {
  int _dormId, _userId;
  HomDormPageState(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }

  List lst = new List();

  @override
  void initState() {
    _createLayout();
    super.initState();
  }

  void _createLayout() {
    Container head = Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Center(
        child: Text(
          "ข่าวประชาสัมพันธ์",
          style: TextStyle(fontSize: 30, color: Colors.red),
        ),
      ),
    );
    setState(() {
      lst.add(head);
    });

    http.post('${config.API_url}/News/list',
        body: {"dormId": _dormId.toString()}).then((response) {
      Map jsonData = jsonDecode(response.body) as Map;
      List newData = jsonData['data'];

      if (jsonData['status'] == 0) {
        for (int i = 0; i < newData.length; i++) {
           Map<String,dynamic> data = newData[i];
           print(data['userId']);
          http.post('${config.API_url}/user/list',
              body: {"userId": data['userId'].toString()}).then((responseUser) {
            Map jsonData = jsonDecode(responseUser.body) as Map;
            Map<String, dynamic> dataMap = jsonData['data'];

            if (jsonData['status'] == 0) {
              Padding news = Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '${data['newsTopic']}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          'ผู้โพสต์ : ${dataMap['userUsername']}    ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'วันโพสต์ : ${(data['dateTime'].toString().substring(0, 10))}',
                          style: TextStyle(color: Colors.grey),
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.red,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text('         ${data['newsDetail']}'),
                        ),
                      ],
                    ),
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
          });
        }
      }
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('คุณต้องการออกจากแอพ ?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('ตกลง'),
                  onPressed: () => Navigator.pop(context, true),
                ),
                FlatButton(
                  child: Text('ยกเลิก'),
                  onPressed: () => Navigator.pop(context, false),
                )
              ],
            ));
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: RefreshIndicator(
          child: ListView.builder(
            itemBuilder: buildBody,
            itemCount: lst.length,
          ),
          onRefresh: _onRefresh,
        ),
      ),
    );
  }
}
