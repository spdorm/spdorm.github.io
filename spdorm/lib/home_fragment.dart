import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spdorm/ViewRoomPage.dart';
import 'AddRoompage.dart';
import 'config.dart';
import 'dart:convert';

class HomeFragment extends StatefulWidget {
  int _dormId;

  HomeFragment(int dormId) {
    this._dormId = dormId;
  }

  @override
  State<StatefulWidget> createState() {
    return new HomeFragmentState(_dormId);
  }
}

class HomeFragmentState extends State<HomeFragment> {
  int _dormId;

  HomeFragmentState(int dormId) {
    this._dormId = dormId;
  }

  List<String> _floor = List();
  List lst = new List();
  List temp = new List();

  String _selectedFloor;
  int _userId;

  @override
  void initState() {
    createRoom();
    super.initState();
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    lst.clear();
    setState(() {
      showFloor();
      showRoom();
    });
    return null;
  }

  void createRoom() {
    http.post('${config.API_url}/dorm/list',
        body: {"dormId": _dormId.toString()}).then((response) {
      Map jsonData = jsonDecode(response.body);
      Map<String, dynamic> data = jsonData["data"] as Map;
      if (jsonData["status"] == 0) {
        int n = int.parse(data["dormFloor"]);
        _userId = data['userId'];

        for (int i = 1; i <= n; i++) {
          _floor.add(i.toString());
        }
        _selectedFloor = _floor.first;
        showFloor();
        showRoom();
      }
    });
  }

  void showRoom() {
    http.post('${config.API_url}/room/listFloor', body: {
      "dormId": _dormId.toString(),
      "roomFloor": _selectedFloor.toString()
    }).then((respone) {
      Map jsonData = jsonDecode(respone.body);
      temp = jsonData['data'];

      if (jsonData['status'] == 0 && temp.isNotEmpty) {
        for (int i = 0; i < temp.length; i++) {
          List data = temp[i];
          Color color;
          if (data[8] == "ว่าง") {
            color = Colors.green[300];
          } else if (data[8] == "จอง") {
            color = Colors.yellow;
          } else if (data[8] == "รายวัน") {
            color = Colors.blue;
          } else {
            color = Colors.red[300];
          }

          Padding cardRoom1 = Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: RaisedButton(
              color: color,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            ViewRoomPage(_dormId, _userId, data[0])));
              },
              child: Text('${data[6]}  ประเภทห้อง : ${data[9]}'),
            ),
          );
          lst.add(cardRoom1);
          setState(() {});
        }
      } else {
        Center ctAlarm = Center(
          child: Text('ไม่พบข้อมูล'),
        );
        lst.add(ctAlarm);
        setState(() {});
      }
    });
  }

  void showFloor() {
    Container con = Container(
      color: Colors.white30.withOpacity(0.75),
      padding: EdgeInsets.all(10.0),
      child: new Form(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Card(
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                    child: Text("ชั้น :"),
                  ),
                  new DropdownButton<String>(
                      value: _selectedFloor,
                      items: _floor.map((String value) {
                        return new DropdownMenuItem(
                            value: value, child: new Text(value));
                      }).toList(),
                      onChanged: (String value) {
                        onMonthChange(value);
                      }),
                ],
              ),
            ),
            new Container(
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Container(
                      width: 30.0,
                      height: 15.0,
                      color: Colors.green[300],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(" : ว่าง"),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Container(
                      width: 30.0,
                      height: 15.0,
                      color: Colors.yellow[300],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(" : จอง"),
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Container(
                      width: 30.0,
                      height: 15.0,
                      color: Colors.red[300],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(" : ไม่ว่าง"),
                  ),
                ],
              ),
            ),
            new Container(
              child: new Row(
                children: <Widget>[
                  new Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Container(
                      width: 30.0,
                      height: 15.0,
                      color: Colors.indigo[300],
                    ),
                  ),
                  new Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(" : รายวัน"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    lst.add(con);
    setState(() {});

    // Container bt = Container(
    //   child: new Row(
    //     children: <Widget>[
    //       new Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: RaisedButton(
    //           onPressed: () {
    //             Navigator.push(
    //                 context,
    //                 MaterialPageRoute(
    //                     builder: (BuildContext context) =>
    //                         AddRoomPage(_dormId, _userId, _selectedFloor)));
    //           },
    //           child: Icon(Icons.add),
    //           textColor: Colors.green,
    //           color: Colors.white70,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    // lst.add(bt);
    // setState(() {});
  }

  void onMonthChange(String item) {
    setState(() {
      _selectedFloor = item;
      lst.clear();
      showFloor();
      showRoom();
    });
  }

  Widget buildBody(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    //final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        AddRoomPage(_dormId, _userId, _selectedFloor)));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
        ),
        body: RefreshIndicator(
          child: ListView.builder(
            itemBuilder: buildBody,
            itemCount: lst.length,
          ),
          onRefresh: _onRefresh,
        ));
  }
}
