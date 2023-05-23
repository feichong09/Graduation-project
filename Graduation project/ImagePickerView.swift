//
//  File.swift
//  Graduation project
//
//  Created by ByteDance on 2023/5/7.
//
import SwiftUI
import PhotosUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Binding var imageURLs: [URL]
    @Environment(\.presentationMode) var presentationMode
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 3
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePickerView
        
        init(_ parent: ImagePickerView) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.images.removeAll()
            parent.imageURLs.removeAll()
            
            for result in results {
                let itemProvider = result.itemProvider
                if itemProvider.canLoadObject(ofClass: UIImage.self) {
                    itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.images.append(image)
                            }
                        }
                    }
                }
                if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg") {
                    itemProvider.loadFileRepresentation(forTypeIdentifier: "public.jpeg") { (url, error) in
                        if let url = url {
                            DispatchQueue.main.async {
                                self.parent.imageURLs.append(url)
                            }
                        }
                    }
                }
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
