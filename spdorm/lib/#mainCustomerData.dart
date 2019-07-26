import 'package:flutter/material.dart';
import 'AddCustomerData.dart';
import 'mainAddVendingMachine.dart';
import 'mainNews.dart';
import 'mainDataDrom.dart';
import 'mainAddAccountIncome.dart';
import 'main.dart';

class CustomerData extends StatefulWidget {
  int _dormId,_userId;
  CustomerData(int dormId,int userId){
    this._dormId = dormId;
    this._userId=userId;
  }
  @override
  State<StatefulWidget> createState() {
    return new CustomerDataState(_dormId,_userId);
  }
}

class CustomerDataState extends State<CustomerData> {
  int selectedDrawerIndex = 0;
  int _dormId,_userId;
  CustomerDataState(int dormId,int userId){
    this._dormId = dormId;
    this._userId=userId;
    print(_dormId);
    print(_userId);
  }

  void onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    print(Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ข้อมูลส่วนตัวลูกค้า',
      home: new Scaffold(
        appBar: new AppBar(title: new Text('ข้อมูลส่วนตัวลูกค้า'),
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
                  'SPDorm',
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
        body: new CustomerDataFragment(),
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
