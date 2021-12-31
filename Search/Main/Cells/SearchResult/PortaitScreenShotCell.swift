//
//  PortaitScreenShotCell.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import UIKit
import RxSwift
import RxRelay

class PortaitViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        PortaitScreenShotCell.self
    }
    
    private var searchResult: SearchResult?
    let firstScreenShot = BehaviorRelay<UIImage?>(value: nil)
    let scaledImageHeight = BehaviorRelay<CGFloat>(value: 0)
    
    lazy var screenShotUrls: [String] = {
        guard let searchResult = self.searchResult else {
            return []
        }

        var count = searchResult.screenshotUrls.count
        if count > 3 {
            count = 3
        }
        let urlStrings = searchResult.screenshotUrls[0..<count]
        return Array(urlStrings)
    }()
    
    private var disposeBag = DisposeBag()
    
    init(_ result: SearchResult) {
        self.searchResult = result
        bindings()
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
    func bindings() {
        guard let result = self.searchResult else {
            return
        }
        UIUtility.shared.loadImage(result.screenshotUrls[0])
            .subscribe(onNext: { image in
                self.firstScreenShot.accept(image)
            })
            .disposed(by: disposeBag)
    }
}

class PortaitScreenShotCell: UITableViewCell, BindableTableViewCell {
    static let name = "PortaitScreenShotCell"
    private let screenShotImageViewWidth: CGFloat = (UIScreen.main.bounds.width - 40.0 - 5.0*2) / 3
    
    private var disposeBag = DisposeBag()
    private var vm: PortaitViewModel?
    
    // screenShotImageView의 width 사이즈
    private var landscapeImageViewWidth: CGFloat = 0.0
    private var portraitImageViewWidth: CGFloat = 0.0
    
    @IBOutlet weak var screenShotTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var portraitStackView: UIStackView!
    @IBOutlet weak var screenShotImageView: UIImageView!
    @IBOutlet weak var screenShotImageView01: UIImageView!
    @IBOutlet weak var screenShotImageView02: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // screenshotImage 사이즈 계산해서 높이 다시 맞춰야함..
        // screenShotImageViewWidth : x = 이미지 사이즈 가로 : y
        landscapeImageViewWidth = UIScreen.main.bounds.width - screenShotTrailingConstraint.constant * 2
        portraitImageViewWidth = (self.landscapeImageViewWidth - self.portraitStackView.spacing) / CGFloat(3)
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let cellVM = cellVM as? PortaitViewModel else { return }
        self.vm = cellVM
        bindings()
    }
    
    private func bindings() {
        guard let vm = self.vm else {
            return
        }
        
        let urls = vm.screenShotUrls
        
        // MARK: kingFisher 내부 로직 문서 보기
        // Core Data 써서 image caching 하기. LRU or 다른 알고리즘
        self.screenShotImageView.loadImage(urls[0], self.disposeBag)
        self.screenShotImageView01.loadImage(urls[1], self.disposeBag)
        
        if urls.count == 3 {
            self.screenShotImageView02.loadImage(urls[2], self.disposeBag)
        }
        
        vm.firstScreenShot
            .subscribe(onNext: { [weak self] image in
                guard let image = image, let self = self else {
                    return
                }
                
                let scaledHeight = image.scaledImageHeight(of: self.portraitImageViewWidth)
                vm.scaledImageHeight.accept(scaledHeight)

            }).disposed(by: disposeBag)
    }
    
}
