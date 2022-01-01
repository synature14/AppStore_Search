//
//  AppIconBigCell.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit
import RxSwift

class AppIconBigCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        AppIconBigCell.self
    }
    
    private(set) var result: SearchResult
    
    lazy var appIconImage: Observable<UIImage?> = {
        return Observable.of(result.iconImage)
            .compactMap { URL(string: $0) }
            .map { URLRequest(url: $0) }
            .flatMap { request -> Observable<Data> in
              return URLSession.shared.rx.data(request: request)
            }
            .map { UIImage(data: $0) }
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
        
    }
    
}
