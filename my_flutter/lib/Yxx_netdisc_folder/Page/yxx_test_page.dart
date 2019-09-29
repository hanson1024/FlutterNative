import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

import '../Model/yxx_netdisc_model.dart';
import '../Util/DB/Yxx_data_base_helper.dart';
import '../Manager/yxx_netdisc_manager.dart';
import '../Model/yxx_provider_model.dart';


class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _counter = Provider.of<CounterModel>(context);
    final textSize = Provider.of<int>(context).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text('FirstPage'),
      ),
      body: Center(
        child: Text(
          'Value: ${_counter.value}',
          style: TextStyle(fontSize: textSize),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => SecondPage())),
        child: Icon(Icons.navigate_next),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Consumer2<CounterModel,int>(
        builder: (context, CounterModel counter, int textSize, _) => Center(
              child: Text(
                'Value: ${counter.value}',
                style: TextStyle(
                  fontSize: textSize.toDouble(),
                ),
              ),
            ),
      ),
      floatingActionButton: Consumer<CounterModel>(
        builder: (context, CounterModel counter, child) => FloatingActionButton(
              onPressed: counter.increment,
              child: child,
            ),
        child: Icon(Icons.add),
      ),
    );
  }
}










class YXXTestPage extends StatefulWidget {
  YXXTestPage({Key key}) : super(key: key);

  _YXXTestPageState createState() => _YXXTestPageState();
}

class _YXXTestPageState extends State<YXXTestPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('点击设置'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  '2',
                    style: Theme.of(context).textTheme.display1,
                  ),
              ),
              Container(
                child: Text(
                  '1',
                    style: Theme.of(context).textTheme.display1,
                  ),
              ),
              RaisedButton(
                  onPressed: (){
                    // Provide.value<Counter>(context).increate();
                    // Provide.value<NewCounter>(context).increate();
                    DataBaseHelper helper = DataBaseHelper();
                    helper.db;
                  },
                  child: Text(
                    '点击'
                  ),
                ),
                RaisedButton(
                  onPressed: (){
                    
                    Map res = json.decode(YXXNetdiscModel.testJsonStr);
                    List data = res['data'];

                    print(data);

                    data.forEach((dict) {
                      // dataModels.add(YXXFileModel.fromJson(dict));
                      YXXNetdiscManager().insertFile(YXXFileModel.fromJson(dict));
                    });

                    // YXXFileModel model = YXXFileModel();
                    // model.fileid = currentTimeMillis();
                    // model.objid = model.fileid;
                    // model.folderid = 0;
                    // model.mc = '小学作文';
                    // model.ex = '.doc';
                    // model.len = 1000;
                    // model.localLen = 55;
                    // model.cjr = '创建人';
                    // model.cjsj = 1564885945;
                    // model.ksxzsj = 1564885945;
                    // model.xzsj = 1564885945;
                    // model.flags = 1;
                    // model.zt = 1;
                    // YXXNetdiscManager().insertFile(model);
                  },
                  child: Text(
                    '增加'
                  ),
                ),
                RaisedButton(
                  onPressed: (){
                    YXXNetdiscManager().deleteFileWithFileid(1569317150875);
                  },
                  child: Text(
                    '删除'
                  ),
                ),
                RaisedButton(
                  onPressed: (){

                    List resList = [];

                    Future<List<YXXFileModel>> res = YXXNetdiscManager().selectFiles(10,0,0,TotalProgressType.completion);
                    res.then((value) {
                        print(value);
                    });
                  },
                  child: Text(
                    '查询'
                  ),
                ),
            ],
          ),
        ),
      );
  }
}