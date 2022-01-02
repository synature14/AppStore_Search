//
//  CarouselLayout.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit

class CarouselLayout: UICollectionViewFlowLayout {
    var eachItemSize: CGSize = .zero
    var itemCount: Int = 0
    private var previousOffset: CGFloat = 0
    private var currentPage: Int = 0
    
    override func prepare() {
        super.prepare()
        setupLayout()
    }
    
    private func setupLayout() {
        self.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        self.scrollDirection = .horizontal
        self.minimumLineSpacing = 10
        self.itemSize = eachItemSize
        self.collectionView?.decelerationRate = .init(rawValue: 0.4)
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let xOffset = proposedContentOffset.x
        let updatedIndex = round(xOffset / (itemSize.width + minimumLineSpacing))
        
        let updatedOffset = updatedIndex * (itemSize.width + minimumLineSpacing)
        print("updatedIndex = \(updatedIndex) , updatedOffset = \(updatedOffset)")
        return CGPoint(x: updatedOffset, y: 0)
    }
}
