//
//  testPicture.swift
//  Sport Record
//
//  Created by EastOS on 2023/5/28.
//

import SwiftUI
import UIKit

struct testPhoto: View {
    @State private var showCameraPicker = false
    //这里的image用于放置等会拍摄了的照片
    @State private var image: UIImage = UIImage()
    var body: some View {
        List{
            Button(action: {
                showCameraPicker = true
            }, label: {
                Text("Camera")
            })
            
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .sheet(isPresented: $showCameraPicker,
               content: {
            ImagePicker(sourceType: .camera) { image in
                self.image = image
            }
        })
    }
}


struct testPicture_Previews: PreviewProvider {
    static var previews: some View {
        testPhoto()
    }
}

