//
//  AppInfoViewModel.swift
//  Search
//
//  Created by Suvely on 2022/01/01.
//

import Foundation
import RxSwift
import RxRelay

class AppInfoViewModel {
    private var disposeBag = DisposeBag()
    let updatedCellVMs = BehaviorRelay<[[TableCellRepresentable]]>(value: [[]])
    private(set) var searchResult: SearchResult
    private(set) var sections: [[TableCellRepresentable]] = [] {
        didSet {
            updatedCellVMs.accept(sections)
        }
    }
    
    init(_ result: SearchResult) {
        self.searchResult = result
        sections = configureCellVMs(result)
        bindings()
    }
    
    
    private func bindings() {
        
    }
    
    private func configureCellVMs(_ result: SearchResult) -> [[TableCellRepresentable]] {
        var section: [[TableCellRepresentable]] = []
        let appIconBig = [AppIconBigCellViewModel(result)]
        let badges = [CollectionViewContainerCellViewModel(result, cellHeight: 60)]
        let 새로운기능Title = [TitleCellViewModel("새로운 기능", buttonTitle: "버전 기록")]
        let 미리보기 = [TitleCellViewModel("미리보기")]
        let 정보 = [TitleCellViewModel("정보")]
        section = [appIconBig, badges, 새로운기능Title, 미리보기, 정보]
        return section
    }
    
}
