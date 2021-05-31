//
//  FullImageViewController.swift
//  JodelChallenge
//
//  Created by Grigor Grigoryan on 30.05.21.
//  Copyright © 2021 Jodel. All rights reserved.
//

import Foundation

class FullImageViewController: UIViewController {
    
    @IBOutlet private weak var fullImageView: UIImageView!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    private var presenter: FullImagePresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
    }

    func configureViewController(imageInfo: PhotoData) {
        presenter = FullImagePresenter(view: self, imageInfo: imageInfo)
    }
    
    @IBAction private func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK:- UIScrollViewDelegate
extension FullImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullImageView
    }
}

// MARK:- FullImageView delegate
extension FullImageViewController: FullImageView {
    
    func setImage(url: URL) {
        fullImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
}
