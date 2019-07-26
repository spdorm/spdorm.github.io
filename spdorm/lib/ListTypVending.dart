import 'package:flutter/material.dart';
import 'AddVending.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';

class ListTypeVendingPage extends StatefulWidget {
  int _dormId;
  ListTypeVendingPage(int dormId) {
    this._dormId = dormId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _ListTypeVendingPage(_dormId);
  }
}

class _ListTypeVendingPage extends State<ListTypeVendingPage> {
  int _dormId;
  _ListTypeVendingPage(int dormId) {
    this._dormId = dormId;
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
          new Text('รายการประเภทเครื่องหยอดเหรียญทั้งหมด'),
        ],
      ),
    );
    setState(() {
      lst.add(head);
    });

    http.post('${config.API_url}/machine/list',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body);
      List temp = jsonData["data"];
      for (int i = 0; i < temp.length; i++) {
        List data = temp[i];
        int _machineId = data[0];
        AddCard(_machineId, data[3]);
        print(_machineId);
        print(data[3]);
      }
    });
  }

  void AddCard(int machineId, String nameMachine) {
    Card cardNew = Card(
      margin: EdgeInsets.all(10),
      child: new Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              FlatButton(
               padding: EdgeInsets.only(left: 70  ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => VendingFragment(
                              _dormId, machineId, nameMachine)));
                },
                textColor: Colors.pink[400],
                child: new Row(
                  children: <Widget>[
                    new Icon(Icons.arrow_right),
                    new Text(
                      '${nameMachine}',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 70 ),
                child: IconButton(
                  icon: Icon(Icons.clear ),
                  onPressed: () {
                    http.post('${config.API_url}/machine/delete', body: {
                      "dormId": _dormId.toString(),
                      "machineId": '${machineId}'
                    }).then((respone) {
                      Map jsonData = jsonDecode(respone.body) as Map;
                      int status = jsonData["status"];
                      if (status == 0) {
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext contex) =>
                        //             ListTypeVendingPage(_dormId)));
                      }
                    });
                  },
                  color: Colors.grey,
                ),
              ),
            ],
          )
        ],
      ),
    );
    lst.add(cardNew);
    setState(() {});
  }

  Widget widgetBuilder(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('เพิ่มรายรับเครื่องหยอดเหรียญ'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        itemBuilder: widgetBuilder,
        itemCount: lst.length,
      ),
    );
  }
}


