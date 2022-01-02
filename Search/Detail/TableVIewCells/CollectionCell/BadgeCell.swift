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

    @IBOutlet var ratingViews: [RatingView]!
    
    private var sortedRatingViews: [RatingView] {
        ratingViews.sorted { $0.tag < $1.tag }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = ""
        largeFontLabel.text = ""
    }

    func bindCellVM(_ cellVM: CollectionCellRepresentable?) {
        largeFontView.isHidden = true
        developerIconImage.isHidden = true
        ratingView.isHidden = true
        descriptionView.isHidden = false
        
        guard let cellVM = cellVM as? BadgeCellViewModel else {
            return
        }
        self.cellVM = cellVM
        
        setUI()
    }
    
    private func setUI() {
        guard let badgeInfo = self.cellVM?.badgeInfo else {
            return
        }
        let result = badgeInfo.result
        categoryLabel.text = badgeInfo.typeToString()
        
        switch badgeInfo.category {
        case .평가:
            categoryLabel.text = "\(badgeInfo.result.userRatingCount)개의 평가"
            let ratingFloat = round(result.averageUserRating*10) / 10
            let averageRating = String(format: "%.1f", ratingFloat)
            largeFontLabel.text = averageRating
            largeFontView.isHidden = false
            ratingView.isHidden = false
            descriptionView.isHidden = true
            
            // 평점 3.2 라면
            let floatAverageRating = CGFloat((averageRating as NSString).floatValue)
            let filledCnt = Int(floatAverageRating)                    // 3
            let unFilledRate = ratingFloat - CGFloat(filledCnt)    // 0.2
            
            for i in 0..<filledCnt {
                sortedRatingViews[i].progress = 1
            }
            for i in filledCnt..<(filledCnt+1) {
                sortedRatingViews[i].progress = unFilledRate
            }
            
            let emptyStarIndex = filledCnt+1
            for i in emptyStarIndex..<ratingViews.count {
                sortedRatingViews[i].progress = 0
            }
            
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
            var firstLang = ""
            if result.languageCodesISO2A.contains("KO") {
                firstLang = "KO"
            }
            
            largeFontLabel.text = firstLang
            if result.languageCodesISO2A.count > 1 {
                descriptionLabel.text = "+ \(result.languageCodesISO2A.count - 1)개 언어"
            } else {
                descriptionLabel.text = localizedString(result.languageCodesISO2A).first
            }
        }
    }
    
    private func localizedString(_ codes: [String]) -> [String] {
        let languageStrings = codes
            .map { $0.lowercased() }
            .compactMap { Locale.current.localizedString(forLanguageCode: $0) }
        return languageStrings
    }
}
