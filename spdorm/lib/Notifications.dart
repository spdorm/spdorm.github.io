import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'AddDataDormpage.dart';

class NotificationsPage extends StatefulWidget {
  int _userId;
  NotificationsPage(int userId) {
    this._userId = userId;
  }
  @override
  _NotificationsPage createState() => _NotificationsPage(_userId);
}

class _NotificationsPage extends State<NotificationsPage> {
  int _userId;
  _NotificationsPage(int userId) {
    this._userId = userId;
  }

  List<Asset> images = List<Asset>();
  bool isSwitched = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.red[300],
        title: const Text('การตั้งค่าทั่วไป'),
      ),
      body: Column(
        children: <Widget>[
          // Center(child: Text('Error: $_error')),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.public),
                new Text(' การแจ้งเตือน:'),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          'แจ้งเตือนการแจ้งซ้อม',
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.brown[400],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (BuildContext) =>
                          //             depositManagementPage(
                          //                 // _dormId, data['userId'], roomId)));
                        },
                        textColor: Colors.green[400],
                        child: new Row(
                          children: <Widget>[
                            Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                });
                              },
                              activeTrackColor: Colors.red[100],
                              activeColor: Colors.red[300],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '55555555: ',
                        style: TextStyle(
                            fontSize: 14,
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
                        '555555555 :',
                        style: TextStyle(
                            fontSize: 14,
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
          )
        ],
      ),
    );
  }
}
