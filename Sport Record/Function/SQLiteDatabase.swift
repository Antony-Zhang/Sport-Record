//
//  SQLiteDatabase.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/28.
//

import SwiftUI
import SQLite3
import Foundation

// 用户信息结构体
struct Info {
    var id: String! = "id"
    var username: String! = "昵称"
    var phone: String! = "电话"
    var address: String! = "地址"
    var qq: String! = "扣扣"
    var logo: UIImage! = UIImage(named: "logo") //  默认为内嵌的图像
}
//  运动数据结构体
struct SportData{
    var id: String! = "id"
    var date: Date! = Date()
    var consumTime: Date! = Date()
    var checkImage: UIImage! = UIImage(named: "sport")
}

// SQLite3数据库管理类 [单例模式]
class SQLiteDatabase: ObservableObject {
    static let shared = SQLiteDatabase()    //  单例
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
            dateString TEXT,
            consumTime TEXT,
            checkImage BLOB,
            FOREIGN KEY (id) REFERENCES Users(id) ON DELETE CASCADE ON UPDATE CASCADE
        );
    """
    
    //  初始化
    private init() {
        dbPointer = nil
        // 打开数据库,文件为“SportRecord.db”
        let filemanager = FileManager.default
        let fileURL = try! filemanager
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("SportRecord.db")
        if sqlite3_open(fileURL.path, &dbPointer) == SQLITE_OK {
            print("数据库打开成功!")
        }else{
            print("数据库打开失败!")
        }
        //  若空则建表
        if sqlite3_exec(dbPointer, createUserQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("用户账户表创建失败: \(errmsg)")
        }else{
            print("用户账户表建表成功")
        }
        if sqlite3_exec(dbPointer, createUserInfoQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("用户信息表创建失败: \(errmsg)")
        }else{
            print("用户信息表建表成功")
        }
        if sqlite3_exec(dbPointer, createSportDataQuery, nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("运动数据表创建失败: \(errmsg)")
        }else{
            print("运动数据表建表成功")
        }
    }
    //  析构
    deinit{
        if(sqlite3_close(dbPointer) == SQLITE_OK){
            print("数据库关闭成功!")
        }
    }
    
    /*   账户信息   */
    //  新建账户,返回id
    func addUser(id: String, password: String) -> String?{
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
                return nil
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("账户插入语句组织失败: \(errmsg)")
            return nil
        }
        sqlite3_finalize(statement)
        return id
    }
    //  查询账户密码
    func getUser(id: String) -> String?{
        let getUserQuery = "SELECT password FROM Users WHERE id = ?"
        var password : String!
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        if sqlite3_prepare_v2(dbPointer, getUserQuery, -1, &statement, nil) == SQLITE_OK{
            //  填充SQLite语句中的参数
            sqlite3_bind_text(statement, 1, (id as NSString).utf8String, -1, nil)
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
    func getUserInfo(id: String) -> Info {
        let getUserInfoQuery = "SELECT * FROM UserInfo WHERE id=?"
        var userInfo = Info()
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        if sqlite3_prepare_v2(dbPointer, getUserInfoQuery, -1, &statement, nil) == SQLITE_OK{
            //  填充SQLite语句中的参数
            //  替代进去的字符串都换成nsstring.uft8string,源自参考大作业:“string直接插入会变成blob”
            sqlite3_bind_text(statement, 1, (id as NSString).utf8String, -1, nil)
            //  执行语句
            //  Q: step返回的是101,即执行完毕,但没有查询到结果; 破案:Navicat中手动添加数据无效,必须在swift中建表并插入数据
            if sqlite3_step(statement) == SQLITE_ROW{
                userInfo.id = String(cString: sqlite3_column_text(statement, 0))
                userInfo.username = String(cString: sqlite3_column_text(statement, 1))
                userInfo.phone = String(cString: sqlite3_column_text(statement, 2))
                userInfo.address = String(cString: sqlite3_column_text(statement, 3))
                userInfo.qq = String(cString: sqlite3_column_text(statement, 4))
                //  done 数据库取图片
//                userInfo.logo = String(cString: sqlite3_column_text(statement, 5))
                let imageData = sqlite3_column_blob(statement, 5)
                let imageSize = sqlite3_column_bytes(statement, 5)
                if let data = imageData, imageSize > 4 {
                    let data = Data(bytes: data, count: Int(imageSize))
                    userInfo.logo = UIImage(data: data)
                }else{
                    print("getUserInfo()取图片错误,数据不存在")
                }
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("查询用户信息语句组织失败: \(errmsg)")
        }
        sqlite3_finalize(statement)
        return userInfo
    }
    //  更新用户信息——LOGO done 更新无效
    func updateLogo(id: String, logo: UIImage){
        let updateLogoQuery = (ExitOrNot(table: "UserInfo", id: id)) ?
            "UPDATE UserInfo SET logo=? WHERE id=?;" :
            "INSERT INTO UserInfo(logo, id) VALUES(?, ?);"
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        let reg = sqlite3_prepare_v2(dbPointer, updateLogoQuery, -1, &statement, nil)
        print(reg)
        if reg == SQLITE_OK{
            //  填充SQLite语句参数
            guard let data = logo.pngData() else{
                print("参数logo错误")
                return
            }
            sqlite3_bind_blob(statement, 1, (data as NSData).bytes, Int32(data.count), nil)
            sqlite3_bind_text(statement, 2, (id as NSString).utf8String, -1, nil)
            //  执行语句
            if sqlite3_step(statement) != SQLITE_DONE{
                let errmsg = String(cString: sqlite3_errmsg(dbPointer))
                print("用户信息logo更新失败: \(errmsg)")
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("用户信息logo更新语句组织失败: \(errmsg)")
        }
        sqlite3_finalize(statement)
        
    }
    //  更新用户信息——除了LOGO
    func updateUserInfo(id: String,username: String, phone: String, address: String, qq: String){
        let updateUserInfoQuery = (ExitOrNot(table: "UserInfo",id: id)) ?
            "UPDATE UserInfo SET username=?, phone=?, address=?, qq=? WHERE id=?;" :
            "INSERT INTO UserInfo(username, phone, address, qq, id) VALUES(?, ?, ?, ?, ?);"
        //  done sql语句如何写? 保持不变,占位符就够了
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        //  done Insert下prepare报错“table UserInfo has no column named logo”; 但是重启电脑直接运行竟然成功了!!
        let reg = sqlite3_prepare_v2(dbPointer, updateUserInfoQuery, -1, &statement, nil)
        print(reg)
        if reg == SQLITE_OK{
            //  填充SQLite语句中的参数
            sqlite3_bind_text(statement, 1, (username as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (phone as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (address as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (qq as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 5, (id as NSString).utf8String, -1, nil)
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
    //   查询运动数据,返回所有运动数据
    func getSportData(id: String) -> [SportData]{
        let getSportDataQuery = "SELECT * FROM SportData WHERE id=? ORDER BY dateString"
        var sportDataList = [SportData]()
        var statement: OpaquePointer?
        //  将String转化为SQLite语句对象并编译
        // todo 报错:查询运动数据语句组织失败: no such column: dateString
        let reg = sqlite3_prepare_v2(dbPointer, getSportDataQuery, -1, &statement, nil)
        print(reg)
        if reg == SQLITE_OK{
            //  填充SQLite语句中的参数
            sqlite3_bind_text(statement, 1, (id as NSString).utf8String, -1, nil)
            //  执行语句
            while sqlite3_step(statement) == SQLITE_ROW{
                var sportData = SportData()
                let timeString = String(cString: sqlite3_column_text(statement, 2))
                let dateString = String(cString: sqlite3_column_text(statement, 1))
                sportData.id = String(cString: sqlite3_column_text(statement, 0))
                sportData.date = TimeManager.stringDate(dateString: dateString)
                sportData.consumTime = TimeManager.stringTime(timeString: timeString)
                //  done 数据库取图片
                let imageData = sqlite3_column_blob(statement, 3)
                let imageSize = sqlite3_column_bytes(statement, 3)
                if let data = imageData, imageSize > 4 {
                    let data = Data(bytes: data, count: Int(imageSize))
                    sportData.checkImage = UIImage(data: data)
                }else{
                    print("getSportData()取图片错误,数据不存在")
                }
                sportDataList.append(sportData)
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("查询运动数据语句组织失败: \(errmsg)")
        }
        sqlite3_finalize(statement)
        return sportDataList
    }
    //  保存运动数据 todo
    func saveSportData(id: String, date: Date, consumTime: Date, checkImage: UIImage){
        let saveSportDataQuery = "INSERT INTO SportData(id, dateString, consumTime, checkImage) VALUES(?, ?, ?, ?);"
        var statement: OpaquePointer?
        //  done sql语句如何写 不变
        //  将String转化为SQLite语句对象并编译
        // todo 报错: 保存运动数据语句组织失败: table SportData has no column named dateString
        if sqlite3_prepare_v2(dbPointer, saveSportDataQuery, -1, &statement, nil) == SQLITE_OK{
            let dateString = TimeManager.dateString(date: date)
            let timeString = TimeManager.timeString(time: consumTime)
            //  填充SQLite语句中的参数
            sqlite3_bind_text(statement, 1, (id as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (dateString as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 3, (timeString as NSString).utf8String, -1, nil)
            //  done 图片如何更新
            guard let data = checkImage.pngData() else{
                print("参数checkImage")
                return
            }
            sqlite3_bind_blob(statement, 4, (data as NSData).bytes, Int32(data.count), nil)
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
    func ExitOrNot(table: String,id: String) -> Bool{
        let exitQuery = "SELECT * FROM \(table) WHERE id=?"    //  ⚠️SQL语言不能多空格!!!!
        var statement: OpaquePointer?
        if sqlite3_prepare_v2(dbPointer, exitQuery, -1, &statement, nil) == SQLITE_OK{
            sqlite3_bind_text(statement, 1, (id as NSString).utf8String, -1, nil)
            //  done:(bug) sqlite3_step执行返回报错SQLITE_MISUSE; 推测是因为数据库连接有问题
            if  sqlite3_step(statement) == SQLITE_ROW{
                //  done 此处对返回的处理有误
                if (String(cString: sqlite3_column_text(statement, 0)) != ""){
                    print("表项\(table)存在")
                    return true
                }
            }
        }else{
            let errmsg = String(cString: sqlite3_errmsg(dbPointer))
            print("表项判断语句组织失败: \(errmsg)")
        }
        print("用户\(id)在表项\(table)中无数据")
        sqlite3_finalize(statement)
        return false
    }
}
