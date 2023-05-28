//
//  UserRegister.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/4.
//

import SwiftUI

struct UserRegister: View {
    @EnvironmentObject var dataBase :SQLiteDatabase
    @EnvironmentObject var userSettings: UserSettings
    @State var id = ""
    @State var password = ""
    @State var second_password = ""
    @State var msg = " "
//    ["账户格式错误","账户已存在","密码长度少于6位","前后密码不一致"]
    var body: some View {
        NavigationView{
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
                    TextField("输入用户名", text: $id)// text是用来存输入字符的变量
                        .textFieldStyle(DefualtTextFeild())
                }.padding(10)
                
                HStack {
                    Text("密       码: ").font(.title2)
                    SecureField("输入密码", text: $password) // text是用来存输入字符的变量
                        .textFieldStyle(DefualtTextFeild())
                }.padding(10)
                
                HStack {
                    Text("确认密码:").font(.title2)
                    SecureField("再次输入密码", text: $second_password) // text是用来存输入字符的变量
                        .textFieldStyle(DefualtTextFeild())
                }.padding(10)
                
                Text("已有账号? **点此登录**").onTapGesture {
                    withAnimation(){    //  渐变切换效果
                        userSettings.signIn.toggle()
                    }
                }.foregroundColor(.blue)
                .padding(.top)
                
                Button("注册") {
                    //  done: 如何加入判断,通过才跳转
                    if(register()){
                        userSettings.notLogin.toggle()
                    }
                }.padding(.top)
                    .buttonStyle(BlueRoundedButton())
                
                Text(msg).foregroundColor(.red).bold()
                
            }.position(x:200,y:250) // 相对于父视图左上角的的位置
        }
    }
    //  注册函数
    func register() -> Bool{
        guard !id.isEmpty, !password.isEmpty, !second_password.isEmpty else{
            msg = "输入格式有误"
            return false
        }
        if(password.count < 6){
            msg = "密码长度小于6"
            return false
        }else if(password != second_password){
            msg = "密码两次输入不一致"
            return false
        }else{
            if let newid = dataBase.addUser(id: id, password: password){
                //  添加用户
                print("新用户id:\(newid)")
                return true
            }else{
                msg = "账户已存在"
                return false
            }
        }
    }
}

struct UserRegister_Previews: PreviewProvider {
    static var previews: some View {
        UserRegister().environmentObject(SQLiteDatabase.shared)
            .environmentObject(UserSettings.shared)
    }
}
