//
//  UserLogin.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/4.
//

import SwiftUI

struct UserLogin: View {
    @EnvironmentObject var dataBase :SQLiteDatabase
    @EnvironmentObject var userSettings: UserSettings
    @State var id = ""
    @State var password = ""
    @State var msg = " "
    var body: some View {
        NavigationView(){
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
                    TextField("输入用户名", text: $id)// text是用来存输入字符的变量
                        .textFieldStyle(DefualtTextFeild())
                }.padding(10)
                
                HStack {
                    Text("密    码:").font(.system(size:25))
                    TextField("输入密码", text: $password) // text是用来存输入字符的变量
                        .textFieldStyle(DefualtTextFeild())
                }.padding(10)
                
                Text("没有账号? **点此注册**").onTapGesture {
                    withAnimation(){
                        userSettings.signIn.toggle()
                    }
                }.foregroundColor(.blue)
                .padding(.top)
                
                Button("登录") {
                    //  done 加入判断,通过才登录
                    if(login()){
                        userSettings.notLogin.toggle()
                    }
                }.buttonStyle(BlueRoundedButton())
                
                Text(msg).foregroundColor(.red).bold()
                    
            }.position(x:200,y:220) // 相对于父视图左上角的的位置
        }
    }
    //  登录函数
    func login() -> Bool{
        guard !id.isEmpty, !password.isEmpty else{
            msg = "输入格式有误"
            return false
        }
        if(password.count < 6){
            msg = "密码长度小于6"
            return false
        }else if (dataBase.getUser(id: id) == nil) {
            //  核查用户账户
            msg = "用户不存在"
            return false
        }else{
            userSettings.id = id
            return true
        }
    }
}

struct UserLogin_Previews: PreviewProvider {
    static var previews: some View {
        UserLogin().environmentObject(SQLiteDatabase.shared)
            .environmentObject(UserSettings.shared)
    }
}
