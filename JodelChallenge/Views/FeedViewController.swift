//
//  FeedViewController.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class FeedViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var photosPresenter: PhotosPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photosPresenter = PhotosPresenter(with: self)
        
        loadingIndicator.startAnimating()
        photosPresenter?.fetchPhotos()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosPresenter?.photoModels?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as? FeedCell,
        
        let photo = photosPresenter?.photoModels?[indexPath.row] else { return UICollectionViewCell() }
        
        cell.configure(with: photo)
        return cell
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            let screenWidth = self.view.frame.width
            let reduction = screenWidth * 0.25
            let height = screenWidth - reduction
            return CGSize(width: screenWidth, height: height)
        }
}

extension FeedViewController: PhotoDeliveryDelegate {
    
    func didReceivePhotos() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingIndicator.stopAnimating()
            self?.collectionView.reloadData()
        }
    }
    
    func didReceiveError(_ error: Error) {
        // TODO: Show error alert
    }
}
