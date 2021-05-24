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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosPresenter = PhotosPresenter(with: self)
        
        photosPresenter?.fetchPhotos(for: "15", on: "1")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosPresenter?.photoURLs?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCell,
        
        let photo = photosPresenter?.photoURLs?[indexPath.row] else { return UICollectionViewCell() }
        
        cell.configure(with: photo)
        return cell
    }
}

extension FeedViewController: PhotoDeliveryDelegate {
    
    func didReceivePhotos() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func didReceiveError(_ error: Error) {
        // TODO: Show error alert
    }
}
