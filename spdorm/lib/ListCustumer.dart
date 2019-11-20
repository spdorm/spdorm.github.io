import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_string/random_string.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sweetalert/sweetalert.dart';
import 'dart:convert';
import 'config.dart';
import 'AddCharterDorm_fragment.dart';
import 'CreateCustomerData.dart';
import 'listManageCustomer.dart';

class listCustumerPage extends StatefulWidget {
  int _dormId, _userId, _roomId;

  listCustumerPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
  }

  @override
  State<StatefulWidget> createState() {
    return new _listCustumerPage(_dormId, _userId, _roomId);
  }
}

class _listCustumerPage extends State<listCustumerPage> {
  int _dormId, _userId, _roomId, _roomDoc;
  String roomNo, roomPrice;

  _listCustumerPage(int dormId, int userId, int roomId) {
    this._dormId = dormId;
    this._userId = userId;
    this._roomId = roomId;
    print(_dormId);
    print(_userId);
  }

  List lst = new List();
  String _FullName;
  bool _check = false;

  @override
  void initState() {
    super.initState();
    _createLayout();
  }

  void _createLayout() {
    Container head = Container(
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Container(
                margin: EdgeInsets.all(10),
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
                            builder: (BuildContext) => CreateCustomerDataPage(
                                _dormId, _userId, _roomId)));
                  },
                  textColor: Colors.red[300],
                  icon: Icon(Icons.add),
                  label: new Text(
                    '  ลงทะเบียนเพิ่มผู้เช่า',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.red[300],
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Center(
                child: Container(
                  margin: EdgeInsets.all(10),
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
                              builder: (BuildContext) => listManageCustumerPage(
                                  _dormId, _userId, _roomId)));
                    },
                    textColor: Colors.red[300],
                    icon: Icon(Icons.people),
                    label: new Text(
                      '  จัดการค่ามัดจำผู้เช่า',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red[300],
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            Divider(
              color: Colors.grey,
            ),
          ],
        ));
    setState(() {
      lst.add(head);
    });

    http.post('${config.API_url}/history/listByIdAndStatus', body: {
      "dormId": _dormId.toString(),
      "status": "รออนุมัติ"
    }).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      List temp = jsonData['data'];

      if (jsonData['status'] == 0 && temp.isNotEmpty) {
        for (int i = 0; i < temp.length; i++) {
          List data = temp[i];
          List dataUser = new List();
          _FullName = '${data[8]}' + ' ' + '${data[9]}';
          dataUser.add(data[7]);
          dataUser.add(_FullName);

          http.post("${config.API_url}/payment/list", body: {
            "userId": data[6].toString(),
            "dormId": _dormId.toString()
          }).then((response) {
            print(response.body);
            Map jsonData = jsonDecode(response.body) as Map;
            print(dataUser);
            if (jsonData['status'] == 0) {
              _check = true;
              _bodyWithBotton(data, dataUser);
            } else if (jsonData['status'] == 1) {
              _check = false;
              _bodyWithBotton(data, dataUser);
            }
          });
        }
      } else {
        _alert();
      }
    });
  }

  void _bodyWithBotton(List data, List dataUser) {
    Padding news = Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${  dataUser[1]}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.brown[400],
                        fontWeight: FontWeight.bold),
                  ),
                ),
                _check == true
                    ? FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext) =>
                                      CharterDormFragment(
                                          _dormId, _roomId, dataUser)));
                        },
                        textColor: Colors.blueGrey,
                        child: new Row(
                          children: <Widget>[
                            Icon(Icons.group_add),
                            new Text(' เลือก'),
                          ],
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(0),
                      )
              ],
            ),
          ),
          // Row(
          //   children: <Widget>[
          //     Text(
          //       'วันโพสต์ : ${(data['dateTime'].toString().substring(0, 10))}',
          //       style: TextStyle(color: Colors.grey),
          //     )
          //   ],
          // ),
          Divider(
            color: Colors.grey,
          ),
        ],
      ),
    );
    setState(() {
      lst.add(news);
    });
  }

  void _alert() {
    // Container alert = Container(
    //   margin: EdgeInsets.only(top: 500),
    //   child: Text('ไม่พบข้อมูลผู้ขอเข้าพัก'),
    // );
    // setState(() {
    //   lst.add(alert);
    // });

    SweetAlert.show(context,
        subtitle: "ไม่พบข้อมูลผู้ขอเข้าพัก!", style: SweetAlertStyle.error);
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
        backgroundColor: Colors.red[300],
        title: Text('คำขอเข้าหอพัก'),
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
