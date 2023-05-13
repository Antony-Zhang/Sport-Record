//
//  Style.swift
//  风格样式文件
//  Sport Record
//
//  Created by EastOS on 2023/5/10.
//

import Foundation
import SwiftUI

// 按钮样式
struct BlueRoundedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.title3)
            .background(Color.blue)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 0)
            )
    }
}
struct RedRoundedButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .font(.title3)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.red, lineWidth: 0)
            )
    }
}

// 输入框样式
struct DefualtTextFeild: TextFieldStyle{
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .offset(x:15)
            .font(.title2)
            .overlay(RoundedRectangle(cornerRadius: 3).stroke(Color.gray,lineWidth:1))
            .frame(width: 200)
    }
}
