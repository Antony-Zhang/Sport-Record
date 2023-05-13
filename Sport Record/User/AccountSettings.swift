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
        NavigationView {
            VStack {
                HStack{
                    Text("👮昵称:").font(.title2)
                    if(isEditMode){
                        TextField("输入", text: $n) // text是用来存输入字符的变量的引用
                            .offset(x:15)
                            .font(.title2)
                            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.gray,lineWidth:1))
                            .frame(width: 200)
                    }else{
                        Text("").font(.title2).frame(width: 200)
                    }
                }.frame(height: 40)
                
            }.position(x:200,y:220)
            .navigationTitle("账号设置")  //  使用navigationTitle而不是Text来设置标题
        }
    }
}

struct AccountSettings_Previews: PreviewProvider {
    static var previews: some View {
        AccountSettings().environmentObject(SQLiteDatabase.shared)
    }
}
