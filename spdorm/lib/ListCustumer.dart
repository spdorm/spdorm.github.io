import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sweetalert/sweetalert.dart';
import 'dart:convert';
import 'config.dart';
import 'AddCharterDorm_fragment.dart';

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
  }

  List lst = new List();  
  String _FullName;

  @override
  void initState() {    
    super.initState();
    _createLayout();
  }

  void _createLayout() {
    // Container head = Container(
    //   margin: EdgeInsets.all(10),
    //   decoration: BoxDecoration(
    //     border: Border.all(color: Colors.grey),
    //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
    //   ),
    //   child: Center(
    //     child: Text(
    //       "คำขอเข้าหอพัก",
    //       style: TextStyle(fontSize: 18, color: Colors.green),
    //     ),
    //   ),
    // );
    // setState(() {
    //   lst.add(head);
    // });

    http.post('${config.API_url}/history/listByIdAndStatus',
        body: {"dormId": _dormId.toString(),"status":"รออนุมัติ"}).then((response) {
          print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      List temp = jsonData['data'];

      if (jsonData['status'] == 0 && temp.isNotEmpty) {
        for (int i = 0; i < temp.length; i++) {
          List data = temp[i];
          List dataUser = new List();
          _FullName = '${data[8]}'+' '+'${data[9]}';
          dataUser.add(data[7]);
          dataUser.add(_FullName);
          _body(data,dataUser);    
        }
      }else{
        _alert();
      }
    });
  }

  void _body(List data,List dataUser) {
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
                    '${_FullName}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext) =>
                                CharterDormFragment(_dormId, _roomId,dataUser)));
                  },
                  textColor: Colors.green,
                  child: new Row(
                    children: <Widget>[
                      Icon(Icons.group_add),
                      new Text(' เลือก'),
                    ],
                  ),
                ),
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

  void _alert(){
    // Container alert = Container(
    //   margin: EdgeInsets.only(top: 500),
    //   child: Text('ไม่พบข้อมูลผู้ขอเข้าพัก'),
    // );
    // setState(() {
    //   lst.add(alert);
    // });

    SweetAlert.show(context,
              subtitle: "ไม่พบข้อมูลผู้ขอเข้าพัก!",
              style: SweetAlertStyle.error);
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
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
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
