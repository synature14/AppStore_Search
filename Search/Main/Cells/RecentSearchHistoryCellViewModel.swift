//
//  RecentSearchHistoryCellViewModel.swift
//  Search
//
//  Created by Suvely on 2021/12/28.
//

import Foundation
import RxSwift

enum SearchHistoryCellType {
    case allResultsCell(RecentSearchHistoryCellViewModel)       // 앱 기동시 core data에 저장된 기록 나열
    case searchResultsCell(RecentSearchHistoryCellViewModel)    // searchBar에 텍스트 editing할때 나열될 셀
    case resultInfoCell(ResultCellViewModel)                    // '검색' 버튼 눌렀을때 결과 뿌려주는 셀
    case noResultsCell
}

extension SearchHistoryCellType {
    var cellHeight: CGFloat {
        switch self {
        case .allResultsCell(_):
            return 50.0
        case .searchResultsCell(_):
            return 45.0
        case .resultInfoCell(_), .noResultsCell:
            return UIScreen.main.bounds.width
        }
    }
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

