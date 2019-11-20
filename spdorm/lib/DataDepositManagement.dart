import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'ConvertDateTime.dart';
import 'CheckOut.dart';

class dataDepositManagePage extends StatefulWidget {
  int _dormId, _userId, _roomId;
  dataDepositManagePage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _dataDepositManagePage(_dormId, _userId, _roomId);
  }
}

class _dataDepositManagePage extends State {
  int _dormId, _userId, _roomId;
  _dataDepositManagePage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  List<Widget> lst = new List<Widget>();
  String _FullName, _pledge, _amount, _datTime;
  int balance = 0, _paymentAmount = 0;
  int _check = 0;

  @override
  void initState() {
    if (_roomId != 0) {
      http.post("${config.API_url}/room/listRoom", body: {
        "dormId": _dormId.toString(),
        "roomId": _roomId.toString()
      }).then((response) async {
        Map jsonData = jsonDecode(response.body) as Map;
        if (jsonData['status'] == 0) {
          Map<String, dynamic> data = jsonData['data'];

          _pledge = data['pledge'];

          var res_sumAmount = await http
              .post('${config.API_url}/payment/sumAmount', body: {
            "dormId": _dormId.toString(),
            "userId": _userId.toString()
          });
          Map jsonDataSumAmount = jsonDecode(res_sumAmount.body) as Map;
          print(res_sumAmount.body);

          if (jsonDataSumAmount['status'] == 0) {
            double temp = jsonDataSumAmount['data'];
            balance = int.parse(_pledge) - temp.toInt();
            setState(() {
              lst.insert(0, _createLayout());
            });
          }

          http.post("${config.API_url}/payment/list", body: {
            "userId": _userId.toString(),
            "dormId": _dormId.toString()
          }).then((response) {
            // print(response.body);
            Map jsonData = jsonDecode(response.body) as Map;
            if (jsonData['status'] == 0) {
              List temp = jsonData['data'];
              convertDateTime a = convertDateTime();
              for (int i = 0; i < temp.length; i++) {
                Map<String, dynamic> data = temp[i];

                _amount = data['paymentAmount'];
                _datTime = a.convertToThai(data['dateTime']);
                this._body();
              }
              setState(() {
                balance == 0 ? lst.insert(lst.length, _button()) : null;
              });
            }
          });
        }
      });
    } else {
      http.post("${config.API_url}/payment/list", body: {
        "userId": _userId.toString(),
        "dormId": _dormId.toString()
      }).then((response) {
        // print(response.body);
        Map jsonData = jsonDecode(response.body) as Map;
        if (jsonData['status'] == 0) {
          List temp = jsonData['data'];

          setState(() {
            lst.insert(0, _createLayout());
          });

          convertDateTime a = convertDateTime();
          for (int i = 0; i < temp.length; i++) {
            Map<String, dynamic> data = temp[i];

            _amount = data['paymentAmount'];
            _datTime = a.convertToThai(data['dateTime']);
            this._body();
          }
        }
      });
    }
    super.initState();
  }

  Widget _createLayout() {
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Center(
            child: _roomId != 0
                ? Text(
                    "ยอดเงินมัดจำค้างชำระ : ${balance} บาท",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red[300],
                        fontWeight: FontWeight.bold),
                  )
                : Text(
                    "ยังไม่มีห้องพัก",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red[300],
                        fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }

  void _body() {
    Padding dataDeposit = Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(0),
            child: Container(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'ชำระค่ามัดจำแล้ว : ${_amount} บาท',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.brown[400],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'วันที่ชำระ : ${_datTime}',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
    setState(() {
      lst.add(dataDeposit);
    });
  }

  Widget _button() {
    return Center(
      child: Container(
        // margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: FlatButton.icon(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => checkOutPage(
                          _dormId, _userId, _roomId)));
          },
          textColor: Colors.red[300],
          icon: Icon(Icons.open_in_new),
          label: new Text(
            ' ออกหอพัก',
            style: TextStyle(
                fontSize: 18,
                color: Colors.red[300],
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1));
    lst.clear();
    setState(() {
      this._createLayout();
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
        backgroundColor: Colors.red[300],
        title: Text('ประวัติการชำระค่ามัดจำ'),
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
