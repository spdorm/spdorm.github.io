
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Registor.dart';
import 'listDorm.dart';
import 'main.dart';
import 'config.dart';

class pendingPage extends StatefulWidget {
  List lst = new List();
  int _dormId;
  String _nameDorm;

  pendingPage(int dormId, String nameDorm) {
    this._nameDorm = nameDorm;
    this._dormId = dormId;
  }

  @override
  State<StatefulWidget> createState() {
    return new _pendingPage(_dormId, _nameDorm);
  }
}

class _pendingPage extends State<pendingPage> {
  int selectedDrawerIndex = 0;
  int _dormId;
  String _nameDorm;

  _pendingPage(int dormId, String nameDorm) {
    this._nameDorm = nameDorm;
    this._dormId = dormId;
  }

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    print(Navigator.of(context).pop());
  }

  String _Name, _lephone;

  void initState() {
    super.initState();
    http.post('${config.API_url}/dorm/list',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      Map<String, dynamic> data = jsonData['data'];
      _lephone = data['dormTelephone'];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: new AppBar(
          title: new Text('รอการอนุมัติ'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                ' รอการอนุมัติ',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              new Text(
                ' โปรดติดต่อเจ้าของหอเพื่อดำเนินการในลำดับต่อไป',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange,                
                ),
              ),
              new Text(
                ' เบอร์ติดต่อ : ${_lephone}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
              new Text(
                '(${_nameDorm})',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 140, top: 5),
                    child: new RaisedButton(
                      onPressed: () {
                        prefix0.Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext)=>ListDormPage()));
                      },
                      textColor: Colors.white,
                      color: Colors.blueGrey,
                      child: new Row(
                        children: <Widget>[
                          new Text('เสร็จสิ้น'),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ) ;
  }
}
