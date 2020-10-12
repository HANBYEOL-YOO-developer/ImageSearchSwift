//
//  ExtensionUIViewController.swift
//  ImageSearchSwift
//
//  Created by APPLE on 2020/10/11.
//

import UIKit

extension UIViewController {
    func showBasicAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
