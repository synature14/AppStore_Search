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
    @IBOutlet weak var largeFontView: UIView!
    @IBOutlet weak var largeFontLabel: UILabel!
    @IBOutlet weak var developerIconImage: UIView!
    
    
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet var starImageViews: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func bindCellVM(_ cellVM: CollectionCellRepresentable?) {
        largeFontView.isHidden = true
        developerIconImage.isHidden = true
        ratingView.isHidden = true
        
        guard let cellVM = cellVM as? BadgeCellViewModel else {
            return
        }
        self.cellVM = cellVM
        
        guard let badgeInfo = cellVM.badgeInfo else {
            return
        }
        let result = badgeInfo.result
        categoryLabel.text = badgeInfo.typeToString()
        
        switch badgeInfo.category {
        case .평가:
            categoryLabel.text = "\(badgeInfo.result.userRatingCount)개의 평가"
            let averageRating = String(format: "%.1f", round(result.averageUserRating*10) / 10)
            largeFontLabel.text = averageRating
            largeFontView.isHidden = false
            ratingView.isHidden = false
            descriptionView.isHidden = true
            
        case .연령:
            largeFontLabel.text = "\(result.trackContentRating)"
            largeFontView.isHidden = false
            descriptionLabel.text = "세"
            
        case .카테고리:
            developerIconImage.isHidden = false
            descriptionLabel.text = result.genres.first
            
        case .개발자:
            developerIconImage.isHidden = false
            descriptionLabel.text = result.sellerName
            
        case .언어:
            largeFontView.isHidden = false
            largeFontLabel.text = result.languageCodesISO2A.first
            if result.languageCodesISO2A.count > 1 {
                descriptionLabel.text = "+ \(result.languageCodesISO2A.count)개 언어"
            } else {
                //MARK: 수정해야함 "KO" -> "한국어"로 맵핑
                descriptionLabel.text = "한국어"
            }
        }
    }
}
