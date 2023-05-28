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
    
    let UnitsOptions = Array(1...30)
    let RingOptions = ["Music1","Music2","Music3"]
    let PlanOptions = Array(1...3)
    
    var body: some View{
//        NavigationView {
            Form {
                Section(header: Text("单次运动的单位")) {
                    Picker(selection: $userSettings.sportUnits, label: Text("运动单位(min)").font(.title3)) {
                        ForEach(UnitsOptions,id: \.self) { index in
                            Text("\(index)").tag(index)
                        }
                    }
                }
                Section(header: Text("运动结束后的铃声")) {
                    Picker(selection: $userSettings.ring, label: Text("响铃设置").font(.title3)) {
                        ForEach(RingOptions,id: \.self){    // id为自身
                            Text($0)    // $0指代闭包中的第一个参数,此处就是RingOptions的每一个元素
                        }
                    }
                }
                Section(header: Text("前后两次运动的间隔")) {
                    Picker(selection: $userSettings.plan, label: Text("任务计划(天)").font(.title3)) {
                        ForEach(PlanOptions,id: \.self) { index in
                            Text("\(index)")
                        }
                    }
                }
                
            }//.position(x:200,y:220)
                .navigationTitle("应用设置")
//        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings().environmentObject(UserSettings.shared)
    }
}
