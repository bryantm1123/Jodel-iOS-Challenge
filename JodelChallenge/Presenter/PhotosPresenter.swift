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
    var photoURLs: [PhotoTuple]? = []
    private weak var photoDeliveryDelegate: PhotoDeliveryDelegate?
    
    init(with photoDeliveryDelegate: PhotoDeliveryDelegate) {
        self.photoDeliveryDelegate = photoDeliveryDelegate
    }
    
    
    func fetchPhotos(for count: String, on page: String) {
        photoService?.fetchPhotos(for: count, completion: { [weak self] result in
            switch result {
                case .success(let response):
                    print(response)
                    self?.photoURLs = self?.photoService?.fetchPhotoUrls(from: response.photos.photo)
                    self?.photoDeliveryDelegate?.didReceivePhotos()
                case .failure(let error):
                    print(error)
                    self?.photoDeliveryDelegate?.didReceiveError(error)
            }
        })
    }
}

protocol PhotoDeliveryDelegate: AnyObject {
    func didReceivePhotos()
    func didReceiveError(_ error: Error)
}
