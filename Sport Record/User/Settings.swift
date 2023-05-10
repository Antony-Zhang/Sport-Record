//
//  Settings.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/4.
//

import SwiftUI

//struct Settings: View {
//    var body: some View {
//        VStack{
//            Text("设置")
//                .font(.title)
//                .frame(width: 280,alignment: .leading)  // 视图框架大小以及其在框架内的对齐形式
//                .padding(.bottom,60)
//
//            VStack{
//                Button("运动单位") {
//                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
//                }
//                Button("响铃设置"){
//                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
//                }
//                Button("任务计划"){
//                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
//                }
//            }
//
//        }.position(x:170,y:100)
//
//
//    }
//}

struct Settings : View{
    var body: some View{
        NavigationView {
//            VStack {
//                Text("设置")
//                    .font(.title)
//                    .frame(width: 280,alignment: .leading)  // 视图框架大小以及其在框架内的对齐形式
//                    .padding(.bottom,60)
                VStack{
                    Button("运动单位") {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    }.font(.title).padding()
                    Button("响铃设置"){
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    }.font(.title).padding()
                    Button("任务计划"){
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                    }.font(.title).padding()
                }
                .navigationTitle("设置")
//            }
        }
    }
}


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
