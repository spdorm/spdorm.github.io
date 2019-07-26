import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'DataVandingMachine.dart';
import 'AddVending.dart';

class VendingMachineFragment extends StatefulWidget {
  int _dormId, _userId;

  VendingMachineFragment(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }

  @override
  State<StatefulWidget> createState() {
    return new _VendingMachineFragmentState(_dormId, _userId);
  }
}

class _VendingMachineFragmentState extends State<VendingMachineFragment> {
  int _dormId, _userId;

  _VendingMachineFragmentState(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }

  List lst = List();
  int temp;
  String _massege = "";
  TextEditingController _machineName = TextEditingController();
  TextEditingController _machineType = TextEditingController();
  TextEditingController _machineValue = TextEditingController();

  void initState() {
    super.initState();
    Container button = Container(
      margin: EdgeInsets.only(top: 10),
      child: Center(
        child: RaisedButton.icon(
          onPressed: () {
            Navigator.push(
                        context,
                     MaterialPageRoute(
                       builder: (BuildContext context) => DataVendingMachinePage(_dormId, _userId))); //ทดลอง
          },
          icon: Icon(Icons.remove_red_eye),
          label: Text('ข้อมูลสถิติเครื่องหยอดเหรียญ'),
          color: Colors.yellow[600],
        ),
      ),
    );
    lst.add(button);
    setState(() {});

    

    
    if(lst.length>0){
      http.post('${config.API_url}/machine/list',
          body: {"dormId": _dormId.toString()}).then((response) {
        print(response.body);
        Map jsonData = jsonDecode(response.body);
        List temp = jsonData["data"];
        for (int i = 0; i < temp.length; i++) {
          List data = temp[i];
          int _machineId = data[0];
          AddCard(_machineId, data[3]);
//        Card cardAll = Card(
//          margin: EdgeInsets.all(10),
//          child: new Column(
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.only(left: 300),
//                child: IconButton(
//                  icon: Icon(Icons.cancel),
//                  onPressed: () {
//                    http.post('${config.API_url}/machine/delete', body: {
//                      "dormId": _dormId.toString(),
//                      "machineId": '${data[0]}'
//                    }).then((respone) {
//                      Map jsonData = jsonDecode(respone.body) as Map;
//                      int status = jsonData["status"];
//                      if (status == 0) {
//                        setState(() {});
//                        Navigator.pop(context);
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(
//                                builder: (BuildContext contex) =>
//                                    VendingMachine(_dormId, data[0])));
//                      }
//                    });
//                  },
//                  color: Colors.grey,
//                ),
//              ),
//              FlatButton(
//                padding: EdgeInsets.only(left: 70, right: 10, top: 20.0),
//                onPressed: () {
//                  Navigator.push(
//                      context,
//                      MaterialPageRoute(
//                          builder: (BuildContext context) => VendingFragment( _dormId,_machineId, data[3])));
//                },
//                textColor: Color(0xFFFF6E40),
//                child: new Row(
//                  children: <Widget>[
//                    new Icon(Icons.label_important),
//                    new Text('${data[3]}'),
//                  ],
//                ),
//              ),
//            ],
//          ),
//        );
//        lst.add(cardAll);
//        setState(() {});
        }
        BtAdd();
      });
    }
  }

  void BtAdd() {
    Card card3 = Card(
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
                        AddCard(0,_machineType.text);
                        BtAdd();
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
                      _massege!="" ? Text('${_massege}'):Padding(padding: EdgeInsets.all(0.0),),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    lst.add(card3);
    setState(() {});
  }

  void AddCard(int machineId,String nameMachine) {
    lst.removeLast();
    Card cardNew =  Card(
      margin: EdgeInsets.all(10),
      child: new Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 300),
            child: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                http.post('${config.API_url}/machine/delete', body: {
                  "dormId": _dormId.toString(),
                  "machineId": '${machineId}'
                }).then((respone) {
                  Map jsonData = jsonDecode(respone.body) as Map;
                  int status = jsonData["status"];
                  if (status == 0) {
                    Navigator.pop(context);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext contex) =>
                    //             VendingMachine(_dormId, _userId)));
                  }
                });
              },
              color: Colors.grey,
            ),
          ),
          FlatButton(
            padding: EdgeInsets.only(left: 70, right: 10, top: 20.0),
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) => VendingFragment( _dormId)));
            },
            textColor: Color(0xFFFF6E40),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.label_important),
                new Text('${nameMachine}'),
              ],
            ),
          ),
        ],
      ),
    );
    lst.add(cardNew);
    setState(() {});
  }

  Widget buildBody(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: new AppBar(title: new Text('สถิติเครื่องหยอดเหรียญ'),),
        body: ListView.builder(
          itemBuilder: buildBody,
          itemCount: lst.length,
        ),
    );
  }
}
