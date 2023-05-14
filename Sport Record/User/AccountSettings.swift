//
//  AccountSettings.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/10.
//

import SwiftUI

struct AccountSettings: View {
    @EnvironmentObject var dataBase :SQLiteDatabase
    
    @State var isEditMode = true
    @State var n = ""
    
    var body: some View {
//        NavigationView {
            Form() {
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
                Section{
                    Button("修改密码") {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    }.font(.title).foregroundColor(.black).padding()
                    Button("退出账号") {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    }.font(.title).foregroundColor(.red).padding()
                }
            }.navigationTitle("账号设置")  //  使用navigationTitle而不是Text来设置标题
//        }
    }
}
    struct AccountSettings_Previews: PreviewProvider {
        static var previews: some View {
            AccountSettings().environmentObject(SQLiteDatabase.shared)
        }
    }
