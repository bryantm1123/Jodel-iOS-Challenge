//
//  FeedViewController.swift
//  JodelChallenge
//
//  Created by Dmitry on 27/06/2019.
//  Copyright © 2019 Jodel. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
            
    @IBOutlet private weak var tableView: UITableView?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    private var paginationEnabled: Bool = false
    private var triggerOffset = 1
    private var presenter: FeedPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        presenter?.loadData()
        
        tableView?.addSubview(refreshControl)
        refreshControl.beginRefreshing()
    }
    
    private func configureViewController() {
        let flickerKit = FlickrKit.shared()
        let flickrService = FlickrService(flickr: flickerKit)
        let imageManager = ImageManager(flickrService: flickrService)
        presenter = FeedPresenter(view: self, imageManager: imageManager)
    }
    
    @objc
    private func handleRefresh(_ refreshControl: UIRefreshControl) {
        presenter?.pullToRefresh()
    }
}

// MARK: - UITableViewDelegate
extension FeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let photosList = presenter?.getPhotosList(),
              let viewControllser = storyboard?.instantiateViewController(withIdentifier: "FullImageViewController") as? FullImageViewController else {
            return
        }
        viewControllser.configureViewController(imageInfo: photosList[indexPath.row])
        present(viewControllser, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if paginationEnabled {
            let lastSectionIndex = tableView.numberOfSections - 1
            let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
            if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
                let spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
                
                tableView.tableFooterView = spinner
                tableView.tableFooterView?.isHidden = false
            }
            
            let currentRowNumber = (0..<indexPath.section)
                .map(tableView.numberOfRows)
                .reduce(0, +)
                + indexPath.row + 1 // Because indexPath.row begins at 0
            
            let totalNumberOfRows = (0..<tableView.numberOfSections)
                .map(tableView.numberOfRows)
                .reduce(0, +)
            
            let triggerPagination = currentRowNumber + triggerOffset >= totalNumberOfRows + 1
            
            guard triggerPagination else { return }
            
            presenter?.loadNextPage()
        } else {
            tableView.tableFooterView = nil
        }
    }
}

// MARK: - UITableViewDataSource
extension FeedViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let photosList = presenter?.getPhotosList() {
            return photosList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.cellIdentifier, for: indexPath) as? FeedTableViewCell else { return UITableViewCell() }
        
        if let photosList = presenter?.getPhotosList() {
            cell.configure(with: photosList[indexPath.row])
        }
        return cell
    }
}

// MARK: - FeedView delegate
extension FeedViewController: FeedView {
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func reloadView() {
        tableView?.reloadData()
    }
    
    func enablePagination() {
        paginationEnabled = true
    }
    
    func desablePagination() {
        paginationEnabled = false
    }
}
