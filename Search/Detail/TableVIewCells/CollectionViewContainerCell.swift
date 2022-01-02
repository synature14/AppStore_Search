//
//  CollectionViewContainerCell.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit
import RxSwift
import RxRelay

struct BadgeInfo {
    var category: BadgeCategory = .평가
    var result: SearchResult
    
    enum BadgeCategory {
        case 평가
        case 연령
        case 카테고리
        case 개발자
        case 언어
    }
    
    func typeToString() -> String {
        switch category {
        case .평가:
            return "평가"
        case .연령:
            return "연령"
        case .카테고리:
            return "카테고리"
        case .개발자:
            return "개발자"
        case .언어:
            return "언어"
        }
    }
}

class CollectionViewContainerCellViewModel: TableCellRepresentable {
    enum ViewAction {
        case tapped
    }
    
    enum CollectionViewCellType {
        case BadgeCell
        case iPhonePreviewCell
        case iPadPreviewCell
    }
    
    var cellType: UITableViewCell.Type {
        CollectionViewContainerCell.self
    }
    
    private(set) var searchResult: SearchResult?
    private(set) var items: [CollectionCellRepresentable] = [] {
        didSet {
            updateCellVMs.onNext(items)
        }
    }
    let updateCellVMs = PublishSubject<[CollectionCellRepresentable]>()
    
    private(set) var type: CollectionViewCellType
    
    init(_ searchResult: SearchResult, type: CollectionViewCellType) {
        self.searchResult = searchResult
        self.type = type
        
        switch type {
        case .BadgeCell:
            self.items = self.configBadgeCellVMs()
        case .iPhonePreviewCell:
            self.items = self.configiPhonePreviewCellVMs()
        case .iPadPreviewCell:
            self.items = self.configiPadPreviewCellVMs()
        }
    }
    
    private func configBadgeCellVMs() -> [CollectionCellRepresentable] {
        guard let searchResult = self.searchResult else { return [] }
        var items: [CollectionCellRepresentable] = []
        let 평가 = BadgeInfo(category: .평가, result: searchResult)
        let 연령 = BadgeInfo(category: .연령, result: searchResult)
        let 카테고리 = BadgeInfo(category: .카테고리, result: searchResult)
        let 개발자 = BadgeInfo(category: .개발자, result: searchResult)
        let 언어 = BadgeInfo(category: .언어, result: searchResult)
        
        let vms = [평가, 연령, 카테고리, 개발자, 언어].map { BadgeCellViewModel($0) }
        items = vms
        
        return items
    }
    
    private func configiPhonePreviewCellVMs() -> [CollectionCellRepresentable] {
        let items: [CollectionCellRepresentable]? = searchResult?.screenshotUrls
            .compactMap { PreviewCellViewModel($0) }
            .compactMap { $0 as CollectionCellRepresentable }
        return items ?? []
    }
    
    private func configiPadPreviewCellVMs() -> [CollectionCellRepresentable] {
        let items: [CollectionCellRepresentable]? = searchResult?.ipadScreenshotUrls
            .compactMap { PreviewCellViewModel($0) }
            .compactMap { $0 as CollectionCellRepresentable }
        return items ?? []
    }
}


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
                layout.itemSize = CGSize(width: collectionView.frame.width / 4, height: collectionView.frame.height)
                layout.scrollDirection = .horizontal
                layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            }
        case .iPhonePreviewCell:
            // layout 교체
            let carouselLayout = CarouselLayout()
            let cellSize = cellSize(result.screenshotUrls.first ?? "")
            carouselLayout.itemSize = CGSize(width: cellSize.width-3,
                                                 height: cellSize.height-3)
            carouselLayout.itemCount = cellVM.items.count
            collectionView.collectionViewLayout = carouselLayout
            
        case .iPadPreviewCell:
            // layout 교체
            let carouselLayout = CarouselLayout()
            let cellSize = cellSize(result.screenshotUrls.first ?? "")
            carouselLayout.itemSize = CGSize(width: cellSize.width-2,
                                                 height: cellSize.height-2)
            carouselLayout.itemCount = cellVM.items.count
            collectionView.collectionViewLayout = carouselLayout
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
        guard let selectedItem = cellVM?.items[indexPath.item] else { return }
        
        let badge = selectedItem as? BadgeCellViewModel
        badge?.badgeInfo?.category
    }
}

private extension CollectionViewContainerCell {
    func cellSize(_ imageURL: String) -> CGSize {
        let originalSize = imageURL.size
        let cellSize = imageURL.isLandscape ? scaledSizeForLandscape(originalSize) : scaledSizeForPortrait(originalSize)
        return cellSize
    }
    
    // collectionView 좌우 패딩 = 20
    func scaledSizeForPortrait(_ originalImageSize: CGSize) -> CGSize {
        let resizedWidth = (UIScreen.main.bounds.width - 20*2) * 0.76
        let imageViewScaledHeight = originalImageSize.height * resizedWidth / originalImageSize.width
        return CGSize(width: resizedWidth, height: imageViewScaledHeight)
    }
    
    func scaledSizeForLandscape(_ originalImageSize: CGSize) -> CGSize {
        let resizedWidth = (UIScreen.main.bounds.width - 20*2)
        let imageViewScaledHeight = originalImageSize.height * resizedWidth / originalImageSize.width
        return CGSize(width: resizedWidth, height: imageViewScaledHeight)
    }
}
