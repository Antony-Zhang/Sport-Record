//
//  Sport_RecordApp.swift
//  Sport Record
//
//  Created by EastOS on 2023/4/27.
//

import SwiftUI
import SQLite3

@main
struct MyApp: App {
    //  单例数据对象
    @StateObject var userSettings = UserSettings.shared      //  设置信息
    @StateObject var dataBase = SQLiteDatabase.shared   //  用户数据
    
    var body: some Scene {
        WindowGroup {
            //  根视图
            EntrancePage().environmentObject(dataBase)  //  传入数据库对象
                .environmentObject(userSettings)        //  传入设置对象
        }
    }
}


//  用户设置类 [单例模式]
class UserSettings :ObservableObject{
    static let shared = UserSettings()  //  唯一单例
    
    @Published var sportUnits: Int = 1  //  运动单位(min)
    @Published var ring: String = "Music1"       //  响铃设置
    @Published var plan: Int = 1       //  运动计划(天)
    @Published var id: String   // 用户id
    
    let userDefaults = UserDefaults.standard
    
    //  读取设置
    private init() {
        sportUnits = Int(userDefaults.integer(forKey: "sportUnits"))
        ring = userDefaults.string(forKey: "ring") ?? "Music1"
        plan = Int(userDefaults.integer(forKey: "plan"))
        id = userDefaults.string(forKey: "id") ?? ""
    }
    
    //  保存设置
    func saveSettings() {
        userDefaults.set(sportUnits, forKey: "sportUnits")
        userDefaults.set(ring, forKey: "ring")
        userDefaults.set(plan, forKey: "plan")
        userDefaults.set(id, forKey: id)
    }
}

// 用户信息结构体 !!! 暂且
struct Info {
    var id: String! = "无"
    var username: String! = "无"
    var phone: String! = "无"
    var address: String! = "无"
    var qq: String! = "无"
    var logo: String! = "logo"
}
//  运动数据结构体 !!!! 暂且使用String
struct SportData{
    var id: String!
    var dateTime: String!
    var consumTIme: String!
    var checkImage: String!
}

// SQLite3数据库管理类 [单例模式]
class SQLiteDatabase: ObservableObject {
    static let shared = SQLiteDatabase()    //  单例
    static var id = "ytzd"     //  当前用户的id
    private var dbPointer: OpaquePointer?   // 指针
    
    //  用户账号表
    let createUserQuery = """
        CREATE TABLE IF NOT EXISTS Users (
            id TEXT PRIMARY KEY NOT NULL,
            password TEXT NOT NULL
        );
        """
    //  用户信息表
    let createUserInfoQuery = """
         CREATE TABLE IF NOT EXISTS UserInfo (
            id TEXT PRIMARY KEY NOT NULL,
            username TEXT,
            phone TEXT,
            address TEXT,
            qq TEXT,
            logo BLOB,
            FOREIGN KEY (id) REFERENCES Users(id) ON DELETE CASCADE ON UPDATE CASCADE
        );
    """
    //  用户运动数据表
    let createSportDataQuery = """
        CREATE TABLE IF NOT EXISTS SportData (
            id TEXT PRIMARY KEY NOT NULL,
            dateTime DATETIME,
            consumTime TEXT,
            checkImage BLOB,
            FOREIGN KEY (id) REFERENCES Users(id) ON DELETE CASCADE ON UPDATE CASCADE
        );
    """
    
    //  初始化
    private init() {
        dbPointer = nil
        // 打开数据库,文件为“MovieRecord.db”
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("MovieRecord.db")
        if sqlite3_open(fileURL.path, &dbPointer) == SQLITE_OK {
            print("数据库打开成功!")
        }else{
            print("数据库打开失败!")
        }
        //  若空则建表
        if sqlite3_exec(dbPointer, createUserQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("用户账户表创建失败: \(errmsg)")
        }
        if sqlite3_exec(dbPointer, createUserInfoQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("用户信息表创建失败: \(errmsg)")
        }
        if sqlite3_exec(dbPointer, createSportDataQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("运动数据表创建失败: \(errmsg)")
        }
    }
    //  析构
    deinit{
        if(sqlite3_close(dbPointer) == SQLITE_OK){
            print("数据库关闭成功!")
        }
    }
    
    /*   账户信息   */
    //  新建账户
    func addUser(id: String, password: String){
        let insertUserQuery = "INSERT INTO Users (id, password) VALUES (?, ?);"
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        if sqlite3_prepare_v2(dbPointer, insertUserQuery, -1, &statement, nil) == SQLITE_OK{
            //  填充SQLite语句中的参数 done 参数填充的时候,需要采用nasstring转utf8
            sqlite3_bind_text(statement, 1, (id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (password as NSString).utf8String, -1, nil)
            //  执行语句
            if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(dbPointer))
                print("账户插入失败: \(errmsg)")
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("账户插入语句组织失败: \(errmsg)")
        }
        sqlite3_finalize(statement)
    }
    //  查询账户密码
    func getUser() -> String{
        let getUserQuery = "SELECT password FROM Users WHERE id=?"
        var password = ""
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        if sqlite3_prepare_v2(dbPointer, getUserQuery, -1, &statement, nil) == SQLITE_OK{
            //  填充SQLite语句中的参数
            sqlite3_bind_text(statement, 1, (SQLiteDatabase.id as NSString).utf8String, -1, nil)
            //  执行语句
            if sqlite3_step(statement) == SQLITE_ROW{
                password = String(cString: sqlite3_column_text(statement, 0))
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("查询账户密码语句组织失败: \(errmsg)")
        }
        sqlite3_finalize(statement)
        return password
    }
    //  更新密码
    func updateUser(password: String){
        let updateUserQuery = "UPDATE Users SET password=?"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(dbPointer, updateUserQuery, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_text(statement, 1, (password as NSString).utf8String, -1, nil)
            //   执行语句
            if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(dbPointer))
                print("账户密码更新失败: \(errmsg)")
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("账户密码更新语句组织失败: \(errmsg)")
        }
        sqlite3_finalize(statement)
    }
    
    /*   用户信息   */
    //  查询用户信息
    func getUserInfo() -> Info {
        let getUserInfoQuery = "SELECT * FROM UserInfo WHERE id=?"
        var userInfo = Info()
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        if sqlite3_prepare_v2(dbPointer, getUserInfoQuery, -1, &statement, nil) == SQLITE_OK{
            //  填充SQLite语句中的参数
            //  替代进去的字符串都换成nsstring.uft8string,源自参考大作业:“string直接插入会变成blob”
            print(sqlite3_bind_text(statement, 1, (SQLiteDatabase.id as NSString).utf8String, -1, nil))
            //  执行语句
            //  Q: step返回的是101,即执行完毕,但没有查询到结果; 破案:Navicat中手动添加数据无效,必须在swift中建表并插入数据
            if sqlite3_step(statement) == SQLITE_ROW{
                //  todo !!!!暂且
                userInfo.id = String(cString: sqlite3_column_text(statement, 0))
                userInfo.username = String(cString: sqlite3_column_text(statement, 1))
                userInfo.phone = String(cString: sqlite3_column_text(statement, 2))
                userInfo.address = String(cString: sqlite3_column_text(statement, 3))
                userInfo.qq = String(cString: sqlite3_column_text(statement, 4))
                userInfo.logo = String(cString: sqlite3_column_text(statement, 5))
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("查询用户信息语句组织失败: \(errmsg)")
        }
        sqlite3_finalize(statement)
        return userInfo
    }
    //  更新用户信息
    func updateUserInfo(username: String, phone: String, address: String, qq: String, logo: String){
        let updateUserInfoQuery = (ExitOrNot(table: "UserInfo")) ?
            "UPDATE UserInfo SET username=?, phone=?, address=?, qq=?, logo=? WHERE id=?;" :
            "INSERT INTO UserInfo(username, phone, address, qq, logo, id) VALUES(?, ?, ?, ?, ?, ?);"
        
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        if sqlite3_prepare_v2(dbPointer, updateUserInfoQuery, -1, &statement, nil) == SQLITE_OK{
            //  填充SQLite语句中的参数
            sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (phone as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (address as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (qq as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (logo as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 6, (SQLiteDatabase.id as NSString).utf8String, -1, nil)
            //  执行语句
            if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(dbPointer))
                print("用户信息更新失败: \(errmsg)")
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("用户信息更新语句组织失败: \(errmsg)")
        }
        sqlite3_finalize(statement)
    }
    
    /*   运动数据   */
    //   查询运动数据 !!!!暂且
    func getSportData() -> SportData{
        let getSportDataQuery = "SELECT * FROM SportData WHERE id=?"
        var sportData = SportData()
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        if sqlite3_prepare_v2(dbPointer, getSportDataQuery, -1, &statement, nil) == SQLITE_OK{
            //  填充SQLite语句中的参数
            sqlite3_bind_text(statement, 1, (SQLiteDatabase.id as NSString).utf8String, -1, nil)
            //  执行语句
            if sqlite3_step(statement) == SQLITE_ROW{
                //  !!!!暂且
                sportData.id = String(cString: sqlite3_column_text(statement, 0))
                sportData.dateTime = String(cString: sqlite3_column_text(statement, 1))
                sportData.consumTIme = String(cString: sqlite3_column_text(statement, 2))
                sportData.checkImage = String(cString: sqlite3_column_text(statement, 3))
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("查询用户信息语句组织失败: \(errmsg)")
        }
        sqlite3_finalize(statement)
        return sportData
    }
    //  保存运动数据 !!!! 暂且选择String数据类型
    func saveSportData(dateTime: String, consumTime: String, checkImage: String){
        let saveSportDataQuery = "INSERT INTO SportData(id, dataTime, consumTime, checkTime) VALUES(?, ?, ?, ?);"
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        if sqlite3_prepare_v2(dbPointer, saveSportDataQuery, -1, &statement, nil) == SQLITE_OK{
            //  填充SQLite语句中的参数
            sqlite3_bind_text(statement, 1, (SQLiteDatabase.id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (dateTime as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (consumTime as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (checkImage as NSString).utf8String, -1, nil)
            //  执行语句
            if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(dbPointer))
                print("运动数据保存失败: \(errmsg)")
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("保存运动数据语句组织失败: \(errmsg)")
        }
        sqlite3_finalize(statement)
    }
    
    //  判断表项是否存在本用户数据
    func ExitOrNot(table: String) -> Bool{
        let exitQuery = "SELECT * FROM \(table) WHERE id=?"    //  ⚠️SQL语言不能多空格!!!!
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(dbPointer, exitQuery, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_text(statement, 1, (SQLiteDatabase.id as NSString).utf8String, -1, nil)
            //  done:(bug) sqlite3_step执行返回报错SQLITE_MISUSE; 推测是因为数据库连接有问题
            let s1 = sqlite3_step(statement)
            if  s1 == SQLITE_ROW{
                //  todo 此处对返回的处理有误
                if (String(cString: sqlite3_column_text(statement, 0)) != ""){
                    print("表项\(table)存在")
                    return true
                }
            }else{
                print(s1)
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("表项判断语句组织失败: \(errmsg)")
        }
        print("表项\(table)不存在")
        sqlite3_finalize(statement)
        return false
    }
}
