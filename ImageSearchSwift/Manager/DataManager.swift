//
//  DataManager.swift
//  ImageSearchSwift
//
//  Created by APPLE on 2020/10/11.
//

import UIKit

class DataManager {
    static let sharedInstance = DataManager()
    
    var imageDatas: ImageData!
    var imageCount = 0      // collectionview에서 보여지고 있는 이미지 수
    var currentPage = 0     // 다음 검색 API request 페이지 번호, 1~50 사이의 값
}
