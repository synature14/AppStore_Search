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
    
    private(set) var urls: [String]?
    var searchResult: SearchResult
    let imageViewSize: CGSize
    
    private var disposeBag = DisposeBag()
    
    init(_ searchResult: SearchResult, imageViewSize: CGSize) {
        self.searchResult = searchResult
        self.imageViewSize = imageViewSize
        self.urls = searchResult.screenshotUrls
    }
}

class LandscapeScreenShotCell: UITableViewCell, BindableTableViewCell {
    private var cellVM: LandscapeCellViewModel?
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var screenShotImageView: UIImageView!
    
    deinit {
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let cellVM = cellVM as? LandscapeCellViewModel else { return }
        self.cellVM = cellVM
        
        ImageManager.shared.loadImage(cellVM.urls?.first ?? "")
//            .observeOn(SerialDispatchQueueScheduler(internalSerialQueueName: Constants.previewImageSerialQueue))
//            .map { $0.downSampling() }
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] image in
                self?.screenShotImageView.image = image
            }).disposed(by: disposeBag)
    }
}
