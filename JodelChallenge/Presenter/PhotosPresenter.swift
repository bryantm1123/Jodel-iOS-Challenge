//
//  PhotosPresenter.swift
//  JodelChallenge
//
//  Created by Matt Bryant on 5/23/21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

class PhotosPresenter: PhotosPresentationLogic {
    
    var photoService: FlickrService? = FlickrService()
    var photoModels: [FeedModel] = []
    private weak var photoDeliveryDelegate: PhotoDeliveryDelegate?
    private var currentPage: Int = 1
    private var countPerPage: Int = 10
    private var total: Int = 10
    private var isFetchInProgress: Bool = false
    
    init(with photoDeliveryDelegate: PhotoDeliveryDelegate) {
        self.photoDeliveryDelegate = photoDeliveryDelegate
    }
    
    var totalCount: Int { total }
    
    var currentCount: Int { photoModels.count }
    
    
    /// Fetches the photos for our feed from the Flickr API
    /// - Parameter isRefreshing: A flag to indicate if we should reset to loading the first page
    func fetchPhotos(isRefreshing: Bool = false) {
        
        // If a fetch is already in progress, back out
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        
        // If pull to refresh
        // start from the first page
        if isRefreshing {
            currentPage = 1
        }
        
        photoService?.fetchPhotos(for: countPerPage, on: currentPage, completion: { [weak self] result in
            switch result {
                case .success(let response):
                    print("Loading page: \(String(describing: self?.currentPage))")
                    
                    // Update our pagination variables
                    self?.currentPage += 1
                    self?.total = response.photos.total
                    self?.isFetchInProgress = false
                    
                    // Get the models for our feed
                    guard let newPhotos = self?.photoService?.fetchFeedModels(from: response.photos.photo) else { return }
                    self?.photoModels.append(contentsOf: newPhotos)
                    
                    // If loading page one, just reload the whole collection view
                    // else calculate only the rows for the new photos to reload
                    if response.photos.page > 1 {
                        let indexPathsToReload = self?.calculateIndexPathsToReload(from: newPhotos)
                        self?.photoDeliveryDelegate?.didReceivePhotos(with: indexPathsToReload)
                    } else {
                        self?.photoDeliveryDelegate?.didReceivePhotos(with: .none)
                    }
                case .failure(let error):
                    print(error)
                    self?.isFetchInProgress = false
                    self?.photoDeliveryDelegate?.didReceiveError(error)
            }
        })
    }
    
    
    /// Calculates the index paths for the last page of photos received from the API.
    /// - Parameter newPhotos: The last page of photos received
    /// - Returns: The indexPaths to reload on the collection view
    private func calculateIndexPathsToReload(from newPhotos: [FeedModel]) -> [IndexPath] {
        let startIndex = photoModels.count - newPhotos.count
        let endIndex = startIndex + newPhotos.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }

}

protocol PhotoDeliveryDelegate: AnyObject {
    func didReceivePhotos(with newIndexPathsToReload: [IndexPath]?)
    func didReceiveError(_ error: Error)
}
