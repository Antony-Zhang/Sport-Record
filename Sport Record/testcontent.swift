//
//  testcontent.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/28.
//

import SwiftUI

struct FullScreenModalView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.primary.edgesIgnoringSafeArea(.all)
            Button("Dismiss Modal") {
                dismiss()
            }
        }
    }
}

struct tContentView: View {
    @State private var isPresented = false

    var body: some View {
        Button("Present!") {
            isPresented.toggle()
        }
        .fullScreenCover(isPresented: $isPresented, content: FullScreenModalView.init)
    }
}

struct testcontent_Previews: PreviewProvider {
    static var previews: some View {
        tContentView()
    }
}
