//
//  update.swift
//  Graduation project
//
//  Created by ByteDance on 2023/5/7.
//
import Alamofire
import SwiftyJSON
import Foundation
import SwiftUI


struct FaceAPI {
    let apiKey = "pzGC-99s3DbfPihp94Ek-O57YTB-DClY"
    let apiSecret = "NyTODVOUUMJs1MUUjbszit0jeSoMcnwh"
    let urlString = "https://api-cn.faceplusplus.com/facepp/v3/detect"
    
    func uploadImage(image: Image, completion: @escaping (Result<FaceData, Error>) -> Void) {
        let uiImage = image.UIImage()
           guard let imageData = uiImage.jpegData(compressionQuality: 1) else {
               return
           }
            let parameters: [String: String] = [
                "api_key": apiKey,
                "api_secret": apiSecret,
                "return_landmark": "1",
                "return_attributes": "gender,age"
            ]
            
            AF.upload(multipartFormData: { multipartFormData in
                for (key, value) in parameters {
                    if let data = value.data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                multipartFormData.append(imageData, withName: "image_file", fileName: "image_file.jpg", mimeType: "image/jpeg")
            }, to: urlString)
            .validate()
            .responseDecodable(of: FaceData.self) { response in
                switch response.result {
                case .success(let faceData):
                    completion(.success(faceData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

    
  
