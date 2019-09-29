

enum TotalProgressType { 
   upload, 
   download, 
   completion
}

enum YxxNetdiscCellDetailProgressType { 
   uploadPause, 
   downloadPause, 
   uploading, 
   downloading, 
   completion,
   uploadFail,
   downloadFail
}

//     fileid char(32),    -- 文件id，32位uuid
//     objid varchar2(36), -- msgobj id
//     folderid varchar(32),  -- 所在文件夹id
//     mc varchar2(255),   -- 文件名
//     ex varchar(12), -- 扩展名
//     len number(9),  -- 文件大小
//     localLen number(9),  -- 已经下载文件大小 add
//     cjr varchar2(36),   -- 创建人userid
//     cjsj timestamp, -- 创建时间
//     ksxzsj timestamp, -- 开始下载时间 add
//     xzsj timestamp, -- 下载成功时间 add
//     flags timestamp, -- 状态 add 与 YxxNetdiscCellDetailProgressType 对应
//     typeFlags timestamp, -- 状态 add 与 TotalProgressType 对应
//     xgsj timestamp, -- 修改时间
//     zt number(4) default 0, -- 状态（0正常，1删除）
//     primary key (fileid)

class YXXFileModel {
  int fileid;
  int objid;
  int folderid;
  String mc;
  String ex;
  int len;
  int localLen;
  String cjr;
  int cjsj;
  int ksxzsj;
  int xzsj;
  int flags;
  int typeFlags;
  int zt;

  YXXFileModel(
      {this.fileid,
      this.objid,
      this.folderid,
      this.mc,
      this.ex,
      this.len,
      this.localLen,
      this.cjr,
      this.cjsj,
      this.ksxzsj,
      this.xzsj,
      this.flags,
      this.typeFlags,
      this.zt});

  YXXFileModel.fromJson(Map<String, dynamic> json) {
    fileid = json['fileid'];
    objid = json['objid'];
    folderid = json['folderid'];
    mc = json['mc'];
    ex = json['ex'];
    len = json['len'];
    localLen = json['localLen'];
    cjr = json['cjr'];
    cjsj = json['cjsj'];
    ksxzsj = json['ksxzsj'];
    xzsj = json['xzsj'];
    flags = json['flags'];
    typeFlags = json['typeFlags'];
    zt = json['zt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fileid'] = this.fileid;
    data['objid'] = this.objid;
    data['folderid'] = this.folderid;
    data['mc'] = this.mc;
    data['ex'] = this.ex;
    data['len'] = this.len;
    data['localLen'] = this.localLen;
    data['cjr'] = this.cjr;
    data['cjsj'] = this.cjsj;
    data['ksxzsj'] = this.ksxzsj;
    data['xzsj'] = this.xzsj;
    data['flags'] = this.flags;
    data['typeFlags'] = this.typeFlags;
    data['zt'] = this.zt;
    return data;
  }
}

class YXXFileFolderModel {
  int folderid;
  int parentid;
  String mc;
  String cjr;
  int cjsj;
  int xgsj;
  int xzsj;
  int ksxzsj;
  int flags;
  int zt;

  YXXFileFolderModel(
      {this.folderid,
      this.parentid,
      this.mc,
      this.cjr,
      this.cjsj,
      this.xgsj,
      this.xzsj,
      this.ksxzsj,
      this.flags,
      this.zt});

  YXXFileFolderModel.fromJson(Map<String, dynamic> json) {
    folderid = json['folderid'];
    parentid = json['parentid'];
    mc = json['mc'];
    cjr = json['cjr'];
    cjsj = json['cjsj'];
    xgsj = json['xgsj'];
    xzsj = json['xzsj'];
    ksxzsj = json['ksxzsj'];
    flags = json['flags'];
    zt = json['zt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['folderid'] = this.folderid;
    data['parentid'] = this.parentid;
    data['mc'] = this.mc;
    data['cjr'] = this.cjr;
    data['cjsj'] = this.cjsj;
    data['xgsj'] = this.xgsj;
    data['xzsj'] = this.xzsj;
    data['ksxzsj'] = this.ksxzsj;
    data['flags'] = this.flags;
    data['zt'] = this.zt;
    return data;
  }
}


class YXXNetdiscModel {

    static const String localImageBase = 'lib/Yxx_netdisc_folder/Resource/Images/';

    static const Map localImagePath = {
      'file_other.png' : localImageBase + 'file_other.png',
      'file_video.png' : localImageBase + 'file_video.png',
      'file_compress.png' : localImageBase + 'file_compress.png',
      'file_excel.png' : localImageBase + 'file_excel.png',
      'file_folder.png' : localImageBase + 'file_folder.png',
      'file_pdf.png' : localImageBase + 'file_pdf.png',
      'file_picture.png' : localImageBase + 'file_picture.png',
      'file_ppt.png' : localImageBase + 'file_ppt.png',
      'file_word.png' : localImageBase + 'file_word.png',
      'file_zip.png' : localImageBase + 'file_zip.png',
      'file_txt.png' : localImageBase + 'file_txt.png',
      'file_upload.png' : localImageBase + 'file_upload.png',
      'file_download.png' : localImageBase + 'file_download.png',
      'file_pause.png' : localImageBase + 'file_pause.png',
    };

    static const String netdiscFileTableName = 'netdiscFileTable';
    static const String netdiscFileFolderTableName = 'netdiscFolderTable';
    static const String testJsonStr = '''
    {
      "data": [
        {
          "fileid": 1569377846,
          "objid": 1569377846,
          "folderid": 0,
          "mc": "历史",
          "ex": "doc",
          "len": 1231231,
          "localLen": 123123,
          "cjsj": 1569377846,
          "ksxzsj": 1569377856,
          "xzsj": 1569377866,
          "flags": 1,
          "zt": 1
        },
        {
          "fileid": 1569377856,
          "objid": 1569377856,
          "folderid": 0,
          "mc": "近代史",
          "ex": "pdf",
          "len": 1231231,
          "localLen": 1231,
          "cjsj": 1569377856,
          "ksxzsj": 1569377876,
          "xzsj": 1569377976,
          "flags": 2,
          "zt": 1
        },
        {
          "fileid": 1569377866,
          "objid": 1569377866,
          "folderid": 0,
          "mc": "历史文学",
          "ex": "txt",
          "len": 1231231,
          "localLen": 123123,
          "cjsj": 1569377866,
          "ksxzsj": 1569377886,
          "xzsj": 1569377966,
          "flags": 3,
          "zt": 1
        },
        {
          "fileid": 1569377876,
          "objid": 1569377876,
          "folderid": 0,
          "mc": "历史图片",
          "ex": "jpeg",
          "len": 1231231,
          "localLen": 123123,
          "cjsj": 1569377876,
          "ksxzsj": 1569377976,
          "xzsj": 1569378876,
          "flags": 2,
          "zt": 1
        },
        {
          "fileid": 1569377886,
          "objid": 1569377886,
          "folderid": 0,
          "mc": "历史合集",
          "ex": "zip",
          "len": 1231231,
          "localLen": 123123,
          "cjsj": 1569377886,
          "ksxzsj": 1569377986,
          "xzsj": 1569378886,
          "flags": 1,
          "zt": 1
        },
        {
          "fileid": 1569377896,
          "objid": 1569377896,
          "folderid": 0,
          "mc": "历史讲解",
          "ex": "ppt",
          "len": 1231231,
          "localLen": 123123,
          "cjsj": 1569377896,
          "ksxzsj": 1569377996,
          "xzsj": 1569378896,
          "flags": 2,
          "zt": 1
        },
        {
          "fileid": 1569377906,
          "objid": 1569377906,
          "folderid": 0,
          "mc": "历史文集",
          "ex": "doc",
          "len": 1231231,
          "localLen": 123123,
          "cjsj": 1569377906,
          "ksxzsj": 1569378906,
          "xzsj": 1569379906,
          "flags": 1,
          "zt": 1
        },
        {
          "fileid": 1569377916,
          "objid": 1569377916,
          "folderid": 0,
          "mc": "历史",
          "ex": "doc",
          "len": 1231231,
          "localLen": 123123,
          "cjsj": 1569377916,
          "ksxzsj": 1569378916,
          "xzsj": 1569387916,
          "flags": 3,
          "zt": 1
        },
        {
          "fileid": 1569377926,
          "objid": 1569377926,
          "folderid": 0,
          "mc": "语文",
          "ex": "doc",
          "len": 1231231,
          "localLen": 123123,
          "cjsj": 1569377926,
          "ksxzsj": 1569378926,
          "xzsj": 1569387926,
          "flags": 3,
          "zt": 1
        },
        {
          "fileid": 1569377936,
          "objid": 1569377936,
          "folderid": 0,
          "mc": "文学",
          "ex": "doc",
          "len": 1231231,
          "localLen": 123123,
          "cjsj": 1569377936,
          "ksxzsj": 1569378936,
          "xzsj": 1569387936,
          "flags": 1,
          "zt": 1
        }
      ]
    }
    ''';
}

