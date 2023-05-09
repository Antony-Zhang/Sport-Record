//
//  UserHomepage.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/4.
//

import SwiftUI

//struct UserHomepage: View {
//    var body: some View {
//        VStack{
//            HStack{
//                Text("主页")
//                    .font(.title)
//                    .frame(width: 250,alignment: .leading)  // 视图框架大小以及其在框架内的对齐形式
//                Label("设置", systemImage: "⚙️")
//            }.padding(.bottom,15)
//            //.alignmentGuide(.leading, computeValue: {d in d[.leading]})
//
//            HStack{
//                Image("logo") // 用户头像
//                    .resizable()    // 修饰符,使Image对象大小可随意调整
//                    .frame(width: 60,height: 60)
//                //                    .scaledToFit()
//                //                    .scaleEffect(0.25)  // 设置缩放比例
//                    .clipShape(Circle())    // 裁剪图像边框形状
//                VStack(alignment: .leading){
//                    Text("用户名").font(.title3)
//                    Text("ID")
//                }.padding(.trailing,150)
//            }
//
//            Button("个人信息"){
//                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
//            }
//            Button("软件信息"){
//                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
//            }
//            Button("退出账号") {
//                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
//            }.foregroundColor(.red)
//                .padding(15)
//        }.position(x:170,y:100) // 相对于父视图左上角的的位置
//            //.edgesIgnoringSafeArea(.top) // 忽视安全区,使所有子视图都与本视图的顶部对齐
//    }
//}

struct UserHomepage : View{
    var body: some View{
        NavigationView {
            VStack {
                NavigationLink(destination: Settings()) {
                    Text("设置")
                }
                NavigationLink(destination: UserInfo()) {
                    Text("个人信息")
                }
            }
            .navigationTitle("个人")  //  使用navigationTitle而不是Text来设置标题
        }
    }
}

struct UserHomepage_Previews: PreviewProvider {
    static var previews: some View {
        UserHomepage()
    }
}
