import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'config.dart';
import 'firstPage.dart';
import 'mainHomDorm.dart';
import 'publishStatus.dart';

class ListDormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListDormPage();
  }
}

class _ListDormPage extends State {
  List lst = new List();

  String _address, _promotion, _price, _detail;

  void initState() {
    super.initState();
    _body();
  }

  Future<int> _getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getInt('id');
  }

  void _body() {
    http.post('${config.API_url}/dorm/listAll').then((respone) {
      print(respone.body);
      Map jsonData = jsonDecode(respone.body);
      List temp = jsonData["data"];
      Color color;

      if (jsonData["status"] == 0) {
        for (int i = 0; i < temp.length; i++) {
          List data = temp[i];
          Image img;
          String _name_image;
          print(data[5]);

          if (data[5] != "" || data[5] != null) {
            setState(() {
              _name_image = data[5];
            });
          } else {
            setState(() {
              _name_image = "";
            });
          }

          http.post('${config.API_url}/room/countStatus',
              body: {"dormId": data[0].toString()}).then((response) {
            Map jsonData = jsonDecode(response.body) as Map;
            int count = jsonData['data'];

            if (jsonData['status'] == 0) {
              if (count == 0) {
                color = Colors.red;
              } else {
                color = Colors.green;
              }

              FlatButton dormInfo = FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext) =>
                              PublishStatus(data[0], data[6])));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: new EdgeInsets.only(top: 8),
                  padding: new EdgeInsets.all(8.0),
                  height: 150.0,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(3.0)),
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black54,
                          offset: new Offset(2.0, 2.0),
                          blurRadius: 5.0)
                    ],
                  ),
                  child: new Row(
                    children: <Widget>[
                      _name_image == "" || _name_image == null
                          ? new CircleAvatar(
                              backgroundColor: Colors.white70,
                              radius: 50.0,
                              backgroundImage:
                                  AssetImage("images/no_image.png"),
                            )
                          : new CircleAvatar(
                              backgroundColor: Colors.white70,
                              radius: 50.0,
                              backgroundImage: NetworkImage(
                                  '${config.API_url}/dorm/image/?nameImage=${_name_image}'),
                            ),
                      new Expanded(
                          child: new Padding(
                        padding: new EdgeInsets.only(left: 8.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              '${data[6]}',
                              style: new TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.blueGrey),
                            ),
                            new Wrap(
                              spacing: 10.0,
                              children: <Widget>[
                                new Text(
                                  'ราคา : ${data[7]} ',
                                  style: TextStyle(fontSize: 12.0),
                                ),
                                new Text(
                                  'ห้องว่าง : ${count}',
                                  style: TextStyle(color: color,fontSize: 12.0),
                                ),
                              ],
                            ),
                            new Chip(
                                    label: new Text(
                                  'โปรโมชัน : ${data[8]}',
                                  style: TextStyle(fontSize: 12.0),
                                )),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              );
              setState(() {
                lst.add(dormInfo);
              });
            }
          });
        }
      }
    });
  }

  Future<bool> _onClose() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('คุณต้องการออกจากแอปหรือไม่'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('ใช่')),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('ไม่ใช่')),
            ],
          );
        });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', null);
    print(prefs.getInt('id'));
  }

  Future<bool> onLogOut() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('คุณต้องการออกจากระบบ ?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('ไม่ใช่'),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text('ใช่'),
                  onPressed: () => {
                    _logout().then((res) => {
                          Navigator.pop(context),
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext) => Login()))
                        }),
                  },
                ),
              ],
            ));
  }

  Future<Null> _onRefresh() async {
    await new Future.delayed(new Duration(seconds: 1));
    _getId().then((userId) {
      http.post('${config.API_url}/room/findByCustomerId',
          body: {"userId": userId.toString()}).then((response) {
        Map jsonData = jsonDecode(response.body) as Map;
        Map<String, dynamic> dataMap = jsonData['data'];
        if (jsonData['status'] == 0) {
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext) => mainHomDorm(
                      dataMap['dormId'], userId, dataMap['roomId'])));
        } else {
          lst.clear();
          setState(() {
            _body();
          });
        }
      });
    });

    return null;
  }

  Widget buildBody(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Kanit'),
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: _onClose,
        child: Scaffold(
         backgroundColor: Color(0xfff5f5f5),
          appBar: AppBar(
            backgroundColor: Colors.blue[300],
            title: const Text('หอพักแนะนำ'),
            actions: <Widget>[
              FlatButton(
                onPressed: onLogOut,
                child: Icon(Icons.exit_to_app),
              )
            ],
          ),
          body: RefreshIndicator(
            child:
                ListView.builder(itemBuilder: buildBody, itemCount: lst.length),
            onRefresh: _onRefresh,
          ),
        ),
      ),
    );
  }
}
