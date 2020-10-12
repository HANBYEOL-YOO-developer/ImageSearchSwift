//
//  ExtensionString.swift
//  ImageSearchSwift
//
//  Created by APPLE on 2020/10/11.
//

import UIKit

extension String {
    func isValidUrlString() -> Bool {
        if let tempUrl = URL(string: self), UIApplication.shared.canOpenURL(tempUrl) {
            return true
        }
        return false
    }
}
