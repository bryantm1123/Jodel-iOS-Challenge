//
//  FeedViewController+ImageZoom.swift
//  JodelChallenge
//
//  Created by Matt Bryant on 5/31/21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

// MARK: Image zoom animation
extension FeedViewController {
    
    /// Animates the selected image view to the center of the screen and provides a black background
    /// - Parameter imageView: the selected image view
    func animateImageView(on imageView: UIImageView) {
        
        selectedImageView = imageView
        
        guard let startingFrame = imageView.superview?.convert(imageView.frame, to: nil),
              let keyWindow = UIApplication.shared.keyWindow else { return }
            
        // hide the image clicked in the feed
        imageView.alpha = 0
        
        setupZoomBackgroundView()
        
        setupTabBarCoverView(keyWindow)
        
        setupZoomImageView(startingFrame, imageView)
        
        UIView.animate(withDuration: 0.3) {
            
            // Animate the frame change for the image view
            // from the starting frame to the center of the screen
            let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
            let y = (self.view.frame.height / 2) - (height / 2)
            self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
            
            // Animate the background view visibility
            self.zoomBackgroundView.alpha = 1
            
            // Animate the tab bar cover view visibility
            self.tabBarCoverView.alpha = 1
        }
    }
    
    
    /// Reverse the image view back out to its position in the feed
    /// and hide the background views
    @objc func zoomOutImageView() {
        guard let imageView = selectedImageView,
            let startingFrame = imageView.superview?.convert(imageView.frame, to: nil) else {
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            self.zoomImageView.frame = startingFrame
            self.zoomBackgroundView.alpha = 0
            self.tabBarCoverView.alpha = 0
        } completion: { (didComplete) in
            self.zoomImageView.removeFromSuperview()
            self.zoomBackgroundView.removeFromSuperview()
            self.tabBarCoverView.removeFromSuperview()
            self.selectedImageView?.alpha = 1
        }
    }
    
    /// Setup and add the zoom background view
    fileprivate func setupZoomBackgroundView() {
        zoomBackgroundView.frame = self.view.frame
        zoomBackgroundView.backgroundColor = UIColor.black
        zoomBackgroundView.alpha = 0
        view.addSubview(zoomBackgroundView)
    }
    
    /// Setup and add the tab bar cover view to hide the tab bar
    fileprivate func setupTabBarCoverView(_ keyWindow: UIWindow) {
        let tabBarHeight: CGFloat = 100.0
        tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - tabBarHeight, width: keyWindow.frame.width, height: tabBarHeight)
        tabBarCoverView.backgroundColor = UIColor.black
        tabBarCoverView.alpha = 0
        keyWindow.addSubview(tabBarCoverView)
    }
    
    /// Setup the zoomed in image view
    fileprivate func setupZoomImageView(_ startingFrame: CGRect, _ imageView: UIImageView) {
        
        zoomImageView.frame = startingFrame
        zoomImageView.image = imageView.image
        zoomImageView.contentMode = .scaleAspectFill
        view.addSubview(zoomImageView)
        
        // Add a tap gesture to the zoom image for zooming back out
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOutImageView)))
    }
}
