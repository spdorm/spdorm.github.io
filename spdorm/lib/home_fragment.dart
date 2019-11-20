import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
  Color color;

  Future<void> _setRoomNo(String no) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('roomNo', no);
  }

  Future<String> _getRoomNo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.getString('roomNo');
  }

  @override
  void initState() {
    _getRoomNo().then((String no) {
      if (no != "1" && no != null) {
        _selectedFloor = no;
        createRoom();
      } else {
        _selectedFloor = "1";
        createRoom();
      }
    });
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

  void onMonthChange(String item) {
    setState(() {
      _selectedFloor = item;
      _setRoomNo(_selectedFloor);
      lst.clear();
      showFloor();
      showRoom();
    });
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
        // _selectedFloor = _floor.first;
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
      print(respone.body);
      Map jsonData = jsonDecode(respone.body);
      temp = jsonData['data'];

      if (jsonData['status'] == 0 && temp.isNotEmpty) {
        for (int i = 0; i < temp.length; i++) {
          List data = temp[i];
          Color color;

          if (data[9] == "ว่าง") {
            color = Colors.green[300];
          } else if (data[9] == "จอง") {
            color = Colors.yellow[700];
          } else if (data[9] == "รายวัน") {
            color = Colors.indigo[300];
          } else if (data[9] == "ปิดปรับปรุง") {
            color = Colors.red[300];
          } else {
            color = Colors.blueGrey[200];
          }

          Padding cardRoom1 = Padding(
            padding: EdgeInsets.only(right: 10, left: 10),
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 1.5),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: FlatButton(
                color: color,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ViewRoomPage(_dormId, _userId, data[0])));
                },
                // textColor: Colors.white,
                // icon: Icon(Icons.panorama_fish_eye),
                child: new Text(
                  '${data[7]}  ประเภทห้อง : ${data[10]}',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            // child: RaisedButton(
            //   color: color,
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (BuildContext context) =>
            //                 ViewRoomPage(_dormId, _userId, data[0])));
            //   },
            //   child: Text('${data[7]}  ประเภทห้อง : ${data[10]}',style: TextStyle(color: Colors.grey[700]),),
            // ),
          );
          lst.add(cardRoom1);
          setState(() {});
        }
      } else {
        Center ctAlarm = Center(
            child: Container(
          padding: EdgeInsets.all(50.0),
          child: Text(
            'ไม่พบข้อมูล',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ));
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
              color: Colors.grey[300],
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    child: Text(
                      "กรุณาเลือกชั้น : ",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),
                  new DropdownButton<String>(
                      value: _selectedFloor,
                      items: _floor.map((String value) {
                        return new DropdownMenuItem(
                            value: value,
                            child: new Text(
                              value,
                              style: TextStyle(color: Colors.grey[700]),
                            ));
                      }).toList(),
                      onChanged: (String value) {
                        onMonthChange(value);
                      }),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.only(top: 10),
              child: new Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 25, left: 20),
                    child: Row(
                      children: <Widget>[
                        new Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.green[300],
                        ),
                        new Text(
                          ' ว่าง',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 25, left: 20),
                    child: Row(
                      children: <Widget>[
                        new Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.blueGrey[200],
                        ),
                        new Text(
                          ' ไม่ว่าง',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 25, left: 20),
                    child: Row(
                      children: <Widget>[
                        new Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.yellow[700],
                        ),
                        new Text(
                          ' จอง',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.only(top: 10),
              child: new Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10, left: 20),
                    child: Row(
                      children: <Widget>[
                        new Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.indigo[300],
                        ),
                        new Text(
                          ' รายวัน',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: Row(
                      children: <Widget>[
                        new Icon(
                          Icons.panorama_fish_eye,
                          color: Colors.red[300],
                        ),
                        new Text(
                          ' ปิดปรับปรุง',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[700]),
                        ),
                      ],
                    ),
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

  Widget buildBody(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    //final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        AddRoomPage(_dormId, _userId, _selectedFloor)));
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.green[300],
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
