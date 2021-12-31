//
//  LandScapeScreenShotCell.swift
//  Search
//
//  Created by Suvely on 2021/12/31.
//

import UIKit
import RxSwift
import RxRelay

class LandScapeViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        LandScapeScreenShotCell.self
    }
    
    private var urls: [String]?
    let firstScreenShot = BehaviorRelay<UIImage?>(value: nil)
    let scaledImageHeight = BehaviorRelay<CGFloat>(value: 0)
    
    private var disposeBag = DisposeBag()
    
    init(_ imageUrls: [String]) {
        self.urls = imageUrls
    }
    
    func bindings() {
        guard let urls = self.urls else {
            return
        }
        UIUtility.shared.loadImage(urls[0])
            .subscribe(onNext: { image in
                self.firstScreenShot.accept(image)
            })
            .disposed(by: disposeBag)
    }
}

class LandScapeScreenShotCell: UITableViewCell, BindableTableViewCell {
    static let name = "LandScapeScreenShotCell"
    private var cellVM: LandScapeViewModel?
    private var landscapeImageViewWidth: CGFloat = 0.0
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var screenShotTrailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let cellVM = cellVM as? LandScapeViewModel else { return }
        self.cellVM = cellVM
        landscapeImageViewWidth = UIScreen.main.bounds.width - screenShotTrailingConstraint.constant * 2
        
        cellVM.firstScreenShot
            .subscribe(onNext: { [weak self] image in
                guard let image = image, let self = self else {
                    return
                }
                
                let scaledHeight = image.scaledImageHeight(of: self.landscapeImageViewWidth)
                cellVM.scaledImageHeight.accept(scaledHeight)
            })
            .disposed(by: disposeBag)
    }
}
