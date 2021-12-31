//
//  LandScapeScreenShotCell.swift
//  Search
//
//  Created by Suvely on 2021/12/31.
//

import UIKit
import RxSwift
import RxRelay

class LandscapeCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        LandscapeScreenShotCell.self
    }
    
    private var urls: [String]?
    let imageSize: CGSize
    
    private var disposeBag = DisposeBag()
    
    init(_ imageUrls: [String], imageSize: CGSize) {
        self.urls = imageUrls
        self.imageSize = imageSize
    }
}

class LandscapeScreenShotCell: UITableViewCell, BindableTableViewCell {
    static let name = "LandscapeScreenShotCell"
    private var cellVM: LandscapeCellViewModel?
    private var landscapeImageViewWidth: CGFloat = 0.0
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var screenShotTrailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let cellVM = cellVM as? LandscapeCellViewModel else { return }
        self.cellVM = cellVM
        landscapeImageViewWidth = UIScreen.main.bounds.width - screenShotTrailingConstraint.constant * 2
        
//        cellVM.firstScreenShot
//            .subscribe(onNext: { [weak self] image in
//                guard let image = image, let self = self else {
//                    return
//                }
//
//                let scaledHeight = image.scaledImageHeight(of: self.landscapeImageViewWidth)
//                cellVM.scaledImageHeight.accept(scaledHeight)
//            })
//            .disposed(by: disposeBag)
    }
}
