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
    var imageLoader: ImageLoader = ImageLoader()
    var token: UUID?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        titleLabel.textColor = UIColor.systemGray
    }
    
    override func prepareForReuse() {
        // Cancel the data task when the cell is reused
        // if the image is in cache
        if let token = token {
            imageLoader.cancelLoad(for: token)
            imageView.image = nil
            titleLabel.text = nil
        }
    }
    
    
    /// Conditionally loads either the Feed Model or a loading indicator
    /// - Parameter photo: A Feed Model if we have one
    public func configure(with photo: FeedModel?) {
        if let photoModel = photo {
            loadRemoteImage(from: photoModel)
        } else {
            showLoadingView()
        }
    }
    
    @objc func animate() {
        feedController?.animateImageView(on: imageView)
    }
    
    /// Loads an image from a remote url using the `ImageLoader` helper class
    /// Updates the cell's image view with the image retrieved
    /// - Parameters:
    ///   - recipe: The given recipe for the populated cell
    ///   - cell: The cell for the current index path which displays the recipe
    fileprivate func loadRemoteImage(from photo: FeedModel) {
        if !loadingIndicator.isAnimating { showLoadingView() }
        token = imageLoader.loadImage(from: photo.url, completion: { result in
            do {
                // Extract the result from the
                // completion handler
                let image = try result.get()
                
                // If image extracted, dispatch
                // to main queue for updating cell
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.titleLabel.text = photo.title.isEmpty ? "Untitled" : photo.title
                    self.imageView.alpha = 1
                    self.titleLabel.alpha = 1
                    self.loadingIndicator.stopAnimating()
                }
            } catch {
                // If image extraction fails,
                // show an error image
                DispatchQueue.main.async {
                    self.imageView.alpha = 1
                    self.imageView.image = UIImage(named: "errorMessage")
                }
                debugPrint(error)
            }
        })
    }
    
    // Show loading indicator and hide the image view and title
    fileprivate func showLoadingView() {
        imageView.alpha = 0
        titleLabel.alpha = 0
        loadingIndicator.startAnimating()
    }
}
