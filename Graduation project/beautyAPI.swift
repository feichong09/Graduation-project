//
//  beautyAPI.swift
//  Graduation project
//
//  Created by ByteDance on 2023/5/8.
//

import Alamofire
import SwiftyJSON
import Foundation

func beautyAPI(using imageURL: URL, completion: @escaping (Result<JSON, Error>) -> Void) {
    let apiKey = "pzGC-99s3DbfPihp94Ek-O57YTB-DClY"
    let apiSecret = "NyTODVOUUMJs1MUUjbszit0jeSoMcnwh"
    let urlString = "https://api-cn.faceplusplus.com/facepp/v2/beautify"
    let parameters: [String: Any] = [
        "api_key": apiKey,
        "api_secret": apiSecret,
        "whitening": "25",
        "smoothing":"35",
        "thinface":"40",
        "shrink_face":"10",
        "enlarge_eye":"60",
        "remove_eyebrow":"20",
    ]
    AF.upload(multipartFormData: { multipartFormData in
        for (key, value) in parameters {
            if let string = value as? String, let data = string.data(using: .utf8) {
                multipartFormData.append(data, withName: key)
            }
        }
        multipartFormData.append(imageURL, withName: "image_file") // 将此行移出循环
    }, to: urlString).responseJSON { response in
        switch response.result {
        case .success(let value):
            let json = JSON(value)
            // 处理响应数据
            completion(.success(json))
        case .failure(let error):
            print(error)
            completion(.failure(error))
        }
    }
}
