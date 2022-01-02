//
//  RatingView.swift
//  Search
//
//  Created by Suvely on 2022/01/02.
//

import Foundation
import UIKit

class RatingView: UIView {
    
    var progress: CGFloat = 0 {
        didSet {
            updateProgressView()
        }
    }
    var fillColor: UIColor = .lightGray {
        didSet {
            updateUI()
        }
    }
    var borderColor: UIColor = .lightGray {
        didSet {
            updateUI()
        }
    }
    
    private var starImageView: UIImageView?
    private var progressView: UIView?
    private var progressWidthAnchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func updateUI() {
        progressView?.backgroundColor = fillColor
        starImageView?.tintColor = borderColor
    }
    
    func commonInit() {
        backgroundColor = .clear
        
        let starImageView = UIImageView(image: UIImage(systemName: "star"))
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(starImageView)
        starImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        starImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        starImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        starImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.starImageView = starImageView
        
        let progressView = UIView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.backgroundColor = fillColor
        addSubview(progressView)
        progressView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        progressView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        progressView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        progressWidthAnchor = progressView.widthAnchor.constraint(equalToConstant: 0)
        progressWidthAnchor?.isActive = true
        self.progressView = progressView
        
        updateMaskView()
        updateUI()
    }
    
    func updateMaskView() {
        let maskView = UIImageView(image: UIImage(systemName: "star.fill"))
        maskView.frame = bounds
        mask = maskView
    }
    
    func updateProgressView() {
        guard progress >= 0, progress <= 1 else { return }
        let width = bounds.width * progress
        progressWidthAnchor?.constant = width
        progressView?.backgroundColor = fillColor
    }
}
