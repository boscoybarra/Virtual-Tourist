//
//  PhotoCell.swift
//  VirtualTourist
//
//  Created by J B on 7/13/17.
//  Copyright © 2017 J B. All rights reserved.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingSpiner: UIActivityIndicatorView!
    
    func setImage(image: UIImage) {
        loadingSpiner.stopAnimating()
        self.imageView.image = image
    }
    
}
