import 'package:flutter/material.dart';
import 'yxx_netdisc_list.dart';

import '../Model/yxx_netdisc_model.dart';
import '../Model/yxx_provider_model.dart';
import 'package:provider/provider.dart';

class YxxNetDiscCompletion extends StatefulWidget {
  @override
  _YxxNetDiscCompletionState createState() => _YxxNetDiscCompletionState();
}

class _YxxNetDiscCompletionState extends State<YxxNetDiscCompletion> with AutomaticKeepAliveClientMixin{
  
  final YXXFileModel model = YXXFileModel();
  List <YXXFileModel>fileList ;

  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(
        children: <Widget>[
          TotalProgress(progressType: TotalProgressType.completion,onTap: (num index){
            Provider.of<NetdiscListProvider>(context).clearnAllFiles(TotalProgressType.completion,context);
          },),
          Expanded(
            child: FileListPage(loadType: TotalProgressType.completion,)
          )
        ],
      )
    );
  }
}
