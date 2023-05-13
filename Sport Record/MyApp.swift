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

// 用户模型
struct User {
    let id: Int32
    let name: String
    let age: Int
}

//// 保存用户数据
//struct Userdata {
//    // 账号信息
//    var username: String!
//    var id: String!
//    var password: String!
//    // 个人信息
//    var phone: String!
//    var address: String!
//    var qq: String!
//}


//  用户设置类 [单例模式]
class UserSettings :ObservableObject{
//    @Published var backgroundColor: Color = .white
//    @Published var fontSize: CGFloat = 12.0
//    @Published var showTutorial: Bool = true
    static let shared = UserSettings()  //  唯一单例
    
    @Published var sportUnits: Int32 = 1  //  运动单位(min)
    @Published var ring: String = "Music1"       //  响铃设置
    @Published var plan: Int32 = 1       //  运动计划(天)
    
    let userDefaults = UserDefaults.standard
    
    //  读取设置
    private init() {
        sportUnits = Int32(userDefaults.integer(forKey: "sportUnits"))
        ring = userDefaults.string(forKey: "ring") ?? "Music1"
        plan = Int32(userDefaults.integer(forKey: "plan"))
//        backgroundColor = Color(userDefaults.string(forKey: "backgroundColor") ?? "white")
//        fontSize = CGFloat(userDefaults.float(forKey: "fontSize"))
//        showTutorial = userDefaults.bool(forKey: "showTutorial")
    }
    
    //  保存设置
    func saveSettings() {
        userDefaults.set(sportUnits, forKey: "sportUnits")
        userDefaults.set(ring, forKey: "ring")
        userDefaults.set(plan, forKey: "plan")
//        userDefaults.set(backgroundColor.description, forKey: "backgroundColor")
//        userDefaults.set(Float(fontSize), forKey: "fontSize")
//        userDefaults.set(showTutorial, forKey: "showTutorial")
    }
}

// SQLite3数据库管理类 [单例模式]
class SQLiteDatabase: ObservableObject {
    static let shared = SQLiteDatabase()    //  单例
    
    private var dbPointer: OpaquePointer?   // 指针
    
    private init() {
        dbPointer = nil
        // 打开数据库,文件为“myDatabase.sqlite”
        let fileURL = try! FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("myDatabase.sqlite")
        if sqlite3_open(fileURL.path, &dbPointer) != SQLITE_OK {
            print("数据库打开失败!")
        }
        
        // 创建表格,名为Users
        let createTableQuery = """
        CREATE TABLE IF NOT EXISTS Users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INTEGER
        );
        """
        if sqlite3_exec(dbPointer, createTableQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("创建表格失败: \(errmsg)")
        }
    }
    
    // 保存用户数据
    func saveUser(name: String, age: Int) {
        let insertQuery = "INSERT INTO Users (name, age) VALUES (?, ?);"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(dbPointer, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, name, -1, nil)
            sqlite3_bind_int(statement, 2, Int32(age))
            if sqlite3_step(statement) != SQLITE_DONE {
                let errmsg = String(cString: sqlite3_errmsg(dbPointer))
                print("数据插入失败: \(errmsg)")
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("error preparing statement: \(errmsg)")
        }
        sqlite3_finalize(statement)
    }
    
    // 查询用户数据
    func getUsers() -> [User] {
        var users: [User] = []
        let query = "SELECT * FROM Users;"
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(dbPointer, query, -1, &statement, nil) == SQLITE_OK {
            while sqlite3_step(statement) == SQLITE_ROW {
                let id = sqlite3_column_int(statement, 0)
                let name = String(cString: sqlite3_column_text(statement, 1))
                let age = Int(sqlite3_column_int(statement, 2))
                users.append(User(id: id, name: name, age: age))
            }
        } else {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("error preparing statement: \(errmsg)")
        }
        sqlite3_finalize(statement)
        return users
    }
}


