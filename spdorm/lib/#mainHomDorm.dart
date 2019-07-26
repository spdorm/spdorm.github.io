import 'package:flutter/material.dart';
import 'mainNews.dart';
import 'mainDataDrom.dart';
import 'mainAddAccountIncome.dart';
import 'mainAddVendingMachine.dart';
import 'AddDormpage.dart';

class HomeDorm extends StatefulWidget {
  int _dormId,_userId;
  HomeDorm(int dormId,int userId){
    this._dormId = dormId;
    this._userId=userId;
  }
  
  @override
  State<StatefulWidget> createState() {
    return new _HomeDormState(_dormId,_userId);
  }
}

class _HomeDormState extends State<HomeDorm> {
  int _dormId,_userId;
  _HomeDormState(int dormId,int userId){
    this._dormId = dormId;
    this._userId=userId;
  }
  int selectedDrawerIndex = 0;

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    print(Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ห้องพักทั้งหมด',
      home: new Scaffold(
        appBar: new AppBar(title: new Text('ห้องพักทั้งหมด'),
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
        drawer: new Drawer(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(
                  '5555',
                ),
                accountEmail: null,
              ),
              new Column(
                children: <Widget>[
                  new ListTile(
                    title: new Text('เพิ่มข้อมูลข่าวสาร'),
                    leading: new Icon(Icons.view_compact),
                    selected: 1 == selectedDrawerIndex,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext) => NewsDorm(_dormId,_userId)));
                    },
                  ),
                  new ListTile(
                    title: new Text('ข้อมูลหอพัก'),
                    leading: new Icon(Icons.note),
                    selected: 1 == selectedDrawerIndex,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext) => DataDorm(_dormId,_userId)));
                    },
                  ),
                  new ListTile(
                    title: new Text('บัญชีรายรับรายจ่าย'),
                    leading: new Icon(Icons.note),
                    selected: 1 == selectedDrawerIndex,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext) => AccountIncome(_dormId,_userId)));
                    },
                  ),
                  new ListTile(
                    title: new Text('สถิติเครื่องซักผ้าหยอดเหรียญ'),
                    leading: new Icon(Icons.insert_chart),
                    selected: 1 == selectedDrawerIndex,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext) => VendingMachine(_dormId,_userId)));
                    },
                  ),
                  new ListTile(
                    title: new Text('ออกจากระบบ'),
                    leading: new Icon(Icons.exit_to_app),
                    selected: 1 == selectedDrawerIndex,
                    onTap: () => onSelectItem(1),
                  )
                ],
              ),
            ],
          ),
        ),
        body: new AddDormPage(_userId),
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
      ),
    );
  }
}
