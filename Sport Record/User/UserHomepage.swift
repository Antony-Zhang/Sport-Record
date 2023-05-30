//
//  UserHomepage.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/4.
//

import SwiftUI

struct UserHomepage : View{
    @EnvironmentObject var dataBase :SQLiteDatabase
    @EnvironmentObject var userSettings: UserSettings
    @State var userInfo: Info = Info()
    
    var body: some View{
        NavigationView {
            Form {
                Section{
                    HStack(alignment: .center){
                        Image(uiImage: userInfo.logo).resizable()    // 修饰符,使Image对象大小可随意调整
                            .frame(width: 100,height: 100)
                        //   .scaledToFit()
                        //   .scaleEffect(0.25) //设置缩放比例
                            .clipShape(Circle())    // 裁剪图像边框形状
                            Spacer()
                        VStack(alignment: .leading){
                            Text(userInfo.username).font(.title)
                            Text("ID:  " + userSettings.id).font(.title2)
                                .foregroundColor(.gray)
                        }
                    }.padding()
                }
                // done 在自视图修改信息后,返回本视图不会立刻刷新,而需要点击“运动”之后返回才刷新
                //  (推测是因为视图切换过程中没有终结母视图,且子视图和母视图的值之间不是直接进行binding)
                NavigationLink(destination: UserInfo(userInfo: $userInfo).environmentObject(dataBase)) {
                    Text("个人信息").font(.title).padding()
                }
                NavigationLink(destination: RecordCharts().environmentObject(dataBase)){
                    Text("个人数据").font(.title).padding()
                }
                NavigationLink(destination: Settings().environmentObject(userSettings)) {
                    Text("运动设置").font(.title).padding()
                }
                NavigationLink(destination: AccountSettings().environmentObject(dataBase)) {
                    Text("账号设置").font(.title).padding()
                }
            }//.position(x:200,y:220)
            .navigationTitle("个人")  //  使用navigationTitle而不是Text来设置标题
        }.onAppear{
            userInfo = dataBase.getUserInfo(id: userSettings.id)
        }
    }
}

struct UserHomepage_Previews: PreviewProvider {
    static var previews: some View {
        UserHomepage().environmentObject(SQLiteDatabase.shared)
            .environmentObject(UserSettings.shared)
    }
}
