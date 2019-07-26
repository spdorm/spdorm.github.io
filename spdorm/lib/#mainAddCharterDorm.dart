import 'package:flutter/material.dart';
import 'AddCharterDorm_fragment.dart';
import 'mainNews.dart';
import 'mainDataDrom.dart';
import 'mainAddVendingMachine.dart';
import 'mainAddAccountIncome.dart';
import 'main.dart';

class AddCharterDorm extends StatefulWidget {
  int _dormId, _roomId;
  AddCharterDorm(int dormId, int roomId) {
    this._dormId = dormId;
    this._roomId = roomId;
  }
  @override
  State<StatefulWidget> createState() {
    return new AddCharterDormState(_dormId, _roomId);
  }
}

class AddCharterDormState extends State<AddCharterDorm> {
  int selectedDrawerIndex = 0;
  int _dormId, _roomId;
  AddCharterDormState(int dormId, int roomId) {
    this._dormId = dormId;
    this._roomId = roomId;
    print(_dormId);
    print(_roomId);
  }

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    print(Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('การเพิ่มข้อมูลสัญญาเช่า'),),
          
        body: new CharterDormFragment(_dormId, _roomId.toString()),
       
      
    );
  }
}
