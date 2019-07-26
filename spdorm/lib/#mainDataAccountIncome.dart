import 'package:flutter/material.dart';
import 'DataAccountIncome.dart';

void main(){
  runApp(MaterialApp(
    home: AccountIncome(),
  ));
}

class AccountIncome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AccountIncomeState();
  }
}

class _AccountIncomeState extends State<AccountIncome> {
  int selectedDrawerIndex = 0;

  onSelectItem(int index) {
    setState(() => selectedDrawerIndex = index);
    print(Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text('ประวัติบัญชีรายรับ-รายจ่าย'),
        ),
        body: new DataAccoutIncomPage(1), //ทดลอง
    );
  }
}
