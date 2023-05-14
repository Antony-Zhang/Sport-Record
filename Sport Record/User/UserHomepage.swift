//
//  UserHomepage.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/4.
//

import SwiftUI

struct UserHomepage : View{
    @EnvironmentObject var dataBase :SQLiteDatabase
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View{
        NavigationView {
            Form {
                Section{
                    HStack(alignment: .center){
                        Image("logo").resizable()    // 修饰符,使Image对象大小可随意调整
                            .frame(width: 100,height: 100)
                        //   .scaledToFit()
                        //   .scaleEffect(0.25) //设置缩放比例
                            .clipShape(Circle())    // 裁剪图像边框形状
                        
                        VStack(alignment: .leading){
                            Text("Fishead_East").font(.title)
                            Text("ID:  "+"ytzd2696").font(.title2)
                                .foregroundColor(.gray)
                        }
                    }.padding()
                }
                NavigationLink(destination: UserInfo().environmentObject(dataBase)) {
                    Text("个人信息").font(.title).padding()
                }
                NavigationLink(destination: RecordCharts().environmentObject(dataBase)){
                    Text("个人数据").font(.title).padding()
                }
                NavigationLink(destination: Settings().environmentObject(userSettings)) {
                    Text("运动设置").font(.title).padding()
                }
                NavigationLink(destination: AccountSettings().environmentObject(dataBase)) {
                    Text("账号设置").font(.title).padding()
                }
            }//.position(x:200,y:220)
            .navigationTitle("个人")  //  使用navigationTitle而不是Text来设置标题
        }
    }
}

struct UserHomepage_Previews: PreviewProvider {
    static var previews: some View {
        UserHomepage().environmentObject(SQLiteDatabase.shared)
            .environmentObject(UserSettings.shared)
    }
}
