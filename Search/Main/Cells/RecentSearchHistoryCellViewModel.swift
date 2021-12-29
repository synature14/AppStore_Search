//
//  RecentSearchHistoryCellViewModel.swift
//  Search
//
//  Created by Suvely on 2021/12/28.
//

import Foundation
import RxSwift

enum SearchHistoryCellType {
    case allResultsCell(RecentSearchHistoryCellViewModel)
    case searchResultsCell(RecentSearchHistoryCellViewModel)
    case noResultsCell
}

class RecentSearchHistoryCellViewModel {
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
            .flatMapLatest { word in
                SYCoreDataManager.shared.delete(word,
                                                request: RecentSearchEntity.fetchRequest())
            }
            .subscribe(onNext: { _ in
                // tableView deleteRow
                
                print("Delete Success! --> tableView Row should be removed")
            }, onError: { error in
                print("[error] \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
}

