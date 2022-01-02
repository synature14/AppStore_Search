//
//  RatingView.swift
//  Search
//
//  Created by Suvely on 2022/01/02.
//

import Foundation
import UIKit

class RatingViews: UIStackView {
    private var stars: [RatingView]?

    var averageRating: CGFloat = 0 {
        didSet{
            updateUI()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {
        var starViews: [RatingView] = []
        for i in 0..<5 {
            let star = RatingView()
            star.tag = i
            starViews.append(star)
        }
        stars = starViews
        stars?.sorted(by: {$0.tag < $1.tag} )
            .forEach { self.addSubview($0) }
    }
    
    func updateUI() {
        guard let stars = stars else { return }
        // 평점 3.2 라면
        let filledCnt = Int(averageRating)                    // 3
        let unFilledRate = averageRating - CGFloat(filledCnt)    // 0.2

        for i in 0..<filledCnt {
            stars[i].progress = 1
        }
        for i in filledCnt..<(filledCnt+1) {
            stars[i].progress = unFilledRate
        }

        let emptyStarIndex = filledCnt+1
        for i in emptyStarIndex..<stars.count {
            stars[i].progress = 0
        }
    }

}

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
