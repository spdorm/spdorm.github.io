import 'package:flutter/material.dart';

class DataVendingMachinePage extends StatefulWidget {
  int _dormId, _userId;
  DataVendingMachinePage(int dormId, int userId) {
    this._dormId = dormId;
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    return new _DataVendingMachinePage(_dormId, _userId);
  }
}

class _DataVendingMachinePage extends State<DataVendingMachinePage> {
  int selectedDrawerIndex = 0;
  int _dormId,_userId;
  _DataVendingMachinePage(int dormId,int userId){
    this._dormId = dormId;
    this._userId=userId;
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

  String _selectedMonth, _selectedYear;

  void onMonthChange(String item) {
    setState(() {
      _selectedMonth = item;
      print(_selectedMonth);
    });
  }

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
    _selectedMonth = _Month.first;
    _selectedYear = _Year.first;

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    print(Navigator.of(context).pop());
  }

   Container head = Container(
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: new Row(
        children: <Widget>[
          new Icon(Icons.label_important),
          new Text('รายละเอียดข้อมูลสถิติเครื่องหยอดเหรียญ'),
        ],
      ),
    );
    setState(() {
      lst.add(head);
    });
//###################################################################################
    Card cardTop = Card(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10),
      child: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              new Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 20.0),
                child: Text("เดือน :"),
              ),
              new DropdownButton<String>(
                  value: _selectedMonth,
                  items: _Month.map((String dropdownStatusValue) {
                    return new DropdownMenuItem(
                        value: dropdownStatusValue,
                        child: new Text(dropdownStatusValue));
                  }).toList(),
                  onChanged: (String value) {
                    onMonthChange(value);
                  }),
              new Container(
                padding: EdgeInsets.only(left: 20, right: 5, top: 20.0),
                child: Text("ปี :"),
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
    Card cardShow = Card(
      margin: EdgeInsets.only(left: 5, right: 5, top: 10),
      child: Padding(
        padding: EdgeInsets.only(left: 5, right: 5),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text('\nรายเดือน : ${null} บาท/เดือน\n\n' +
                  'รายปี : ${null} บาทต่อปี\n\n'
                  ),
            ),
          ],
        ),
      ),
    );
    setState(() {
      lst.add(cardShow);
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
          title: Text('ข้อมูลสถิติเครื่องหยอดเหรียญ'),
        ),
      body: ListView.builder(
        padding: EdgeInsets.only(left: 5, right: 5, top: 5),
        itemBuilder: widgetBuilder,
        itemCount: lst.length,
      ),
    );
  }
}
