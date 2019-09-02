import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'mainHomDorm.dart';

class PersonalFragment extends StatefulWidget {
  int _dormId, _userId, _roomId;
  PersonalFragment(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _PersonalFragment(_dormId, _userId, _roomId);
  }
}

class _PersonalFragment extends State<PersonalFragment> {
  int selectedDrawerIndex = 0;
  int _dormId, _userId, _roomId;
  _PersonalFragment(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  String _Username, _Firstname, _userLastname, _Address, _Email, _Telephone;

  TextEditingController userFirstname = TextEditingController();
  TextEditingController userLastname = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  TextEditingController userEmail = TextEditingController();
  TextEditingController userTelephone = TextEditingController();
  List lst = new List();

  void initState() {
    super.initState();
    http.post('${config.API_url}/user/list',
        body: {"userId": _userId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      Map<String, dynamic> data = jsonData['data'];
      setState(() {
        _Username = data['userUsername'];
        userFirstname.text = data['userFirstname'];
        userLastname.text = data['userLastname'];
        userAddress.text = data['userAddress'];
        userEmail.text = data['userEmail'];
        userTelephone.text = data['userTelephone'];
        _body();
      });
    });
  }

  Future<bool> _alert(){
    return showDialog(
      context: context,
      builder: (context)=>AlertDialog(
        title: Text('ยืนยันการแก้ไขข้อมูล ?'),
        actions: <Widget>[
          FlatButton(
            onPressed: onSumit,
            child: Text('ยืนยัน'),
          ),
          FlatButton(
            onPressed: (){
              Navigator.pop(context);
            },
            child: Text('ยกเลิก'),
          )
        ],
      )
    );
  }

  void onSumit() {
    http.post('${config.API_url}/user/updateProfile', body: {
      "userId": _userId.toString(),
      "userFirstname": userFirstname.text,
      "userLastname": userLastname.text,
      "userAddress": userAddress.text,
      "userEmail": userEmail.text,
      "userTelephone": userTelephone.text
    }).then((respone) {
      print(respone.body);
      Map jsonData = jsonDecode(respone.body) as Map;
      int status = jsonData['status'];
      print(status);
      if (status == 0) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=>mainHomDorm(_dormId, _userId, _roomId)));
      }
    });
  }

  void _body(){
    Text head = Text(':รายละเอียดข้อมูลส่วนตัว');
          Card body = Card(
            margin: EdgeInsets.all(0.5),
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.green[600],
                      ),
                      new Text(
                        '   ${_Username}',
                        style: TextStyle(color: Colors.green[600]),
                      ),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: userFirstname,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.perm_contact_calendar,color: Colors.pink),
                        hintText: '${_Firstname}',
                        labelText: 'ชื่อ:',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.text,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: userLastname,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.perm_contact_calendar,color: Colors.pink),
                        hintText: '${_userLastname}',
                        labelText: 'นามสกุล:',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.text,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: userAddress,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.add_location,color: Colors.green),
                        hintText: '${_Address}',
                        labelText: 'ที่อยู่:',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.text,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: userEmail,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.email,color: Colors.orange),
                        hintText: '${_Email}',
                        labelText: 'อีเมล:',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: userTelephone,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.local_phone,color: Colors.indigo),
                        hintText: '${_Telephone}',
                        labelText: 'เบอร์โทรศัพท์:',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: new RaisedButton(
                        onPressed: _alert,
                        textColor: Colors.white,
                        color: Colors.blue[300],
                        child: new Row(
                          children: <Widget>[
                            new Text('ตกลง'),
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
            lst.add(head);
            lst.add(body);
          });
  }

  Widget bodyBuild(BuildContext context,int index){
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('ข้อมูลส่วนตัว'),
      ),
      body: new ListView.builder(
        padding: EdgeInsets.all(8),
        itemBuilder: bodyBuild,
        itemCount: lst.length,
      ),
    );
  }
}
