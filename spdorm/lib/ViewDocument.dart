import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

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
      print(respone.body);
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
          img = Image.network(
            '${config.url_upload}/upload/image/charter/${_roomDoc}',
            height: 500,
            width: 500,
          );
        }
        setState(() {});
      }
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
                  child: img,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
