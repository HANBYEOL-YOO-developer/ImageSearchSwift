//
//  ExtensionUIImageView.swift
//  ImageSearchSwift
//
//  Created by APPLE on 2020/10/09.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView{
    
    func loadImageFromURLString(_ urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            print("[error]: making url")
            return false
        }
        do {
            let data = try Data(contentsOf: url)
            if let image = UIImage(data: data) {
                let ratio = image.size.width / image.size.height
                let newHeight = frame.width / ratio
                frame.size.height = newHeight
                self.image = image // UIImage(data: data)
                return true
            }
        } catch {
            print("[error] making image from url: \(error.localizedDescription)")
            return false
        }
        return false
    }
    
    func setImageFromURl(stringImageUrl urlString: String?, fadeInAnimation fadeIn: Bool = true) {
        if let urlStr = urlString {
            if let url = NSURL(string: urlStr) {
                DispatchQueue.global(qos: .default).async{
                    if let data = NSData(contentsOf: url as URL) {
                        DispatchQueue.main.async {
                            if fadeIn {
                                let image = UIImage(data: data as Data)
                                let crossFade: CABasicAnimation = CABasicAnimation(keyPath: "contents")
                                crossFade.duration = 1
                                crossFade.fromValue = self.image?.cgImage
                                crossFade.toValue = image?.cgImage
                                self.image = image
                                self.layer.add(crossFade, forKey: "animateContents")
                            } else {
                                self.image = UIImage(data: data as Data)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadImageUsingCacheWithURLString(stringImageUrl url: String?, placeHolder: UIImage?) {
        if let tempUrl = url {
            if let cachedImage = imageCache.object(forKey: NSString(string: tempUrl)) {
                self.image = cachedImage
                return
            }
            
            if let url = URL(string: tempUrl) {
                URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                    //print("RESPONSE FROM API: \(response)")
                    if let err = error {
                        print("[error] loading images from url: \(err.localizedDescription))")
                        DispatchQueue.main.async {
                            self.image = placeHolder
                        }
                        return
                    }
                    DispatchQueue.main.async {
                        if let data = data {
                            if let downloadedImage = UIImage(data: data) {
                                imageCache.setObject(downloadedImage, forKey: NSString(string: tempUrl))
                                self.image = downloadedImage
                            }
                        }
                    }
                }).resume()
            }
        }
    }
}
