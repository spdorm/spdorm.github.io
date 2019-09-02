import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import 'config.dart';
import 'mainHomeFragment.dart';

class vieWDocument extends StatefulWidget {
  int _dormId, _roomId;
  vieWDocument(int dormId, int roomId) {
    this._dormId = dormId;
    this._roomId = roomId;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _vieWDocument(_dormId, _roomId);
  }
}

class _vieWDocument extends State {
  int _dormId, _roomId;
  _vieWDocument(int dormId, int roomId) {
    this._dormId = dormId;
    this._roomId = roomId;
  }

  String _roomNo, _roomPrice, _roomType, _roomDoc = "", _customer;
  var img;

  void initState() {
    super.initState();
    http.post('${config.API_url}/room/listRoom', body: {
      "dormId": _dormId.toString(),
      "roomId": _roomId.toString()
    }).then((respone) {
      Map jsonData = jsonDecode(respone.body) as Map;
      Map<String, dynamic> dataMap = jsonData["data"];

      if (jsonData["status"] == 0) {
        _roomNo = dataMap["roomNo"];
        _roomPrice = dataMap["roomPrice"];
        _roomDoc = dataMap["roomDocument"];
        _roomType = dataMap["roomType"];

        if (_roomDoc == "") {
          img = null;
        } else {
          img = Container(
            width: 500,
            height: 500,
            color: Colors.white,
            child: PhotoView(
              imageProvider: NetworkImage(
                '${config.API_url}/room/image/?nameImage=${_roomDoc}',
              ),
            ),
          );
        }
        setState(() {});
      }
    });
  }

  Future<int> _getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }

  void _onPressed() {
    return SweetAlert.show(context,
        subtitle: "คุณต้องการยกเลิกสัญญาเช่า ?",
        style: SweetAlertStyle.confirm,
        showCancelButton: true, onPress: (bool isConfirm) {
      if (isConfirm) {
        SweetAlert.show(context,
            subtitle: "กำลังลบ...", style: SweetAlertStyle.loading);
        new Future.delayed(new Duration(seconds: 1), () {
          http.post('${config.API_url}/room/cancelRent',
              body: {"roomId": _roomId.toString()}).then((response) {
                print(response.body);
            Map jsonData = jsonDecode(response.body) as Map;
            if (jsonData["status"] == 0) {
              _getId().then((int userId) {
                // Navigator.pop(context);
                // Navigator.pop(context);
                // Navigator.pop(context);
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext) =>
                //             MainHomeFragment(_dormId, userId)));
                SweetAlert.show(context,
                    subtitle: "สำเร็จ!",
                    style: SweetAlertStyle.success, onPress: (bool isConfirm) {
                  if (isConfirm) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext) =>
                                MainHomeFragment(_dormId, userId)));
                  }
                  return false;
                });
              });
            }
          });
        });
      } else {
        SweetAlert.show(context,
            subtitle: "ยกเลิก!", style: SweetAlertStyle.error);
      }
      // return false to keep dialog
      return false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('สัญญาเช่า'),
      ),
      body: ListView(
        padding: EdgeInsets.all(5),
        children: <Widget>[
          Card(
            child: Column(
              children: <Widget>[
                Text(
                  'หมายเลขห้อง : ${_roomNo}',
                  style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                ),
                Text(
                  'ราคาเช่า : ${_roomPrice}',
                  style: TextStyle(fontSize: 18, color: Colors.orangeAccent),
                ),
                Text(
                  'สัญญาเช่า',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: img == null
                      ? Text(
                          'ไม่พบรูปสัญญาเช่า',
                          style: TextStyle(color: Colors.red),
                        )
                      : img,
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: RaisedButton(
                    child: Text(
                      'ยกเลิกสัญญาเช่า',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: _onPressed,
                    color: Colors.redAccent,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
