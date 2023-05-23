//
//  File.swift
//  Graduation project
//
//  Created by ByteDance on 2023/5/7.
//
import SwiftUI

struct ImageGallery: View {
    let images: [UIImage]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: true) {
            HStack {
                ForEach(images, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .padding()
                }
            }
        }
    }
}
