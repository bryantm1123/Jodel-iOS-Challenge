//
//  FeedViewController.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class FeedViewController : UICollectionViewController {
    
    var photos : [URL] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let service = FlickrService()
        
        service.fetchPhotos(for: "15")
        
//        FlickrApi.fetchPhotos { [weak self] (responsePhotos, error) in
//            self?.photos = responsePhotos ?? []
//            DispatchQueue.main.async(execute: {
//                self?.collectionView?.reloadData()
//            })
//        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCell", for: indexPath) as! FeedCell
        cell.configure(with: photos[indexPath.row])
        return cell
    }
}
