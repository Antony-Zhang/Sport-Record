//
//  test2.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/28.
//

import SwiftUI


enum ActiveSheet: Identifiable {
    case login, register

    var id: Int {
        hashValue
    }
}

struct LoginView: View {
    @Binding var activeSheet: ActiveSheet?

    var body: some View {
        VStack {
            Text("Login")
            Button("Go to Register") {
                activeSheet = .register
            }
        }
    }
}

struct RegisterView: View {
    @Binding var activeSheet: ActiveSheet?

    var body: some View {
        VStack {
            Text("Register")
            Button("Go to Login") {
                activeSheet = .login
            }
        }
    }
}

struct ContentView: View {
    @State private var activeSheet: ActiveSheet?

    var body: some View {
        Button("Show Modal") {
            activeSheet = .login
        }
        .fullScreenCover(item: $activeSheet) { item in
            switch item {
            case .login:
                LoginView(activeSheet: $activeSheet)
            case .register:
                RegisterView(activeSheet: $activeSheet)
            }
        }
    }
}


struct test2_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
