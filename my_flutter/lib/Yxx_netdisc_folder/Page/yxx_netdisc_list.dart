import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../Util/yxx_dialog_util.dart';

import 'yxx_netdisc_list_completion.dart';
import 'yxx_netdisc_list_download.dart';
import 'yxx_netdisc_list_upload.dart';

import '../Model/yxx_netdisc_model.dart';
import '../Manager/yxx_netdisc_manager.dart';
import '../Util/yxx_common_util.dart';
import '../Manager/yxx_netdisc_respond_manager.dart';
import '../Model/yxx_provider_model.dart';
import 'package:provider/provider.dart';


class YxxNetdiscList extends StatefulWidget {
  @override
  _YxxNetdiscListState createState() => _YxxNetdiscListState();
}

class _YxxNetdiscListState extends State<YxxNetdiscList> with TickerProviderStateMixin {

  TabController tabController;

  @override
  void initState() { 
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
  }

  @override
  void dispose() {

    tabController.dispose();
    super.dispose();
  }

  Future runiOSMethod() async {
  const platform = const MethodChannel('lianchu');
    var result;
    try {
      result = await platform.invokeMethod('comeonman');
      return Future.value(result);
    } on PlatformException catch (e) {
      return Future.error(e.toString());
    }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar (
        title: const Text("传输列表"),
        leading: Builder(builder: (context){
            return IconButton (
              icon: Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () async {
                var futureValue = await runiOSMethod();
                Navigator.pop(context);
                print('object dismiss');
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(
                        futureValue,
                        textAlign:TextAlign.center
                      ),
                    );
                  }
                );
              },
            );
          },
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: 100.0),
              decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(width: 0.5,color: Colors.black26)
                            )
                          ),
              child: Material(
                color: Colors.white,
                child: TabBar(
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.black54,
                  controller: tabController,
                  tabs: <Widget>[
                    Tab(text: '正在上传',),
                    Tab(text: '正在下载',),
                    Tab(text: '已完成',)
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  Center(child: YxxNetDiscUpload()),
                  Center(child: YxxNetDiscDownload()),
                  Center(child: YxxNetDiscCompletion()),
                ],
                controller: tabController,
              ),
            )
          ],
        ),
      )
    );
  }
}

class FileListPage extends StatefulWidget {
    FileListPage({Key key,this.loadType}) : super(key: key);

    final TotalProgressType loadType;
  
    _FileListPageState createState() => _FileListPageState();
  }
  
class _FileListPageState extends State<FileListPage> with YxxNetdiscRespondManager {

  @override
  void initState() { 

    Future.delayed(Duration(milliseconds: 1), () {
        fileListInfo(widget.loadType,context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.loadType == TotalProgressType.upload) {
      return Container(
        child: Consumer<NetdiscListUploadProvider>(
          builder: (context,NetdiscListUploadProvider netdiscListProvider,child) {
            print('Consumer BuildContext upload');
            List<YXXFileModel> updateList = netdiscListProvider.value[widget.loadType.toString()];
            if (updateList == null) {
              print('null 暂无文件');
              return Text('加载中...');
            }else {
              if (updateList.length == 0) {
                print('暂无文件');
                return Center(
                  child: Text('暂无文件'),
                );
              } else {
                print('updateList 暂无文件');
                return ListFileProgress(fileList: updateList);
              }
            }
          }
        ),
      );
    } else if (widget.loadType == TotalProgressType.download){

      return Container(
        child: Consumer<NetdiscListDownloadProvider>(
          builder: (context,NetdiscListDownloadProvider netdiscListProvider,child) {
            print('Consumer BuildContext download');
            List updateList = netdiscListProvider.value[widget.loadType.toString()];
            if (updateList == null) {
              return Text('加载中...');
            }else {
              if (updateList.length == 0) {
                print('暂无文件');
                return Center(
                  child: Text('暂无文件'),
                );
              } else {
                print('updateList 暂无文件');
                return ListFileProgress(fileList: updateList);
              }
            }
          }
        ),
      );

    } else if (widget.loadType == TotalProgressType.completion){

      return Container(
        child: Consumer<NetdiscListCompletionProvider>(
          builder: (context,NetdiscListCompletionProvider netdiscListProvider,child) {
            print('Consumer BuildContext completion');
            List updateList = netdiscListProvider.value[widget.loadType.toString()];
            if (updateList == null) {
              return Text('加载中...');
            }else {
              if (updateList.length == 0) {
                print('暂无文件');
                return Center(
                  child: Text('暂无文件'),
                );
              } else {
                print('updateList 暂无文件');
                return ListFileProgress(fileList: updateList);
              }
            }
          }
        ),
      );
    }else {
      return Text('no data');
    }
  }
}

class ListFileProgress extends StatelessWidget {

  final List <YXXFileModel> fileList;

  ListFileProgress ({
    @required this.fileList
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: fileList.length,
        itemBuilder: (context,index){
          return Container(
            height: 70,
            child: ListFileProgressCell(detailModel: fileList[index],),
          );
        },
      )
    );
  }
}

class ListFileProgressCell extends StatefulWidget {

  final YXXFileModel detailModel;
  final String curProgressOperationIconStr;

  ListFileProgressCell({Key key,this.detailModel, this.curProgressOperationIconStr}) : super(key: key);

  _ListFileProgressCellState createState() => _ListFileProgressCellState();
}

class _ListFileProgressCellState extends State<ListFileProgressCell>  {

  int curFlags;
  
  @override
  Widget build(BuildContext context) {

    print('widget.detailModel ${widget.detailModel.flags}');
    curFlags = widget.detailModel.flags;

    String fullName = widget.detailModel.mc + widget.detailModel.ex;
    String iconStr = YxxNetdiscIconStrWithFileName(fullName);
    String totalLength = getRollupSize(widget.detailModel.len);
    String completionLength = getRollupSize(widget.detailModel.localLen);
    num typeFlags = widget.detailModel.typeFlags;
    num circularProgressIndicatorValue = (widget.detailModel.localLen/widget.detailModel.len).toDouble();
    var curProgressTypeStr = getSubCellParams(curFlags,0);
    var curProgressTypeColor = getSubCellParams(curFlags,1);
    String progressOperationIconStr = getSubCellParams(curFlags,2);

    progressOperationIconStr = YXXNetdiscModel.localImagePath[progressOperationIconStr];

    return InkWell(
      onLongPress: (){
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return YXXShowAlertDialog('确定删除？', (num index){
                print(index);
                Navigator.pop(context);
            });
          }
        ); 
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 10,top: 10),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.5,color: Colors.black26)
          )
        ),
        child: Row(
          children: <Widget>[
            Container(
              width: 60,
              alignment: Alignment.center,
              child: Image.asset(iconStr),
            ),
            Expanded(
              child: _createCenterContent(fullName, 
              typeFlags,
              completionLength, 
              totalLength, 
              curProgressTypeStr, 
              curProgressTypeColor)
            ),
            Container(
              alignment: Alignment.center,
              width: 60,
              child: Offstage(
                offstage: typeFlags == TotalProgressType.completion.index,
                child: _createCircularProgressIndicator(
                circularProgressIndicatorValue,
                progressOperationIconStr,
                (){
                  widget.detailModel.flags = getUpdateSubCellOperationStatus(curFlags);
                  (context as Element).markNeedsBuild();
                  curFlags = widget.detailModel.flags;
                }),
              )
            )
          ],
        ),
      ),
    );
  }

  Column _createCenterContent (String fullName, num typeFlags, String completionLength,String totalLength,String curProgressTypeStr,Color curProgressTypeColor) {
    return Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  height: 25,
                  child: Text(
                        fullName,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 3),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '$completionLength/$totalLength',
                          overflow:TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12
                          ),
                        ),
                      ),
                      Container(
                        width: 50,
                        alignment: Alignment.bottomRight,
                        child: Offstage(
                          offstage: typeFlags == TotalProgressType.completion.index,
                          child: Text(curProgressTypeStr,style: TextStyle(
                          fontSize: 12,
                          color: curProgressTypeColor
                        ),),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            );
  }

  SizedBox _createCircularProgressIndicator (double value, String iconStr,VoidCallback onTap) {
      return SizedBox(
              width: 35,
              height: 35,
              child: InkWell(
                onTap: onTap,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.black12,
                      strokeWidth: 1.5,
                      value: value,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    Image.asset(iconStr)
                  ],
                ),
              )
            );
  }
}





class TotalProgress extends StatelessWidget {

  final TotalProgressType progressType;
  final VoidClikeCallback onTap;

  TotalProgress ({
    @required this.progressType,
    @required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 0.5,color: Colors.black26)
        )
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TotalProgressSubLeftContainer(progressType: progressType),
          ),
          TotalProgressSubRightContainer(
            progressType: progressType,
            onTap: onTap,
          )
        ],
      ),
    );
  }
}





class TotalProgressSubRightContainer extends StatelessWidget {

  final TotalProgressType progressType;
  final VoidClikeCallback onTap;

  TotalProgressSubRightContainer (
    {@required this.progressType,
    @required this.onTap}
  );

  @override
  Widget build(BuildContext context) {

    String rightButtonTitle,leftButtonTitle;
    bool shouldHiddenLeftButtton = false;

    if (progressType == TotalProgressType.upload || progressType == TotalProgressType.download) {
      rightButtonTitle = '全部暂停';
      leftButtonTitle = '全部继续';
    }else if (progressType == TotalProgressType.completion){
      rightButtonTitle = '全部清除';
      leftButtonTitle = '全部清除';
      shouldHiddenLeftButtton = true;
    }

    // _deleteOperation () {

    //   showDialog(
    //       context: context,
    //       barrierDismissible: false,
    //       builder: (BuildContext context) {
    //         return YXXShowLoadDialog('正在清除...');
    //       }
    //     );

    //   Timer timer = Timer(const Duration(milliseconds: 1500), (){
    //       Navigator.pop(context);
    //   });
      
    // }



    _showTapOperation (String buttonTitle) {

      if (progressType == TotalProgressType.upload) {

        if (buttonTitle != rightButtonTitle) {
          print('上传 全部继续');
          if (onTap != null) {
              onTap(0);
          }
        } else {
          print('上传 全部暂停');
          if (onTap != null) {
              onTap(1);
          }
        }
          
      }else if (progressType == TotalProgressType.download){

        if (buttonTitle != rightButtonTitle) {
          print('下载 全部继续');
          if (onTap != null) {
              onTap(0);
          }
        } else {
          print('下载 全部暂停');
          if (onTap != null) {
              onTap(1);
          }
        }
          
      }else if (progressType == TotalProgressType.completion){

        if (onTap != null) {
              onTap(1);
          }

        // showDialog(
        //   context: context,
        //   barrierDismissible: false,
        //   builder: (BuildContext context) {
        //     return YXXShowAlertDialog('确定全部清除吗？', (num index){
        //         print(index);
        //         Navigator.pop(context);
        //         _deleteOperation();
        //     });
        //   }
        // ); 
      }
    }

    if (shouldHiddenLeftButtton) {
        return Container(
          child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: TotalProgressSubButton(buttonTitle: leftButtonTitle,callBack: (){
                    _showTapOperation(leftButtonTitle);
                  },),
                )
              ],
          ),
      );
          
    } else {
        return Container(
          child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 10,right: 10),
                  child: TotalProgressSubButton(buttonTitle: leftButtonTitle, callBack: (){
                    _showTapOperation(leftButtonTitle);
                  },),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: TotalProgressSubButton(buttonTitle: rightButtonTitle,callBack: () {
                    _showTapOperation(rightButtonTitle);
                  },),
                )
              ],
          ),
      );
    }
  }
}





class TotalProgressSubLeftContainer extends StatefulWidget {

  final TotalProgressType progressType;

  TotalProgressSubLeftContainer (
    {@required this.progressType}
  );

  @override
  _TotalProgressSubLeftContainerState createState() => _TotalProgressSubLeftContainerState();
}

class _TotalProgressSubLeftContainerState extends State<TotalProgressSubLeftContainer> {

  @override
  Widget build(BuildContext context) {

    bool shouldHiddenLeftButtton = false;

    if (widget.progressType == TotalProgressType.upload) {
    } else if (widget.progressType == TotalProgressType.download){
    } else if (widget.progressType == TotalProgressType.completion){
      shouldHiddenLeftButtton = true;
    }
    if (!shouldHiddenLeftButtton) {
      return Container(
        padding: const EdgeInsets.only(left: 15),
        child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(4.0))
                  ),
                  child: SizedBox(
                    height: 8,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.blue[100],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      value: 0.595,
                    ),
                  )
                )
              ),
              Container(
                width: 40,
                child: Text('100%',style: TextStyle(
                  fontSize:14 
                ),),
              )
            ],
        ),
      );
    } else {
      return Container(
        color: Colors.white,
      );
    }
  }
}





class TotalProgressSubButton extends StatefulWidget {

  final String buttonTitle;
  final GestureTapCallback callBack;

  TotalProgressSubButton (
    {@required this.buttonTitle,
    @required this.callBack}
  );

  @override
  _TotalProgressSubButtonState createState() => _TotalProgressSubButtonState();
}

class _TotalProgressSubButtonState extends State<TotalProgressSubButton>  {

  _log () {

    showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return YXXShowAlertDialog('确定删除？', (num index){
                print(index);
                Navigator.pop(context);
            });
          }
        ); 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 26,
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black54,
          width: 1.0,
          ),
        borderRadius: BorderRadius.all(Radius.circular(5))
      ),
      child: InkWell(
          onTap: widget.callBack,
          child: Container(
              margin: EdgeInsets.all(2.0),
              alignment: Alignment.center,
              child: Text(
                        widget.buttonTitle,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                      ),
                  ),
            ),
        )
    );
  }
}