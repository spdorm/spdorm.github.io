import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'mainHomeFragment.dart';

class NewsDorm extends StatefulWidget{
  int _dormId,_userId;
  NewsDorm(int dormId,int userId){
    this._dormId = dormId;
    this._userId=userId;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _NewsDorm(_dormId,_userId);
  }
}

class _NewsDorm extends State {
  int _dormId,_userId;
  _NewsDorm(int dormId,int userId){
    this._dormId = dormId;
    this._userId=userId;
  }
  final TextEditingController _multiLineTextFieldcontroller = TextEditingController();

  TextEditingController newsTopic = TextEditingController();
  TextEditingController newsDetail = TextEditingController();

  void onNewsDorm() {
    Map<String, dynamic> param = Map();
    param["dormId"] = _dormId.toString();
    param["userId"] = '${_userId}';
    param["newsTopic"] = newsTopic.text;
    param["newsDetail"] = newsDetail.text;
    param["newsStatus"] = 'active';
    http
        .post('${config.API_url}/News/add', body: param)
        .then((response) {
      print(response.body);
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap['status'];
      if(status == 0){
        Navigator.pop(context);
        // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => HomeDorm(_dormId,_userId)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(title: Text('เพิ่มข้อมูลข่าวสาร'),
        leading: Builder(
    builder: (BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () { Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext)=>MainHomeFragment(_dormId,_userId))); },
      );
    },
  ),),
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  padding: EdgeInsets.only(left: 8,right: 8,bottom: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: TextField(
                    controller: newsTopic,
                    decoration: InputDecoration(
                      hintText: ':หัวข้อข่าว',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(15.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),

                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: newsDetail,
                        maxLines: 20,
                        decoration: InputDecoration(
                          hintText: 'Please Type Your Text then click submit',
                        ),
                      ),
                      SizedBox(height: 8.0),
                      FlatButton(
                        onPressed: onNewsDorm,
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

}