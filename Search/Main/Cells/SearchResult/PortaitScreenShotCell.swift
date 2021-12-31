//
//  PortaitScreenShotCell.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import UIKit
import RxSwift

class PortaitScreenShotCell: UITableViewCell, BindableTableViewCell {
    static let name = "PortaitScreenShotCell"
    private let screenShotImageViewWidth: CGFloat = (UIScreen.main.bounds.width - 40.0 - 5.0*2) / 3
    
    private var disposeBag = DisposeBag()
    private var vm: ResultCellViewModel?
    
    // screenShotImageView의 width 사이즈
    private var landscapeImageViewWidth: CGFloat = 0.0
    private var portraitImageViewWidth: CGFloat = 0.0
    
    @IBOutlet weak var screenShotTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var portraitStackView: UIStackView!
    @IBOutlet weak var screenShotImageView: UIImageView!
    @IBOutlet weak var screenShotImageView01: UIImageView!
    @IBOutlet weak var screenShotImageView02: UIImageView!
    
    @IBOutlet weak var landScapeView: UIView!
    @IBOutlet weak var landScapeImageView: UIImageView!
    
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
    
    func bindCellVM(_ cell: TableCellRepresentable?) {
        <#code#>
    }
    
    func setData(_ vm: ResultCellViewModel) {
        self.vm = vm
        guard let result = vm.searchResult else {
            return
        }
        
        bindings()
    }
    
    private func bindings() {
        guard let vm = self.vm else {
            return
        }
        
        vm.firstScreenShot
            .subscribe(onNext: { [weak self] image in
                guard let image = image, let self = self else {
                    return
                }
                
                let urls = vm.screenShotUrls
                
                switch image.imageMode() {
                case .landscape:
                    self.landScapeView.isHidden = false
                    self.landScapeImageView.loadImage(urls[0], self.disposeBag)
                    
                case .portrait:
                    self.landScapeView.isHidden = true
                    
                    // MARK: kingFisher 내부 로직 문서 보기
                    // Core Data 써서 image caching 하기. LRU or 다른 알고리즘
                    self.screenShotImageView.loadImage(urls[0], self.disposeBag)
                    self.screenShotImageView01.loadImage(urls[1], self.disposeBag)
                    
                    if urls.count == 3 {
                        self.screenShotImageView02.loadImage(urls[2], self.disposeBag)
                    }
                }
                
                let scaledImageViewWidth: CGFloat = image.scaledImageHeight(of: self.portraitImageViewWidth)
                vm.scaledImageHeight.accept(scaledImageViewWidth)
            }).disposed(by: disposeBag)
    }
    
}
