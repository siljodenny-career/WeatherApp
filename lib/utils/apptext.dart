// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Apptext extends StatelessWidget {
  Apptext({super.key,required this.data,this.align,this.size,this.color,this.fw,this.ff});
  String? data;
  TextAlign? align;
  double? size;
  Color? color;
  FontWeight? fw;
  String? ff;
  @override
  Widget build(BuildContext context) {
    return Text(
      data.toString(),
      textAlign: align,
      style: TextStyle(
        fontSize: size,
        color: color,
        fontWeight:fw, 
        fontFamily: ff,
        
      ),
    );
  }
}
