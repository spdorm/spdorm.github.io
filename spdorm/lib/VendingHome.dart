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
  List lst = new List();

  var now = new DateTime.now();

  @override
  void initState() {
    super.initState();

     Container head = Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.label_important),
          new Text('รายการจัดการเครื่องหยอดเหรียญ'),
        ],
      ),
    );
    setState(() {
      lst.add(head);
    });

    Container button1 = Container(
      margin: EdgeInsets.only(top: 10),
      child: Center(
        child: RaisedButton.icon(
          onPressed: () {
            Navigator.push(
                        context,
                     MaterialPageRoute(
                       builder: (BuildContext context) => AddTypeVendingPage(1))); //ทดลอง
          },
          icon: Icon(Icons.add),
          label: Text('เพิ่มประเภทเครื่องหยอดเหรียญ'),
          color: Colors.green[200],
        ),
      ),
    );
    setState(() {
      lst.add(button1);
    });


    Container button2 = Container(
      margin: EdgeInsets.only(top: 10),
      child: Center(
        child: RaisedButton.icon(
          onPressed: () {
            Navigator.push(
                        context,
                     MaterialPageRoute(
                       builder: (BuildContext context) => ListTypeVendingPage(1))); //ทดลอง
          },
          icon: Icon(Icons.add),
          label: Text('เพิ่มรายรับเครื่องหยอดเหรียญ'),
          color: Colors.green[200],
        ),
      ),
    );
    setState(() {
      lst.add(button2);
    });
  }

  Widget widgetBuilder(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('เครื่องหยอดเหรียญ'),
        leading: Builder(
    builder: (BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () { Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext)=>MainHomeFragment(_dormId,_userId))); },
      );
    },
  ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        itemBuilder: widgetBuilder,
        itemCount: lst.length,
      ),
    );
  }
}
