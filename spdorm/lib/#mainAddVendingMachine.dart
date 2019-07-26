import 'package:flutter/material.dart';
import 'AddVendingMachine.dart';


class VendingMachine extends StatefulWidget {
  int _dormId,_userId;
  VendingMachine(int dormId,int userId){
    this._dormId = dormId;
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    return new VendingMachineState(_dormId,_userId);
  }
}

class VendingMachineState extends State<VendingMachine> {
  int selectedDrawerIndex = 0;
  int _dormId,_userId;
  VendingMachineState(int dormId,int userId){
    this._dormId = dormId;
    this._userId=userId;
  }

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    print(Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('สถิติเครื่องหยอดเหรียญ'),),
        body: new VendingMachineFragment(_dormId,_userId),
    );
  }
}
