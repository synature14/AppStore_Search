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
    
    private(set) var sections: [[TableCellRepresentable]] = []
    let updatedCellVMs = BehaviorRelay<[[TableCellRepresentable]]>(value: [[]])     // tableView reload 시키는 주체

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
    
    private func configureCellVMs(_ results: [SearchResult]) -> [[TableCellRepresentable]] {
//        results.map { $0.screenshotUrls }
        
        
//
        let str = "/406x228bb.jpg"
        print(str.size)
        return [[]]
//
//
//        results.map { $0.screenshotUrls.first }
//        .split(separator: "/").last
//        .map { String($0) }
//        ?.removeSubrange(Range()
//
//
//        // image가 landscape 모드인가?
//        let landScapeSection: [TableCellRepresentable] = [
//            AppIconViewModel.init(result), LandScapeViewModel(result)
//        ]
//        // image가 portrait 모드인가?
//        let portraitSection: [TableCellRepresentable] = [
//            AppIconViewModel.init(result), PortaitViewModel(result)
//        ]
    }
    
    private func bindRequestKeyword() {
        requestKeyword
            .do(onNext: { searchTextValue in
                SYCoreDataManager.shared.save(searchTextValue)
            })
            .flatMapLatest { NetworkManager.request(search: $0) }   // emit될 Observable 여러개일 수 있음. 이전에 만든 observable은 무시하고 가장 최근의 Observable을 따름
            .map { $0.results }
            .map { self.configureCellVMs($0) }
            .subscribe(onNext: { [weak self] cellVMs in
                self?.updatedCellVMs.accept(cellVMs)
            }).disposed(by: requestKeywordDisposeBag)
    }
    
    // Core Data에 저장된 기록 조회
    func searchHistory(_ filter: SearchFilter) {
        switch filter {
        case .all:
            let cellVMs: [TableCellRepresentable] = SYCoreDataManager.shared.loadData(request: RecentSearchEntity.fetchRequest())
                .map { RecentSearchHistoryCellViewModel($0) }
                
            print("=== recentSearchHistory emit====")
            
            updatedCellVMs.accept([cellVMs])
            
        case .keyword(let word):
            let cellVMs: [TableCellRepresentable] = SYCoreDataManager.shared.find(word)
                .map { RecentSearchHistoryCellViewModel($0) }
            print("==== keyword: \(word) searched =====")
            
            cellVMs.count > 0 ? updatedCellVMs.accept([cellVMs]) : updatedCellVMs.accept([[NoResultsCellViewModel()]])
        }
    }
    
    func search(_ text: String) {
        self.requestKeywordDisposeBag = DisposeBag()    // 이전에 서칭해서 생성된 stream을 삭제
        bindRequestKeyword()        // 다시 바인딩
        requestKeyword.onNext(text)
    }
}
                         
private extension String {
    
//    var isDecimalNumber: Bool {
//        "0" ~ "9"
//        return true
//        else false
//    }
    
    // 406x228bb.jpg
    var size: CGSize {
        let imageSizeString = self.split(separator: "/").last
        let splited = imageSizeString?.split(separator: "x") ?? []
        let widthString = splited
            .first?
            .filter { $0.isNumber }
        let heightString = splited
            .last?
            .filter { $0.isNumber }
        
        guard let widthString = widthString, let heightString = heightString else {
            return .zero
        }
        guard let width = Int(widthString), let height = Int(heightString) else {
            return .zero
        }
        return CGSize(width: width, height: height)
    }
}
