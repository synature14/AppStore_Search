//
//  LargeViewController.swift
//  Search
//
//  Created by Suvely on 2022/01/03.
//

import UIKit

class LargeViewModel {
    let cellVMs: [PreviewCellViewModel]
    let type: PreviewCollectionCellType
    
    init(type: PreviewCollectionCellType, _ cellVMs: [PreviewCellViewModel]) {
        self.cellVMs = cellVMs
        self.type = type
    }
}


class LargeViewController: UIViewController {
    var vm: LargeViewModel?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setCollectionView()
        bindVMs()
    }
    
    private func setCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(cells: [PreviewCell.self])
    }
    
    private func bindVMs() {
        guard let vm = self.vm else { return }

        switch vm.type {
        case .BadgeCell:
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.itemSize = CGSize(width: collectionView.frame.width / 4, height: 76)
                layout.scrollDirection = .horizontal
                layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            }
        case .iPhonePreviewCell:
            // layout 교체
            let carouselLayout = CarouselLayout()
//            let cellSize = cellSize(vm.cellVMs.first?.imageURL ?? "")
            let sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            carouselLayout.sectionInset = sectionInset
            carouselLayout.itemSize = CGSize(width: (collectionView.frame.width - sectionInset.right - sectionInset.left),
                                             height: collectionView.frame.height)
            carouselLayout.itemCount = vm.cellVMs.count
            carouselLayout.minimumLineSpacing = 15
            collectionView.collectionViewLayout = carouselLayout
            
        case .iPadPreviewCell:
            // layout 교체
            let carouselLayout = CarouselLayout()
            let cellSize = cellSize(vm.cellVMs.first?.imageURL ?? "")
            let sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            carouselLayout.sectionInset = sectionInset
            carouselLayout.itemSize = CGSize(width: collectionView.frame.width - sectionInset.right - sectionInset.left,
                                                 height: cellSize.height-2)
            carouselLayout.itemCount = vm.cellVMs.count
            collectionView.collectionViewLayout = carouselLayout
        }
    }
}


extension LargeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm?.cellVMs.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = vm?.cellVMs[indexPath.item] else {
            return UICollectionViewCell()
        }
        let cell = collectionView.resolveCell(item, indexPath: indexPath)
        cell.layer.cornerRadius = 30
        return cell
    }
}

private extension LargeViewController {
    func cellSize(_ imageURL: String) -> CGSize {
        let cellSize = imageURL.isLandscape ? scaledSizeForLandscape() : scaledSizeForPortrait()
        return cellSize
    }
    
    // collectionView 좌우 패딩 = 20
    func scaledSizeForPortrait() -> CGSize {
        let resizedWidth = (UIScreen.main.bounds.width - 20*2) * 0.76
        let imageViewScaledHeight = Constants.iPhonePreviewRowHeight
        return CGSize(width: resizedWidth, height: imageViewScaledHeight)
    }
    
    func scaledSizeForLandscape() -> CGSize {
        let resizedWidth = (UIScreen.main.bounds.width - 20*2)
        let imageViewScaledHeight = Constants.iPadPreviewRowHeight
        return CGSize(width: resizedWidth, height: imageViewScaledHeight)
    }
}
