import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/counter.dart';

class MemberPage extends StatefulWidget {
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Provide<Counter>(
          builder: (context, child, counter) {
            return Text('${counter.value}');
          },
        ),
      ),
    );
  }
}
