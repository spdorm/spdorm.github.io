import 'package:flutter/material.dart';
import 'mainHomeFragment.dart';

class StaticVendingPage extends StatefulWidget {
  int _dormId, _userId;
  StaticVendingPage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _StaticVendingPage(_dormId, _userId);
  }
}

class _StaticVendingPage extends State<StaticVendingPage> {
 int _dormId, _userId;

  _StaticVendingPage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }

  
  String dropdownStatusValue;
  String dropdownValue;

  List<String> _Month = [
    "มกราคม",
    "กุมภาพันธุ์",
    "มีนาคม",
    "เมษายน",
    "พฤษภาคม",
    "มิถุนายน",
    "กรกฏาคม",
    "สิงหาคม",
    "กันยายน",
    "ตุลาคม",
    "พฤษจิกายน",
    "ธ้นวาคม",
  ].toList();
  List<String> _Year = List();

  List lst = new List();

  var now = new DateTime.now();

  String _selectedYear;


  void onYearChange(String item) {
    setState(() {
      _selectedYear = item;
      print(_selectedYear);
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = (now.year + 543); i > (now.year + 543) - 5; i--) {
      _Year.add((i).toString());
    }
    print(_Year);
    _selectedYear = _Year.first;

//###################################################################################
    Card cardTop = Card(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10,bottom: 10),
      child: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 20, right: 5, top: 20.0),
                child: Text("โปรดเลือกปี พ.ศ เพื่อดูประวัติ    ปี  :"),
              ),
              new DropdownButton<String>(
                  value: _selectedYear,
                  items: _Year.map((String dropdownValue) {
                    return new DropdownMenuItem(
                        value: dropdownValue, child: new Text(dropdownValue));
                  }).toList(),
                  onChanged: (String value) {
                    onYearChange(value);
                  }),
            ],
          ),
        ],
      ),
    );
    setState(() {
      lst.add(cardTop);
    });
//################################################################################
    Container button = Container(
      margin: EdgeInsets.only(top: 10),
      child: Center(
        child: RaisedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.search),
          label: Text('ค้นหา'),
          color: Colors.blue[500],
        ),
      ),
    );
    setState(() {
      lst.add(button);
    });

//##############F#################################################################
    Container head = Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.label_important),
          new Text('รายละเอียดสถิติเครื่องหยอดเหรียญ/เดือน'),
        ],
      ),
    );
    setState(() {
      lst.add(head);
    });
//##############F#################################################################
    Card cardmonth = Card(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10),
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5,top: 5,bottom: 5),
        child:  Container(
          child: Table(
            border: TableBorder.all(width: 0.2, color: Colors.black),
            columnWidths: {
            0: FractionColumnWidth(.3)
          }, 
          children: [
            TableRow(children: [
              Text(
                "เดือน",
                textAlign: TextAlign.center,
              ),
              Text(
                "รายเดือน",
                textAlign: TextAlign.center,
              ),
              Text(
                "กำไร/เดือน",
                textAlign: TextAlign.center,
              ),
              
            ]),
            TableRow(children: [
              Text(
                "มกราคม",
                textAlign: TextAlign.center,
              ),
              Text(
                '1',
                textAlign: TextAlign.center,
              ),
              Text(
                '1',
                textAlign: TextAlign.center,
              ),
              
            ]),
            TableRow(children: [
              Text(
                'กุมภาพันธ์',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              
            ]),
            TableRow(children: [
              Text(
                'มีนาคม',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              
            ]),
            TableRow(children: [
              Text(
                'เมษายน',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
             
            ]),
            TableRow(children: [
              Text(
                'พฤษภาคม',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
             
            ]),
            TableRow(children: [
              Text(
                'มิถุนายน',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              
            ]),
            TableRow(children: [
              Text(
                'กรกฎาคม',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
            
            ]),
            TableRow(children: [
              Text(
                'สิงหาคม',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
              
            ]),
            TableRow(children: [
              Text(
                'กันยายน',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'ตุลาคม',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'พฤษจิกายน',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                'ธันวาคม',
                textAlign: TextAlign.center,
              ),
              Text(
                '3',
                textAlign: TextAlign.center,
              ),
              Text(
                '4',
                textAlign: TextAlign.center,
              ),
            ]),
          ]),
        ),
      ),
    );
    setState(() {
      lst.add(cardmonth);
    });

    Container head2 = Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.label_important),
          new Text('รายละเอียดสถิติเครื่องหยอดเหรียญ/ปี'),
        ],
      ),
    );
    setState(() {
      lst.add(head2);
    });

     Card cardYear = Card(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10),
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5,top: 5,bottom: 5),
        child:  Container(
          child: Table(
            border: TableBorder.all(width: 0.2, color: Colors.black),
            columnWidths: {
            0: FractionColumnWidth(.3)
          }, 
          children: [
            TableRow(children: [
              Text(
                "ปี",
                textAlign: TextAlign.center,
              ),
              Text(
                "รายปี",
                textAlign: TextAlign.center,
              ),
              Text(
                "กำไร/ปี",
                textAlign: TextAlign.center,
              ),
            ]),
            TableRow(children: [
              Text(
                "2562",
                textAlign: TextAlign.center,
              ),
              Text(
                '1',
                textAlign: TextAlign.center,
              ),
              Text(
                '1',
                textAlign: TextAlign.center,
              ),
            ]),
          ]),
        ),
      ),
    );
    setState(() {
      lst.add(cardYear);
    });
  }

  Widget widgetBuilder(BuildContext context, int index) {
    return lst[index];
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
       appBar: AppBar(
        title: Text('สถิติเครื่องหยอดเหรียญ'),
        leading:  Builder(
    builder: (BuildContext context) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () { Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext)=>MainHomeFragment(_dormId,_userId))); },
      );
    },
  ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        itemBuilder: widgetBuilder,
        itemCount: lst.length,
      ),
    );
  }
}
