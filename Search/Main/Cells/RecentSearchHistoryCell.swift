//
//  RecentSearchHistoryCell.swift
//  Search
//
//  Created by Suvely on 2021/12/28.
//

import UIKit
import RxSwift
import RxCocoa

class RecentSearchHistoryCell: UITableViewCell, BindableTableViewCell {
    static let name = "RecentSearchHistoryCell"
    
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    private var cellVM: RecentSearchHistoryCellViewModel?
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
    
    func setData(_ vm: RecentSearchHistoryCellViewModel) {
        self.cellVM = vm
        wordLabel.text = vm.item.word
        setBindings()
    }
    
    private func setBindings() {
        deleteButton.rx.tap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                let word = self.wordLabel.text ?? ""
                self.cellVM?.deleteHistorySubject.onNext(word)
            })
            .disposed(by: disposeBag)
    }
}
