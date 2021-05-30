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
    var photoModels: [PhotoTuple]? = []
    private weak var photoDeliveryDelegate: PhotoDeliveryDelegate?
    private var currentPage: Int = 1
    private var countPerPage: Int = 10
    private var totalCount: Int = 500
    private var isFetchInProgress: Bool = false
    
    init(with photoDeliveryDelegate: PhotoDeliveryDelegate) {
        self.photoDeliveryDelegate = photoDeliveryDelegate
    }
    
    
    func fetchPhotos() {
        
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        
        photoService?.fetchPhotos(for: countPerPage, on: currentPage, completion: { [weak self] result in
            switch result {
                case .success(let response):
                    print(response)
                    self?.isFetchInProgress = false
                    self?.photoModels = self?.photoService?.fetchPhotoModels(from: response.photos.photo)
                    self?.photoDeliveryDelegate?.didReceivePhotos()
                case .failure(let error):
                    print(error)
                    self?.isFetchInProgress = false
                    self?.photoDeliveryDelegate?.didReceiveError(error)
            }
        })
    }
}

protocol PhotoDeliveryDelegate: AnyObject {
    func didReceivePhotos()
    func didReceiveError(_ error: Error)
}
