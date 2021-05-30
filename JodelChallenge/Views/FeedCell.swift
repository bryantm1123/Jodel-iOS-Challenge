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
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    public func configure(with photo: PhotoTuple?) {
        if let photoModel = photo,
           let data = try? Data(contentsOf: photoModel.1) {
            let image = UIImage(data: data)
            imageView.image = image
            titleLabel.text = photoModel.0
            imageView.alpha = 1
            titleLabel.alpha = 1
            loadingIndicator.stopAnimating()
        } else {
            imageView.alpha = 0
            titleLabel.alpha = 1
            loadingIndicator.startAnimating()
        }
    }
}
