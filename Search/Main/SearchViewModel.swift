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
    let searchText = PublishSubject<String>()
    let requestKeyword = BehaviorRelay<String>(value: "")
    
    private(set) var sections: [[TableCellRepresentable]] = [] {
        didSet {
            updateCellVMs.onNext(sections)
        }
    }
    let updateCellVMs = PublishSubject<[[TableCellRepresentable]]>()     // tableView reload 시키는 주체
    
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
    
    private func configureCellVMs(_ results: [SearchResult]) -> [[TableCellRepresentable]] {
        var section: [[TableCellRepresentable]] = []
        
        // 검색결과가 없는 경우
        if results.isEmpty {
            return [[EmptyResultCellViewModel(searchText: requestKeyword.value)]]
        }
        
        // 검색 결과 mapping
        for result in results {
            var cellVMs: [TableCellRepresentable] = []
            
            let appIconCellVM = AppIconCellViewModel(result)
            cellVMs.append(appIconCellVM)
            
            let representableImageUrl = result.screenshotUrls.first ?? ""
            if representableImageUrl.isLandscape == true {
                let landscapeVM = LandscapeCellViewModel(result, imageViewSize: representableImageUrl.size)
                cellVMs.append(landscapeVM)
            } else {
                let portraitVM = PortaitCellViewModel(result, imageViewSize: representableImageUrl.size)
                cellVMs.append(portraitVM)
            }
            section.append(cellVMs)
        }
        
        return section
    }
    
    private func bindRequestKeyword() {
        requestKeyword
            .filter { $0.count > 0 }
            .do(onNext: { [weak self] searchTextValue in
                SYCoreDataManager.shared.save(searchTextValue)
                self?.sections = [[ActivityViewModel()]]
            })
            .flatMapLatest { NetworkManager.request(search: $0) }   // emit될 Observable 여러개일 수 있음. 이전에 만든 observable은 무시하고 가장 최근의 Observable을 따름
            .map { $0.results }
            .map { self.configureCellVMs($0) }
            .subscribe(onNext: { [weak self] cellVMs in
                self?.sections = cellVMs
            }).disposed(by: requestKeywordDisposeBag)
    }
    
    // Core Data에 저장된 기록 조회
    func searchHistory(_ filter: SearchFilter) {
        switch filter {
        case .all:
            SYCoreDataManager.shared.loadAllData { entities in
                guard let entities = entities else { return }
                
                let cellVMs = entities
                    .compactMap { RecentSearchHistoryCellViewModel($0) }
                    
                cellVMs.forEach { $0.delegate = self }
                print("cellVMs: \(cellVMs)")
                print("=== [SearchFilter: .all] recentSearchHistory emit====")
                self.sections = [cellVMs]
            }
            
        case .keyword(let word):
            SYCoreDataManager.shared.find(word) { entities in
                let cellVMs = entities.map { SearchingResultCellViewModel($0) }
                print("==== keyword: \(word) searched =====")
                
                self.sections = cellVMs.count > 0 ? [cellVMs] : [[NoResultsCellViewModel()]]
            }
        }
    }
    
    func search(_ text: String) {
        self.requestKeywordDisposeBag = DisposeBag()    // 이전에 서칭해서 생성된 stream을 삭제
        bindRequestKeyword()        // 다시 바인딩
        requestKeyword.accept(text)
    }
}

extension SearchViewModel: RecentSearchHistoryCellVMDelegate {
    func deleteButtonTapped(within item: RecentSearchEntity) {
        searchHistory(.all)
    }
}
