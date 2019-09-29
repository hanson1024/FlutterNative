import 'package:flutter/material.dart';
import 'yxx_netdisc_list.dart';

import '../Model/yxx_netdisc_model.dart';
import '../Model/yxx_provider_model.dart';
import 'package:provider/provider.dart';

class YxxNetDiscDownload extends StatefulWidget {
  @override
  _YxxNetDiscDownloadState createState() => _YxxNetDiscDownloadState();
}

class _YxxNetDiscDownloadState extends State<YxxNetDiscDownload> with AutomaticKeepAliveClientMixin{
  
  final YXXFileModel model = YXXFileModel();
  List <YXXFileModel>fileList = List();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(
        children: <Widget>[
          TotalProgress(progressType: TotalProgressType.download,onTap: (num index){
            Provider.of<NetdiscListProvider>(context).updateNetdiscList(TotalProgressType.download, index == 1,context);
          },),
          Expanded(
            child: FileListPage(loadType: TotalProgressType.download,)
          )
        ],
      )
    );
  }
}