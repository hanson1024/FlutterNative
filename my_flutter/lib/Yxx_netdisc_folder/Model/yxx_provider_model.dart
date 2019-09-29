import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'yxx_netdisc_model.dart';
import '../Manager/yxx_netdisc_manager.dart';

class CounterModel with ChangeNotifier {
  int _count = 0;
  int get value => _count;

  void increment () {
    _count ++;
    notifyListeners();
  }

}

class NetdiscListUploadProvider extends NetdiscListProvider{

  clearnAllFiles (TotalProgressType type,BuildContext context) async {

    
  }

  getNetdiscList (TotalProgressType type,BuildContext context) async {
    var data = await YXXNetdiscManager().selectFiles(10,0,0,type);
    _dataMap[type.toString()] = data;

    notifyListeners();
  }

  updateNetdiscList (TotalProgressType type,bool cancel,BuildContext context) async {

    List<YXXFileModel> list = _dataMap[type.toString()];

    list.forEach((YXXFileModel model) {
        if (cancel) {
            model.flags = YxxNetdiscCellDetailProgressType.uploadPause.index;
          } else {
            model.flags = YxxNetdiscCellDetailProgressType.uploading.index;
          }
    });

    _dataMap[type.toString()] = list;

    notifyListeners();
  }

}

class NetdiscListDownloadProvider extends NetdiscListProvider{

  clearnAllFiles (TotalProgressType type,BuildContext context) async {

    
  }

  getNetdiscList (TotalProgressType type,BuildContext context) async {
    var data = await YXXNetdiscManager().selectFiles(10,0,0,type);
    _dataMap[type.toString()] = data;
    
    notifyListeners();
  }

  updateNetdiscList (TotalProgressType type,bool cancel,BuildContext context) async {

      List<YXXFileModel> list = _dataMap[type.toString()];

      list.forEach((YXXFileModel model) {
          if (cancel) {
              model.flags = YxxNetdiscCellDetailProgressType.downloadPause.index;
            } else {
              model.flags = YxxNetdiscCellDetailProgressType.downloading.index;
            }
      });

      _dataMap[type.toString()] = list;

      notifyListeners();
  }
    
}

class NetdiscListCompletionProvider extends NetdiscListProvider{

  clearnAllFiles (TotalProgressType type,BuildContext context) async {
      _dataMap[type.toString()] = List<YXXFileModel>();
      notifyListeners();
  }

  getNetdiscList (TotalProgressType type,BuildContext context) async {
    var data = await YXXNetdiscManager().selectFiles(10,0,0,type);
    _dataMap[type.toString()] = data;
    
    notifyListeners();
  }
    
}

class NetdiscListProvider with ChangeNotifier {

  Map _dataMap = {};
  Map get value => _dataMap;

  updateNetdiscList (TotalProgressType type,bool cancel,BuildContext context) async {
    if (type == TotalProgressType.upload) {
      Provider.of<NetdiscListUploadProvider>(context).updateNetdiscList(type,cancel,context);
    } else if (type == TotalProgressType.download){
      Provider.of<NetdiscListDownloadProvider>(context).updateNetdiscList(type,cancel,context);
    } else if (type == TotalProgressType.completion){
      Provider.of<NetdiscListCompletionProvider>(context).updateNetdiscList(type,cancel,context);
    }
  }

  getNetdiscList (TotalProgressType type,BuildContext context) async {
    if (type == TotalProgressType.upload) {
      Provider.of<NetdiscListUploadProvider>(context).getNetdiscList(type,context);
    } else if (type == TotalProgressType.download){
      Provider.of<NetdiscListDownloadProvider>(context).getNetdiscList(type,context);
    } else if (type == TotalProgressType.completion){
      Provider.of<NetdiscListCompletionProvider>(context).getNetdiscList(type,context);
    }
  }

  clearnAllFiles (TotalProgressType type,BuildContext context) async {

    if (type == TotalProgressType.upload) {
      Provider.of<NetdiscListUploadProvider>(context).clearnAllFiles(type,context);
    } else if (type == TotalProgressType.download){
      Provider.of<NetdiscListDownloadProvider>(context).clearnAllFiles(type,context);
    } else if (type == TotalProgressType.completion){
      Provider.of<NetdiscListCompletionProvider>(context).clearnAllFiles(type,context);
    }

  }
}