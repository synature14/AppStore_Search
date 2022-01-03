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
    
    lazy var previewImage: Observable<UIImage> = {
        return ImageManager.shared.loadImage(imageURL)
            .observeOn(SerialDispatchQueueScheduler(internalSerialQueueName: Constants.previewImageSerialQueue))
            .map { $0.downSampling(self.itemSize) }
    }()
    
    private(set) var imageURL: String
    private(set) var itemSize: CGSize?
    
    init(_ imageUrl: String, itemSize: CGSize? = nil) {
        self.imageURL = imageUrl
        self.itemSize = itemSize
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
