import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import 'dart:convert';
import 'Pending.dart';
import 'config.dart';

class PublishStatus extends StatefulWidget {
  int _dormId;
  String _nameDorm;

  PublishStatus(int dormId, String nameDorm) {
    this._nameDorm = nameDorm;
    this._dormId = dormId;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PublishStatus(_dormId, _nameDorm);
  }
}

Future<int> _getId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getInt('id'));
  return prefs.getInt('id');
}

class _PublishStatus extends State {
  int selectedDrawerIndex = 0;
  int _dormId;
  String _nameDorm, _nameImage = "";

  _PublishStatus(int dormId, String nameDorm) {
    this._nameDorm = nameDorm;
    this._dormId = dormId;
  }

  Image img;
  String _address, _promotion, _price, _detail;
  List lst = new List();
  int _userId;
  bool status = false;

  void initState() {
    super.initState();
    _getId().then((int userId) {
      this._userId = userId;
    });
    http.post('${config.API_url}/dorm/list',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      Map<String, dynamic> data = jsonData['data'];

      if (jsonData['status'] == 0) {
        _price = data['dormPrice'];
        _address = data['dormAddress'];
        _detail = data['dormDetail'];
        _promotion = data['dormPromotion'];

        if (data['dormImage'] == "" || data['dormImage'] == null) {
          setState(() {
            img = Image.asset('images/no_image.png');
          });
        } else {
          setState(() {
            img = Image.network(
                '${config.API_url}/dorm/image/?nameImage=${data['dormImage']}');
          });
        }
        _head();
        _body();
        getAPI();
      }
    });
  }

  void getAPI() {
    http.post('${config.API_url}/history/checkStatus', body: {
      "dormId": _dormId.toString(),
      "userId": _userId.toString(),
      "status": "รออนุมัติ"
    }).then((response) {
      Map jsonData = jsonDecode(response.body) as Map;

      if (jsonData['status'] == 0) {
        status = true;
      } else {
        status = false;
      }
      _button();
    });
  }

  void _head() {
    Container head = Container(
      height: 300,
      width: 300,
      child: Center(
        child: img,
      ),
    );
    setState(() {
      lst.add(head);
    });
  }

  void _body() {
    Column body = Column(
      children: <Widget>[
        Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'ที่อยู่ : ${_address}' +
                          '\n' +
                          'บรรยากาศ : ${_detail}\n' +
                          'ราคา : ${_price}\n' +
                          'โปรโมชั่น : ${_promotion}',
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
    setState(() {
      lst.add(body);
    });
  }

  void _button() {
    Row bt = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new RaisedButton(
          onPressed: status == false ? onAccept : onDelete,
          textColor: Colors.white,
          color: Colors.pinkAccent,
          child: status == false
              ? new Text('แจ้งเข้าพัก')
              : new Text('ยกเลิกคำขอ'),
        ),
        Padding(
          padding: EdgeInsets.only(left: 5),
        ),
        new RaisedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext) =>
                        pendingPage(_dormId, _nameDorm)));
          },
          textColor: Colors.white,
          color: Colors.pinkAccent,
          child: new Text('ข้อมูลติดต่อ'),
        ),
      ],
    );
    setState(() {
      lst.add(bt);
    });
  }

  void onAccept() {
    SweetAlert.show(context,
        subtitle: "คุณต้องการแจ้งเข้าพัก ?",
        style: SweetAlertStyle.confirm,
        showCancelButton: true, onPress: (bool isConfirm) {
      if (isConfirm) {
        _getId().then((int userId) {
          http.post('${config.API_url}/history/add', body: {
            "dormId": _dormId.toString(),
            "userId": userId.toString(),
            "historyStatus": "รออนุมัติ"
          }).then((response) {
            print(response.body);
            Map jsonData = jsonDecode(response.body) as Map;
            if (jsonData['status'] == 0) {
              setState(() {
                lst.removeLast();
                getAPI();
              });
            }
          });
        });
      }
    });
  }

  void onDelete() {
    SweetAlert.show(context,
        subtitle: "คุณต้องการยกเลิกคำขอ ?",
        style: SweetAlertStyle.confirm,
        showCancelButton: true, onPress: (bool isConfirm) {
      if (isConfirm) {
        _getId().then((int userId) {
          http.post('${config.API_url}/history/delete', body: {
            "dormId": _dormId.toString(),
            "userId": userId.toString(),
            "status": "รออนุมัติ"
          }).then((response) {
            Map jsonData = jsonDecode(response.body) as Map;
            print(response.body);
            if (jsonData['status'] == 0) {
              setState(() {
                lst.removeLast();
                getAPI();
              });
            }
          });
        });
      }
    });
  }

  Widget bodyBuild(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('${_nameDorm}'),
      ),
      body: new ListView.builder(
        //shrinkWrap: true,
        padding: const EdgeInsets.all(10.0),
        itemBuilder: bodyBuild,
        itemCount: lst.length,
      ),
    );
  }
}
