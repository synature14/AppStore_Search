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
    private let screenShotImageViewWidth: CGFloat = (UIScreen.main.bounds.width - 40.0 - 5.0*2) / 3
    
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
        
        // screenshotImage 사이즈 계산해서 높이 다시 맞춰야함..
        // screenShotImageViewWidth : x = 이미지 사이즈 가로 : y
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
        
        vm.screenShotImage
            .observeOn(MainScheduler.instance)
            .enumerated()
            .subscribe(onNext: { [weak self] (index, image) in
                switch index {
                case 0:
                    self?.screenShotImageView.image = image
                case 1:
                    self?.screenShotImageView01.image = image
                case 2:
                    self?.screenShotImageView02.image = image
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
