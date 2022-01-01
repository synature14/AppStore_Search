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
        case 차트
        case 개발자
        case 언어
    }
}

class CollectionViewContainerCellViewModel: TableCellRepresentable {
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
    
    enum ViewAction {
        case tapped
    }
    
    private(set) var cellHeight: CGFloat
    
    init(_ searchResult: SearchResult, cellHeight: CGFloat) {
        self.searchResult = searchResult
        self.cellHeight = cellHeight
        self.items = self.configureCellVMs()
    }
    
    private func configureCellVMs() -> [CollectionCellRepresentable] {
        guard let searchResult = self.searchResult else { return [] }
        var items: [CollectionCellRepresentable] = []
        let 평가 = BadgeInfo(category: .평가, result: searchResult)
        let 연령 = BadgeInfo(category: .연령, result: searchResult)
        let 차트 = BadgeInfo(category: .차트, result: searchResult)
        let 개발자 = BadgeInfo(category: .개발자, result: searchResult)
        let 언어 = BadgeInfo(category: .언어, result: searchResult)
        
        let vms = [평가, 연령, 차트, 개발자, 언어].map { BadgeCellViewModel($0) }
        items = vms
        
        return items
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
        
        collectionView.register(cells: [ BadgeCell.self ])
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 15*2)/4, height: 70)
            layout.scrollDirection = .horizontal
            layout.sectionInset = .zero
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
