//
//  UserInfo.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/7.
//

import SwiftUI

struct UserInfo: View {
    var body: some View {
        VStack{
            Text("个人信息")
                .font(.title)
                .frame(width: 280,alignment: .leading)  // 视图框架大小以及其在框架内的对齐形式
                .padding(.bottom,50)
                
            VStack(alignment: .leading){
                Text("昵称:")
                Text("☎️手机号:")
                Text("🐧QQ:")
                Text("🏠地址:")
            }
           
        }.position(x:170,y:100)
        
        
    }
}

struct UserInfo_Previews: PreviewProvider {
    static var previews: some View {
        UserInfo()
    }
}
