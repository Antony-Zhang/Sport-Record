//
//  UserLogin.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/4.
//

import SwiftUI

struct UserLogin: View {
    var body: some View {
        VStack {
            Text("用户登录")
                .font(.system(.largeTitle,design: .rounded))      // 修成largeTitle的样式而且是圆弧的
                .fontWeight(.bold)  // 加粗
                .shadow(color:.gray,radius: 2,x:0,y:10)    // 阴影
                .foregroundColor(.blue)  // 字体颜色
//                .background(Color.gray) // 背景颜色
                .multilineTextAlignment(.leading)   // 对齐
                .padding(30)
            
            HStack {
                Text("用户名:").font(.system(size:25))
                TextField("输入用户名", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)// text是用来存输入字符的变量
                    .offset(x:15)
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.gray,lineWidth:1))
                    .frame(width: 250)
            }
            
            HStack {
                Text("密    码:").font(.system(size:25))
                TextField("输入密码", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/) // text是用来存输入字符的变量
                    .offset(x:15)
                    .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.gray,lineWidth:1))
                    .frame(width: 250)
            }
            
            
            Button("登录") {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
            }.foregroundColor(.black)
                .padding(15)
                
            
        }.position(x:200,y:200) // 相对于父视图左上角的的位置
        //.offset(y:-100)   // 在当前位置基础上的偏移
    }
}

struct UserLogin_Previews: PreviewProvider {
    static var previews: some View {
        UserLogin()
    }
}
