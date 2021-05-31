//
//  FeedView.swift
//  JodelChallenge
//
//  Created by Grigor Grigoryan on 29.05.21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

protocol FeedView: AnyObject {
    
    func reloadView()
    func endRefreshing()
    
    func enablePagination()
    func desablePagination()
}
