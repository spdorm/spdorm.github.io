import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import 'config.dart';
import 'dart:convert';
import 'DataDepositManagement.dart';

class depositManagementPage extends StatefulWidget {
  int _dormId, _userId, _roomId;
  depositManagementPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _depositManagementPage(_dormId, _userId, _roomId);
  }
}

class _depositManagementPage extends State {
  int _dormId, _userId, _roomId;
  _depositManagementPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _deposit = TextEditingController();
  String _fullName, _address, _email, _tel, _pledge = "";
  int balance = 0, _paymentAmount = 0, _check = 0;
  List<Widget> lst = List<Widget>();

  @override
  void initState() {
    http.post("${config.API_url}/user/list",
        body: {"userId": _userId.toString()}).then((response) {
      //print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      if (jsonData['status'] == 0) {
        Map<String, dynamic> data = jsonData['data'];
        // setState(() {
        _fullName = "${data['userFirstname']} ${data['userLastname']}";
        _address = data['userAddress'];
        _email = data['userEmail'];
        _tel = data['userTelephone'];
        // });

        http.post("${config.API_url}/room/listRoom", body: {
          "dormId": _dormId.toString(),
          "roomId": _roomId.toString()
        }).then((response) async {
          // print(response.body);
          Map jsonData = jsonDecode(response.body) as Map;
          if (jsonData['status'] == 0) {
            Map<String, dynamic> data = jsonData['data'];

            // setState(() {
            _pledge = data['pledge'];
            // });

            var responsePayment = await http
                .post("${config.API_url}/payment/list", body: {
              "userId": _userId.toString(),
              "dormId": _dormId.toString()
            });
            // print(responsePayment.body);
            Map jsonDataPay = jsonDecode(responsePayment.body) as Map;

            if (jsonDataPay['status'] == 0) {
              List temp = jsonDataPay['data'];

              for (int i = 0; i < temp.length; i++) {
                Map<String, dynamic> data = temp[i];
                _paymentAmount += int.parse(data['paymentAmount']);
                // _check++;
              }
              // setState(() {
              balance = int.parse(_pledge) - _paymentAmount;
              // });
            } else {
              // setState(() {
              balance = int.parse(_pledge);
              // });
            }
          } else {
            // setState(() {
            _pledge = "-";
            // });
          }
          setState(() {
           lst.add(_body()); 
          });
        });
      }
    });
    super.initState();
  }

  void onPressed() {
    bool _check = _formKey.currentState.validate();
    if (_check) {
      Map<String, dynamic> param = Map();
      param["dormId"] = _dormId.toString();
      param["roomId"] = _roomId.toString();
      param["userId"] = '${_userId}';
      param["paymentAmount"] = _deposit.text;
      http.post('${config.API_url}/payment/add', body: param).then((response) {
        print(response.body);
        Map jsonMap = jsonDecode(response.body) as Map;
        int status = jsonMap['status'];
        if (status == 0) {
          SweetAlert.show(context,
              title: "สำเร็จ!",
              subtitle: "เพิ่มค่ามัดจำแล้ว",
              style: SweetAlertStyle.success, onPress: (isTrue) {
            if (isTrue) {
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          depositManagementPage(_dormId, _userId, _roomId)));
            }
            return false;
          });
          // http.post('${config.API_url}/history/add', body: {
          //   "dormId": _dormId.toString(),
          //   "roomId": _roomId.toString(),
          //   "userId": _userId.toString(),
          //   "historyStatus": "รออนุมัติ"
          // }).then((response) {
          //   print(response.body);
          //   Map jsonMap = jsonDecode(response.body) as Map;
          //   int status = jsonMap['status'];
          //   if (status == 0) {
          //     SweetAlert.show(context,
          //         title: "สำเร็จ!",
          //         subtitle: "เพิ่มค่ามัดจำแล้ว",
          //         style: SweetAlertStyle.success, onPress: (isTrue) {
          //       if (isTrue) {
          //         Navigator.push(
          //             context,
          //             MaterialPageRoute(
          //                 builder: (BuildContext context) =>
          //                     depositManagementPage(
          //                         _dormId, _userId, _roomId)));
          //       }
          //     });
          //   } else {
          //     SweetAlert.show(context,
          //         title: "ผิดพลาด!",
          //         subtitle: "กรุณาลองใหม่ภายหลัง",
          //         style: SweetAlertStyle.confirm, onPress: (isTrue) {
          //       if (isTrue) {
          //         Navigator.pop(context);
          //       }
          //     });
          //   }
          // });
        }
      });
    }
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${_fullName}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.brown[400],
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'ที่อยู่ : ${_address}',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown[300],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'อีเมล : ${_email}',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown[300],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'เบอร์โทรศัพท์ : ${_tel}',
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.brown[300],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'ค่าประกันทั้งหมด : ${_pledge} บาท',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.brown[400],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Card(
            margin: EdgeInsets.all(10),
            child: new Column(
              children: <Widget>[
                new Container(
                  padding:
                      EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                  child: Form(
                    key: _formKey,
                    child: TextFormField(
                      readOnly: balance == 0 ? true : false,
                      controller: _deposit,
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a amount',
                          labelText: 'จำนวนเงินมัดจำ',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.number,
                      validator: (String value) {
                        if (value.trim().isEmpty) {
                          return "กรุณากรอกจำนวนเงินค่ามัดจำ";
                        } else if (int.parse(value) > int.parse(_pledge)) {
                          return "จำนวนเงินมัดจำมากกว่าเงินมัดจำทั้งหมด";
                        } else if (int.parse(value) > balance) {
                          return "จำนวนเงินมัดจำมากกว่าเงินมัดจำคงเหลือ";
                        }
                      },
                    ),
                  ),
                ),
                new Column(
                  children: <Widget>[
                    Center(
                      child: new RaisedButton.icon(
                        onPressed: balance != 0 ? onPressed : null,
                        textColor: Colors.white,
                        color: Colors.brown[400],
                        icon: Icon(Icons.save),
                        label: new Text('บันทึก'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'ค่าประกันคงเหลือ : ${balance} บาท',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.brown[400],
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Divider(
            color: Colors.grey,
          ),
          new Column(
            children: <Widget>[
              Center(
                child: new RaisedButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext) => dataDepositManagePage(
                                _dormId, _userId, _roomId)));
                  },
                  textColor: Colors.white,
                  color: Colors.brown[400],
                  icon: Icon(Icons.markunread_mailbox),
                  label: new Text('ประวัติการชำระค่ามัดจำ'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.red[300],
          title: Text('จัดการเงินค่ามัดจำ'),
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   onPressed: () {
          //     Navigator.pop(context);
          //     Navigator.pushReplacement(
          //         context,
          //         MaterialPageRoute(
          //             builder: (BuildContext context) =>
          //                 listManageCustumerAllPage(_dormId, _userId)));
          //   },
          // ),
        ),
        resizeToAvoidBottomPadding: true,
        body: ListView.builder(
          itemCount: lst.length,
          itemBuilder: (BuildContext context, int index) {
            return lst[index];
          },
        ));
  }
}
