//
//  AppIconCell.swift
//  Search
//
//  Created by Suvely on 2021/12/31.
//

import UIKit
import RxSwift

class AppIconCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        AppIconCell.self
    }
    
    private var disposeBag = DisposeBag()
    var searchResult: SearchResult
    
    init(_ result: SearchResult) {
        self.searchResult = result
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
    lazy var appIconImage: Observable<UIImage> = {
        return UIUtility.shared.loadImage(searchResult.iconImage)
    }()
}

class AppIconCell: UITableViewCell, BindableTableViewCell {
    
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var userRatingCountLabel: UILabel!
    
    @IBOutlet var ratingViews: [RatingView]!
    
    private var sortedRatingViews: [RatingView] {
        ratingViews.sorted { $0.tag < $1.tag }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = ""
        sellerNameLabel.text = ""
        userRatingCountLabel.text = ""
        disposeBag = DisposeBag()
    }
    
    func bindCellVM(_ viewModel: TableCellRepresentable?) {
        guard let vm = viewModel as? AppIconCellViewModel else {
            return
        }
        let result = vm.searchResult
        trackNameLabel.text = result.trackName
        userRatingCountLabel.text = "\(result.userRatingCount)"
        sellerNameLabel.text = result.sellerName
        
        vm.appIconImage
            .observeOn(MainScheduler.instance)
            .bind(to: self.appIconImageView.rx.image)
            .disposed(by: disposeBag)
        
        let averageRating = round(result.averageUserRating*10) / 10
        // 평점 3.2136 라면
        let floatAverageRating = averageRating
        let filledCnt = Int(floatAverageRating)                    // 3
        
        let unFilledRate = averageRating - CGFloat(filledCnt)    // 0.2136
        
        for i in 0..<filledCnt {
            sortedRatingViews[i].progress = 1
        }
        
        if filledCnt == 5 {
            return
        }
        
        for i in filledCnt..<(filledCnt+1) {
            sortedRatingViews[i].progress = unFilledRate
        }
        
        let emptyStarIndex = filledCnt+1
        for i in emptyStarIndex..<ratingViews.count {
            sortedRatingViews[i].progress = 0
        }
    }
}
