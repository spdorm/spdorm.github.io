import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Pending.dart';
import 'dart:convert';
import 'Registor.dart';
import 'main.dart';
import 'config.dart';

class PubStatus extends StatefulWidget {
  List lst = new List();
  int _dormId;
  String _nameDorm;

  PubStatus(int dormId,String nameDorm) {
    this._nameDorm = nameDorm;
    this._dormId = dormId;
  }

  @override
  State<StatefulWidget> createState() {
    return new _PubStatus(_dormId, _nameDorm);
  }
}

class _PubStatus extends State<PubStatus> {
  int selectedDrawerIndex = 0;
  int _dormId;
  String _nameDorm;

  _PubStatus(int dormId, String nameDorm) {
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
  }

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    print(Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('${_nameDorm}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search,
              semanticLabel: 'search',
            ),
            onPressed: () {
              print('Search button');
            },
          ),
          IconButton(
            icon: Icon(
              Icons.tune,
              semanticLabel: 'filter',
            ),
            onPressed: () {
              print('Filter button');
            },
          ),
        ],
      ),
      body: new ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        children: List.generate(choices.length, (index) {
          return Center(
            child: Column(
              children: <Widget>[
                Card(
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      Container(
                          padding: const EdgeInsets.all(8.0),
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.home,
                            size: 80.0,
                            color: Colors.grey,
                          )),
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
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 120, top: 5),
                      child: new RaisedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext) => pendingPage(_dormId,_nameDorm)));
                        },
                        textColor: Colors.white,
                        color: Colors.pinkAccent,
                        child: new Row(
                          children: <Widget>[
                            new Text('แจ้งเข้าพัก'),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.mail),
            title: new Text('Messages'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: new Text('Profile'),
          )
        ],
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(
      title:
          'This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car.'
          'This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car. This is a Car, because its a car. So, it\'s a car.',
      icon: Icons.home),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard(
      {Key key,
      this.choice,
      this.onTap,
      @required this.item,
      this.selected: false})
      : super(key: key);

  final Choice choice;
  final VoidCallback onTap;
  final Choice item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.display1;
    if (selected)
      textStyle = textStyle.copyWith(color: Colors.lightGreenAccent[400]);
    return Column(
      children: <Widget>[
        Card(
          color: Colors.white,
          child: Row(
            children: <Widget>[
              new Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.topLeft,
                  child: Icon(
                    choice.icon,
                    size: 80.0,
                    color: textStyle.color,
                  )),
              new Expanded(
                child: new Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    choice.title,
                    style: null,
                    textAlign: TextAlign.left,
                    maxLines: 5,
                  ),
                ),
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 40, top: 5),
              child: new RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext) => RegisterSPDorm()));
                },
                textColor: Colors.white,
                color: Colors.pinkAccent,
                child: new Row(
                  children: <Widget>[
                    new Text('ลงทะเบียนเข้าพัก'),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 5),
              child: new RaisedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext) => Login()));
                },
                textColor: Colors.white,
                color: Colors.green,
                child: new Row(
                  children: <Widget>[
                    new Text('เข้าสู่ระบบ'),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
