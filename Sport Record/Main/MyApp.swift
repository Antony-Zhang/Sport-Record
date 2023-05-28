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
