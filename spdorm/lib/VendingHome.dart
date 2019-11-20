import 'package:flutter/material.dart';
import 'AddTypeVending.dart';
import 'ListTypVending.dart';
import 'mainHomeFragment.dart';

class VendingHomePage extends StatefulWidget {
  int _dormId, _userId;

  VendingHomePage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }

  @override
  State<StatefulWidget> createState() {
    return new _VendingHomePage(_dormId, _userId);
  }
}

class _VendingHomePage extends State<VendingHomePage> {
  int _dormId, _userId;

  _VendingHomePage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }

  var now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.red[300],
        title: Text('เครื่องหยอดเหรียญ'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: new Row(
              children: <Widget>[
                new Text(' รายการจัดการเครื่องหยอดเหรียญ'),
              ],
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: FlatButton.icon(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddTypeVendingPage(_dormId))); //ทดลอง
                },
                textColor: Colors.red[300],
                icon: Icon(Icons.add),
                label: new Text(
                  ' เพิ่มประเภทเครื่องหยอดเหรียญ',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.red[300],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: FlatButton.icon(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ListTypeVendingPage(_dormId))); //ทดลอง
                },
                textColor: Colors.red[300],
                icon: Icon(Icons.add),
                label: new Text(
                  '  เพิ่มรายรับเครื่องหยอดเหรียญ',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.red[300],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
