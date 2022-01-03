//
//  PortaitScreenShotCell.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import Foundation
import UIKit
import RxSwift
import RxRelay

class PortaitCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        PortaitScreenShotCell.self
    }
    
    var searchResult: SearchResult
    let imageViewSize: CGSize
    var screenShotTrailingConstraint: CGFloat = 0.0
    
    lazy var screenShotUrls: [String] = {
        var count = searchResult.screenshotUrls.count
        if count > 3 {
            count = 3
        }
        let urlStrings = searchResult.screenshotUrls[0..<count]
        return Array(urlStrings)
    }()
    
    private var disposeBag = DisposeBag()
    
    init(_ result: SearchResult, imageViewSize: CGSize) {
        self.searchResult = result
        self.imageViewSize = imageViewSize
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
        
        screenShotImageView.image = nil
        screenShotImageView01.image = nil
        screenShotImageView02.image = nil
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
        
        // MARK: kingFisher 내부 로직 문서 참조 -> Disk 캐싱과 Memory 캐싱 두가지 사용
        loadImage(urls[0], imageView: screenShotImageView)
        
        switch urls.count {
        case 1:
            screenShotImageView01.isHidden = true
            screenShotImageView02.isHidden = true
        case 2:
            self.screenShotImageView01.isHidden = false
            loadImage(urls[1], imageView: screenShotImageView01)
        case 3:
            self.screenShotImageView01.isHidden = false
            loadImage(urls[1], imageView: screenShotImageView01)
            
            self.screenShotImageView02.isHidden = false
            loadImage(urls[2], imageView: screenShotImageView02)
        default:
            break
        }
    }
    
    private func loadImage(_ url: String, imageView: UIImageView) {
        guard let vm = self.vm else {
            return
        }
        
        ImageManager.shared.loadImage(url)
            .observeOn(SerialDispatchQueueScheduler(internalSerialQueueName: Constants.previewImageSerialQueue))
            .map { $0.downSampling() }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { img in
                imageView.image = img
                print("downSampling 이미지 get = \(img.size)")
            })
            .disposed(by: disposeBag)
    }
}

