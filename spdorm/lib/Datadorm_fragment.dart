import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:sweetalert/sweetalert.dart';
import 'config.dart';
import 'dart:convert';

import 'mainHomeFragment.dart';

class DataDormFragment extends StatefulWidget {
  int _dormId, _userId;
  DataDormFragment(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    return new DataDormFragmentState(_dormId, _userId);
  }
}

class DataDormFragmentState extends State<DataDormFragment> {
  int _dormId, _userId;
  DataDormFragmentState(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }

  final TextEditingController _multiLineTextFieldcontroller =
      TextEditingController();
  File _image;
  bool checkImg = false;

  List<String> _status = ["active", "inactive"].toList();
  List lst = new List();
  String _selectedStatus;

  String dormImage = "", _status_db;
  TextEditingController dormName = TextEditingController();
  TextEditingController dormAddress = TextEditingController();
  TextEditingController dormPhone = TextEditingController();
  TextEditingController dormEmail = TextEditingController();
  TextEditingController dormFloor = TextEditingController();
  TextEditingController dormPrice = TextEditingController();
  TextEditingController dormPromotion = TextEditingController();
  TextEditingController dormDetail = TextEditingController();

  void initState() {
    super.initState();
    http.post('${config.API_url}/dorm/list',
        body: {"dormId": _dormId.toString()}).then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body);
      Map<String, dynamic> dataMap = jsonData["data"];

      if (jsonData['status'] == 0) {
        dormName.text = dataMap['dormName'];
        dormAddress.text = dataMap['dormAddress'];
        dormPhone.text = dataMap['dormTelephone'];
        dormEmail.text = dataMap['dormEmail'];
        dormFloor.text = dataMap['dormFloor'];
        dormPrice.text = dataMap['dormPrice'];
        dormPromotion.text = dataMap['dormPromotion'];
        dormDetail.text = dataMap['dormDetail'];
        dormImage = dataMap['dormImage'];
        _selectedStatus = dataMap['dormStatus'];
        cardShow(0);
      }
    });
  }

  void cardShow(int state) {
    Card show = Card(
      child: new Column(
        children: <Widget>[
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.image,color: Colors.blue,),
                new Text(' รูปหอพัก :',style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          dormImage == null || checkImg == true || dormImage == ""
              ? new Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: _image == null
                      ? Text('No image selected.')
                      : Image.file(_image),
                )
              : Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    child: Image.network(
                        '${config.API_url}/dorm/image/?nameImage=${dormImage}'),
                  ),
                ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: FloatingActionButton(
              onPressed: getImageGallery,
              tooltip: 'เลือกรูป',
              child: Icon(Icons.image),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 20, right: 10, top: 20.0),
                child: Text("สถานะ :",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              new DropdownButton<String>(
                  value: _selectedStatus,
                  items: _status.map((String value) {
                    return new DropdownMenuItem(
                        value: value, child: new Text(value));
                  }).toList(),
                  onChanged: (String value) {
                    onStatusChange(value);
                  }),
            ],
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: dormName,
              decoration: InputDecoration(
                  icon: const Icon(Icons.home,color: Colors.pink,),
                  hintText: '** คลิกเพื่อเพิ่มชื่อหอพัก **',
                  labelText: 'ชื่อหอพัก:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: dormAddress,
              decoration: InputDecoration(
                  icon: const Icon(Icons.add_location,color: Colors.green,),
                  hintText: '** คลิกเพื่อเพิ่มที่อยู่ **',
                  labelText: 'ที่อยู่:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: dormPhone,
              decoration: InputDecoration(
                  icon: const Icon(Icons.phone_android),
                  hintText: '** คลิกเพื่อเพิ่มเบอร์โทรศัพท์ **',
                  labelText: 'เบอร์โทรศัพท์:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: dormEmail,
              decoration: InputDecoration(
                  icon: const Icon(Icons.email,color: Colors.orange,),
                  hintText: '** คลิกเพื่อนเพิ่มอีเมล **',
                  labelText: 'อีเมล:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: dormFloor,
              decoration: InputDecoration(
                  icon: const Icon(Icons.add_circle,color: Colors.indigo,),
                  hintText: '** คลิกเพื่อเพิ่มจำนวนชั้นหอพัก **',
                  labelText: 'จำนวนชั้นหอพัก:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextFormField(
              controller: dormPrice,
              decoration: InputDecoration(
                  icon: const Icon(Icons.attach_money,color: Colors.purple,),
                  hintText: '** คลิกเพื่อเพิ่มราคาห้องพัก',
                  labelText: 'ราคาห้องพัก:',
                  labelStyle: TextStyle(fontSize: 15)),
              keyboardType: TextInputType.text,
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.content_paste,color: Colors.yellow[700],),
                new Text(' โปรโมชั่น:',style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextField(
              controller: dormPromotion,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '** คลิกเพื่อเพิ่มโปรโมชั่นหอพัก **',
              ),
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: new Row(
              children: <Widget>[
                new Icon(Icons.star_half,color: Colors.red[300],),
                new Text(' รายละเอียดหอพัก:',style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            ),
          ),
          new Container(
            padding: EdgeInsets.only(left: 15, right: 15, top: 15),
            child: TextField(
              controller: dormDetail,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '** คลิกเพื่อเพิ่มรายละเอียดหอพัก **',
              ),
            ),
          ),
          Container(
            child: Center(
              child: new RaisedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('คุณต้องการแก้ไขข้อมูลหอพัก ?'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('ยืนยัน'),
                                onPressed: onEditDormProfile,
                              ),
                              FlatButton(
                                child: Text('ยกเลิก'),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                            ],
                          ));
                },
                textColor: Colors.white,
                color: Colors.blue[300],
                child: Text('บันทึก'),
              ),
            ),
          ),
        ],
      ),
    );
    if (state == 1) {
      lst.removeLast();
      setState(() {
        lst.add(show);
      });
    } else {
      setState(() {
        lst.add(show);
      });
    }
  }

  void onStatusChange(String item) {
    setState(() {
      _selectedStatus = item;
      cardShow(1);
    });
  }

  Future getImageGallery() async {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = imageFile;
      checkImg = true;
      cardShow(1);
    });
  }

  Future upload(File imageFile) {
    if (imageFile != null) {
      SweetAlert.show(context,
          subtitle: "กำลังอัพโหลดรูปภาพ...", style: SweetAlertStyle.loading);
      new Future.delayed(new Duration(seconds: 1), () async {
        var stream =
            new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
        var length = await imageFile.length();
        var uri = Uri.parse("${config.API_url}/dorm/saveImage");

        var request = new http.MultipartRequest("POST", uri);
        var multipartFile = new http.MultipartFile("file", stream, length,
            filename: path.basename(imageFile.path));
        request.fields['dormId'] = _dormId.toString();
        request.files.add(multipartFile);

        var response = await request.send();
        if (response.statusCode == 200) {
          print("Image Uploaded");
          SweetAlert.show(context,
              subtitle: "สำเร็จ!",
              style: SweetAlertStyle.success, onPress: (bool isTrue) {
            if (isTrue) {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext) =>
                      MainHomeFragment(_dormId, _userId)));
            }
            return false;
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

  void onEditDormProfile() {
    Map<String, dynamic> param = Map();
    param["dormId"] = _dormId.toString();
    param["dormName"] = dormName.text;
    param["dormAddress"] = dormAddress.text;
    param["dormTelephone"] = dormPhone.text;
    param["dormEmail"] = dormEmail.text;
    param["dormFloor"] = dormFloor.text;
    param["dormPrice"] = dormPrice.text;
    param["dormPromotion"] = dormPromotion.text;
    param["dormDetail"] = dormDetail.text;
    param["dormStatus"] = _selectedStatus.toString();

    http
        .post('${config.API_url}/dorm/updateDormProfile', body: param)
        .then((response) {
      print(response.body);
      Map jsonData = jsonDecode(response.body) as Map;
      if (jsonData['status'] == 0) {
        if(_image != null){
          upload(_image);
        }else{
          Navigator.pop(context);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext) =>
                      MainHomeFragment(_dormId, _userId)));
        }
      }
    });
  }

  Widget bodybuild(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('ข้อมูลหอพัก'),
      ),
      body: new ListView.builder(
        padding: EdgeInsets.all(3),
        itemBuilder: bodybuild,
        itemCount: lst.length,
      ),
    );
  }
}
