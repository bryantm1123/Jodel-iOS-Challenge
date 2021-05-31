//
//  FullImagePresenter.swift
//  JodelChallenge
//
//  Created by Grigor Grigoryan on 30.05.21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

class FullImagePresenter {
    
    private let imageInfo: PhotoData
    private weak var view: FullImageView?
    
    init(view: FullImageView, imageInfo: PhotoData) {
        self.view = view
        self.imageInfo = imageInfo
    }
    
    func viewDidLoad() {
        view?.setImage(url: imageInfo.imageURL)
        view?.setTitle(title: imageInfo.title ?? "")
    }
}
