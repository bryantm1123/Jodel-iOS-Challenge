//
//  FeedViewController.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class FeedViewController : UICollectionViewController {
    
    var photosPresenter: PhotosPresenter?
    let zoomBackgroundView: UIView = UIView()
    let zoomImageView: UIImageView = UIImageView()
    let tabBarCoverView: UIView = UIView()
    var selectedImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosPresenter = PhotosPresenter(with: self)
        collectionView.prefetchDataSource = self
        photosPresenter?.fetchPhotos()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosPresenter?.totalCount ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCell else { return UICollectionViewCell() }
        
        // Show the loading indicator on the loading cell
        // otherwise populate with the photo
        if isLoadingCell(for: indexPath) {
            cell.configure(with: .none)
        } else {
            let photo = photosPresenter?.photoModels[indexPath.row]
            cell.configure(with: photo)
        }
        
        cell.feedController = self
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let screenWidth = self.view.frame.width
        return CGSize(width: screenWidth, height: screenWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

// MARK: Prefetching delegate
extension FeedViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // Go ahead and pre-fetch next page photos
        // when we get to the loading cell
        if indexPaths.contains(where: isLoadingCell) {
            photosPresenter?.fetchPhotos()
        }
    }
}

// MARK: Prefetching utility functions
private extension FeedViewController {
    
    /// Determines if the current indexPath is beyond the current count of photos, ie the last cell
    /// - Parameter indexPath: The current index path to check
    /// - Returns: Boolean to indicate if index path is the loading cell
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= photosPresenter?.currentCount ?? 0
    }

    
    /// Calculates the collection view cells that need to be reloaded when receiving a new page
    /// by calculating the intersection of indexPaths passed in (as calculated by the presenter)
    /// with the visible indexPaths
    /// - Parameter indexPaths: Index paths that may need to be reloaded
    /// - Returns: the visible index paths to reload
   func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
   }
}


// MARK: Photo service delivery delegate
extension FeedViewController: PhotoDeliveryDelegate {
    
    func didReceivePhotos(with newIndexPathsToReload: [IndexPath]?) {
        DispatchQueue.main.async { [weak self] in
            // Reload the whole collection view the first time
            guard let pathsToReload = newIndexPathsToReload else {
                self?.collectionView.reloadData()
                return
            }
            // On subsequent fetches, reload only the index paths
            // for the new photos
            self?.collectionView.reloadItems(at: pathsToReload)
        }
    }
    
    func didReceiveError(_ error: Error) {
        // TODO: Show error alert
    }
}

// MARK: Image zoom animation
extension FeedViewController {
    func animateImageView(on imageView: UIImageView) {
        
        selectedImageView = imageView
        
        guard let startingFrame = imageView.superview?.convert(imageView.frame, to: nil),
              let keyWindow = UIApplication.shared.keyWindow else { return }
            
        // hide the image clicked in the feed
        imageView.alpha = 0
        
        // Setup and add the zoom background view
        zoomBackgroundView.frame = self.view.frame
        zoomBackgroundView.backgroundColor = UIColor.black
        zoomBackgroundView.alpha = 0
        view.addSubview(zoomBackgroundView)
        
        // Setup and add the tab bar cover view to hide the tab bar
        let tabBarHeight: CGFloat = 100.0
        tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - tabBarHeight, width: keyWindow.frame.width, height: tabBarHeight)
        tabBarCoverView.backgroundColor = UIColor.black
        tabBarCoverView.alpha = 0
        keyWindow.addSubview(tabBarCoverView)
        
        // Setup the zoomed in image view
        zoomImageView.backgroundColor = UIColor.red
        zoomImageView.frame = startingFrame
        zoomImageView.image = imageView.image
        zoomImageView.contentMode = .scaleAspectFill
        view.addSubview(zoomImageView)
        
        // Add a tap gesture to the zoom image for zooming back out
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOutImageView)))
        
        UIView.animate(withDuration: 0.3) {
            
            // Animate the frame change for the image view
            let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
            let y = (self.view.frame.height / 2) - (height / 2)
            self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
            
            // Animate the background view visibility
            self.zoomBackgroundView.alpha = 1
            
            // Animate the tab bar cover view visibility
            self.tabBarCoverView.alpha = 1
        }
    }
    
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
}
