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
    //  引入设置对象
    @EnvironmentObject var userSettings :UserSettings
    
    var body: some View {
        TabView {   // 底部导航栏
            Sport()
                .environmentObject(dataBase)
                .environmentObject(userSettings)
                .tabItem {
                Image(systemName: "figure.jumprope")
                Text("运动")
            }
            UserHomepage()
                .environmentObject(dataBase)
                .environmentObject(userSettings)
                .tabItem {
                Image(systemName: "person.circle")
                Text("用户")
            }
        }.fullScreenCover(isPresented: $userSettings.notLogin){
            if(userSettings.signIn){
                UserRegister()
                    .environmentObject(dataBase)
                    .environmentObject(userSettings)
            }else{
                UserLogin()
                    .environmentObject(dataBase)
                    .environmentObject(userSettings)
            }
        }
    }
}

struct EntrancePage_Previews: PreviewProvider {
    static var previews: some View {
        EntrancePage().environmentObject(SQLiteDatabase.shared)
            .environmentObject(UserSettings.shared)
    }
}
