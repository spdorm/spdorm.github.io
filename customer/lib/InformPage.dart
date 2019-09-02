import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'listStatusInform.dart';

class InformMultiLine extends StatefulWidget {
  int _dormId,_userId,_roomId;
  String _userName;
  InformMultiLine(int dormId,int userId,int roomId, String userName) {
    this._dormId = dormId;
    this._roomId = roomId;
    this._userId = userId;
    this._userName = userName;
  }

  @override
  State<StatefulWidget> createState() {
    return new InformMultiLineState(_dormId,_userId,_roomId, _userName);
  }
}

class InformMultiLineState extends State<InformMultiLine> {
 int _dormId,_userId,_roomId;
  String _userName;
  InformMultiLineState(int dormId,int userId,int roomId, String userName) {
    this._dormId = dormId;
    this._roomId = roomId;
    this._userId = userId;
    this._userName = userName;
  }
  final TextEditingController _multiLineTextFieldcontroller = TextEditingController();

  TextEditingController fixTopic = TextEditingController();
  TextEditingController fixDetail = TextEditingController();

  void onfixDorm() {
    Map<String, dynamic> param = Map();
    param["dormId"] = _dormId.toString();
    param["userId"] = '${_userId}';
    param["roomId"] = _roomId.toString();
    param["fixTopic"] = fixTopic.text;
    param["fixDetail"] = fixDetail.text;
    param["fixStatus"] = 'active';
    http
        .post('${config.API_url}/fix/add', body: param)
        .then((response) {
      print(response.body);
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap['status'];
      if(status == 0){
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(title: Text('การแจ้งซ่อม'),),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
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
                        controller: fixTopic,
                        decoration: InputDecoration(
                          hintText: 'หัวข้อ :',
                        ),
                      ),
                      SizedBox(height: 8.0),
                    ],
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
                        controller: fixDetail,
                        maxLines: 10,
                        decoration: InputDecoration(
                          hintText: 'แจ้งปัญหา :',
                        ),
                      ),
                      SizedBox(height: 8.0),
                      FlatButton(
                        onPressed: onfixDorm,
                        child: const Text('ตกลง'),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: new RaisedButton(
                  onPressed: () {
                     Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext) => listStatusInformPage(_dormId,_userId,_roomId, _userName)));
                  },
                  textColor: Colors.white,
                  color: Colors.blueGrey,
                  child:  new Text('แสดงสถานะรายการ'),
                ),
                ),
              )
            ],
          ),
        ),
      );
  }
}