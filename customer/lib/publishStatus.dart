import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

class _PublishStatus extends State {
  int selectedDrawerIndex = 0;
  int _dormId;
  String _nameDorm, _nameImage = "";

  _PublishStatus(int dormId, String nameDorm) {
    this._nameDorm = nameDorm;
    this._dormId = dormId;
  }

  String _address, _promotion, _price, _detail;
  void initState() {
    super.initState();
    http.post('${config.API_url}/dorm/list',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      Map<String, dynamic> data = jsonData['data'];
      _price = data['dormPrice'];
      _address = data['dormAddress'];
      _detail = data['dormDetail'];
      _promotion = data['dormPromotion'];
      setState(() {});
    });

    http.post('${config.API_url}/dorm/findImageDorm',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      if (jsonData["status"] == 0) {
        setState(() {
          _nameImage = jsonData["data"];
        });
      }
    });
  }

  void onSubmit() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext) => pendingPage(_dormId, _nameDorm)));
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('${_nameDorm}'),
      ),
      body: new ListView(
        //shrinkWrap: true,
        padding: const EdgeInsets.all(10.0),
        children: <Widget>[
          _nameImage != ""
              ? Container(
                  child: Center(
                    child: Image.network(
                        '${config.url_upload}/upload/image/dorm/${_nameImage}'),
                  ),
                )
              : Container(
                  child: Center(
                    child: Image.network(
                        '${config.url_upload}/upload/image/no_image.png'),
                  ),
                ),
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
          Container(
            child: Container(
              child: Center(
                child: new RaisedButton(
                  onPressed: onSubmit,
                  textColor: Colors.white,
                  color: Colors.pinkAccent,
                  child: new Text('แจ้งเข้าพัก'),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
