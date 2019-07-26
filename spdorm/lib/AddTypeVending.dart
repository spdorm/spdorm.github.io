import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'package:sweetalert/sweetalert.dart';

class AddTypeVendingPage extends StatefulWidget {
  int _dormId;
  AddTypeVendingPage(int dormId) {
    this._dormId = dormId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _AddTypeVendingPage(_dormId);
  }
}

class _AddTypeVendingPage extends State<AddTypeVendingPage> {
  int _dormId;
  _AddTypeVendingPage(int dormId) {
    this._dormId = dormId;
  }

  List lst = List();
  int temp;
  String _massege = "";
  TextEditingController _machineName = TextEditingController();
  TextEditingController _machineType = TextEditingController();
  TextEditingController _machineValue = TextEditingController();

  var now = new DateTime.now();

  @override
  void initState() {
    super.initState();

    Container head = Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.label_important),
          new Text('รายละเอียดการเพิ่มประเภทเครื่องหยอดเหรียญ'),
        ],
      ),
    );
    setState(() {
      lst.add(head);
    });

    Card textFormField = Card(
      margin: EdgeInsets.all(10),
      child: new Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: _machineType,
              decoration: InputDecoration(
                  icon: const Icon(Icons.control_point),
                  hintText: 'Enter a amount',
                  labelText: 'ชื่อเครื่องหยอดเหรียญ',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          _massege != ""
              ? Text('${_massege}')
              : Padding(
                  padding: EdgeInsets.all(0.0),
                ),
          new Row(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: 65, top: 5, right: 20, bottom: 5),
                child: new RaisedButton(
                  onPressed: () {
                    http.post('${config.API_url}/machine/add', body: {
                      "dormId": _dormId.toString(),
                      "machineType": _machineType.text,
                    }).then((response) {
                      print(response.body);
                      Map jsonData = jsonDecode(response.body) as Map;
                      int status = jsonData["status"];
                      if (status == 0) {
                        _massege = "";
                        //AddCard(0,_machineType.text);
                        // BtAdd();
                      } else {
                        _massege = "มีเครื่องหยอดเหรียญประเภทนี้แล้ว";
                      }
                    });
                  },
                  textColor: Colors.white,
                  color: Colors.green,
                  child: new Row(
                    children: <Widget>[
                      new Icon(Icons.add),
                      new Text('เพิ่มชนิดเครื่องหยอดเหรียญ'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    setState(() {
      lst.add(textFormField);
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
        title: Text('เพิ่มประเภทเครื่องหยอดเหรียญ'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.label_important),
                new Text('รายละเอียดการเพิ่มประเภทเครื่องหยอดเหรียญ'),
              ],
            ),
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: _machineType,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.control_point),
                        hintText: 'Enter a amount',
                        labelText: 'ชื่อเครื่องหยอดเหรียญ',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.text,
                  ),
                ),
                _massege != ""
                    ? Text('${_massege}')
                    : Padding(
                        padding: EdgeInsets.all(0.0),
                      ),
                new Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          left: 65, top: 5, right: 20, bottom: 5),
                      child: new RaisedButton(
                        onPressed: () {
                          http.post('${config.API_url}/machine/add', body: {
                            "dormId": _dormId.toString(),
                            "machineType": _machineType.text,
                          }).then((response) {
                            print(response.body);
                            Map jsonData = jsonDecode(response.body) as Map;
                            int status = jsonData["status"];
                            if (status == 0) {
                              setState(() {
                                _massege = "";
                              });
                              return SweetAlert.show(context,
                                  title: "สำเร็จ!",
                                  subtitle: "เพิ่มประเภทเครื่องหยอดเหรียญแล้ว",
                                  style: SweetAlertStyle.success);
                            } else {
                              setState(() {
                                _massege = "มีเครื่องหยอดเหรียญประเภทนี้แล้ว";
                              });
                            }
                          });
                        },
                        textColor: Colors.white,
                        color: Colors.green,
                        child: new Row(
                          children: <Widget>[
                            new Icon(Icons.add),
                            new Text('เพิ่มชนิดเครื่องหยอดเหรียญ'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
