import 'package:flutter/src/widgets/framework.dart';

import '../Model/yxx_provider_model.dart';
import 'package:provider/provider.dart';
import '../Model/yxx_netdisc_model.dart';

class YxxNetdiscRespondManager{

  Future<String> fileListInfo(TotalProgressType type,BuildContext context) async{
    print('_fileListInfo');
    await Provider.of<NetdiscListProvider>(context).getNetdiscList(type,context);
    return 'done';
  }
}

class YxxNetdiscDownloadManager {

   
}