import SwiftUI
extension UIImage: Identifiable {
    public var id: UUID {
        return UUID()
    }
}
struct FaceDataView: View {
    var gender: String
    var age: Int
    var smiling: Double
    var emotion: [String: Double]
    var beauty: [String: Double]
    var skinstatus: [String: Double]
    let imageURL: URL?
    let image: UIImage?
    @State private var beautifiedImage: UIImage?
    @State private var showBeautifiedImage = false
    @State private var showARKit = false
    var body: some View {
        ScrollView (showsIndicators: false){
            VStack {
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .frame(width: 200, height: 200)
                        .padding()
                }
                VStack(alignment: .leading){
                    
                    Image(systemName: "person.text.rectangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 30)
                    Text("性别: \(gender)")
                        .padding(.bottom, 1)
                    Text("年龄: \(age)")
                        .padding(.bottom, 1)
                    Text("微笑指数: \(smiling)")
                        .padding(.bottom, 1)
                    
                    VStack(alignment: .leading) {
                        Text("情绪")
                            .font(.headline)
                            .padding(.bottom, 1)
                        
                        ForEach(emotion.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            Text("\(key): \(String(format: "%.2f", value))%")
                                .padding(.bottom, 1)
                        }
                    }
                    .padding(.bottom, 1)
                    
                    VStack(alignment: .leading) {
                        Text("颜值")
                            .font(.headline)
                            .padding(.bottom, 1)
                        
                        ForEach(beauty.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            Text("\(key): \(String(format: "%.2f", value))%")
                                .padding(.bottom, 1)
                        }
                    }
                    .padding(.bottom, 1)
                    
                    VStack(alignment: .leading) {
                        Text("皮肤")
                            .font(.headline)
                            .padding(.bottom, 1)
                        ForEach(skinstatus.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                            Text("\(key): \(String(format: "%.2f", value))%")
                                .padding(.bottom, 1)
                        }
                    }
                    .padding(.bottom, 1)
                }
                
                Button("智能美颜") {
                    if let imageURL = imageURL {
                        beautyAPI(using: imageURL) { result in
                            switch result {
                            case .success(let json):
                                if let base64String = json["result"].string {
                                    self.beautifiedImage = base64ToImage(base64String)
                                    print("美化接口调用成功")
                                    DispatchQueue.main.async {
                                        self.beautifiedImage = base64ToImage(base64String)
                                    }
                                }
                            case .failure(let error):
                                print("Error: \(error.localizedDescription)")
                                print("美化接口调用失败")
                            }
                        }
                    }
                }.sheet(item: $beautifiedImage) { image in
                    VStack {
                        VStack{
                            if let originalImage = self.image {
                                Image(uiImage: originalImage)
                                    .resizable()
                                    .scaledToFit()
                                    .padding()
                                    .overlay(Text("美颜前").foregroundColor(.white).background(Color.black.opacity(0.7)).padding(4), alignment: .bottom)
                            }
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .overlay(Text("美颜后").foregroundColor(.white).background(Color.black.opacity(0.7)).padding(4), alignment: .bottom)
                        }
                        Button(action: {
                            self.showARKit.toggle()
                        }) {
                            Image(systemName: "arkit").resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 30)
                                .foregroundColor(.black)
                        }.fullScreenCover(isPresented: $showARKit) {
                            ContentView()
                        }
                    }
                }
                
            }.padding()
        }

    }
}

func base64ToImage(_ base64String: String) -> UIImage? {
    guard let imageData = Data(base64Encoded: base64String)
    
    
    else {
        return nil
    }
    print(imageData)
    return UIImage(data: imageData)
    
}
