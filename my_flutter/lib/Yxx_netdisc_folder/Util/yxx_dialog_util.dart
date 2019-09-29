import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

typedef VoidClikeCallback = void Function(num index);

YXXShowAlertDialog (String title,VoidClikeCallback clickCallBack) {

    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(title,style: TextStyle(
                fontSize: 16
              ),),
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
              child: Text("确定"),
              onPressed: (){
                if (clickCallBack != null) {
                  clickCallBack(0);
                }
              },
            ),
            CupertinoDialogAction(
              child: Text("取消"),
              onPressed: (){
                if (clickCallBack != null) {
                  clickCallBack(1);
                }
              }),
        ],
      );
    } else {
      return AlertDialog(
          content: new SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text(title)],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("确定"),
              onPressed: () {
                if (clickCallBack != null) {
                  clickCallBack(0);
                }
              },
            ),
            FlatButton(
              child: Text("取消"),
              onPressed: () {
                if (clickCallBack != null) {
                  clickCallBack(1);
                }
              },
            )
          ],
        );
    }

}

YXXShowLoadDialog (String text) {
  return LoadingDialog(text: text,);
}

class LoadingDialog extends Dialog {

  final String text;
  LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Material(
      type: MaterialType.transparency,
      child: new Center(
        child: new SizedBox(
          width: 120.0,
          height: 120.0,
          child: new Container(
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(),
                new Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: new Text(text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


