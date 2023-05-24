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


// SQLite3数据库管理类 [单例模式]
class SQLiteDatabase: ObservableObject {
    static let shared = SQLiteDatabase()    //  单例
    static var id = ""     //  当前用户的id
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
        if sqlite3_open(fileURL.path, &dbPointer) != SQLITE_OK {
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
    //  新建用户
    func addUser(id: String, password: String){
        let insertUserQuery = "INSERT INTO Users (id, password) VALUES (?, ?);"
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        if sqlite3_prepare_v2(dbPointer, insertUserQuery, -1, &statement, nil) == SQLITE_OK{
            //  填充SQLite语句中的参数
            sqlite3_bind_text(statement, 1, id, -1, nil)
            sqlite3_bind_text(statement, 2, password, -1, nil)
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
    //  更新用户数据
    func updateUserInfo(username: String, phone: String, address: String, qq: String){
        let updateUserInfoQuery = (ExitOrNot(table: "UserINfo")) ?
            "UPDATE UserInfo SET username = ?, phone = ?, address = ?, qq = ? WHERE id = ?;" :
            "INSERT INTO UserInfo(username, phone, address, qq, id) VALUES(?, ?, ?, ?, ?);"
        
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        if sqlite3_prepare_v2(dbPointer, updateUserInfoQuery, -1, &statement, nil) == SQLITE_OK{
            //  填充SQLite语句中的参数
            sqlite3_bind_text(statement, 1, username, -1, nil)
            sqlite3_bind_text(statement, 2, phone, -1, nil)
            sqlite3_bind_text(statement, 3, address, -1, nil)
            sqlite3_bind_text(statement, 4, qq, -1, nil)
            sqlite3_bind_text(statement, 5, SQLiteDatabase.id, -1, nil)
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
    //  保存运动数据 !!!! 此处暂且选择String数据类型
    func saveSportData(dateTime: String, consumTime: String, checkImage: String){
        let saveSportDataQuery = "INSERT INTO SportData(id, dataTime, consumTime, checkTime) VALUES(?, ?, ?, ?);"
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        if sqlite3_prepare_v2(dbPointer, saveSportDataQuery, -1, &statement, nil) == SQLITE_OK{
            //  填充SQLite语句中的参数
            sqlite3_bind_text(statement, 1, SQLiteDatabase.id, -1, nil)
            sqlite3_bind_text(statement, 2, dateTime, -1, nil)
            sqlite3_bind_text(statement, 3, consumTime, -1, nil)
            sqlite3_bind_text(statement, 4, checkImage, -1, nil)
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
        let exitQUery = "SELECT * FROM UserInfo WHEN id = ?"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(dbPointer, exitQUery, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_text(statement, 1, SQLiteDatabase.id, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_ROW{
                return (String(cString: sqlite3_column_text(statement, 0)) != "")
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("表项判断语句组织失败: \(errmsg)")
        }
        return false
    }
    
//    // 查询所有用户数据
//    func getUsers() -> [User] {
//        var users: [User] = []
//        let query = "SELECT * FROM Users;"
//        var statement: OpaquePointer?
//        if sqlite3_prepare_v2(dbPointer, query, -1, &statement, nil) == SQLITE_OK {
//            while sqlite3_step(statement) == SQLITE_ROW {
//                let id = String(cString: sqlite3_column_text(statement, 0))
//                let username = String(cString: sqlite3_column_text(statement, 1))
//                let password = String(cString: sqlite3_column_text(statement, 3))
//                let phone = String(cString: sqlite3_column_text(statement, 4))
//                let address = String(cString: sqlite3_column_text(statement, 5))
//                let qq = String(cString: sqlite3_column_text(statement, 6))
//                users.append(User(id: id, username: username, password: password, phone: phone, address: address, qq: qq))
//            }
//        } else {
//            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
//            print("error preparing statement: \(errmsg)")
//        }
//        sqlite3_finalize(statement)
//        return users
//    }
}


