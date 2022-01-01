//
//  PreviewCell.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import UIKit
import RxSwift

class PreviewCellViewModel: CollectionCellRepresentable {
    var cellType: UICollectionViewCell.Type {
        return PreviewCell.self
    }
    
    private var disposeBag = DisposeBag()
    lazy var previewImage: Observable<UIImage?> = {
        return Observable.of(self.imageURL)
            .compactMap { URL(string: $0) }
            .map { URLRequest(url: $0) }
            .flatMap { request -> Observable<Data> in
              return URLSession.shared.rx.data(request: request)
            }
            .map { UIImage(data: $0) }
    }()
    
    private(set) var imageURL: String
    var itemSize: CGSize {
        get {
            return imageURL.size
        }
    }
    
    init(_ imageUrl: String) {
        self.imageURL = imageUrl
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
}

class PreviewCell: UICollectionViewCell, BindableCollectionViewCell {
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bindCellVM(_ cellVM: CollectionCellRepresentable?) {
        guard let cellVM = cellVM as? PreviewCellViewModel else {
            return
        }
        cellVM.previewImage
            .observeOn(MainScheduler.instance)
            .bind(to: self.imageView.rx.image)
            .disposed(by: disposeBag)
    }

}
