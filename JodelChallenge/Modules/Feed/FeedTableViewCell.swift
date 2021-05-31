//
//  FeedTableViewCell.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    static let cellIdentifier = "FeedTableViewCell"
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(with imageInfo: PhotoData) {
        titleLabel.text = imageInfo.title
        mainImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        mainImageView?.sd_setImage(with: imageInfo.thumbnailURL, placeholderImage: UIImage(named: "placeholder"))
    }
}
