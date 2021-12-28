//
//  RecentSearchHistoryCell.swift
//  Search
//
//  Created by Suvely on 2021/12/28.
//

import UIKit
import RxSwift
import RxCocoa

class RecentSearchHistoryCell: UITableViewCell {
    static let name = "RecentSearchHistoryCell"
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    private let cellVM = RecentSearchHistoryCellViewModel()
    private var disposeBag = DisposeBag()
    
    deinit {
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        wordLabel.text = ""
    }
    
    func setLabel(_ word: String) {
        wordLabel.text = word
        setBindings()
    }
    
    func setBindings() {
        deleteButton.rx.tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let word = self.wordLabel.text ?? ""
                self.cellVM.deleteHistorySubject.onNext(word)
            })
            .disposed(by: disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
