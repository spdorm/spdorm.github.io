import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:spdorm/mainHomDorm.dart';
import 'AddDataDormpage.dart';
import 'dart:convert';
import 'config.dart';
import 'mainHomDorm.dart';

class AddFloorPage extends StatefulWidget {
  int _dormId,_userId;
  AddFloorPage(int dormId,int userId){
    this._dormId = dormId;
    this._userId=userId;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _AddFloorPage(_dormId,_userId);
  }
}

class _AddFloorPage extends State {
  int _dormId, _userId;
  _AddFloorPage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
    print(_dormId);
    print(_userId);
  }
  List lst = new List();
  TextEditingController machine = TextEditingController();
  TextEditingController dormImage = TextEditingController();
  TextEditingController dormName = TextEditingController();
  TextEditingController dormAddress = TextEditingController();
  TextEditingController dormPrice = TextEditingController();
  TextEditingController dormPromotion = TextEditingController();
  TextEditingController dormDetail = TextEditingController();

  void initState(){
    super.initState();
    http.post('${config.API_url}/dorm/list',body: {"dormId":_dormId.toString(),"userId":_userId.toString()}).then((response){
      print(response.body);
      Map jsonData = jsonDecode(response.body);
      Map<String,dynamic> data = jsonData["data"] as Map;
      int n = int.parse(data["dormFloor"]);
      for(int i = 1 ; i <= n ;i ++ ){
        AddCard(i.toString());
      }
    });
    Padding topBar = Padding(
      padding: EdgeInsets.only(left: 10, top: 0, right: 10),
      child: Column(
        children: <Widget>[
          Text(':จำนวนชั้นหอพักทั้งหมด'),
        ],
      ),
    );
    lst.add(topBar);
    setState(() {});
  }

  void updateFloor(){

  }
  void AddCard(String nameMachine){
    //lst.removeLast();
    Padding cardNew = Padding(
      padding: EdgeInsets.only(left: 20,right: 20,top: 10),
      child: RaisedButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext) => HomeDorm(_dormId,_userId)));
        },
        color: Colors.white,
        child: new Column(
          children: <Widget>[
            new Container(
              padding: EdgeInsets.only(left: 140, right: 15),
              child: new Row(
                children: <Widget>[
                  new Text('${nameMachine}',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.green
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    lst.add(cardNew);
    setState(() {
    });
  }

  void onDataDorm() {
    Map<String, dynamic> param = Map();
    param["dormId"] = _dormId.toString();
    param["userId"] = '${_userId}';
    param["dormImage"] = dormImage.text;
    param["dormName"] = dormName.text;
    param["dormAddress"] = dormAddress.text;
    param["dormPrice"] = dormPrice.text;
    param["dormPromotion"] = dormPromotion.text;
    param["dormDetail"] = dormDetail.text;
    param["userType"] = 'host';
    param["userStatus"] = 'active';
    http.post('${config.API_url}/dorm/add', body: param).then((response) {
      print(response.body);
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap['status'];
      if (status == 0) {
        Navigator.pop(context);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => HomeDorm(_dormId, _userId)));
      }
    });
  }
  Widget buildBody(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: const Text('การเพิ่มชั้นหอพัก')),
      body: ListView.builder(itemBuilder: buildBody, itemCount: lst.length),
    );
  }
}
