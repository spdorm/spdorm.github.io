import 'package:flutter/material.dart';

class CharterDataDorm extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ข้อมูลสัญญาเช่า',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: new _CharterDataDorm(title: 'ข้อมูลสัญญาเช่า'),
    );
  }
}

class _CharterDataDorm extends StatelessWidget {
  _CharterDataDorm({Key key, this.title}) : super(key: key);

  final String title;

  final cols = [
    new DataColumn(
      label: const Text('เบอร์ห้องเช่า'),
    ),
    new DataColumn(
      label: const Text('ชื่อลูกค้า'),
    ),
    new DataColumn(
      label: const Text('ใบสัญญาเช่า'),
    ),
  ];

  final rows = new List.generate(
      3,
      (_) => new DataRow(
          cells: [
            new DataCell(new Text('101')),
            new DataCell(new Text('คุณทราย')),
            new DataCell(new Text('ไฟล์รูป')),
          ]
      ),
  );

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ข้อมูลสัญญาเช่า',
      home: new Scaffold(
        body: new Column(
          children: [
            new Container(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: new Row(
                children: <Widget>[
                  new Text('เพิ่มข้อมูลสัญญาเช่า:'),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.only(left: 110, right: 110, top: 10),
              child: new RaisedButton(
                onPressed: () {},
                textColor: Colors.white,
                color: Colors.green,
                child: new Row(
                  children: <Widget>[
                    new Icon(Icons.add),
                    new Text('Add Charter'),
                  ],
                ),
              ),
            ),
            new Container(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10),
              child: new Row(
                children: <Widget>[
                  new Text('ข้อมูลสัญญาเช่าทั้งหมด:'),
                ],
              ),
            ),
            new Card(
              child: new Material(
                child: new DataTable(columns: cols, rows: rows),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
