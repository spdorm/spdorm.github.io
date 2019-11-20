import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:async/async.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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

  String _roomNo, _roomPrice, _roomType, _roomDoc = "", _customer, _username;
  var img;
  bool checkImg = false;
  File _image;
  int _userId;

  void initState() {
    super.initState();

    http.post('${config.API_url}/room/listRoom', body: {
      "dormId": _dormId.toString(),
      "roomId": _roomId.toString(),
    }).then((respone) async {
      print(respone.body);
      Map jsonData = jsonDecode(respone.body) as Map;
      Map<String, dynamic> dataMap = jsonData["data"];

      if (jsonData["status"] == 0) {
        _roomNo = dataMap["roomNo"];
        _roomPrice = dataMap["roomPrice"];
        _roomDoc = dataMap["roomDocument"];
        _roomType = dataMap["roomType"];
        _userId = dataMap["userId"];

        var resUser = await http.post('${config.API_url}/user/list',
            body: {"userId": _userId.toString()});

        Map jsonData = jsonDecode(resUser.body) as Map;
        print(resUser.body);
        if (jsonData["status"] == 0) {
          Map<String, dynamic> dataUser = jsonData["data"];
          _username = dataUser['userUsername'];
          print(_username);
        }

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

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (imageFile != null) {
      checkImg = true;
    } else {
      checkImg = false;
    }
    setState(() {
      _image = imageFile;
    });
  }

  Future upload(File imageFile) async {
    print(_roomNo);
    if (imageFile != null) {
      SweetAlert.show(context,
          subtitle: "กำลังอัปโหลดรูปภาพ...", style: SweetAlertStyle.loading);
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.parse("${config.API_url}/room/saveImage");

      var request = new http.MultipartRequest("POST", uri);
      var multipartFile = new http.MultipartFile("file", stream, length,
          filename: path.basename(imageFile.path));
      request.fields['roomId'] = '$_roomId';
      request.fields['roomNo'] = _roomNo.toString();
      request.fields['userName'] = _username.toString();
      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        print("Image Uploaded");
        SweetAlert.show(context,
            subtitle: "สำเร็จ!",
            style: SweetAlertStyle.success, onPress: (bool isTrue) {
          if (isTrue) {
            _getId().then((int userId) {
              Navigator.pop(context);
              // Navigator.pop(context);
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext) =>
              //             MainHomeFragment(_dormId, userId)));
            });
          }
        });
      } else {
        print("Upload Failed");
      }
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
  }

  Future<int> _getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('id');
  }

  void onDataDorm() {
    if (_image != null) {
      upload(_image);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.red[300],
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
                !checkImg
                    ? Padding(
                        padding: EdgeInsets.all(5),
                        child: img == null
                            ? Text(
                                'ไม่พบรูปสัญญาเช่า',
                                style: TextStyle(color: Colors.blueGrey[200]),
                              )
                            : Container(
                                width: 500,
                                height: 500,
                                color: Colors.white,
                                child: PhotoView(
                                  imageProvider: NetworkImage(
                                    '${config.API_url}/room/image/?nameImage=${_roomDoc}',
                                  ),
                                ),
                              ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(0),
                      ),
                checkImg
                    ? Container(
                        width: 500,
                        height: 500,
                        color: Colors.white,
                        child: PhotoView(
                          imageProvider: FileImage(_image),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(0),
                      ),
                img == null && !checkImg
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          checkImg
                              ? Container(
                                  padding: EdgeInsets.only(right: 5),
                                  child: RaisedButton(
                                    child: Text('บันทึกรูปสัญญาเช่า'),
                                    onPressed: onDataDorm,
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(0),
                                ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: RaisedButton(
                              child: Text('เพิ่มรูปสัญญาเช่า'),
                              onPressed: getImageGallery,
                            ),
                          )
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          checkImg
                              ? Container(
                                  padding: EdgeInsets.only(right: 5),
                                  child: RaisedButton(
                                    child: Text('บันทึกรูปสัญญาเช่า'),
                                    onPressed: onDataDorm,
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.all(0),
                                ),
                          Container(
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            child: RaisedButton(
                              child: Text('แก้ไขรูปภาพ'),
                              onPressed: getImageGallery,
                            ),
                          )
                        ],
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
