import 'package:flutter/material.dart';
import 'yxx_netdisc_list.dart';

import '../Model/yxx_netdisc_model.dart';
import '../Model/yxx_provider_model.dart';
import 'package:provider/provider.dart';

class YxxNetDiscUpload extends StatefulWidget  {
  @override
  _YxxNetDiscUploadState createState() => _YxxNetDiscUploadState();
}

class _YxxNetDiscUploadState extends State<YxxNetDiscUpload> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      child: Column(
        children: <Widget>[
          TotalProgress(progressType: TotalProgressType.upload,onTap: (num index){
              Provider.of<NetdiscListProvider>(context).updateNetdiscList(TotalProgressType.upload, index == 1,context);
          },),
          Expanded(
            child: FileListPage(loadType: TotalProgressType.upload,)
          )
        ],
      )
    );
  }

}



