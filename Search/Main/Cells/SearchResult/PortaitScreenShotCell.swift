//
//  PortaitScreenShotCell.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import UIKit
import RxSwift
import RxRelay

class PortaitCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        PortaitScreenShotCell.self
    }
    
    private var searchResult: SearchResult?
    let imageSize: CGSize
    var screenShotTrailingConstraint: CGFloat = 0.0
    
    lazy var screenShotUrls: [String] = {
        guard let searchResult = self.searchResult else {
            return []
        }

        // MARK: 깜짝 놀랐쥬?? 임시 코드 ~
        var count = searchResult.screenshotUrls.count
        if count > 3 {
            count = 3
        }
        let urlStrings = searchResult.screenshotUrls[0..<count]
        return Array(urlStrings)
    }()
    
    private var disposeBag = DisposeBag()
    
    init(_ result: SearchResult, imageSize: CGSize) {
        self.searchResult = result
        self.imageSize = imageSize
        bindings()
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
    func bindings() {
    }
}

class PortaitScreenShotCell: UITableViewCell, BindableTableViewCell {
    private var disposeBag = DisposeBag()
    private var vm: PortaitCellViewModel?

    @IBOutlet weak var portraitStackView: UIStackView!
    @IBOutlet weak var screenShotImageView: UIImageView!
    @IBOutlet weak var screenShotImageView01: UIImageView!
    @IBOutlet weak var screenShotImageView02: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 이미지 요청 cancel
        self.disposeBag = DisposeBag()
    }

    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let cellVM = cellVM as? PortaitCellViewModel else { return }
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
        
        switch urls.count {
        case 1:
            screenShotImageView01.isHidden = true
            screenShotImageView02.isHidden = true
        case 2:
            self.screenShotImageView01.isHidden = false
            self.screenShotImageView01.loadImage(urls[1], self.disposeBag)
        case 3:
            self.screenShotImageView01.isHidden = false
            self.screenShotImageView01.loadImage(urls[1], self.disposeBag)
            
            self.screenShotImageView02.isHidden = false
            self.screenShotImageView02.loadImage(urls[2], self.disposeBag)
        default:
            break
        }
    }
}

