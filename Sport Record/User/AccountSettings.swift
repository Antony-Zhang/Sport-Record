//
//  AccountSettings.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/10.
//

import SwiftUI

struct AccountSettings: View {
    @EnvironmentObject var dataBase :SQLiteDatabase
    @EnvironmentObject var userSettings :UserSettings
    
    @State var isEditMode = true
    
    var body: some View {
//        NavigationView {
            Form() {
                HStack(alignment: .center){
                    Image(uiImage: dataBase.getUserInfo(id: userSettings.id).logo).resizable()    // 修饰符,使Image对象大小可随意调整
                        .frame(width: 100,height: 100)
                        //   .scaledToFit()
                        //   .scaleEffect(0.25) //设置缩放比例
                        .clipShape(Circle())    // 裁剪图像边框形状
                    
                    VStack(alignment: .leading){
                        Text(dataBase.getUserInfo(id: userSettings.id).username).font(.title)
                        Text("ID:  "+userSettings.id).font(.title2)
                            .foregroundColor(.gray)
                    }
                }.padding()
                Section{
                    //  todo 功能迭代
//                    Button("修改密码") {
//                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
//                    }.font(.title).foregroundColor(.black).padding()
                    Button("退出账号") {
                        userSettings.id = ""
                        userSettings.notLogin.toggle()
                    }.font(.title).foregroundColor(.red).padding()
                }
            }.navigationTitle("账号设置")  //  使用navigationTitle而不是Text来设置标题
//        }
    }
}
    struct AccountSettings_Previews: PreviewProvider {
        static var previews: some View {
            AccountSettings().environmentObject(SQLiteDatabase.shared)
                .environmentObject(UserSettings.shared)
        }
    }
