//
//  ImageCollectionViewCell.swift
//  ImageSearchSwift
//
//  Created by APPLE on 2020/10/09.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
}
