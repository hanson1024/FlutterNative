import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Yxx_netdisc_folder/Model/yxx_netdisc_model.dart';
import 'Yxx_netdisc_folder/Model/yxx_provider_model.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';


import 'package:provider/provider.dart';
import 'Yxx_netdisc_folder/Page/yxx_test_page.dart';
import 'Yxx_netdisc_folder/Page/yxx_netdisc.dart';
import 'Yxx_netdisc_folder/Manager/yxx_netdisc_manager.dart';
import 'Yxx_netdisc_folder/Util/yxx_common_util.dart';

void main() {
  final counter = CounterModel();
  final netdiscListProvider = NetdiscListProvider();
  final netdiscListUploadProvider = NetdiscListUploadProvider();
  final netdiscListDownloadProvider = NetdiscListDownloadProvider();
  final netdiscListCompletionProvider = NetdiscListCompletionProvider();

  
  final textSize = 48;

  return runApp(

    MultiProvider(
      providers: [
        Provider.value(value: textSize,),
        ChangeNotifierProvider.value(value: counter,),
        ChangeNotifierProvider.value(value: netdiscListProvider,),
        ChangeNotifierProvider.value(value: netdiscListUploadProvider,),
        ChangeNotifierProvider.value(value: netdiscListDownloadProvider,),
        ChangeNotifierProvider.value(value: netdiscListCompletionProvider,)
      ],
      child: MyApp(),
    )
  );

}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: MyHomePage(title: 'Flutter Download'),
      home: YxxNetDisc(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // 初始化进度条

    ProgressDialog pr = new ProgressDialog(context, type:ProgressDialogType.Download);
    // pr.setMessage('下载中…');
    pr.style(
      message: '下载中…'
    );
    
    
    // 设置下载回调
    FlutterDownloader.registerCallback((id, status, progress) {
      // 打印输出下载信息
      print(
          'Download task ($id) is in status ($status) and process ($progress)');
      if (!pr.isShowing()) {
        pr.show();
      }
      if (status == DownloadTaskStatus.running) {
        pr.update(progress: progress.toDouble(), message: "下载中，请稍后…");
      }
      if (status == DownloadTaskStatus.failed) {
        showToast("下载异常，请稍后重试");
        if (pr.isShowing()) {
          pr.hide();
        }
      }

      if (status == DownloadTaskStatus.complete) {
        print(pr.isShowing());
        if (pr.isShowing()) {
          pr.hide();
        }
        // 显示是否打开的对话框
        showDialog(
            // 设置点击 dialog 外部不取消 dialog，默认能够取消
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('提示'),
                  // 标题文字样式
                  content: Text('文件下载完成，是否打开？'),
                  // 内容文字样式
                  backgroundColor: CupertinoColors.white,
                  elevation: 8.0,
                  // 投影的阴影高度
                  semanticLabel: 'Label',
                  // 这个用于无障碍下弹出 dialog 的提示
                  shape: Border.all(),
                  // dialog 的操作按钮，actions 的个数尽量控制不要过多，否则会溢出 `Overflow`
                  actions: <Widget>[
                    // 点击取消按钮
                    FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('取消')),
                    // 点击打开按钮
                    FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // 打开文件
                          _openDownloadedFile(id).then((success) {
                            if (!success) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Cannot open this file')));
                            }
                          });
                        },
                        child: Text('打开')),
                  ],
                ));
      }
    });
  }

  @override
  void dispose() {
    FlutterDownloader.registerCallback(null);
    super.dispose();
  }

  // 执行下载文件的操作
  _doDownloadOperation() async {

    ///下载文件的步骤：
    ///1. 获取权限：网络权限、存储权限
    ///2. 获取下载路径
    ///3. 设置下载回调

    // 获取权限
    var isPermissionReady = await _checkPermission();
    if (isPermissionReady) {
      // 获取存储路径
      var _localPath = (await _findLocalPath()) + '/Download';

      print('_localPath: $_localPath');

      final savedDir = Directory(_localPath);
      // 判断下载路径是否存在
      bool hasExisted = await savedDir.exists();
      // 不存在就新建路径
      if (!hasExisted) {
        savedDir.create();
      }
      // 下载链接
      String downloadUrl = "https://ytools.xyz/0039MnYb0qxYhV.mp3";
      // 下载
      _downloadFile(downloadUrl, _localPath);
    } else {
      showToast("您还没有获取权限");
    }
  }

// 申请权限
  Future<bool> _checkPermission() async {
    // 先对所在平台进行判断
    if (Theme.of(context).platform == TargetPlatform.android) {
      PermissionStatus permission = await PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage);
      if (permission != PermissionStatus.granted) {
        Map<PermissionGroup, PermissionStatus> permissions =
            await PermissionHandler()
                .requestPermissions([PermissionGroup.storage]);
        if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

// 获取存储路径
  Future<String> _findLocalPath() async {
    // 因为Apple没有外置存储，所以第一步我们需要先对所在平台进行判断
    // 如果是android，使用getExternalStorageDirectory
    // 如果是iOS，使用getApplicationSupportDirectory
    final directory = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    return directory.path;
  }

  // 根据 downloadUrl 和 savePath 下载文件
  _downloadFile(downloadUrl, savePath) async {
    await FlutterDownloader.enqueue(
      url: downloadUrl,
      savedDir: savePath,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }

  // 根据taskId打开下载文件
  Future<bool> _openDownloadedFile(taskId) {
    return FlutterDownloader.open(taskId: taskId);
  }

  // 弹出toast
  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("点我下载文件"),
              onPressed: () {
                // 执行下载操作
                _doDownloadOperation();

                YXXFileModel model = YXXFileModel();
                model.fileid = currentTimeMillis();
                model.objid = model.fileid;
                model.folderid = 0;
                model.mc = '数学笔记';
                model.ex = '.doc';
                model.len = 123123;
                model.localLen = 156955;
                model.cjr = 'luo';
                model.cjsj = model.fileid;
                model.ksxzsj = model.fileid + 10;
                model.xzsj = model.fileid + 40;
                model.flags = 1;
                model.typeFlags = 1;
                model.zt = 1;

                YXXFileFolderModel folderModel = YXXFileFolderModel();
                folderModel.folderid = 1569551166061;
                folderModel.parentid = 156955866061;
                folderModel.mc = '数据集合文件夹';
                folderModel.cjr = 'luo';
                folderModel.cjsj = 1569551166061;
                folderModel.xgsj = 1569551166061;
                folderModel.xzsj = 1569551816061;
                folderModel.ksxzsj = 1569551186061;
                folderModel.flags = 1;
                folderModel.zt = 1;
                // YXXNetdiscManager().insertFile(model);
                // YXXNetdiscManager().insertFileFolder(folderModel);

              },
            ),
          ],
        ),
      ),
    );
  }
}
