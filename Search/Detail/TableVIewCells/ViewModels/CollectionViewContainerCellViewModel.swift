//
//  CollectionViewContainerCellViewModel.swift
//  Search
//
//  Created by SutieDev on 2022/01/03.
//

import Foundation
import RxSwift

struct BadgeInfo {
    var category: BadgeCategory = .평가
    var result: SearchResult
    
    enum BadgeCategory {
        case 평가
        case 연령
        case 카테고리
        case 개발자
        case 언어
    }
    
    func typeToString() -> String {
        switch category {
        case .평가:
            return "평가"
        case .연령:
            return "연령"
        case .카테고리:
            return "카테고리"
        case .개발자:
            return "개발자"
        case .언어:
            return "언어"
        }
    }
}

enum PreviewCollectionCellType {
    case BadgeCell
    case iPhonePreviewCell
    case iPadPreviewCell
}

protocol CollectionViewContainerCellProtocol {
    func showLargePreviewVC(_ type: PreviewCollectionCellType, items: [CollectionCellRepresentable])
}

class CollectionViewContainerCellViewModel: TableCellRepresentable {
    var cellType: UITableViewCell.Type {
        CollectionViewContainerCell.self
    }
    
    private(set) var delegate: CollectionViewContainerCellProtocol?
    
    private(set) var searchResult: SearchResult?
    private(set) var items: [CollectionCellRepresentable] = [] {
        didSet {
            updateCellVMs.onNext(items)
        }
    }
    let updateCellVMs = PublishSubject<[CollectionCellRepresentable]>()
    
    private(set) var type: PreviewCollectionCellType
    
    init(_ searchResult: SearchResult, type: PreviewCollectionCellType,_ delegate: CollectionViewContainerCellProtocol) {
        self.searchResult = searchResult
        self.type = type
        self.delegate = delegate
        
        switch type {
        case .BadgeCell:
            self.items = self.configBadgeCellVMs()
        case .iPhonePreviewCell:
            self.items = self.configiPhonePreviewCellVMs()
        case .iPadPreviewCell:
            self.items = self.configiPadPreviewCellVMs()
        }
    }
    
    private func configBadgeCellVMs() -> [CollectionCellRepresentable] {
        guard let searchResult = self.searchResult else { return [] }
        var items: [CollectionCellRepresentable] = []
        let 평가 = BadgeInfo(category: .평가, result: searchResult)
        let 연령 = BadgeInfo(category: .연령, result: searchResult)
        let 카테고리 = BadgeInfo(category: .카테고리, result: searchResult)
        let 개발자 = BadgeInfo(category: .개발자, result: searchResult)
        let 언어 = BadgeInfo(category: .언어, result: searchResult)
        
        let vms = [평가, 연령, 카테고리, 개발자, 언어].map { BadgeCellViewModel($0) }
        items = vms
        
        return items
    }
    
    private func configiPhonePreviewCellVMs() -> [CollectionCellRepresentable] {
        let items: [CollectionCellRepresentable]? = searchResult?.screenshotUrls
            .compactMap { PreviewCellViewModel($0) }
            .compactMap { $0 as CollectionCellRepresentable }
        return items ?? []
    }
    
    private func configiPadPreviewCellVMs() -> [CollectionCellRepresentable] {
        let items: [CollectionCellRepresentable]? = searchResult?.ipadScreenshotUrls
            .compactMap { PreviewCellViewModel($0) }
            .compactMap { $0 as CollectionCellRepresentable }
        return items ?? []
    }
}

