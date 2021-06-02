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
        addRefreshControl()
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
        // give some vertical spacing between cells
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
        let tryAgain: UIAlertAction = UIAlertAction(title: "Try Again", style: .default, handler: { action in
            self.photosPresenter?.fetchPhotos()
        })
        
        let ok: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        showAlert(with: "Oops!", message: "Something went wrong. Please try again.", style: .alert, actions: [ok, tryAgain])
    }
}

// MARK: Pull to refresh
extension FeedViewController {
    
    fileprivate func addRefreshControl() {
        let refresher = UIRefreshControl()
        refresher.tintColor = UIColor.systemGray
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .medium)])
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    
    // On a pull to refresh, assume we want to start with a fresh list
    @objc func handleRefresh() {
        photosPresenter?.photoModels.removeAll()
        photosPresenter?.fetchPhotos(isRefreshing: true)
        collectionView.refreshControl?.endRefreshing()
    }
}
