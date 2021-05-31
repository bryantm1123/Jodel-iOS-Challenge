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
    
    var feedController: FeedViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
    }
    
    public func configure(with photo: FeedModel?) {
        if let photoModel = photo,
           let data = try? Data(contentsOf: photoModel.url) {
            let image = UIImage(data: data)
            imageView.image = image
            titleLabel.text = photoModel.title.isEmpty ? "Untitled" : photoModel.title
            imageView.alpha = 1
            titleLabel.alpha = 1
            loadingIndicator.stopAnimating()
        } else {
            imageView.alpha = 0
            titleLabel.alpha = 1
            loadingIndicator.startAnimating()
        }
    }
    
    @objc func animate() {
        feedController?.animateImageView(on: imageView)
    }
}
