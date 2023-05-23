import SwiftUI

struct FaceDataView: View {
    let faceData: FaceData?
    
    var body: some View {
        VStack {
            if let faceData = faceData {
                Text("Image ID: \(faceData.imageId)")
                Text("Request ID: \(faceData.requestId)")
                Text("Time Used: \(faceData.timeUsed)")
                
                ForEach(faceData.faces.indices, id: \.self) { index in
                    let face = faceData.faces[index]
                    
                    VStack(alignment: .leading) {
                        Text("Face Token: \(face.faceToken)")
                        Text("Gender: \(face.attributes.gender.value)")
                        Text("Age: \(face.attributes.age.value)")
                    }
                    .padding()
                }
            } else {
                Text("No face data available")
                    .font(.headline)
                    .padding()
            }
        }
        .padding()
        .navigationBarTitle("面部数据", displayMode: .inline)
    }
}

struct FaceDataView_Previews: PreviewProvider {
    static var previews: some View {
        FaceDataView(faceData: nil)
    }
}
