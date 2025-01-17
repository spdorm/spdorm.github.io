import 'package:flutter/material.dart';
import 'package:sweetalert/sweetalert.dart';
import 'package:http/http.dart' as http;
import 'AddVending.dart';
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
    _head();
    AddCard();
  }

  void _head() {
    Container head = Container(
      padding: EdgeInsets.only( top: 15, bottom: 15),
      child: new Row(
        children: <Widget>[
          new Text(' รายการล่าสุด',style: TextStyle(color: Colors.grey[500]),),
        ],
      ),
    );
    setState(() {
      lst.add(head);
    });
  }

  void AddCard() {
    http.post('${config.API_url}/machine/list',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body);
      List temp = jsonData["data"];

      if (jsonData["status"] == 0) {
        for (int i = 0; i < temp.length; i++) {
          List data = temp[i];
          int _machineId = data[0];
          String nameMachine = data[3];
          Card cardNew = Card(
              child: FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> VendingFragment(_dormId,_machineId,nameMachine)));
                },
                padding: EdgeInsets.all(5),
                  child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
                leading: Container(
                  padding: EdgeInsets.only(right: 12.0),
                  decoration: new BoxDecoration(
                      border: new Border(
                          right:
                              new BorderSide(width: 1.0, color: Colors.black))),
                  child: Icon(Icons.monetization_on, color: Colors.brown[400]),
                ),
                title: Text(
                  '${nameMachine}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.brown[400]),
                ),
                // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                // subtitle: Row(
                //   children: <Widget>[
                //     Icon(Icons.linear_scale, color: Colors.yellowAccent),
                //     Text(" Intermediate", style: TextStyle(color: Colors.black))
                //   ],
                // ),
                trailing: IconButton(
                    icon: Icon(Icons.clear, color: Colors.black),
                    onPressed: () {
                      SweetAlert.show(context,
                          subtitle: "คุณต้องการลบข้อมูล ?",
                          style: SweetAlertStyle.confirm,
                          showCancelButton: true, onPress: (bool isConfirm) {
                        if (isConfirm) {
                          SweetAlert.show(context,
                              subtitle: "กำลังลบ...",
                              style: SweetAlertStyle.loading);
                          new Future.delayed(new Duration(seconds: 1), () {
                            http.post('${config.API_url}/machine/delete',
                                body: {
                                  "dormId": _dormId.toString(),
                                  "machineId": '${_machineId}'
                                }).then((respone) {
                              print(respone.body);
                              Map jsonData = jsonDecode(respone.body) as Map;
                            
                              int status = jsonData["status"];
                              if (status == 0) {
                                setState(() {
                                  lst.clear();
                                  _head();
                                  AddCard();
                                });
                                return SweetAlert.show(context,
                                    subtitle: "สำเร็จ!",
                                    style: SweetAlertStyle.success);
                              }
                            });
                          });
                        } else {
                          SweetAlert.show(context,
                              subtitle: "ยกเลิก!",
                              style: SweetAlertStyle.error);
                        }
                        // return false to keep dialog
                        return false;
                      });
                    }),
              )));
          lst.add(cardNew);
          setState(() {});
        }
      }
    });
  }

  Future<Null> _onRefresh() async {
    //_key.currentState.show();
    await Future.delayed(Duration(seconds: 1));
    lst.clear();
    setState(() {
      _head();
      AddCard();
    });
    return null;
  }

  Widget widgetBuilder(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[300],
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
           backgroundColor: Colors.red[300],
          title: Text('เพิ่มรายรับเครื่องหยอดเหรียญ'),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView.builder(
            padding: EdgeInsets.only(left: 5, right: 5, top: 5),
            itemBuilder: widgetBuilder,
            itemCount: lst.length,
          ),
        ));
  }
}
