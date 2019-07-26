import 'package:flutter/material.dart';

void main() {
  runApp(DataRoom());
}

class DataRoom extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _DataRoom();
  }
}

class _DataRoom extends State<DataRoom> {
  var _image;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'แสดงข้อมูลลูกค้า',
      home: new Scaffold(
        body: new ListView(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20),
          children: <Widget>[
            Text(':ข้อมูลส่วนตัวลูกค้า'),
            new Card(
              margin: EdgeInsets.all(5),
              child: new Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: new Row(
                      children: <Widget>[
                        new Text('ชื่อ สกุล:'),
                      ],
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: new Row(
                      children: <Widget>[
                        new Text('ภูมิลำเนา:'),
                      ],
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                    child: new Row(
                      children: <Widget>[
                        new Text('เบอร์โทร:'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            new Card(
              margin: EdgeInsets.all(5),
              child: new Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: new Row(
                      children: <Widget>[
                        new Icon(Icons.label_important),
                        new Text('การเพิ่มใบแจ้งชำระ'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:70,top: 5,right: 70),
                    child: new RaisedButton(
                      onPressed: () {},
                      textColor: Colors.white,
                      color: Colors.deepPurpleAccent,
                      child: new Row(
                        children: <Widget>[
                          new Icon(Icons.remove_red_eye),
                          new Text(' ประวัติใบแจ้งชำระ'),
                        ],
                      ),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a amount',
                          labelText: 'ค่าห้องพัก : บาท/เดือน',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a amount',
                          labelText: 'ค่าน้ำ : บาท/เดือน',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a amount',
                          labelText: 'ค่าไฟ:',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a amount',
                          labelText: 'เคเบิ้ล : บาท/เดือน',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a amount',
                          labelText: 'ซ่อม : บาท/เดือน',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a amount',
                          labelText: 'รวมทั้งหมด : บาท/เดือน',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left:30,top: 5,right: 1),
                        child: new RaisedButton(
                          onPressed: () {},
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
                        padding: EdgeInsets.only(left: 1,top: 5),
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
                      Padding(
                        padding: EdgeInsets.only(left: 1,top: 5),
                        child: new RaisedButton(
                          onPressed: () {},
                          textColor: Colors.white,
                          color: Colors.green,
                          child: new Row(
                            children: <Widget>[
                              new Text('ส่งข้อมูล'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
