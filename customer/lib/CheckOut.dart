import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import 'dart:convert';
import 'config.dart';
import 'mainHomDorm.dart';

class CheckOutPage extends StatefulWidget {
  int _dormId, _userId, _roomId;
  CheckOutPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _CheckOutPage(_dormId, _userId, _roomId);
  }
}

class _CheckOutPage extends State<CheckOutPage> {
  int selectedDrawerIndex = 0;
  int _dormId, _userId, _roomId;
  _CheckOutPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  List lst = new List();
  String _FullName;

  @override
  void initState() {
    super.initState();
    _createLayout();
  }

  void _createLayout() {
    Padding head = Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                "เรียนผู้เช่า ควรแจ้งก่อนย้ายออกล่วงหน้า 1 เดือน ตามกฏที่หอพักกำหนดไว้ เพื่อเป็นผลประโยชน์สำหรับผู้เช่า",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red[300],
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text("โปรดติดต่อเจ้าของหอ : ${0853881970}",
              style: TextStyle(color: Colors.yellow[700]),)
                ],
              )
            ),
          ),
        ],
      ),
    );
    setState(() {
      lst.add(head);
    });
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    lst.clear();
    setState(() {
      _createLayout();
    });
    return null;
  }

  Widget buildBody(BuildContext context, int index) {
    return lst[index];
  }

  final TextEditingController _multiLineTextFieldcontroller =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[300],
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('ขอออกหอพัก'),
      ),
      body: RefreshIndicator(
        child: ListView.builder(
          itemBuilder: buildBody,
          itemCount: lst.length,
        ),
        onRefresh: _onRefresh,
      ),
    );
  }
}
