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
    //  从母视图UserHomepage传来的绑定值,保证本视图修改后母视图信息的同步更新
    @Binding var userInfo: Info
    
    @State var isEditMode = false;  // 修改状态
    
    @State private var showImagePicker = false  //  进行图片选择(相册or拍照)
    @State private var showActionSheet = false  //  进行图片来源选择
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary   //  来源类型(默认相册)
    
    var body: some View {
//        NavigationView(){     //  会使页面切换时下偏,但从主页面开始调试时、标题会出现
        Form(){
            Section{
                HStack{
                    Text("头像").font(.title2)
                    Spacer()
                    Text("点击更换").foregroundColor(.gray)
                        .onTapGesture {
                            showActionSheet = true
                        }
                    Image(uiImage: userInfo.logo).resizable()    // 修饰符,使Image对象大小可随意调整
                        .frame(width: 60,height: 60)
                    //   .scaledToFit()
                    //   .scaleEffect(0.25) //设置缩放比例
                        .clipShape(Circle())    // 裁剪图像边框形状
                    
                }
            }
            .actionSheet(isPresented: $showActionSheet){
                ActionSheet(title: Text("选择图片"),message: nil,buttons: [
                    .default(Text("相册")){
                        sourceType = .photoLibrary
                        showImagePicker = true
                    },
                    .default(Text("拍照")){
                        sourceType = .camera
                        showImagePicker = true
                    },
                    .cancel()
                ])
            }
            .sheet(isPresented: $showImagePicker,
                   content: {
                ImagePicker(sourceType: sourceType) { image in
                    userInfo.logo = image
                }
            })
            
            HStack{
                Text("👤昵称:").font(.title2)
                if(isEditMode){
                    TextField("输入", text: $userInfo.username) // text是用来存输入字符的变量的引用
                        .textFieldStyle(DefualtTextFeild())
                }else{
                    Text(userInfo.username).font(.title2).frame(width: 200)
                }
            }.frame(height: 40)
            HStack{
                Text("☎️手机:").font(.title2)
                if(isEditMode){
                    TextField("输入", text: $userInfo.phone) // text是用来存输入字符的变量
                        .textFieldStyle(DefualtTextFeild())
                }else{
                    Text(userInfo.phone).font(.title2).frame(width: 200)
                }
            }.frame(height: 40)
            HStack{
                Text("🐧扣扣:").font(.title2)
                if(isEditMode){
                    TextField("输入", text: $userInfo.qq) // text是用来存输入字符的变量
                        .textFieldStyle(DefualtTextFeild())
                }else{
                    Text(userInfo.qq).font(.title2).frame(width: 200)
                }
            }.frame(height: 40)
            HStack{
                Text("🏠地址:").font(.title2)
                if(isEditMode){
                    TextField("输入", text: $userInfo.address) // text是用来存输入字符的变量
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
                            //  更新数据库,注意username是绑定值
                            dataBase.updateUserInfo(id: userSettings.id, username: userInfo.username, phone: userInfo.phone, address: userInfo.address, qq: userInfo.qq)
                            isEditMode = false;
                        }.padding(.leading).buttonStyle(BlueRoundedButton())
                    }
                }
                Spacer()
            }
        }.navigationTitle("个人信息")
            .onDisappear{
                dataBase.updateLogo(id: userSettings.id, logo: userInfo.logo)
            }
    }
}



//struct UserInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        UserInfo(userInfo: $userInfo).environmentObject(SQLiteDatabase.shared)
//            .environmentObject(UserSettings.shared)
//    }
//}
