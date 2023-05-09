//
//  UserInfo.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/7.
//

import SwiftUI

struct UserInfo: View {
    var body: some View {
        NavigationView(){
            VStack(alignment: .leading){
                Text("昵称:")
                Text("☎️手机号:")
                Text("🐧QQ:")
                Text("🏠地址:")
            }
            .navigationTitle("个人信息")
        }
    }
}

struct UserInfo_Previews: PreviewProvider {
    static var previews: some View {
        UserInfo()
    }
}
