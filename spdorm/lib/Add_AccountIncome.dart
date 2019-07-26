import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'DataAccountIncome.dart';
import 'mainHomeFragment.dart';


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
        Navigator.pop(context);
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
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('การเพิ่มบัญชีรายรับ-รายจ่าย'),
        leading: Builder(
    builder: (BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () { Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext)=>MainHomeFragment(_dormId,_userId))); },
      );
    },
  ),
      ),
      body: new ListView(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Center(
              child: RaisedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DataAccoutIncomPage(1))); //ทดลอง
                },
                icon: Icon(Icons.search),
                label: Text('ประวัติรายรับรายจ่ายทั้งหมด'),
                color: Colors.yellow[600],
              ),
            ),
          ),
          Text(':รายละเอียดข้อมูลบัญชีรายรับ-รายจ่าย'),
          new Card(
            margin: EdgeInsets.all(5),
            child: new Column(
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: new Row(
                    children: <Widget>[
                      new Icon(Icons.label_important),
                      new Text('รายรับ:'),
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
                      new Icon(Icons.label_important),
                      new Text('รายจ่าย:'),
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
                      new Icon(Icons.label_important),
                      new Text('กำไรต่อเดือนทั้งหมด : บาท/เดือน'),
                    ],
                  ),
                ),
                incomeRent.text != "" || expend.text != ""
                    ? new Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Text('${sum()}'),
                      )
                    : new Container(
                        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Text('0'),
                      ),
                new Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 70, top: 5, right: 1),
                      child: new RaisedButton(
                        onPressed: onAccountIncome,
                        textColor: Colors.white,
                        color: Colors.blue,
                        child: new Row(
                          children: <Widget>[
                            new Text('บันทึก'),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 1, top: 5),
                      child: new RaisedButton(
                        onPressed: () {},
                        textColor: Colors.white,
                        color: Colors.blueGrey,
                        child: new Row(
                          children: <Widget>[
                            new Text('แก้ไข'),
                          ],
                        ),
                      ),
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
