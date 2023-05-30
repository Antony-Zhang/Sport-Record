//
//  Sport.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/9.
//

import SwiftUI

struct Sport: View {
    @EnvironmentObject var dataBase :SQLiteDatabase
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        NavigationView(){
            NavigationLink(destination: SportRecording().environmentObject(dataBase).environmentObject(userSettings)){
                Text("开始运动吧!!").font(.title).bold()
            }.navigationTitle("运动")
            
        }
    }
}

struct Sport_Previews: PreviewProvider {
    static var previews: some View {
        Sport().environmentObject(SQLiteDatabase.shared)
            .environmentObject(UserSettings.shared)
    }
}
