import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../../Model/yxx_netdisc_model.dart';

class DataBaseHelper {

  static final DataBaseHelper _instance = DataBaseHelper.internal();
  factory DataBaseHelper() => _instance;
  static Database _db;
  DataBaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {

    String dataBasePath = await getDatabasesPath();
    String path = join(dataBasePath,'yxx_netdisc.db');

    print(path);

    Database db;

    try {

      db = await openDatabase(path,version: 1,onCreate: (Database db,int version) async {

          await db.execute(SqlTable.sql_createTable_netdiscFileTable);
          await db.execute(SqlTable.sql_createTable_netdiscFolderTable);
          print('db created version is $version');

      },onOpen: (Database db) async {

          print('new db opend');
      });

    } catch (e) {
      print(e);
    }

    return db;
  }


  Future<List<String>> getTables() async {
    if (_db == null) {
      return Future.value([]);
    }
    List tables = await _db
        .rawQuery('SELECT name FROM sqlite_master WHERE type = "table"');
    List<String> targetList = [];
    tables.forEach((item) {
      targetList.add(item['name']);
    });
    return targetList;
  }

  // 检查数据库中, 表是否完整, 在部份android中, 会出现表丢失的情况
  Future checkTableIsRight() async {
    //将项目中使用的表的表名添加集合中
    List<String> expectTables = [YXXNetdiscModel.netdiscFileTableName,YXXNetdiscModel.netdiscFileFolderTableName]; 
    List<String> tables = await getTables();
 
    for (int i = 0; i < expectTables.length; i++) {
      if (!tables.contains(expectTables[i])) {
        return false;
      }
    }
    return true;
  }

}

class SqlTable {

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
//     flags timestamp, -- 状态 add
//     xgsj timestamp, -- 修改时间
//     zt number(4) default 0, -- 状态（0正常，1删除）
//     primary key (fileid)

  static final String sql_createTable_netdiscFileTable = '''CREATE TABLE ${YXXNetdiscModel.netdiscFileTableName}(
          fileid INTEGER PRIMARY KEY,
          objid INTEGER, 
          folderid INTEGER,
          len INTEGER,
          localLen INTEGER, 
          flags INTEGER,
          typeFlags INTEGER, 
          mc TEXT, 
          ex TEXT, 
          cjr TEXT,
          cjsj INTEGER,
          ksxzsj INTEGER,
          xzsj INTEGER,
          xgsj INTEGER,
          zt INTEGER)
        ''';

// folderid char(32),  -- 文件夹id，32位uuid
// parentid varchar(32),   -- 父文件夹id
// mc varchar2(255),   -- 文件夹名
// cjr varchar2(36),   -- 创建人userid
// cjsj timestamp, -- 创建时间
// xgsj timestamp, -- 修改时间
// ksxzsj timestamp, -- 开始下载时间 add
// xzsj timestamp, -- 下载时间 add
// flags int add 
// zt number(4) default 0, -- 状态（0正常，1删除）
// primary key (folderid)

  static final String sql_createTable_netdiscFolderTable = '''CREATE TABLE ${YXXNetdiscModel.netdiscFileFolderTableName}(
          folderid INTEGER PRIMARY KEY,
          parentid INTEGER, 
          mc TEXT, 
          cjr TEXT,
          cjsj INTEGER,
          xgsj INTEGER,
          xzsj INTEGER,
          ksxzsj INTEGER,
          zt INTEGER,
          flags INTEGER)
        ''';
}