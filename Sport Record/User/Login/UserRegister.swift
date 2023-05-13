//
//  UserRegister.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/4.
//

import SwiftUI

struct UserRegister: View {
//    @State var id = 
    var body: some View {
        VStack {
            Text("用户注册")
                .font(.system(.largeTitle,design: .rounded))      // 修成largeTitle的样式而且是圆弧的
                .fontWeight(.bold)  // 加粗
                .shadow(color:.gray,radius: 2,x:0,y:10)    // 阴影
                .foregroundColor(.red)  // 字体颜色
//                .background(Color.gray) // 背景颜色
                .multilineTextAlignment(.leading)   // 对齐
                .padding(30)
            
            HStack {
                Text(" 用 户 名: ").font(.title2)
                TextField("输入用户名", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)// text是用来存输入字符的变量
                    .textFieldStyle(DefualtTextFeild())
            }.padding(10)
            
            HStack {
                Text("密       码: ").font(.title2)
                TextField("输入密码", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/) // text是用来存输入字符的变量
                    .textFieldStyle(DefualtTextFeild())
            }.padding(10)
            
            HStack {
                Text("确认密码:").font(.title2)
                TextField("再次输入密码", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/) // text是用来存输入字符的变量
                    .textFieldStyle(DefualtTextFeild())
            }.padding(10)
            
            Button("注册") {
                
            }
            .padding(.top)
            .buttonStyle(BlueRoundedButton())
            
        }.position(x:200,y:200) // 相对于父视图左上角的的位置
        //.offset(y:-100)   // 在当前位置基础上的偏移
    }
}

struct UserRegister_Previews: PreviewProvider {
    static var previews: some View {
        UserRegister()
    }
}
