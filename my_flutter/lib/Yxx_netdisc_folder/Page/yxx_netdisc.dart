import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


import 'yxx_netdisc_list.dart';


class YxxNetDisc extends StatefulWidget {
  @override
  _YxxNetDiscState createState() => _YxxNetDiscState();
}

class _YxxNetDiscState extends State<YxxNetDisc> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    return YxxNetdiscList(); 
  }

  
}