//
//  RecentSearchHistoryCellViewModel.swift
//  Search
//
//  Created by Suvely on 2021/12/28.
//

import Foundation
import RxSwift


class RecentSearchHistoryCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        RecentSearchHistoryCell.self
    }
    
    private var disposeBag = DisposeBag()
    var item: RecentSearchEntity
    
    let deleteHistorySubject = PublishSubject<String>()
    
    init(_ item: RecentSearchEntity) {
        self.item = item
        bindings()
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
    
    private func bindings() {
        deleteHistorySubject
            .subscribe(onNext: { word in
                SYCoreDataManager.shared.delete(word) {
                    // tableView deleteRow
                    
                }
                
                print("Delete Success! --> tableView Row should be removed")
            }, onError: { error in
                print("[error] \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

