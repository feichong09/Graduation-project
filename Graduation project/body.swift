//
//  login.swift
//  Graduation project
//
//  Created by ByteDance on 2023/5/7.
//

import SwiftUI

struct upContentView: View {
    @State private var images = [UIImage]()
    @State private var isShowingImagePicker = false
    
    var body: some View {
        VStack {
            if images.isEmpty {
                Text("开始：首先尝试上传至少一张照片！")
                    .padding()
            } else {
                ImageGallery(images: images)
                Spacer()
            }
            
            if !isShowingImagePicker {
                UploadButton(text: images.isEmpty ? "上传照片" : "下一步", action: {
                    if images.isEmpty {
                        isShowingImagePicker = true
                    } else {
                        // do something else
                    }
                })
                .padding()
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            PhotoPicker(didFinishPicking: { images in
                self.images = images
                self.isShowingImagePicker = false
            })
        }
    }
}
struct upContentView_Previews : PreviewProvider {
    static var previews: some View {
        upContentView()
    }
}
