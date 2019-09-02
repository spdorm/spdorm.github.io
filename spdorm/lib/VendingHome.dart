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
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('เครื่องหยอดเหรียญ'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5, top: 5),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.label_important),
                new Text('รายการจัดการเครื่องหยอดเหรียญ'),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Column(
              children: <Widget>[
                RaisedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddTypeVendingPage(_dormId))); //ทดลอง
                  },
                  icon: Icon(Icons.add),
                  label: Text('เพิ่มประเภทเครื่องหยอดเหรียญ'),
                  color: Colors.green[200],
                ),
                RaisedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ListTypeVendingPage(_dormId))); //ทดลอง
                  },
                  icon: Icon(Icons.add),
                  label: Text('เพิ่มรายรับเครื่องหยอดเหรียญ  '),
                  color: Colors.green[200],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
