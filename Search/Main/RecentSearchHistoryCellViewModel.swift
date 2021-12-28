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
            .asObservable()
            .map { word in
                return SYCoreDataManager.shared.delete(word ?? "",
                                                       request: RecentSearchEntity.fetchRequest())
            }
            .subscribe(onNext: {
                // tableView deleteRow
                
            }, onError: { error in
                print("[error] \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
            
    }
    
}
