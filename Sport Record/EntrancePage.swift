//
//  EntrancePage.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/9.
//

import SwiftUI

struct EntrancePage: View {
    //  引入数据库对象
    @EnvironmentObject var dataBase :SQLiteDatabase
    //  引入设置数据对象
    @EnvironmentObject var userSettings :UserSettings
    
    var body: some View {
        TabView {   // 底部导航栏
            Sport().tabItem {
                Image(systemName: "figure.run")
                Text("运动")
            }
            UserHomepage().tabItem {
                Image(systemName: "person")
                Text("个人")
            }
        }
    }
}

struct EntrancePage_Previews: PreviewProvider {
    static var previews: some View {
        EntrancePage()
    }
}
