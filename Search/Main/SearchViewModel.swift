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
    private var requestKeywordDisposeBag = DisposeBag()
    let searchText = BehaviorRelay<String>(value: "")
    let requestKeyword = PublishSubject<String>()
    var updatedCellTypes = BehaviorRelay<[SearchCellType]>(value: [])     // tableView reload 시키는 주체

    private var response: Observable<SYResponse>?
    
    init() {
        bindings()
    }
    
    private func bindings() {
        // 검토!
        searchText
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] text in
                print("#####  searchText - \(text)  ####")
                // [RecentSearchCellViewModel] 갱신해서 tableView.reload해야함
                self?.searchHistory(.keyword(text))
            })
            .disposed(by: disposeBag)
                
        
        bindRequestKeyword()
    }
    
    private func bindRequestKeyword() {
        requestKeyword
            .do(onNext: { searchTextValue in
                SYCoreDataManager.shared.save(searchTextValue)
            })
            .flatMapLatest { NetworkManager.request(search: $0) }   // emit될 Observable 여러개일 수 있음. 이전에 만든 observable은 무시하고 가장 최근의 Observable을 따름
            .map { $0.results }
            .subscribe(onNext: { [weak self] results in
                let cellTypeArr  = results
                    .map { ResultCellViewModel($0) }
                    .map { SearchCellType. resultInfoCell($0) }
                self?.updatedCellTypes.accept(cellTypeArr)
                
                
            }).disposed(by: requestKeywordDisposeBag)
    }
    
    // Core Data에 저장된 기록 조회
    func searchHistory(_ filter: SearchFilter) {
        switch filter {
        case .all:
            let cellVMs = SYCoreDataManager.shared
                .loadData(request: RecentSearchEntity.fetchRequest())
                .map { RecentSearchHistoryCellViewModel($0) }
                .map { SearchHistoryCellType.allResultsCell($0) }
            print("=== recentSearchHistory emit====")
            
            updatedCellVMs.accept(cellVMs)
            
        case .keyword(let word):
            let cellVMs = SYCoreDataManager.shared
                .find(word)
                .map { RecentSearchHistoryCellViewModel($0) }
                .map { SearchHistoryCellType.searchResultsCell($0) }
            print("==== keyword: \(word) searched =====")
            
            cellVMs.count > 0 ? updatedCellVMs.accept(cellVMs) : updatedCellVMs.accept([.noResultsCell])
        }
    }
    
    func search(_ text: String) {
        self.requestKeywordDisposeBag = DisposeBag()    // 이전에 서칭해서 생성된 stream을 삭제
        bindRequestKeyword()        // 다시 바인딩
        requestKeyword.onNext(text)
    }
}
