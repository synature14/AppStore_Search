//
//  ResultInfoCell.swift
//  Search
//
//  Created by Suvely on 2021/12/29.
//

import UIKit
import RxSwift

class ResultInfoCell: UITableViewCell {
    static let name = "ResultInfoCell"
    
    private var disposeBag = DisposeBag()
    private var vm: ResultCellViewModel?
    
    @IBOutlet weak var appIconImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var userRatingCountLabel: UILabel!
    
    @IBOutlet weak var screenShotImageView: UIImageView!
    
    @IBOutlet weak var screenShotImageView01: UIImageView!
    @IBOutlet weak var screenShotImageView02: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    deinit {
        self.disposeBag = DisposeBag()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = ""
        userRatingCountLabel.text = ""
    }
    
    func setData(_ vm: ResultCellViewModel) {
        self.vm = vm
        guard let result = vm.searchResult else {
            return
        }
        trackNameLabel.text = result.trackName
        userRatingCountLabel.text = "\(result.userRatingCount)"
        
        bindings()
    }
    
    private func bindings() {
        guard let vm = self.vm else {
            return
        }
        
        vm.appIconImage
            .observeOn(MainScheduler.instance)
            .bind(to: self.appIconImageView.rx.image)
            .disposed(by: disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
