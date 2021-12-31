//
//  RecentSearchHistoryCellViewModel.swift
//  Search
//
//  Created by Suvely on 2021/12/28.
//

import Foundation
import RxSwift

//extension SearchHistoryCellType {
//    var cellHeight: CGFloat {
//        switch self {
//        case .allResultsCell(_):
//            return 50.0
//        case .searchResultsCell(_):
//            return 45.0
//        case .resultInfoCell(let vm):
//            return vm.scaledImageHeight.asObservable()
//        case .noResultsCell:
//            return Observable.of(UIScreen.main.bounds.width)
//        }
//    }
//}

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

