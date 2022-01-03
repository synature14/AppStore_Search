//
//  CollectionViewContainerCell.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit
import RxSwift
import RxRelay

class CollectionViewContainerCell: UITableViewCell, BindableTableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var disposeBag = DisposeBag()
    private(set) var cellVM: CollectionViewContainerCellViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cells: [ BadgeCell.self, PreviewCell.self ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let cellVM = cellVM as? CollectionViewContainerCellViewModel else {
            return
        }
        
        self.cellVM = cellVM
        setCollectionView()
        collectionView.reloadData()
    }
    
    private func setCollectionView() {
        guard let cellVM = self.cellVM, let result = cellVM.searchResult else { return }

        switch cellVM.type {
        case .BadgeCell:
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: collectionView.frame.width / 4, height: 76)
                layout.scrollDirection = .horizontal
                layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            }
        case .iPhonePreviewCell:
            // layout 교체
            let carouselLayout = CarouselLayout()
            let sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
            carouselLayout.sectionInset = sectionInset
//            let cellSize = cellSize(result.screenshotUrls.first ?? "")
            let spacing = CGFloat(10)
            carouselLayout.minimumLineSpacing = spacing
            
            carouselLayout.itemSize = CGSize(width: collectionView.frame.width - sectionInset.left - sectionInset.right - spacing,
                                             height: Constants.iPhonePreviewRowHeight)
            carouselLayout.itemCount = cellVM.items.count
            collectionView.collectionViewLayout = carouselLayout
            
            // downSampling할 imageView사이즈 업데이트
            cellVM.updateItemSizeForCell(carouselLayout.itemSize, .iPhonePreviewCell)
        case .iPadPreviewCell:
            // layout 교체
            let carouselLayout = CarouselLayout()
            let sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
            carouselLayout.sectionInset = sectionInset
            
//            let cellSize = cellSize(result.screenshotUrls.first ?? "")
            let spacing = CGFloat(10)
            carouselLayout.minimumLineSpacing = spacing
            carouselLayout.itemSize = CGSize(width: collectionView.frame.width - sectionInset.left - sectionInset.right - spacing,
                                             height: Constants.iPadPreviewRowHeight)
            carouselLayout.itemCount = cellVM.items.count
            collectionView.collectionViewLayout = carouselLayout
            // downSampling할 imageView사이즈 업데이트
            cellVM.updateItemSizeForCell(carouselLayout.itemSize, .iPadPreviewCell)
        }
    }
    
}

extension CollectionViewContainerCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellVM?.items.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = cellVM?.items[indexPath.item] else {
            return UICollectionViewCell()
        }
        return collectionView.resolveCell(item, indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cellVM = cellVM else { return }
        let selectedItem = cellVM.items[indexPath.item]
        
        switch selectedItem {
        case let badge as BadgeCellViewModel:
            badge.badgeInfo?.category
        case _ as PreviewCellViewModel:
            cellVM.delegate?.showLargePreviewVC(cellVM.type, items: cellVM.items)
        default:
            break
        }
        
    }
}

private extension CollectionViewContainerCell {
//    func cellSize(_ imageURL: String) -> CGSize {
//        let cellSize = imageURL.isLandscape ? scaledSizeForLandscape() : scaledSizeForPortrait()
//        return cellSize
//    }
//
//    // collectionView 좌우 패딩 = 20
//    func scaledSizeForPortrait() -> CGSize {
//        let resizedWidth = (UIScreen.main.bounds.width - 20*2) * 0.76
//        return CGSize(width: resizedWidth, height: collectionView.frame.height)
//    }
//
//    func scaledSizeForLandscape() -> CGSize {
//        let resizedWidth = (UIScreen.main.bounds.width - 20*2)
////        let imageViewScaledHeight = Constants.iPadPreviewRowHeight
//        return CGSize(width: resizedWidth, height: collectionView.frame.height)
//    }
}
