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
    
    // ⚠️该变量未配好,会导致Picker呈现失败、XCode崩溃
    @EnvironmentObject var userSettings: UserSettings
    
    @State var isEditMode = true
    // 选择选项的[索引]
    @State private var unitsSelect = 0
    @State private var ringSelect = 0
    @State private var planSelect = 0
    
    let UnitsOptions = Array(1...30)
    let RingOptions = ["Music1","Music2","Music3"]
    let PlanOptions = Array(1...3)
    
    var body: some View{
        NavigationView {
            Form {
                Section(header: Text("单次运动的单位")) {
                    Picker(selection: $unitsSelect, label: Text("运动单位(min)")) {
                        ForEach(0 ..< UnitsOptions.count) { index in
                            Text(String(self.UnitsOptions[index])).tag(index)
                        }
                    }
                }
                Section(header: Text("运动结束后的铃声")) {
                    Picker(selection: $unitsSelect, label: Text("响铃设置")) {
                        ForEach(RingOptions,id: \.self){    // id为自身
                            Text($0)    // $0指代闭包中的第一个参数,此处就是RingOptions的每一个元素
                        }
                    }
                }
                Section(header: Text("前后两次运动的间隔")) {
                    Picker(selection: $unitsSelect, label: Text("任务计划")) {
                        ForEach(0 ..< PlanOptions.count) {
                            op in Text("\(op)")
                        }
                    }
                }
                
            }//.position(x:200,y:220)
                .navigationTitle("应用设置")
                // 视图消失后保存设置
                .onDisappear{userSettings.saveSettings()}
                
//                VStack{
//                    Text("运动单位").font(.title)
//                        .fontWeight(.bold)
//                        .padding()
//                    if(isEditMode){
//                        Picker("Select a number", selection: $unitsSelect) {
//                            ForEach(UnitsOptions, id: \.self) {
//                                op in Text("\(op)")
//                            }
//                        }
//                        .pickerStyle(DefaultPickerStyle())
//                    }else{
//
//                    }
//                }.padding()
//                VStack{
//                    Text("响铃设置").font(.title)
//                        .fontWeight(.bold)
//                    if(isEditMode){
//
//                    }else{
//
//                    }
//                }.padding()
//                VStack{
//                    Text("任务计划").font(.title)
//                        .fontWeight(.bold)
//                    if(isEditMode){
//
//                    }else{
//
//                    }
//                }.padding()
//
//                if(!isEditMode){
//                    Button("修改设置") {
//                        isEditMode = true;
//                    }.padding(.top).buttonStyle(BlueRoundedButton())  // 使用自定义的样式
//                }else{
//                    HStack{
//                        Button("取消") {
//                            isEditMode = false ;
//                        }.padding(.trailing).buttonStyle(RedRoundedButton())
//                        Button("确定") {
//
//                            isEditMode = false;
//                        }.padding(.leading).buttonStyle(BlueRoundedButton())
//                    }.padding(.top)
//                }
        }
    }
}


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
