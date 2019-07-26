import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'config.dart';
import 'publishStatus.dart';

class ListDormPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ListDormPage();
  }
}

class _ListDormPage extends State {
  List lst = new List();

  String _address, _promotion, _price, _detail, _nameImage = "";

  void initState() {
    super.initState();
    http.post('${config.API_url}/dorm/listAll').then((respone) {
      print(respone.body);
      Map jsonData = jsonDecode(respone.body);
      List temp = jsonData["data"];
      Color color;

      for (int i = 0; i < temp.length; i++) {
        List data = temp[i];

        http.post('${config.API_url}/dorm/findImageDorm',
            body: {"dormId": data[0].toString()}).then((response) {
          print(response.body);
          Map jsonData = jsonDecode(response.body) as Map;
          if (jsonData["status"] == 0) {
            setState(() {
              _nameImage = jsonData["data"];
            });
          }
        });

        http.post('${config.API_url}/room/countStatus',
            body: {"dormId": data[0].toString()}).then((response) {
          Map jsonData = jsonDecode(response.body) as Map;
          int count = jsonData['data'];

          if (count == 0) {
            color = Colors.red;
          } else {
            color = Colors.green;
          }

          FlatButton dormInfo = FlatButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext) =>
                          PublishStatus(data[0], data[6])));
            },
            child: Card(
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      _nameImage != ""
                          ? Container(
                              child: Center(
                                child: Image.network(
                                    '${config.url_upload}/upload/image/dorm/${_nameImage}',height: 100,width: 100,),
                              ),
                            )
                          : Container(
                              child: Center(
                                child: Image.network(
                                    '${config.url_upload}/upload/image/no_image.png',height: 100,width: 100,),
                              ),
                            ),
                    ],
                  ),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Text(
                        '${data[6]}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue),
                      ),
                      Text('ราคา : ${data[7]}',
                          style: TextStyle(color: Colors.orange)),
                      Text('โปรโมชัน : ${data[8]}'),
                      Text(
                        'จำนวนห้องว่าง : ${count}',
                        style: TextStyle(color: color),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          );
          lst.add(dormInfo);
          setState(() {});
        });
      }
    });
  }

  Future<bool> _onClose() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('คุณต้องการออกจากแอปหรือไม่'),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('ใช่')),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('ไม่ใช่')),
            ],
          );
        });
  }

  Widget buildBody(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: _onClose,
        child: Scaffold(
          appBar: AppBar(title: const Text('หอพัก')),
          body: ListView.builder(itemBuilder: buildBody, itemCount: lst.length),
        ),
      ),
    );
  }
}
