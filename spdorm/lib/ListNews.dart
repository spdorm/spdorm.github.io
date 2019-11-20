import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'NewsDorm.dart';
import 'package:sweetalert/sweetalert.dart';

class ListNewsPage extends StatefulWidget {
  int _dormId, _userId;
  ListNewsPage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }

  @override
  State<StatefulWidget> createState() {
    return new _ListNewsPage(_dormId, _userId);
  }
}

class _ListNewsPage extends State<ListNewsPage> {
  int _dormId, _userId;
  _ListNewsPage(int dormId, int userId) {
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
          "ประวัติข่าวประชาสัมพันธ์",
          style: TextStyle(fontSize: 24, color: Colors.brown[400]),
        ),
      ),
    );
    setState(() {
      lst.add(head);
    });

    http.post('${config.API_url}/News/list',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;

      if (jsonData['status'] == 0) {
        List newData = jsonData['data'];

        if (newData.isNotEmpty) {
          for (int i = 0; i < newData.length; i++) {
            Map<String, dynamic> data = newData[i];
            //print(data['userId']);
            http.post('${config.API_url}/user/list', body: {
              "userId": data['userId'].toString()
            }).then((responseUser) {
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
                                    color: Colors.red[300],
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
        subtitle: "ไม่พบข้อมูลข่าวสาร!", style: SweetAlertStyle.error,onPress: (isTrue) {
          if (isTrue) {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext) =>
                        NewsDorm(_dormId, _userId)));
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
      backgroundColor: Colors.grey[100],
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text('เพิ่มข้อมูลข่าวสาร'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext) => NewsDorm(_dormId, _userId)));
              },
            );
          },
        ),
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
