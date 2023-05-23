//
//  File.swift
//  Graduation project
//
//  Created by ByteDance on 2023/5/8.
//
import SwiftUI

struct BeautifiedImageView: View {
    let image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .padding()
    }
}
