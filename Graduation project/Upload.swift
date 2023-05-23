import SwiftUI
import Alamofire
import Photos
struct uiContentView: View {
    
    @State private var image: UIImage?
    @State private var imageURL: URL?
    @State private var showImagePicker = false
    @State private var isActive = false
    @State private var gender: String = ""
    @State private var age: Int = 0
    @State private var smiling: Double = 0.0
    @State private var emotion: [String: Double] = [:]
    @State private var beauty: [String: Double] = [:]
    @State private var skinstatus: [String: Double] = [:]
    @State private var showCamera = false
    @State private var showAlert = false
  
    var body: some View {
        NavigationView {
            VStack {
                Text("首先：让我们尝试上传一张图片")
                    .font(.headline)
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 100, height: 100)
                }

                HStack {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        if image == nil {
                            Image(systemName: "photo.on.rectangle").resizable().aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 40)
                                .foregroundColor(.black)
                        } else {
                            Text("更改图片").foregroundColor(.secondary)
                        }
                    }.padding()
                    .sheet(isPresented: $showImagePicker) {
                        ImagePicker(image: $image, imageURL: $imageURL, sourceType: .photoLibrary)
                    }

                    if image == nil {
                        Button(action: {
                            showCamera = true
                        }) {
                            Image(systemName: "camera").resizable().aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 40)
                                .foregroundColor(.black)
                        }.padding()
                        .sheet(isPresented: $showCamera) {
                            ImagePicker(image: $image, imageURL: $imageURL, sourceType: .camera)
                        }
                    }
                }

                if image != nil {
                    Button(action:{loadImage()}) {
                        Image(systemName: "arrow.right.circle").resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 30)
                            .foregroundColor(.black).padding()
                           
                    }
                    .background(
                        NavigationLink("人脸属性", destination: FaceDataView(gender: gender, age: age, smiling: smiling, emotion: emotion, beauty: beauty,skinstatus:skinstatus,imageURL: imageURL,image: image), isActive: $isActive)
                            .opacity(0)
                    ).alert(isPresented: $showAlert) {
                        Alert(title: Text("错误"), message: Text("未检测到人脸，请重新选择照片。"), dismissButton: .default(Text("好的")))
                }
            }
       
            }
        }
    }




    func loadImage() {
        guard let imageURL = imageURL else {
            print("Error: imageURL is nil")
            return
        }
        
        print("Loading image from URL: \(imageURL)")
        FacePlusPlusAPIClient(using: imageURL) { result in
                switch result {
                case .success(let json):
                    print("Received JSON data: \(json)")

                    if let face = json["faces"].array?.first {
                        let attributes = face["attributes"]
                        self.gender = attributes["gender"]["value"].stringValue
                        self.age = attributes["age"]["value"].intValue
                        self.smiling = attributes["smile"]["value"].doubleValue
                        self.emotion = attributes["emotion"].dictionaryValue.mapValues { $0.doubleValue }
                        self.beauty = attributes["beauty"].dictionaryValue.mapValues { $0.doubleValue }
                        self.skinstatus = attributes["skinstatus"].dictionaryValue.mapValues { $0.doubleValue }
                        self.isActive = true
                        self.showImagePicker = false
                    } else {
                        print("Error: No face detected.")
                        self.showAlert = true
                        self.showImagePicker = false
                    }
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    self.showAlert = true
                    self.showImagePicker = false
                }
            }
    }
  
}

struct uiContentView_Previews: PreviewProvider {
    static var previews: some View {
        uiContentView()
    }
}

// Replace ImagePickerView with ImagePicker using UIImagePickerController
struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @Binding var imageURL: URL?
    var sourceType: UIImagePickerController.SourceType

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage

                if parent.sourceType == .camera {
                    // If the image was captured from camera, save it to the photo album and use its URL
                    UIImageWriteToSavedPhotosAlbum(uiImage, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
                } else if let imageUrl = info[.imageURL] as? URL {
                    // If the image was picked from library, use its existing URL
                    parent.imageURL = imageUrl
                    parent.presentationMode.wrappedValue.dismiss()
                }
            } else {
                parent.presentationMode.wrappedValue.dismiss()
            }
        }

        @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if let error = error {
                print("Error saving image to photo album: \(error)")
            } else {
                // Fetch the most recent photo (i.e., the one we just saved)
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
                fetchOptions.fetchLimit = 1
                let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                if let asset = fetchResult.firstObject {
                    let options = PHContentEditingInputRequestOptions()
                    options.canHandleAdjustmentData = { _ in return false }
                    asset.requestContentEditingInput(with: options) { [weak self] (editingInput, _) in
                        self?.parent.imageURL = editingInput?.fullSizeImageURL
                        DispatchQueue.main.async {
                            self?.parent.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
}
