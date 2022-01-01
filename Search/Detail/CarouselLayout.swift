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
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return .zero
        }
        
        collectionView.decelerationRate = .init(rawValue: 0.4)
        
        let xOffset = collectionView.contentOffset.x
        
        let distance = abs(previousOffset - xOffset)
        print("distance = \(distance)")
//        if distance < (collectionView.bounds.width / 5) {   // 컬렉션뷰 width의 1/5 미만 스크롤하면 제자리로
//            return CGPoint(x: previousOffset, y: 0)
//        }
        
        if previousOffset < xOffset {    // 다음 페이지(오른쪽) 스와이핑
            currentPage = currentPage + Int(round(velocity.x)) - 1
        } else {
            // 뒤로 스와이핑
            currentPage = currentPage + Int(round(velocity.x))
        }
        
        if currentPage > itemCount {
            currentPage = itemCount - 1
        }
        
        if currentPage < 0 {
            currentPage = 0
        }
        
        let updatedOffset = (itemSize.width + minimumLineSpacing) * CGFloat(currentPage)
        previousOffset = updatedOffset
        
        print("currentPage = \(currentPage), updatedOffset = \(updatedOffset)")
        return CGPoint(x: updatedOffset, y: 0)
    }

}
