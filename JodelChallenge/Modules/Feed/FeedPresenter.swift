//
//  FeedPresenter.swift
//  JodelChallenge
//
//  Created by Grigor Grigoryan on 29.05.21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

enum LoadType {
    case initial
    case next
}

class FeedPresenter {
    
    private let imageManager: IManager
    private weak var view: FeedView?
    private var photosList: [PhotoData]?
    private var currentPage = 1
    private var maxPages = 1
    
    init(view: AnyObject, imageManager: IManager) {
        self.view = view as? FeedView
        self.imageManager = imageManager
    }
    
    func loadData() {
        loadPhotos()
    }
    
    func getPhotosList() -> [PhotoData] {
        return photosList ?? []
    }
    
    func pullToRefresh() {
        loadPhotos()
    }
    
    private func loadPhotos(page: Int = 1, loadType: LoadType = .initial) {
        imageManager.getPhotos(page: page) {[weak self] photos, error in
            self?.view?.endRefreshing()
            if let photos = photos {
                self?.onFetchResult(with: photos, loadType: loadType)
            } else if let error = error {
                AlertFactory.default(message: error.localizedDescription).show()
            }
        }
    }
    
    func loadNextPage() {
        currentPage += 1
        loadPhotos(page: currentPage, loadType: .next)
    }
    
    func onFetchResult(with photos: Photos, loadType: LoadType) {
        currentPage = photos.currentPage
        maxPages = photos.pages
        
        currentPage < maxPages ? view?.enablePagination() : view?.desablePagination()

        switch loadType {
        case .initial:
            self.photosList = photos.photoDataList
        case .next:
            self.photosList?.append(contentsOf: photos.photoDataList ?? [])
        }
        
        view?.reloadView()
    }
}
