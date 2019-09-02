import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'AddDataDormpage.dart';
import 'dart:convert';
import 'config.dart';
import 'firstPage.dart';
import 'mainHomeFragment.dart';

class AddDormPage extends StatefulWidget {
  int _userId;

  AddDormPage(int userId) {
    this._userId = userId;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddDormPage(_userId);
  }
}

class _AddDormPage extends State {
  int _userId;

  _AddDormPage(int userId) {
    this._userId = userId;
  }

  List lst = new List();
  var img;

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', null);
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
                    _logout().then((_) => {
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
    await Future.delayed(Duration(seconds: 1));
    lst.clear();
    setState(() {
      _body();
    });
    return null;
  }

  void initState() {
    super.initState();

    // FlatButton addButton = FlatButton(
    //   onPressed: () {
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //             builder: (BuildContext) => RegisterDataDorm(_userId)));
    //   },
    //   child: Container(
    //     alignment: Alignment.centerLeft,
    //     margin: new EdgeInsets.only(top: 5),
    //     // padding: new EdgeInsets.all(5.0),
    //     height: 50.0,
    //     decoration: new BoxDecoration(
    //       color: Colors.lightBlue[200],
    //       borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
    //       boxShadow: [
    //         new BoxShadow(
    //             color: Colors.black54,
    //             offset: new Offset(2.0, 2.0),
    //             blurRadius: 5.0)
    //       ],
    //     ),
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: <Widget>[
    //         Center(
    //           child: new Icon(
    //             Icons.add,
    //             color: Colors.white,
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
    // lst.add(addButton);
    // setState(() {});
    _body();
  }

  void _body() {
    http.post('${config.API_url}/dorm/findInfo',
        body: {"userId": _userId.toString()}).then((respone) {
      Map jsonData = jsonDecode(respone.body);
      List temp = jsonData["data"];

      if (jsonData['status'] == 0) {
        for (int i = 0; i < temp.length; i++) {
          List data = temp[i];
          String _name_image = data[5], _status;
          Color colorStatus;

          if (data[10] == "inactive") {
            colorStatus = Colors.red;
            _status = "ปิด";
          } else {
            colorStatus = Colors.green;
            _status = "เปิด";
          }

          http.post('${config.API_url}/room/countStatus',
              body: {"dormId": data[0].toString()}).then((response) {
            Map jsonData = jsonDecode(response.body) as Map;

            if (jsonData['status'] == 0) {
              int count = jsonData['data'];
              Color color;

              if (count == 0) {
                color = Colors.red;
              } else {
                color = Colors.green;
              }

              FlatButton dormInfo = FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext) =>
                              MainHomeFragment(data[0], data[12])));
                },
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: new EdgeInsets.only(top: 8),
                  padding: new EdgeInsets.all(5.0),
                  height: 150.0,
                  decoration: new BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(10.0)),
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
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            new Wrap(
                              spacing: 2.0,
                              children: <Widget>[
                                new Chip(
                                    label: new Text(
                                  'ห้องว่าง: ${count}',
                                  style: TextStyle(color: color),
                                )),
                                new Chip(
                                    label: new Text(
                                  'สถานะ: ${_status}',
                                  style: TextStyle(color: colorStatus),
                                )),
                                // new Chip(label: new Text('Hot')),
                              ],
                            )
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
              );
              lst.add(dormInfo);
              setState(() {});
            }
          });
        }
      }
    });
  }

  Widget buildBody(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
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

    return MaterialApp(
      theme: ThemeData(fontFamily: 'Kanit'),
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: AppBar(
              title: Text('หอพักทั้งหมด'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: onLogOut,
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext) => RegisterDataDorm(_userId)));
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.lightBlue,
            ),
            body:RefreshIndicator(
              child: ListView.builder(itemBuilder: buildBody, itemCount: lst.length),
              onRefresh: _onRefresh,
            )
          ),
        ));
  }
}
