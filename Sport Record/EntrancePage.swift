//
//  EntrancePage.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/9.
//

import SwiftUI

struct EntrancePage: View {
    var body: some View {
        TabView {
            Sport().tabItem {
                Image(systemName: "house")
                Text("运动")
            }
            UserHomepage().tabItem {
                Image(systemName: "person")
                Text("个人")
            }
        }
    }
}

struct EntrancePage_Previews: PreviewProvider {
    static var previews: some View {
        EntrancePage()
    }
}
