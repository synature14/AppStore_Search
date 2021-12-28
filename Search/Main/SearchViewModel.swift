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
    
    private var disposeBag = DisposeBag()
    let searchText = BehaviorRelay<String>(value: "")
    let requestKeyword = PublishSubject<String>()
    
    let observableEmitter = PublishSubject<Observable<Int>>()
    
    private var response: Observable<SYResponse>?
    lazy var recentSearchHistory: Observable<[RecentSearchEntity]> = {
        return Observable.create { emitter in
            let items = SYCoreDataManager.shared.loadData(request: RecentSearchEntity.fetchRequest())
            emitter.onNext(items)
            return Disposables.create()
        }
        
    }()
    
    init() {
        bindings()
    }
    
    private func bindings() {
        searchText
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { keyword in
                print("[search] \(keyword)")

            }).disposed(by: disposeBag)
        
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
    
}
