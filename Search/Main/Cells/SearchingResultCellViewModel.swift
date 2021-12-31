//
//  SearchingResultCellViewModel.swift
//  Search
//
//  Created by Suvely on 2021/12/31.
//

import Foundation
import RxSwift

class SearchingResultCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        SearchingResultCell.self
    }
    
    private var disposeBag = DisposeBag()
    var item: RecentSearchEntity
    
    init(_ item: RecentSearchEntity) {
        self.item = item
        
    }
    
    deinit {
        disposeBag = DisposeBag()
    }
}

