//
//  Settings.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/4.
//

import SwiftUI

struct Settings : View{
    /*
     运动单位:双重选择——1⃣️时间上
     响铃设置:
     */
    let UnitOptions = 0...30
    @State var isEditMode = false
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View{
        NavigationView {
            VStack(alignment: .center){
                VStack{
                    Text("运动单位").font(.title).fontWeight(.bold)
                    if(isEditMode){
                        
                    }else{
                        
                    }
                }.padding()
                VStack{
                    Text("响铃设置").font(.title).fontWeight(.bold)
                    if(isEditMode){
                        
                    }else{
                        
                    }
                }.padding()
                VStack{
                    Text("任务计划").font(.title).fontWeight(.bold)
                    if(isEditMode){
                        
                    }else{
                        
                    }
                }.padding()
                
                if(!isEditMode){
                    Button("修改设置") {
                        isEditMode = true;
                    }.padding(.top).buttonStyle(BlueRoundedButton())  // 使用自定义的样式
                }else{
                    HStack{
                        Button("取消") {
                            isEditMode = false ;
                        }.padding(.trailing).buttonStyle(RedRoundedButton())
                        Button("确定") {
                            
                            isEditMode = false;
                        }.padding(.leading).buttonStyle(BlueRoundedButton())
                    }.padding(.top)
                }
            }.position(x:200,y:220)
                .navigationTitle("应用设置")
                // 视图消失后保存设置
                .onDisappear{userSettings.saveSettings()}
        }
    }
}


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
