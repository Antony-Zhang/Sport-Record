//
//  UserInfo.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/7.
//

import SwiftUI

struct UserInfo: View {
    @StateObject var userSettings = UserSettings.shared      //  设置信息
    @StateObject var dataBase = SQLiteDatabase.shared   //  用户数据
    
    @State var isEditMode = false;  // 修改状态
    @State var userInfo = Info()
    
    @State var nameReg = "无"
    @State var phoneReg = "无"
    @State var qqReg = "无"
    @State var addressReg = "无"
    
    
    var body: some View {
//        NavigationView(){     //  会使页面切换时下偏,但从主页面开始调试时、标题会出现
        Form(){
            HStack{
                Text("头像").font(.title2)
                Spacer()
                Image(userInfo.logo).resizable()    // 修饰符,使Image对象大小可随意调整
                    .frame(width: 60,height: 60)
                //   .scaledToFit()
                //   .scaleEffect(0.25) //设置缩放比例
                    .clipShape(Circle())    // 裁剪图像边框形状
                    
            }
            HStack{
                Text("👤昵称:").font(.title2)
                if(isEditMode){
                    TextField("输入", text: $nameReg) // text是用来存输入字符的变量的引用
                        .textFieldStyle(DefualtTextFeild())
                }else{
                    Text(userInfo.username).font(.title2).frame(width: 200)
                }
            }.frame(height: 40)
            HStack{
                Text("☎️手机:").font(.title2)
                if(isEditMode){
                    TextField("输入", text: $phoneReg) // text是用来存输入字符的变量
                        .textFieldStyle(DefualtTextFeild())
                }else{
                    Text(userInfo.phone).font(.title2).frame(width: 200)
                }
            }.frame(height: 40)
            HStack{
                Text("🐧扣扣:").font(.title2)
                if(isEditMode){
                    TextField("输入", text: $qqReg) // text是用来存输入字符的变量
                        .textFieldStyle(DefualtTextFeild())
                }else{
                    Text(userInfo.qq).font(.title2).frame(width: 200)
                }
            }.frame(height: 40)
            HStack{
                Text("🏠地址:").font(.title2)
                if(isEditMode){
                    TextField("输入", text: $addressReg) // text是用来存输入字符的变量
                        .textFieldStyle(DefualtTextFeild())
                }else{
                    Text(userInfo.address).font(.title2).frame(width: 200)
                }
            }.frame(height: 40)
            
            HStack{
                Spacer()
                if(!isEditMode){
                    Button("修改信息") {
                        isEditMode = true;
                    }.buttonStyle(BlueRoundedButton())  // 使用自定义的样式
                }else{
                    HStack{
                        Button("取消") {
                            isEditMode = false ;
                        }.padding(.trailing).buttonStyle(RedRoundedButton())
                        Button("确定") {
                            userInfo.username = nameReg;
                            userInfo.phone = phoneReg;
                            userInfo.qq = qqReg;
                            userInfo.address = addressReg;
                            //  更新数据库
                            dataBase.updateUserInfo(id: userSettings.id, username: userInfo.username, phone: userInfo.phone, address: userInfo.address, qq: userInfo.qq, logo: userInfo.logo)
                            isEditMode = false;
                        }.padding(.leading).buttonStyle(BlueRoundedButton())
                    }
                }
                Spacer()
            }
        }.navigationTitle("个人信息")
            .onAppear{
                userInfo = dataBase.getUserInfo(id: userSettings.id)
            }
        
//        }
    }
}




struct UserInfo_Previews: PreviewProvider {
    static var previews: some View {
        UserInfo().environmentObject(SQLiteDatabase.shared)
            .environmentObject(UserSettings.shared)
    }
}
