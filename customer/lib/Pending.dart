import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
  List lst = new List();

  void initState() {
    super.initState();
    http.post('${config.API_url}/dorm/list',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;

      if (jsonData['status'] == 0) {
        Map<String, dynamic> data = jsonData['data'];

        Column body = Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(
                'หอพัก : ${data['dormName']}',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              new Text(
                'ที่อยู่ : ${data['dormAddress']}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                ),
              ),
              new Text(
                ' เบอร์ติดต่อ : ${data['dormTelephone']}',
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
            ],
          );
        setState(() {
          lst.add(body);
        });
      }
    });
  }

  Widget bodyBuild(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: new AppBar(
            title: new Text('ข้อมูลติดต่อ'),
          ),
          body: ListView.builder(            
            itemBuilder: bodyBuild,
            itemCount: lst.length,
          ));
  }
}
