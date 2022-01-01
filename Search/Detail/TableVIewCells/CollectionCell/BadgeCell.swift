//
//  BadgeCell.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit

class BadgeCellViewModel: CollectionCellRepresentable {
    var cellType: UICollectionViewCell.Type {
        BadgeCell.self
    }
    
    private(set) var badgeInfo: BadgeInfo?
    
    init(_ badgeInfo: BadgeInfo) {
        self.badgeInfo = badgeInfo
    }
}

class BadgeCell: UICollectionViewCell, BindableCollectionViewCell {

    private(set) var cellVM: BadgeCellViewModel?
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var developerIconImage: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet var starImageViews: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindCellVM(_ cellVM: CollectionCellRepresentable?) {
        guard let cellVM = cellVM as? BadgeCellViewModel else {
            return
        }
        self.cellVM = cellVM
        
        guard let badgeInfo = cellVM.badgeInfo else {
            return
        }
        
//        developerIconImage.isHidden = badgeInfo.
        
    }
}
