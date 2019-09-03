import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sweetalert/sweetalert.dart';
import 'config.dart';
import 'dart:convert';

import 'mainHomeFragment.dart';

class CharterDormFragment extends StatefulWidget {
  int _dormId, _roomId;
  List _user = new List();
  CharterDormFragment(int dormId, int roomId, List user) {
    this._dormId = dormId;
    this._roomId = roomId;
    this._user = user;

    print(_user);
  }
  @override
  State<StatefulWidget> createState() {
    return new CharterDormFragmentState(_dormId, _roomId, _user);
  }
}

class CharterDormFragmentState extends State<CharterDormFragment> {
  int _dormId, _roomId;
  List _user = new List();
  CharterDormFragmentState(int dormId, int roomId, List user) {
    this._dormId = dormId;
    this._roomId = roomId;
    this._user = user;
  }

  File _image, _see;
  List lst = new List();
  String _roomNo;

  @override
  void initState() {
    super.initState();
    _body();
  }

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 1024, maxHeight: 1024);
    lst.clear();
    setState(() {
      _image = imageFile;
      _body();
    });
  }

  Future getImageCamera() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = imageFile;
    });
  }

  // Future upload(File imageFile) async {
  //   if (imageFile != null) {
  //     var stream =
  //         new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  //     var length = await imageFile.length();
  //     var uri = Uri.parse("${config.API_url}/room/saveImage");

  //     var request = new http.MultipartRequest("POST", uri);
  //     print(path.basename(imageFile.path));
  //     var multipartFile = new http.MultipartFile("file", stream, length,
  //         filename: path.basename(imageFile.path));
  //     request.fields['roomId'] = _roomId.toString();
  //     request.fields['roomNo'] = _roomNo.toString();
  //     request.fields['userName'] = _user[0].toString();
  //     request.files.add(multipartFile);

  //     var response = await request.send();

  //     if (response.statusCode == 200) {
  //       print("Image Uploaded");
  //     } else {
  //       print("Upload Failed");
  //     }
  //     response.stream.transform(utf8.decoder).listen((value) {
  //       print(value);
  //     });
  //   } else {
  //     return;
  //   }
  // }

  Future upload(File imageFile) {
    if (imageFile != null) {
      SweetAlert.show(context,
          subtitle: "กำลังอัพโหลดรูปภาพ...", style: SweetAlertStyle.loading);
      new Future.delayed(new Duration(seconds: 1), () async {
        var stream =
            new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        var length = await imageFile.length();
        var uri = Uri.parse("${config.API_url}/room/saveImage");

        var request = new http.MultipartRequest("POST", uri);
        var multipartFile = new http.MultipartFile("file", stream, length,
            filename: path.basename(imageFile.path));
        request.fields['roomId'] = _roomId.toString();
        request.fields['roomNo'] = _roomNo.toString();
        request.fields['userName'] = _user[0].toString();
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
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext) =>
                            MainHomeFragment(_dormId, userId)));
              });
            }
          });
        } else {
          print("Upload Failed");
        }
        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
        });
      });
    }
  }

  TextEditingController roomDocument = TextEditingController();

  Future alartDialog(String str) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('คุณต้องการออกจากระบบ ?'),
        actions: <Widget>[
          FlatButton(
            child: Text('ไม่ใช่'),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text('ใช่'),
            onPressed: () => {},
          ),
        ],
      ),
    );
  }

  Future<int> _getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getInt('id'));
    return prefs.getInt('id');
  }

  void onDataDorm() {
    Map<String, dynamic> param = Map();
    param["roomId"] = _roomId.toString();
    param["userName"] = _user[0].toString();

    http
        .post('${config.API_url}/room/updateCustomerToRoom', body: param)
        .then((response) {
      print(response.body);
      Map jsonMap = jsonDecode(response.body) as Map;
      int status = jsonMap['status'];
      if (status == 0) {
        if (_image != null) {
          upload(_image);
        } else {
          SweetAlert.show(context,
              subtitle: "สำเร็จ!",
              style: SweetAlertStyle.success, onPress: (bool isTrue) {
            if (isTrue) {
              _getId().then((int userId) {
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext) =>
                            MainHomeFragment(_dormId, userId)));
              });
            }
          });
        }
      }
    });
  }

  void _body() {
    http.post('${config.API_url}/room/listRoom', body: {
      "dormId": _dormId.toString(),
      "roomId": _roomId.toString()
    }).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      //     List temp = jsonData['data'];

      if (jsonData['status'] == 0) {
        //       for (int i = 0; i < temp.length; i++) {
        Map<String, dynamic> data = jsonData['data'];
        _roomNo = data['roomNo'];
        print(_roomId);
        print(_roomNo);
        print(_user[0]);
        Text head = Text(':รายละเอียดข้อมูลสัญญาเช่า');
        Card body = Card(
          margin: EdgeInsets.all(5),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Text(
                  'หมายเลขห้อง : ${data['roomNo']}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
              ),
              new Container(
                //padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Text(
                  'บัญชีผู้ขอเช่า : ${_user[0]}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent),
                ),
              ),
              new Container(
                //padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Text(
                  '${_user[1]}',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
              ),
              new Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: new Row(
                  children: <Widget>[
                    new Icon(Icons.image),
                    new Text('ใบสัญญาเช่า:'),
                  ],
                ),
              ),
              new Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: _image == null
                    ? Text('No image selected.')
                    : Image.file(_image),
              ),
              new Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: FloatingActionButton(
                  onPressed: getImageGallery,
                  tooltip: 'Pick Image',
                  child: Icon(Icons.add_a_photo),
                ),
              ),
              new Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 70, top: 5, right: 1),
                    child: new RaisedButton(
                      onPressed: onDataDorm,
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: new Row(
                        children: <Widget>[
                          new Text('บันทึก'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 1, top: 5),
                    child: new RaisedButton(
                      onPressed: () {},
                      textColor: Colors.white,
                      color: Colors.blueGrey,
                      child: new Row(
                        children: <Widget>[
                          new Text('แก้ไข'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
        setState(() {
          lst.add(head);
          lst.add(body);
        });
//        }
      }
    });
  }

  Widget bodyBuild(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: const Text('เพิ่มใบสัญญาเช่า')),
      body: new ListView.builder(
        padding: EdgeInsets.only(left: 15, right: 15, top: 20),
        itemBuilder: bodyBuild,
        itemCount: lst.length,
      ),
    );
  }
}
