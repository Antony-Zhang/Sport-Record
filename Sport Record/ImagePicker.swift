//
//  ImagePicker.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/28.
//

import SwiftUI
import UIKit

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    let sourceType: UIImagePickerController.SourceType  //  图片来源类型[.camera相机 .photoLibrary相册]
    let onImagePicked: (UIImage) -> Void
    
    //  内嵌类,作为图片选择器的代理
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 
        @Binding private var presentationMode: PresentationMode // 用以表示当前视图是否被另一视图呈现
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (UIImage) -> Void    //  用户选择图片后调用的函数闭包
 
        init(presentationMode: Binding<PresentationMode>,
             sourceType: UIImagePickerController.SourceType,
             onImagePicked: @escaping (UIImage) -> Void) {
            _presentationMode = presentationMode
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
        }
        // 选择图片后调用
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage   //  从info中获取用户选择的图片,同时强转为UIImage类型
            onImagePicked(uiImage)  // 调用闭包
            presentationMode.dismiss()  // 关闭图片选择器
        }
        //  取消图片选择
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
 
    }
 
    //  创建Coordinator实例
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode,
                           sourceType: sourceType,
                           onImagePicked: onImagePicked)
    }
    //  创建UIImagePickerController实例,用于在视图中显示图片选择器
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType  //  设置图片来源
        picker.delegate = context.coordinator   //  设置代理
        return picker   //  返回图片选择器实例
    }
    //  用于更新现有的UIImagePickerController实例,为空
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
}
