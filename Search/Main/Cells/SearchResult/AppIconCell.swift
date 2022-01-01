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
    
    lazy var appIconImage: Observable<UIImage?> = {
        return Observable.of(searchResult.iconImage)
            .compactMap { URL(string: $0) }
            .map { URLRequest(url: $0) }
            .flatMap { request -> Observable<Data> in
              return URLSession.shared.rx.data(request: request)
            }
            .map { UIImage(data: $0) }
    }()
}

class AppIconCell: UITableViewCell, BindableTableViewCell {
    
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var userRatingCountLabel: UILabel!
    
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
    }
}
