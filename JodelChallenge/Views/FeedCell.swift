//
//  FeedCell.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class FeedCell : UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    public func configure(with imageUrl : URL) {
        if let data = try? Data(contentsOf: imageUrl) {
            let image = UIImage(data: data)
            imageView.image = image
        }
    }
}
