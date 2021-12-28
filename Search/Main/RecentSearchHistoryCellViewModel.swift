//
//  RecentSearchHistoryCellViewModel.swift
//  Search
//
//  Created by Suvely on 2021/12/28.
//

import Foundation
import RxSwift


class RecentSearchHistoryCellViewModel {
    private var disposeBag = DisposeBag()
    
    let deleteHistorySubject = PublishSubject<String>()
    
    init() {
        bindings()
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
