//
//  SearchViewModel.swift
//  Search
//
//  Created by SutieDev on 2021/12/28.
//

import Foundation
import RxSwift
import RxRelay



class SearchViewModel {
    enum SearchFilter {
        case all
        case keyword(String)
    }
    
    private var disposeBag = DisposeBag()
    let searchText = BehaviorRelay<String>(value: "")
    let requestKeyword = PublishSubject<String>()
    var updatedCellVMs = PublishSubject<[SearchHistoryCellType]>()

    private var response: Observable<SYResponse>?
    
    init() {
        bindings()
    }
    
    private func bindings() {
        // 검토!
        searchText
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { text in
                print("#####  searchText - \(text)  ####")
                // [RecentSearchCellViewModel] 갱신해서 tableView.reload해야함
                self.recentSearchHistory(.keyword(text))
            })
            .disposed(by: disposeBag)
                
        requestKeyword
            .asObservable()
            .do(onNext: { searchTextValue in
                SYCoreDataManager.shared.save(searchTextValue)
            })
            .flatMapLatest { NetworkManager.request(search: $0) }   // emit될 Observable 여러개일 수 있음. 이전에 만든 observable은 무시하고 가장 최근의 Observable을 따름
            .subscribe(onNext: { result in
                print("[resultCount] = \(result.resultCount)")
            }).disposed(by: disposeBag)
    }
    
    func recentSearchHistory(_ filter: SearchFilter) {
        switch filter {
        case .all:
            let cellVMs = SYCoreDataManager.shared
                .loadData(request: RecentSearchEntity.fetchRequest())
                .map { RecentSearchHistoryCellViewModel($0) }
                .map { SearchHistoryCellType.allResultsCell($0) }
            print("=== recentSearchHistory emit====")
            
            updatedCellVMs.onNext(cellVMs)
            
        case .keyword(let word):
            let cellVMs = SYCoreDataManager.shared
                .find(word)
                .map { RecentSearchHistoryCellViewModel($0) }
                .map { SearchHistoryCellType.searchResultsCell($0) }
            print("==== keyword: \(word) searched =====")
            
            cellVMs.count > 0 ? updatedCellVMs.onNext(cellVMs) : updatedCellVMs.onNext([.noResultsCell])
        }
    }
}
