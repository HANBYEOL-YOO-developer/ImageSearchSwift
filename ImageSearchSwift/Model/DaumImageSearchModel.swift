//
//  DaumImageSearchModel.swift
//  ImageSearchSwift
//
//  Created by APPLE on 2020/10/10.
//

import Foundation

struct ImageData: Codable {
    var meta: MetaData
    var documents: [DocumentsData]
}

struct MetaData: Codable {
    var total_count: Int
    var pageable_count: Int
    var is_end: Bool
}

struct DocumentsData: Codable {
    var thumbnail_url: String
    var image_url: String
    var display_sitename: String
    var datetime: String
}
