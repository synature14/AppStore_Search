//
//  AppIconBigCell.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit
import RxSwift

protocol AppIconBigCellVMProtocol {
    func didShareButtonTapped(_ downloadURL: String)
}

class AppIconBigCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        AppIconBigCell.self
    }
    
    private(set) var result: SearchResult
    var delegate: AppIconBigCellVMProtocol?
    lazy var appIconImage: Observable<UIImage> = {
        return UIUtility.shared.loadImage(result.iconImage)
    }()
    
    init(_ result: SearchResult) {
        self.result = result
    }
}

class AppIconBigCell: UITableViewCell, BindableTableViewCell {
    private var disposeBag = DisposeBag()
    var cellVM: AppIconBigCellViewModel?
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    func bindCellVM(_ cellVM: TableCellRepresentable?) {
        guard let cellVM = cellVM as? AppIconBigCellViewModel else {
            return
        }
        
        self.cellVM = cellVM
        trackNameLabel.text = cellVM.result.trackName
        sellerNameLabel.text = cellVM.result.sellerName
        
        cellVM.appIconImage
            .observeOn(MainScheduler.instance)
            .bind(to: self.iconImageView.rx.image)
            .disposed(by: disposeBag)
        
        shareButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                cellVM.delegate?.didShareButtonTapped(cellVM.result.trackViewUrl)
            }).disposed(by: disposeBag)
    }
    
}
