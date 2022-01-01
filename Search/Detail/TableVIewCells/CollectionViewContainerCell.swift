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
        case PreviewCell
    }
    
    var cellType: UITableViewCell.Type {
        CollectionViewContainerCell.self
    }
    
    private var searchResult: SearchResult?
    private(set) var items: [CollectionCellRepresentable] = [] {
        didSet {
            updatedCellVMs.accept(items)
        }
    }
    let updatedCellVMs = BehaviorRelay<[CollectionCellRepresentable]>(value: [])
    
    private(set) var cellSize: CGSize
    private(set) var type: CollectionViewCellType
    
    init(_ searchResult: SearchResult, cellSize: CGSize, type: CollectionViewCellType) {
        self.searchResult = searchResult
        self.cellSize = cellSize
        self.type = type
        
        switch type {
        case .BadgeCell:
            self.items = self.configureBadgeCellVMs()
        case .PreviewCell:
            self.items = self.configurePreviewCellVMs()
        }
    }
    
    private func configureBadgeCellVMs() -> [CollectionCellRepresentable] {
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
    
    private func configurePreviewCellVMs() -> [CollectionCellRepresentable] {
        let items: [CollectionCellRepresentable]? = searchResult?.screenshotUrls
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
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cells: [ BadgeCell.self, PreviewCell.self ])
        
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = cellVM?.cellSize ?? .zero
            layout.scrollDirection = .horizontal
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            
            switch cellVM?.type {
            case .BadgeCell:
                break
            case .PreviewCell:
                layout.minimumLineSpacing = 15
            default:
                break
            }
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
    
    
}