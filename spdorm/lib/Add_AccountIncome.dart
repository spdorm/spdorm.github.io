import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import 'config.dart';
import 'dart:convert';
import 'DataAccountIncome.dart';

class AccountIncomeFragment extends StatefulWidget {
  int _dormId, _userId;
  AccountIncomeFragment(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    return _AccountIncomeFragmenttState(_dormId, _userId);
  }
}

class _AccountIncomeFragmenttState extends State {
  int _dormId, _userId;
  _AccountIncomeFragmenttState(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }
  var _image;

  final TextEditingController _multiLineTextFieldcontroller =
      TextEditingController();

  TextEditingController incomeRent = TextEditingController();
  TextEditingController expend = TextEditingController();
  TextEditingController profit = TextEditingController();

  void onAccountIncome() {
    Map<String, dynamic> param = Map();
    param["dormId"] = _dormId.toString();
    param["userId"] = _userId.toString();
    param["incomeRent"] = incomeRent.text;
    param["expend"] = expend.text;
    param["profit"] = sum().toString();

    http.post('${config.API_url}/income/add', body: param).then((response) {
      print(response.body);
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap['status'];
      if (status == 0) {
        return SweetAlert.show(context,
            title: "สำเร็จ!",
            subtitle: "เพิ่มรายรับ-รายจ่ายเรียบร้อยแล้ว",
            style: SweetAlertStyle.success);
      }
    });
  }

  int sum() {
    int total1 = 0;
    int total2 = 0;

    if (incomeRent.text != "") {
      total1 = int.parse(incomeRent.text);
    }
    if (expend.text != "") {
      total2 = int.parse(expend.text);
    }
    return total1 - total2;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
         backgroundColor: Colors.red[300],
        title: Text('การเพิ่มบัญชีรายรับ-รายจ่าย'),
      ),
      body: new ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Container(
            child: Center(
              child: RaisedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DataAccoutIncomPage(_dormId, _userId))); //ทดลอง
                },
                icon: Icon(Icons.remove_red_eye,color: Colors.white),
                label: Text('สรุปยอดรายรับ-รายจ่าย',style: TextStyle(color: Colors.white),),
                color: Colors.brown[400],
              ),
            ),
          ),
          new Card(
            margin: EdgeInsets.all(5),
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: new Row(
                    children: <Widget>[
                      new Text(' รายรับ',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.brown),),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: incomeRent,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.control_point),
                        hintText: 'Enter a amount',
                        labelText: 'รายรับค่าเช่า : บาท/เดือน',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.text,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: new Row(
                    children: <Widget>[
                      
                      new Text(' รายจ่าย',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.brown),),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    controller: expend,
                    decoration: InputDecoration(
                        icon: const Icon(Icons.control_point),
                        hintText: 'Enter a amount',
                        labelText: 'รายจ่ายทั่วไปทั้งหมด : บาท/เดือน',
                        labelStyle: TextStyle(fontSize: 15)),
                    keyboardType: TextInputType.text,
                  ),
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: new Row(
                    children: <Widget>[
                      
                      new Text(' กำไรต่อเดือนทั้งหมด : บาท/เดือน',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.brown),),
                    ],
                  ),
                ),
                incomeRent.text != "" || expend.text != ""
                    ? new Container(
                        padding: EdgeInsets.all(10),
                        child: Text('${sum()}'),
                      )
                    : new Container(
                        padding: EdgeInsets.all(10),
                        child: Text('0'),
                      ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new RaisedButton.icon(
                      onPressed: onAccountIncome,
                      textColor: Colors.white,
                      color: Colors.brown[400],
                      icon : Icon(Icons.save) , 
                      label: new Text('บันทึก'),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
