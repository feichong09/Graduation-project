//
//  File.swift
//  Graduation project
//
//  Created by ByteDance on 2023/5/8.
//

import Foundation
import Foundation

struct FaceData: Codable {
    let imageId: String
    let requestId: String
    let timeUsed: Int
    let faces: [Face]
    let faceNum: Int
    
    enum CodingKeys: String, CodingKey {
        case imageId = "image_id"
        case requestId = "request_id"
        case timeUsed = "time_used"
        case faces
        case faceNum = "face_num"
    }
}

struct Face: Codable {
    let faceToken: String
    let attributes: Attributes
    
    enum CodingKeys: String, CodingKey {
        case faceToken = "face_token"
        case attributes
    }
}

struct Attributes: Codable {
    let gender: Gender
    let age: Age
}

struct Gender: Codable {
    let value: String
}

struct Age: Codable {
    let value: Int
}
