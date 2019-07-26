import 'package:flutter/material.dart';

void main() {
  runApp(CustomerDataFragment());
}

class CustomerDataFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CustomerDataFragmentState();
  }
}

class _CustomerDataFragmentState extends State<CustomerDataFragment> {
  List<String> _floor = ["1", "2", "3", "4"].toList();

  // String _selectedMonth = null;
  String _selectedMonth;

  @override
  void initState() {
    super.initState();
    _selectedMonth = _floor.first;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    void onMonthChange(String item) {
      setState(() {
        _selectedMonth = item;
      });
    }
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'เครื่องหยอดเหรียญ',
      home: new Scaffold(
        body: new ListView(
          padding: EdgeInsets.only(left: 15, right: 15, top: 20),
          children: <Widget>[
            Text(':รายละเอียดข้อมูลส่วนตัวลูกค้า'),
            new Card(
              child: new Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(left: 20, right: 10),
                    child: Text("ชั้น :"),
                  ),
                  new DropdownButton<String>(
                      value: _selectedMonth,
                      items: _floor.map((String value) {
                        return new DropdownMenuItem(
                            value: value, child: new Text(value));
                      }).toList(),
                      onChanged: (String value) {
                        onMonthChange(value);
                      }),
                ],
              ),
            ),
            new Card(
              margin: EdgeInsets.all(10),
              child: new Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: new Row(
                      children: <Widget>[
                        new Icon(Icons.label_important),
                        new Text('ห้อง 101:'),
                      ],
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a name of customer',
                          labelText: 'ชื่อ สกุล :',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a domicile',
                          labelText: 'ภูมิลำเนา :',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a phone number',
                          labelText: 'เบอร์โทร :',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 15,top: 5,right: 5),
                        child: new RaisedButton(
                          onPressed: () {},
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: new Row(
                            children: <Widget>[
                              new Text('ตกลง'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5,top: 5),
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
                        padding: EdgeInsets.only(left: 5,top: 5),
                        child: new RaisedButton(
                          onPressed: () {},
                          textColor: Colors.white,
                          color: Colors.teal,
                          child: new Row(
                            children: <Widget>[
                              new Text('เคลียร์'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            new Card(
              margin: EdgeInsets.all(10),
              child: new Column(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: new Row(
                      children: <Widget>[
                        new Icon(Icons.label_important),
                        new Text('ห้อง 102:'),
                      ],
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a name of customer',
                          labelText: 'ชื่อ สกุล :',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a domicile',
                          labelText: 'ภูมิลำเนา :',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                          icon: const Icon(Icons.control_point),
                          hintText: 'Enter a phone number',
                          labelText: 'เบอร์โทร :',
                          labelStyle: TextStyle(fontSize: 15)),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  new Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 15,top: 5,right: 5),
                        child: new RaisedButton(
                          onPressed: () {},
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: new Row(
                            children: <Widget>[
                              new Text('ตกลง'),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 5,top: 5),
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
                        padding: EdgeInsets.only(left: 5,top: 5),
                        child: new RaisedButton(
                          onPressed: () {},
                          textColor: Colors.white,
                          color: Colors.teal,
                          child: new Row(
                            children: <Widget>[
                              new Text('เคลียร์'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
