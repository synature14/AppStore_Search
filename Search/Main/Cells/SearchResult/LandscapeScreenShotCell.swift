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
    let imageSize: CGSize
    
    private var disposeBag = DisposeBag()
    
    init(_ searchResult: SearchResult, imageSize: CGSize) {
        self.searchResult = searchResult
        self.imageSize = imageSize
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
        screenShotImageView.loadImage(cellVM.urls?.first ?? "",
                            disposeBag)
    }
}
