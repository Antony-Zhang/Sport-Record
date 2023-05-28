
//
//  testPhoto.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/28.
//

import SwiftUI
import UIKit

struct PicturePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void
 
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
 
        @Binding private var presentationMode: PresentationMode
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (UIImage) -> Void
 
        init(presentationMode: Binding<PresentationMode>,
             sourceType: UIImagePickerController.SourceType,
             onImagePicked: @escaping (UIImage) -> Void) {
            _presentationMode = presentationMode
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
        }
 
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            onImagePicked(uiImage)
            presentationMode.dismiss()
        }
 
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
 
    }
 
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode,
                           sourceType: sourceType,
                           onImagePicked: onImagePicked)
    }
 
    func makeUIViewController(context: UIViewControllerRepresentableContext<PicturePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
 
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<PicturePicker>) {
    }
}
struct testPicture: View {
    @State private var showImagePicker = false
    //这里的image用于放置等会获取的照片
    @State private var image: UIImage = UIImage()
    var body: some View {
        List{
            Button(action: {
                showImagePicker = true
            }, label: {
                Text("Select Image")
            })
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .sheet(isPresented: $showImagePicker,
               content: {
            ImagePicker(sourceType: .photoLibrary) { image in
                self.image = image
            }
        })
    }
}


struct testPhoto_Previews: PreviewProvider {
    static var previews: some View {
        testPicture()
    }
}
