import '../Model/yxx_netdisc_model.dart';
import '../Util/DB/Yxx_data_base_helper.dart';
import 'package:flutter/material.dart';

class YXXNetdiscManager {

  Future <int> insertFileFolder(YXXFileFolderModel folderModel) async {
    return insertObj(YXXNetdiscModel.netdiscFileFolderTableName, folderModel.toJson());
  }

  Future <int> deleteFileFolderWithFolderid(int folderid) async {
    return deleteFileFolder('folderid', folderid);
  }

  Future <int> deleteFileFolder(String key,dynamic value) async {
    return deleteObj(YXXNetdiscModel.netdiscFileFolderTableName, key, value);
  }

  Future <int> updateFileFolder(YXXFileFolderModel fileModel) async {
    return updateObj(YXXNetdiscModel.netdiscFileFolderTableName, fileModel.toJson(), 'folderid', fileModel.folderid);
  }

  Future <int> updateFileFolderWithMap(Map params,String key,dynamic value) async {
    return updateObj(YXXNetdiscModel.netdiscFileFolderTableName, params, key, value);
  }


  Future <int> insertFile(YXXFileModel fileModel) async {
    return insertObj(YXXNetdiscModel.netdiscFileTableName, fileModel.toJson());
  }

  Future <int> deleteFileWithFileid(int fileid) async {
    return await deleteFile('fileid', fileid);
  }

  Future <int> deleteFile(String key,dynamic value) async {
    return deleteObj(YXXNetdiscModel.netdiscFileTableName, key, value);
  }

  Future <int> updateFile(YXXFileModel fileModel) async {
    return updateObj(YXXNetdiscModel.netdiscFileTableName, fileModel.toJson(), 'fileid', fileModel.fileid);
  }

  Future <int> updateFileWithMap(Map params,String key,dynamic value) async {
    return updateObj(YXXNetdiscModel.netdiscFileTableName, params, key, value);
  }

  Future <int> insertObj(String tableName,Map params) async {

    var db = await DataBaseHelper().db;
    var result;

    try {
      result = await db.insert(tableName,params);
    } catch (e) {
      print('insertObj error = $e');
    }

    return result;
  }

  Future <int> deleteObj(String tableName, String key,dynamic value) async {

    var db = await DataBaseHelper().db;
    var result = await db.delete(tableName,where: '$key = ?',whereArgs: [value]);
    return result;
  }

  Future <int> updateObj(String tableName,Map params,String key,dynamic value) async {
    var db = await DataBaseHelper().db;
    var result = await db.update(tableName, params, where:'$key = ?', whereArgs: [value]);
    return result;
  }

  


  Future<YXXFileModel> getFile(int fileid) async {

    var db = await DataBaseHelper().db;
    List<Map> result = await db.query(YXXNetdiscModel.netdiscFileTableName,
        where: 'fileid = ?',
        whereArgs: [fileid]);
    if (result.length > 0) {
      return YXXFileModel.fromJson(result.first);
    }
    return null;
  }

  Future<List<YXXFileModel>> selectFiles(int limit, int offset, int folderid, TotalProgressType type) async {

    var db = await DataBaseHelper().db;
    var result = await db.query(
      YXXNetdiscModel.netdiscFileTableName,
      where: 'folderid = ? and typeFlags = ?',
      whereArgs: [folderid,type.index],
      limit: limit,
      offset: offset,
    );
    List<YXXFileModel> files = [];
    result.forEach((item) => files.add(YXXFileModel.fromJson(item)));
    return files;
  }

}


getSubCellParams (int flags, int type) {

    var curProgressTypeStr = '已暂停';
    var curProgressTypeColor = Colors.blue;
    var progressOperationIconStr = 'file_upload.png';

    if (flags == YxxNetdiscCellDetailProgressType.downloadPause.index) {
      curProgressTypeStr = '已暂停';
      curProgressTypeColor = Colors.red;
      progressOperationIconStr = 'file_download.png';
    } else if (flags == YxxNetdiscCellDetailProgressType.uploadPause.index) {
      curProgressTypeStr = '已暂停';
      curProgressTypeColor = Colors.red;
      progressOperationIconStr = 'file_upload.png';
    } else if (flags == YxxNetdiscCellDetailProgressType.uploading.index) {
      curProgressTypeStr = '正在上传';
      progressOperationIconStr = 'file_pause.png';
    } else if (flags == YxxNetdiscCellDetailProgressType.downloading.index) {
      curProgressTypeStr = '正在下载';
      progressOperationIconStr = 'file_pause.png';
    } else if (flags == YxxNetdiscCellDetailProgressType.completion.index) {
      curProgressTypeStr = '已完成';
      progressOperationIconStr = 'file_upload.png';
    } else if (flags == YxxNetdiscCellDetailProgressType.uploadFail.index) {
      curProgressTypeStr = '上传失败';
      progressOperationIconStr = 'file_upload.png';
      curProgressTypeColor = Colors.red;
    } else if (flags == YxxNetdiscCellDetailProgressType.downloadFail.index) {
      curProgressTypeStr = '下载失败';
      progressOperationIconStr = 'file_download.png';
      curProgressTypeColor = Colors.red;
    }

    if (type == 0) {

      return  curProgressTypeStr;
      
    } else if (type == 1) {

      return  curProgressTypeColor;

    } else if (type == 2) {

      return  progressOperationIconStr;
    }
}


int getUpdateSubCellOperationStatus (int flags) {

    var updateFlags;

    if (flags == YxxNetdiscCellDetailProgressType.downloadPause.index) {
      updateFlags = YxxNetdiscCellDetailProgressType.downloading.index;
    } else if (flags == YxxNetdiscCellDetailProgressType.uploadPause.index) {
      updateFlags = YxxNetdiscCellDetailProgressType.uploading.index;
    }  else if (flags == YxxNetdiscCellDetailProgressType.uploading.index) {
      updateFlags = YxxNetdiscCellDetailProgressType.uploadPause.index;
    } else if (flags == YxxNetdiscCellDetailProgressType.downloading.index) {
      updateFlags = YxxNetdiscCellDetailProgressType.downloadPause.index;
    } else if (flags == YxxNetdiscCellDetailProgressType.completion.index) {
    } else if (flags == YxxNetdiscCellDetailProgressType.uploadFail.index) {
      updateFlags = YxxNetdiscCellDetailProgressType.downloadPause.index;
    } else if (flags == YxxNetdiscCellDetailProgressType.downloadFail.index) {
      updateFlags = YxxNetdiscCellDetailProgressType.downloadPause.index;
    }

    return  updateFlags;
}



String YxxNetdiscIconStrWithFileName (String fileFullName) {

  var lowFileFullName = fileFullName.toLowerCase();
  var imageStr = 'file_other.png';

  if (lowFileFullName.endsWith('.rar')) {
    imageStr = 'file_compress.png';
  } else if (lowFileFullName.endsWith('.xlsx')||lowFileFullName.endsWith('.xls')) {
    imageStr = 'file_excel.png';
  } else if (lowFileFullName.endsWith('.file_folder')) {
    imageStr = 'file_folder.png';
  } else if (lowFileFullName.endsWith('.pdf')) {
    imageStr = 'file_pdf.png';
  } else if (lowFileFullName.endsWith('.ppt')) {
    imageStr = 'file_ppt.png';
  } else if (lowFileFullName.endsWith('.mp4')) {
    imageStr = 'file_video.png';
  } else if (lowFileFullName.endsWith('.doc') || lowFileFullName.endsWith('.docx')) {
    imageStr = 'file_word.png';
  } else if (lowFileFullName.endsWith('.zip')) {
    imageStr = 'file_zip.png';
  } else if (lowFileFullName.endsWith('.txt')) {
    imageStr = 'file_txt.png';
  } else if (lowFileFullName.endsWith('.png') || lowFileFullName.endsWith('.jpg')
  || lowFileFullName.endsWith('.jpeg')) {
    imageStr = 'file_picture.png';
  }

  return YXXNetdiscModel.localImagePath[imageStr];
}