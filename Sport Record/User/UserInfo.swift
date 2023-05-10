//
//  UserInfo.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/7.
//

import SwiftUI

struct UserInfo: View {
    @State var isEditMode = false;  // 修改状态
    @State var logo = "logo"
    @State var name = "无"
    @State var phone = "无"
    @State var qq = "无"
    @State var address = "无"
    @State var nameReg = "无"
    @State var phoneReg = "无"
    @State var qqReg = "无"
    @State var addressReg = "无"
    
    
    var body: some View {
        NavigationView(){
            VStack(alignment: .center){
                Image(logo).resizable()    // 修饰符,使Image对象大小可随意调整
                    .frame(width: 100,height: 100)
                    //   .scaledToFit()
                    //   .scaleEffect(0.25) //设置缩放比例
                    .clipShape(Circle())    // 裁剪图像边框形状
                    .padding(.top)
                
                VStack(alignment: .leading){
                    HStack{
                        Text("👮昵称:").font(.title2)
                        if(isEditMode){
                            TextField("输入", text: $nameReg) // text是用来存输入字符的变量的引用
                                .offset(x:15)
                                .font(.title2)
                                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.gray,lineWidth:1))
                                .frame(width: 200)
                        }else{
                            Text(name).font(.title2).frame(width: 200)
                        }
                    }.frame(height: 40)
                    HStack{
                        Text("☎️手机:").font(.title2)
                        if(isEditMode){
                            TextField("输入", text: $phoneReg) // text是用来存输入字符的变量
                                .offset(x:15)
                                .font(.title2)
                                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.gray,lineWidth:1))
                                .frame(width: 200)
                        }else{
                            Text(phone).font(.title2).frame(width: 200)
                        }
                    }.frame(height: 40)
                    HStack{
                        Text("🐧扣扣:").font(.title2)
                        if(isEditMode){
                            TextField("输入", text: $qqReg) // text是用来存输入字符的变量
                                .offset(x:15)
                                .font(.title2)
                                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.gray,lineWidth:1))
                                .frame(width: 200)
                        }else{
                            Text(qq).font(.title2).frame(width: 200)
                        }
                    }.frame(height: 40)
                    HStack{
                        Text("🏠地址:").font(.title2)
                        if(isEditMode){
                            TextField("输入", text: $addressReg) // text是用来存输入字符的变量
                                .offset(x:15)
                                .font(.title2)
                                .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.gray,lineWidth:1))
                                .frame(width: 200)
                        }else{
                            Text(address).font(.title2).frame(width: 200)
                        }
                    }.frame(height: 40)
                }
                .padding(.bottom)
                
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
                            name = nameReg;
                            phone = phoneReg;
                            qq = qqReg;
                            address = addressReg;
                            isEditMode = false;
                        }.padding(.leading).buttonStyle(BlueRoundedButton())
                    }
                }
            }.position(x:200,y:180)
            .navigationTitle("个人信息")
        }
    }
}




struct UserInfo_Previews: PreviewProvider {
    static var previews: some View {
        UserInfo()
    }
}
